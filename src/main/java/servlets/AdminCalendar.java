package servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.reflect.Field;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import classes.UserBooking;

/**
 * Servlet implementation class AdminCalendar
 */
@WebServlet("/AdminCalendar")
public class AdminCalendar extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Default to current date
		LocalDate currentDate = LocalDate.now();

		// Check for month and year parameters
		String monthParam = request.getParameter("month");
		String yearParam = request.getParameter("year");

		try {
			if (monthParam != null && yearParam != null) {
				int month = Integer.parseInt(monthParam);
				int year = Integer.parseInt(yearParam);

				// whenever the user goes next or go previous,
				// the servlet is called and current year and month will add to the parameters
				currentDate = LocalDate.of(year, month, 1);
			}
		} catch (Exception e) {
			// If parsing fails, fall back to current date
			currentDate = LocalDate.now();
		}

		// Generate calendar data
		List<List<LocalDate>> calendarMatrix = generateCalendarMatrix(currentDate);

		// Get bookings for the month
		Map<LocalDate, List<UserBooking>> bookings = getBookingsForMonth(currentDate);

		// Set attributes for JSP
		request.setAttribute("currentDate", currentDate);
		request.setAttribute("calendarMatrix", calendarMatrix);
		request.setAttribute("adminBookings", bookings);
		RequestDispatcher dispatcher = request.getRequestDispatcher("./client/adminDashboard.jsp");
		dispatcher.forward(request, response);
	}

	// Generate a 2D list where each inner list represents a week of the month,
	// and the outer list represents the entire month (a grid of weeks).
	// gives the month
	private List<List<LocalDate>> generateCalendarMatrix(LocalDate currentDate) {

		// get the first day of the month
		LocalDate firstDayOfMonth = currentDate.withDayOfMonth(1);
		// get the last day of the month using lengthOfMonth
		LocalDate lastDayOfMonth = currentDate.withDayOfMonth(currentDate.lengthOfMonth());

		// 2D array for the month
		List<List<LocalDate>> monthlyCalendar = new ArrayList<>();
		// 1D array with days in a week
		List<LocalDate> currentWeek = new ArrayList<>();

		// firstDayOfMonth is the LocalDate object representing the first day of the
		// current month.
		// getDayOfWeek() returns a DayOfWeek object
		// which represents the day of the week for that date (e.g., Monday, Tuesday,
		// etc.).
		// getValue() returns an integer value representing the day of the week
		// (where Monday is 1, Tuesday is 2, ..., and Sunday is 7).
		// This value is used to determine how many days need to be padded at the
		// beginning of the calendar grid.

		// so for each day of the week that is blank, add null
		for (int i = 1; i < firstDayOfMonth.getDayOfWeek().getValue(); i++) {
			currentWeek.add(null);
		}

		// looping through the weeks
		// LocalDate date = firstDayOfMonth:
		// This initializes the loop with the first day of the month (firstDayOfMonth).
		// !date.isAfter(lastDayOfMonth):
		// The loop continues as long as date is not after the last day of the month
		// (lastDayOfMonth).
		// date = date.plusDays(1): In each iteration of the loop, the date is
		// incremented by 1 day.
		for (LocalDate date = firstDayOfMonth; !date.isAfter(lastDayOfMonth); date = date.plusDays(1)) {
			currentWeek.add(date);

			// when the week array has 7 days, add to the monthlyCalendar
			// create a new week
			// the loop continues
			if (currentWeek.size() == 7) {
				monthlyCalendar.add(currentWeek);
				currentWeek = new ArrayList<>();
			}
		}

		// For last week, id it it fewer than 7 days,
		// add more blank days
		while (currentWeek.size() < 7) {
			currentWeek.add(null);
		}

		// even though the last week was partially filled with null,
		// it is still added to the monthlyCalendar
		if (!currentWeek.isEmpty()) {
			monthlyCalendar.add(currentWeek);
		}

		return monthlyCalendar;
	}

	private Map<LocalDate, List<UserBooking>> getBookingsForMonth(LocalDate date) {

		// Map key - date
		// value - time and booking details
		Map<LocalDate, List<UserBooking>> bookings = new HashMap<>();

		try {
			Connection conn = DatabaseConnection.initializeDatabase();
			String selectStr = "SELECT * FROM \"booking\" WHERE date >= ? AND date <= ?";

			PreparedStatement userStatement = conn.prepareStatement(selectStr);

			userStatement.setDate(1, java.sql.Date.valueOf(date.withDayOfMonth(1))); // Start of the month
			userStatement.setDate(2, java.sql.Date.valueOf(date.withDayOfMonth(date.lengthOfMonth()))); // End of the
																										// month

			// this gets all the data in the month 
			ResultSet bookingSet = userStatement.executeQuery();

			// in this month 
			while (bookingSet.next()) {
			    
			    // this creates userBooking objs for each booking 
			    UserBooking booking = new UserBooking();

			    // turn the value from the column to LocalDate
			    LocalDate bookingDate = date;
			    String bookingServiceName = "";

			    // Get all columns from the ResultSet dynamically
			    ResultSetMetaData metaData = bookingSet.getMetaData();
			    int columnCount = metaData.getColumnCount();

			    for (int i = 1; i <= columnCount; i++) {

			        // getting the column name from the database
			        String columnName = metaData.getColumnName(i);

			        // getting the value from the database
			        Object value = bookingSet.getObject(i);

			        if (columnName.equals("receipt_id")) {
			            continue;
			        }

			        // if service_id, fetch the data from the backend
			        if ("service_id".equalsIgnoreCase(columnName)) {
			            int serviceParam = (int) value;
			            String serviceStr = "SELECT service_name FROM \"service\" WHERE service_id = ?";
			            PreparedStatement serviceStatement = conn.prepareStatement(serviceStr);
			            serviceStatement.setInt(1, serviceParam);
			            ResultSet serviceSet = serviceStatement.executeQuery();

			            if (serviceSet.next()) {
			                // Get the value of service_name column
			                bookingServiceName = serviceSet.getString("service_name");
			            } else {
			                System.out.println("No service with such id");
			            }
			            serviceSet.close();
			        }

			        // getting the fields of the java class
			        Field field = UserBooking.class.getDeclaredField(columnName);
			        field.setAccessible(true); // Make the private field accessible

			        if ("service_id".equalsIgnoreCase(columnName)) {
			            field.set(booking, bookingServiceName);
			        } else {
			            // For other fields, set the value directly
			            field.set(booking, value);
			        }
			    }

			    // get the booking date from the db 
			    bookingDate = bookingSet.getDate("date").toLocalDate();
			    
			    // Check if the bookingDate is already present in the map
			    if (!bookings.containsKey(bookingDate)) {
			        // If not, initialize a new list and add the booking
			        List<UserBooking> newBookingList = new ArrayList<>();
			        newBookingList.add(booking);
			        bookings.put(bookingDate, newBookingList);
			    } else {
			        // If the date is already in the map, get the booking list using the date as the key 
			    	// add the booking to the existing retrieved list 
			        List<UserBooking> existingBookingList = bookings.get(bookingDate);
			        existingBookingList.add(booking);
			    }
			}
			
			userStatement.close();
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return bookings;
	}
}