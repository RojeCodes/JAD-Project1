package servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.lang.reflect.Field;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import classes.Category;
import classes.LoggedInUser;
import classes.UserBooking;

/**
 * Servlet implementation class AdminCalendar
 */
@WebServlet("/adminDashboard")
public class AdminCalendar extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String selectedDate = (String) request.getParameter("selectedDate");
		System.out.println("selectedDate" + selectedDate);
		Connection conn = null;
		List<UserBooking> bookings = new ArrayList<>();
		java.sql.Date sqlDate = null;
		LocalDate selectedLocalDate = LocalDate.now();
		Map<LocalDate, List<UserBooking>> bookingMap = new HashMap<>();

		try {
			conn = DatabaseConnection.initializeDatabase();
		} catch (Exception e) {
			e.printStackTrace();
		}

		try {
			sqlDate = java.sql.Date.valueOf(selectedDate);
			selectedLocalDate = sqlDate.toLocalDate();

			String selectedDateStr = "SELECT * FROM \"booking\" WHERE date = ?";

			PreparedStatement userStatement = conn.prepareStatement(selectedDateStr);

			userStatement.setDate(1, sqlDate);

			ResultSet bookingSet = userStatement.executeQuery();

			while (bookingSet.next()) {
				String bookingServiceName = "";
				int service_id = 0;

				service_id = bookingSet.getInt("service_id");

				String serviceStr = "SELECT service_name FROM \"service\" WHERE service_id = ?";
				PreparedStatement serviceStatement = conn.prepareStatement(serviceStr);
				serviceStatement.setInt(1, service_id);
				ResultSet serviceSet = serviceStatement.executeQuery();

				if (serviceSet.next()) {
					// Get the value of service_name column
					bookingServiceName = serviceSet.getString("service_name");
				} else {
					System.out.println("No service with such id");
				}
				serviceSet.close();

				UserBooking booking = new UserBooking();

				booking.setBooking_id(bookingSet.getInt("booking_id"));
				booking.setDate(bookingSet.getDate("date"));
				booking.setTime(bookingSet.getTime("time"));
				booking.setService_name(bookingServiceName);
				booking.setHour_count(bookingSet.getInt("hour_count"));

				bookings.add(booking);

				// Check if the bookingDate is already present in the map
				if (!bookingMap.containsKey(selectedLocalDate)) {
					// If not, initialize a new list and add the booking
					List<UserBooking> newBookingList = new ArrayList<>();
					newBookingList.add(booking);
					bookingMap.put(selectedLocalDate, newBookingList);
				} else {
					// If the date is already in the map, get the booking list using the date as the
					// key
					// add the booking to the existing retrieved list
					List<UserBooking> existingBookingList = bookingMap.get(selectedLocalDate);
					existingBookingList.add(booking);
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		request.setAttribute("selectedBookings", bookingMap);

		doGet(request, response);
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);

		if (session == null) {
			response.sendRedirect("./client/adminDashboard.jsp?errCode=invalidLogin");
			return;
		} else {
			LoggedInUser user = (LoggedInUser) session.getAttribute("user");
			if (user == null) {
				response.sendRedirect("./client/adminDashboard.jsp?errCode=invalidLogin");
				return;
			} else if (user.getRole_id() == 2) {
				response.sendRedirect("./client/adminDashboard.jsp?errCode=unauthorized");
				return;
			}
		}

		// -----------------------------
		// ADMIN STATS
		// -----------------------------

		// BOOKING THIS MONTH

		// config
		LocalDate todayDate = LocalDate.now();
		int thisMonthsBookingCount = 0;
		int thisYearBookingCount = 0;
		int upcomingBookingCount = 0;

		Connection conn = null;
		try {
			conn = DatabaseConnection.initializeDatabase();
		} catch (Exception e) {
			e.printStackTrace();
		}

		try {
			String statStr = "SELECT COUNT(*) AS rowcount FROM \"booking\" WHERE date >= ? AND date <= ?";

			PreparedStatement userStatement = conn.prepareStatement(statStr);

			userStatement.setDate(1, java.sql.Date.valueOf(todayDate.withDayOfMonth(1))); // Start of the month
			userStatement.setDate(2, java.sql.Date.valueOf(todayDate.withDayOfMonth(todayDate.lengthOfMonth()))); // End																// of
																													// the
			// month
			ResultSet countSet = userStatement.executeQuery();

			if (countSet.next()) {
				int rowCount = countSet.getInt("rowcount");
				thisMonthsBookingCount = rowCount;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		// BOOKING THIS YEAR

		try {
			String statStr = "SELECT COUNT(*) AS rowcount FROM \"booking\" WHERE date >= ? AND date <= ?";

			PreparedStatement userStatement = conn.prepareStatement(statStr);

			userStatement.setDate(1, java.sql.Date.valueOf(todayDate.withDayOfYear(1))); // Start of the year
			userStatement.setDate(2, java.sql.Date.valueOf(todayDate.withDayOfYear(todayDate.lengthOfYear()))); // End
																												// of
																												// the
			// year
			ResultSet countSet = userStatement.executeQuery();

			if (countSet.next()) {
				int rowCount = countSet.getInt("rowcount");
				thisYearBookingCount = rowCount;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		// UPCOMING BOOKING COUNT

		try {
			String statStr = "SELECT COUNT(*) AS rowcount FROM public.\"booking\" WHERE status_id = ?";

			PreparedStatement userStatement = conn.prepareStatement(statStr);

			userStatement.setInt(1, 2);
			ResultSet countSet = userStatement.executeQuery();

			if (countSet.next()) {
				int rowCount = countSet.getInt("rowcount");
				upcomingBookingCount = rowCount;
				System.out.println("rowCount : " + rowCount);
				System.out.println("upcomingBookingCount : " + upcomingBookingCount);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		// -----------------------------
		// CALENDAR
		// -----------------------------

// localDate to pass in generateCalendarMatrix 
		// currentDate to pass in getBookingsForMonth
		String clickedDate = request.getParameter("selectedDate");
		System.out.println("clicked date " + clickedDate);

		LocalDate localDate = LocalDate.now();
		java.sql.Date currentDate = java.sql.Date.valueOf(localDate);

		// Check for month and year parameters
		String monthParam = request.getParameter("month");
		String yearParam = request.getParameter("year");
		System.out.println("Month Param " + monthParam);
		System.out.println(yearParam);

		try {

			// localDate is for calendar
			if (monthParam != null && yearParam != null) {
				int month = Integer.parseInt(monthParam);
				int year = Integer.parseInt(yearParam);
				localDate = LocalDate.of(year, month, 1);
				System.out.println("line 242 " + localDate);
				currentDate = java.sql.Date.valueOf(localDate);
				System.out.println("line 244 " + currentDate);

			}
		} catch (Exception e) {
			e.printStackTrace();
			// If there's an error, default to current month
			localDate = LocalDate.now();
		}

		List<List<LocalDate>> calendarMatrix = generateCalendarMatrix(localDate);

		// currentDate - get all bookings for the month
		Map<LocalDate, List<UserBooking>> bookings = getBookingsForMonth(currentDate, conn);

		System.out.println("adminBookings  " + bookings.isEmpty());
		// -----------------------------
		// SETTING ATTRIBUTES
		// -----------------------------

		request.setAttribute("thisMonthsBookingCount", thisMonthsBookingCount);
		request.setAttribute("thisYearBookingCount", thisYearBookingCount);
		request.setAttribute("upcomingBookingCount", upcomingBookingCount);

		List<List<LocalDate>> sessionCalendar = (List<List<LocalDate>>) session.getAttribute("calendarMatrix");

		System.out.println(sessionCalendar);
		if (sessionCalendar == null) {
			session.setAttribute("calendarMatrix", calendarMatrix);
			session.setAttribute("currentDate", localDate);
			session.setAttribute("adminBookings", bookings);

		} else if (sessionCalendar != null && monthParam != null && yearParam != null) {
			session.setAttribute("calendarMatrix", calendarMatrix);
			session.setAttribute("currentDate", localDate);
			session.setAttribute("adminBookings", bookings);
		} else if (sessionCalendar != null && monthParam == null && yearParam == null) {}

		RequestDispatcher dispatcher = request.getRequestDispatcher("./client/adminDashboard.jsp");
		dispatcher.forward(request, response);
	}

	// ------------------------------
	// FOR CALENDAR AND BOOKING
	// ------------------------------

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

	private Map<LocalDate, List<UserBooking>> getBookingsForMonth(Date date, Connection conn) {

		// Map key - date
		// value - time and booking details
		Map<LocalDate, List<UserBooking>> bookings = new HashMap<>();
		LocalDate myBookingDate = ((java.sql.Date) date).toLocalDate();

		try {
			String selectStr = "SELECT * FROM \"booking\" WHERE date >= ? AND date <= ?";

			PreparedStatement userStatement = conn.prepareStatement(selectStr);
//
			userStatement.setDate(1, java.sql.Date.valueOf(myBookingDate.withDayOfMonth(1))); // Start of the month
			userStatement.setDate(2,
					java.sql.Date.valueOf(myBookingDate.withDayOfMonth(myBookingDate.lengthOfMonth()))); // End of the
			// month

			System.out.println("my booking date : " + myBookingDate);
			// this gets all the data in the month
			ResultSet bookingSet = userStatement.executeQuery();

			// in this month
			while (bookingSet.next()) {

				// this creates userBooking objs for each booking
				UserBooking booking = new UserBooking();

				// bookingDate (LocalDate)
				LocalDate bookingDate = myBookingDate;
				String bookingServiceName = "";
				int service_id = 0;

				service_id = bookingSet.getInt("service_id");

				String serviceStr = "SELECT service_name FROM \"service\" WHERE service_id = ?";
				PreparedStatement serviceStatement = conn.prepareStatement(serviceStr);
				serviceStatement.setInt(1, service_id);
				ResultSet serviceSet = serviceStatement.executeQuery();

				if (serviceSet.next()) {
					// Get the value of service_name column
					bookingServiceName = serviceSet.getString("service_name");
				} else {
					System.out.println("No service with such id");
				}
				serviceSet.close();

				// get the booking date from the db
				bookingDate = bookingSet.getDate("date").toLocalDate();
				booking.setBooking_id(bookingSet.getInt("booking_id"));
				booking.setDate(date);
				booking.setHour_count(bookingSet.getInt("hour_count"));
				booking.setTime(bookingSet.getTime("time"));
				booking.setService_name(bookingServiceName);

				// Check if the bookingDate is already present in the map
				if (!bookings.containsKey(bookingDate)) {
					// If not, initialize a new list and add the booking
					List<UserBooking> newBookingList = new ArrayList<>();
					newBookingList.add(booking);
					bookings.put(bookingDate, newBookingList);
				} else {
					// If the date is already in the map, get the booking list using the date as the
					// key
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
