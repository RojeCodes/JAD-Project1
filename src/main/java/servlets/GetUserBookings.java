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
import java.util.ArrayList;
import java.util.List;

import classes.LoggedInUser;
import classes.UserBooking;

/**
 * Servlet implementation class GetUserBookings
 */
@WebServlet("/GetUserBookings")
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
		if (session == null) {

			// only 1 response.send can be done at each time
			// response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User is not logged
			// in.");
			response.sendRedirect("./client/login.jsp");
			return;
		}

		LoggedInUser user = new LoggedInUser();
		user = (LoggedInUser) session.getAttribute("user");

		int user_id = user.getUser_id();

		List<UserBooking> bookings = getBookingsByUserId(user_id);
		System.out.println("bookings in GetUserBookings" + bookings);

		// Add bookings to the request scope
		session.setAttribute("bookings", bookings);
		request.setAttribute("bookings", bookings);

		// Forward to the JSP page

		
//		RequestDispatcher dispatcher = request.getRequestDispatcher("./client/profile.jsp");
//		dispatcher.forward(request, response);

		 response.sendRedirect("/ST0510_JAD_Proj/client/home.jsp");

		return;
	}

	private List<UserBooking> getBookingsByUserId(int userId) {
		// Simulated database call

		List<UserBooking> bookings = new ArrayList<>();

		try {
			Connection conn = DatabaseConnection.initializeDatabase();
			String selectStr = "SELECT * FROM \"booking\" WHERE user_id = ?";

			PreparedStatement userStatement = conn.prepareStatement(selectStr);

			userStatement.setInt(1, userId);

			ResultSet userSet = userStatement.executeQuery();

			while (userSet.next()) {
				UserBooking booking = new UserBooking();

				String bookingServiceName = "";

				// Get all columns from the ResultSet dynamically
				ResultSetMetaData metaData = userSet.getMetaData();
				int columnCount = metaData.getColumnCount();

				for (int i = 1; i <= columnCount; i++) {

					// getting the column name from the database
					String columnName = metaData.getColumnName(i);

					// getting the value from the database
					Object value = userSet.getObject(i);
					
					if (columnName.equals("booking_id") || columnName.equals("user_id") ||
						columnName.equals("receipt_id")) {
						continue;
					}

					// if service_id, fetch the data from the backend
					if ("service_id".equalsIgnoreCase(columnName)) {

						int serviceParam = (int) value;
						String serviceStr = "SELECT service_name FROM \"service\"" + " WHERE service_id = ?";
						PreparedStatement serviceStatement = conn.prepareStatement(serviceStr);
						serviceStatement.setInt(1, serviceParam);
						ResultSet serviceSet = serviceStatement.executeQuery();

						if (serviceSet.next()) {
							System.out.println(serviceSet); 
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
				
				bookings.add(booking);
			}
			userStatement.close();
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return bookings;
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

	}
}
