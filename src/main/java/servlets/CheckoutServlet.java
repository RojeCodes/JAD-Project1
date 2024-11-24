package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import classes.Booking;
import classes.LoggedInUser;
import classes.Review;

/**
 * Servlet implementation class CheckoutServlet
 */
@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CheckoutServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
		
		HttpSession session = request.getSession();
		
		LoggedInUser user = new LoggedInUser();
		user = (LoggedInUser) session.getAttribute("user");
		if (user==null) {
			request.getRequestDispatcher("./client/login.jsp").forward(request, response);
			return;
		}
		int userId = user.getUser_id();
		
		ArrayList<Booking> cart = (ArrayList<Booking>) session.getAttribute("cart");
		insertReceipt(userId);
		for (Booking booking: cart) {
			int bookingCount = getNumberOfBookings();
			insertBooking(booking, bookingCount);
		}
		session.setAttribute("cart", new ArrayList<Booking>());
		request.setAttribute("bookingConfirmed", true);
		request.getRequestDispatcher("./client/home.jsp").forward(request, response);
		return;
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}
	private int getNumberOfBookings() {
		int numberOfBookings = 0;
		try {
			Connection conn = DatabaseConnection.initializeDatabase();

			String selectStr = "SELECT COUNT(booking_id) FROM booking;";

			PreparedStatement userStatement = conn.prepareStatement(selectStr);

			ResultSet userSet = userStatement.executeQuery();
			
			while(userSet.next()) numberOfBookings = userSet.getInt("count");
			
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
		return numberOfBookings;
	}
	private void insertBooking(Booking booking, int bookingCount) {
			
		try {
			Connection conn = DatabaseConnection.initializeDatabase();

			String selectStr = "INSERT INTO booking (booking_id, date, time, hour_count, service_id, user_id, receipt_id) VALUES (?,?,?,?,?,?,(SELECT COALESCE(MAX(receipt_id), 0) FROM receipt));";

			PreparedStatement userStatement = conn.prepareStatement(selectStr);
			userStatement.setInt(1, bookingCount + 1);
			userStatement.setDate(2, booking.getDate());
			userStatement.setTime(3, booking.getTime());
			userStatement.setInt(4, booking.getHourCount());
			userStatement.setInt(5, booking.getServiceId());
			userStatement.setInt(6, booking.getUserId());
			int rowsAffected = userStatement.executeUpdate();
			
			System.out.println("Query executed successfully. Rows affected: " + rowsAffected);
			
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	private void insertReceipt(int user_id) {
		try {
			Connection conn = DatabaseConnection.initializeDatabase();

			String selectStr = "INSERT INTO receipt(receipt_id, user_id)\r\n"
					+ "VALUES ((SELECT COALESCE(MAX(receipt_id), 0) + 1 FROM receipt), ?);";

			PreparedStatement userStatement = conn.prepareStatement(selectStr);
			userStatement.setInt(1, user_id);
			int rowsAffected = userStatement.executeUpdate();
			
			System.out.println("Query executed successfully. Rows affected: " + rowsAffected);
			
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
		}		
	}
}
