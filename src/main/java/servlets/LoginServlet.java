package servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import classes.LoggedInUser;
import classes.UserBooking;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.lang.reflect.Field;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

import org.mindrot.bcrypt.BCrypt;

/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/user/login")
public class LoginServlet extends HttpServlet {
	public LoginServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession oldSession = request.getSession(false);
		System.out.println("oldSession " + oldSession);

		String action = (String) request.getParameter("action");

		System.out.print(action);
		if (oldSession != null && action.equals("logOut")) {
			oldSession.invalidate();

			response.sendRedirect("../client/home.jsp");
			return;
		} else if (action == null) {
			response.sendRedirect("../client/login.jsp");
			return;
		}
	}

	private boolean checkBanned(Connection conn, String email) {
		boolean banned = false;
		try {
			String checkBannedStr = "SELECT * FROM \"user\" WHERE \"email\" = ? AND \"banned\" = ?";

			PreparedStatement stmt = conn.prepareStatement(checkBannedStr);

			stmt.setString(1, email);
			stmt.setBoolean(2, true);

			ResultSet bannedUser = stmt.executeQuery();

			if (bannedUser.next()) {
				banned = true;
				System.out.println(banned);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return banned;
	}

	private String hashPassword(String password) {
		String salt = BCrypt.gensalt(12);
		return BCrypt.hashpw(password, BCrypt.gensalt());
	}

	private boolean verifyPassword(String input, String existingPwd) {
		if (input == null || existingPwd == null) {
			return false;
		}
		try {
			return BCrypt.checkpw(input, existingPwd);
		} catch (IllegalArgumentException e) {
			return false;
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession oldSession = request.getSession(false);
		if (oldSession != null) {
			oldSession.invalidate();
		}

		// config
		String email = request.getParameter("email");
		String password = request.getParameter("password");

		int user_id = 0;
		String full_name = "";
		int role_id = 0;
		String birthdate = "";
		String address = "";
		String phone = "";
		Connection conn = null;

		LoggedInUser user = new LoggedInUser();

		HttpSession session = request.getSession();
		session.setMaxInactiveInterval(3600);

		try {
			// Initialize the database
			conn = DatabaseConnection.initializeDatabase();
		} catch (Exception e) {
			e.printStackTrace();
		}

		if (checkBanned(conn, email)) {
			response.sendRedirect("../client/login.jsp?errCode=banned");
			return;
		}

		String hashPwd = hashPassword(password); 
		System.out.println(hashPwd);
		try {

			String selectStr = "SELECT * FROM \"user\" WHERE \"email\" = ?";
			PreparedStatement userStatement = conn.prepareStatement(selectStr);

			userStatement.setString(1, email);

			// execute statement
			ResultSet userSet = userStatement.executeQuery();

			System.out.print(userSet);

			if (userSet != null) {
				System.out.println("ResultSet initialized successfully.");
			} else {
				System.out.println("ResultSet is null.");
			}

			// data processing
			while (userSet.next()) {

				if (!verifyPassword(password, userSet.getString("password"))) {
					response.sendRedirect("../client/login.jsp?errCode=invalidLogin");
					return;
				}
				user_id = userSet.getInt("user_id");
				full_name = userSet.getString("full_name");
				role_id = userSet.getInt("role_id");
				birthdate = userSet.getString("birthdate");
				address = userSet.getString("address");
				phone = userSet.getString("phone");
			}

			System.out.print(user_id);

			user.setUser_id(user_id);
			user.setFull_name(full_name.toString());
			user.setbirthdate(birthdate);
			user.setAddress(address);
			user.setPhone(phone);
			user.setRole_id(role_id);
			user.setEmail(email);

			// Forward to the JSP page

			session.setAttribute("user", user);

			if (role_id == 1) {
				response.sendRedirect("../adminDashboard");
				return;
			} else if (role_id == 2) {
				System.out.println("Go to get user bookings");
				response.sendRedirect("../userBookings");
				return;
			}
			conn.close();

		} catch (SQLException e) {
			e.printStackTrace();
		}

	}

}
