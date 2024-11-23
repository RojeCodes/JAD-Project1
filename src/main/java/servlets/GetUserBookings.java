package servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
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
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import classes.LoggedInUser;
import classes.UserBooking;

/**
 * Servlet implementation class GetUserBookings
 */
@WebServlet("/userBookings")
public class GetUserBookings extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public GetUserBookings() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		System.out.println(session);
		if (session == null) {

			response.sendRedirect("./client/login.jsp?errCode=invalidLogin");
			return;
		} else {

			LoggedInUser user = new LoggedInUser();
			user = (LoggedInUser) session.getAttribute("user");

			System.out.println(user);
			if (user == null) {
				response.sendRedirect("./client/login.jsp?errCode=invalidLogin");
				return;
			}

			int user_id = user.getUser_id();
			System.out.println("user id in get user bookings " + user_id);

			List<UserBooking> bookings = getBookingsByUserId(user_id);
			System.out.println("bookings in GetUserBookings" + bookings.size());

			bookings = getBookingsByUserId(user_id);

			// Add bookings to the request scope
			session.setAttribute("userBookings", bookings);

			response.sendRedirect("./client/home.jsp");
		}
		return;
	}

	private List<UserBooking> getBookingsByUserId(int userId) {
		// Simulated database call

		List<UserBooking> bookings = new ArrayList<>();
		LocalDate todayDate = LocalDate.now();
		LocalTime currentTime = LocalTime.now();

		try {
			Connection conn = DatabaseConnection.initializeDatabase();
			String selectStr = "SELECT * FROM public.\"booking\" WHERE user_id = ?";

			PreparedStatement userStatement = conn.prepareStatement(selectStr);

			userStatement.setInt(1, userId);

			ResultSet userSet = userStatement.executeQuery();

			while (userSet.next()) {

				LocalDate fetchedDate = userSet.getDate("date").toLocalDate();
				LocalTime fetchedTime = userSet.getTime("time").toLocalTime();

				// Compare the date and Time
				if (fetchedDate.isBefore(todayDate)
						|| (fetchedDate.isEqual(todayDate) && fetchedTime.isBefore(currentTime))) {
					String dateStr = "UPDATE booking SET status_id = ?";
					PreparedStatement dateStatement = conn.prepareStatement(dateStr);
					dateStatement.setInt(1, 1);
					int updatedRows = dateStatement.executeUpdate();

					System.out.println("updatedRows " + updatedRows);
				}
				UserBooking booking = new UserBooking();

				String bookingServiceName = "";

				int booking_id = userSet.getInt("booking_id");

				Time time = userSet.getTime("time");

				Date date = userSet.getDate("date");

				int hour_count = userSet.getInt("hour_count");

				int status_id = userSet.getInt("status_id");
				System.out.println("status id " + status_id);

				int service_id = userSet.getInt("service_id");

				try {
					String serviceStr = "SELECT * FROM service WHERE service_id =?";
					PreparedStatement serviceStatement = conn.prepareStatement(serviceStr);
					serviceStatement.setInt(1, service_id);
					ResultSet serviceName = serviceStatement.executeQuery();

					while (serviceName.next()) {
						bookingServiceName = serviceName.getString("service_name");
					}
				} catch (Exception e) {
					e.printStackTrace();
				}

				booking.setBooking_id(booking_id);
				booking.setDate(date);
				booking.setHour_count(hour_count);
				booking.setService_name(bookingServiceName);
				booking.setTime(time);
				booking.setStatus_id(status_id);

				bookings.add(booking);
			}
			userStatement.close();
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return bookings;
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

	}
}
