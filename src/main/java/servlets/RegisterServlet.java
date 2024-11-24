package servlets;

/*Author : Kaung Ye Myint Mo
Adm No : 2340250
Class : DIT/FT/2B/01
Date : 25/11/2024
Description : ST0510-JAD-Assignment1
*/
import jakarta.servlet.ServletException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Enumeration;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import org.mindrot.bcrypt.BCrypt;

// Import Database Connection Class file 
import servlets.DatabaseConnection;

/**
 * Servlet implementation class RegisterServlet
 */
@WebServlet("/user/register")
public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public RegisterServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.print("ADD PRODUCT");
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

	private boolean checkDuplicateEmail(Connection conn, String email) {
		boolean duplicate = false;
		try {
			String duplicateEmailStr = "SELECT * FROM \"user\" WHERE \"email\" = ?";

			PreparedStatement stmt = conn.prepareStatement(duplicateEmailStr);

			stmt.setString(1, email);

			ResultSet duplicateUser = stmt.executeQuery();

			if (duplicateUser.next()) {
				duplicate = true;
				System.out.println(duplicate);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return duplicate;
	}

	// Use BCrypt to generate a hash
	private String hashPassword(String password) {
		String salt = BCrypt.gensalt(12);
		return BCrypt.hashpw(password, salt);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// config
		Enumeration<String> params = request.getParameterNames();
		String paramName = "";
		String[] paramValues = null;
		ArrayList<String> databaseValues = new ArrayList<>();
		Connection con = null;

		// processing
		String userEmail = request.getParameter("email");
		String userPhone = request.getParameter("phone");

		String pwd = request.getParameter("password");
		String confirmPwd = request.getParameter("confirmpassword");

		if (!pwd.equals(confirmPwd)) {
			System.out.println("Passwords don't match");
			response.sendRedirect("../client/register.jsp?errCode=passwordMismatch");
			return;
		}

		String birthdate = request.getParameter("birthdate");
		if (birthdate != null && !birthdate.isEmpty()) {
			try {
				LocalDate birthdateDate = LocalDate.parse(birthdate);

				// Calculate the date 18 years ago
				LocalDate eighteenYearsAgo = LocalDate.now().minusYears(18);

				if (birthdateDate.isBefore(eighteenYearsAgo) || birthdateDate.isEqual(eighteenYearsAgo)) {
					System.out.println("older than or exactly 18 years.");
				} else {
					response.sendRedirect("../client/register.jsp?errCode=ageRestricted");
					return;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		try {
			// Initialize the database
			con = DatabaseConnection.initializeDatabase();
		} catch (Exception e) {
			e.printStackTrace();
		}

		if (checkBanned(con, userEmail)) {
			response.sendRedirect("../client/register.jsp?errCode=banned");
			return;
		}

		if (checkDuplicateEmail(con, userEmail)) {
			response.sendRedirect("../client/register.jsp?errCode=duplicateEmail");
			return;
		}

		try {

			PreparedStatement insertStatement = con.prepareStatement(
					"insert into \"user\" (full_name, phone, address, birthdate, email, password) values(?, ?, ?, ?, ?, ?)");

			if (params.hasMoreElements()) {

				while (params.hasMoreElements()) {
					// get parameter name to get parameter value accordingly
					paramName = (String) params.nextElement();
					// get parameter value
					paramValues = request.getParameterValues(paramName);

					System.out.println(paramName + ": " + request.getParameter(paramName));

					// add to array in order
					for (int i = 0; i < paramValues.length; i++) {
						databaseValues.add(paramValues[i].toString());
					}
				}
			} else {
				System.out.println("No element in params");
			}

			// 6 columns in the table
			if (databaseValues.size() >= 6) {
				for (int i = 0, j = 1; i < 6; i++, j++) {
					// getting datatype
					System.out.println(databaseValues.get(i).getClass().getName());

					if (i == 3) { // for birthdate
						java.sql.Date sqlDate = java.sql.Date.valueOf(databaseValues.get(i));
						insertStatement.setDate(j, sqlDate);
					} else if (i == 5) {
						String hashPwd = hashPassword(databaseValues.get(i));
						insertStatement.setString(j, hashPwd);
					} else {
						insertStatement.setString(j, databaseValues.get(i));
					}
				}
			} else {
				System.out.println("Insufficient parameters received.");
				return;
			}

			// execute statement
			int insertedRow = insertStatement.executeUpdate();

			if (insertedRow > 0) {
				response.sendRedirect("../client/home.jsp?code=successfulRegistration");
			}

			// Close all the connections
			insertStatement.close();
			con.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
