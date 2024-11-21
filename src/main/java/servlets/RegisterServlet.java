package servlets;

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

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// config
		Enumeration<String> params = request.getParameterNames();
		String paramName = "";
		String[] paramValues = null;
		ArrayList<String> databaseValues = new ArrayList<>();

		// processing
		String userEmail = request.getParameter("email");
		String userPhone = request.getParameter("phone");
		
		System.out.println("My user EMAIL : " + userEmail);

		String pwd = request.getParameter("password");
		String confirmPwd = request.getParameter("confirmpassword");

		if (!pwd.equals(confirmPwd)) {
			System.out.println("Passwords don't match");
			response.sendRedirect("client/register.jsp?errCode=passwordMismatch");
		}
		try {
			// Initialize the database
			Connection con = DatabaseConnection.initializeDatabase();

			PreparedStatement selectStatement = con.prepareStatement("select * from \"user\" where email = ? OR phone = ?");
			selectStatement.setString(1, userEmail);
			selectStatement.setString(2, userPhone);
			System.out.println(userEmail);

			ResultSet userSet = selectStatement.executeQuery();
			
			// if duplicate user exist 
			if (userSet.next()) {
				System.out.println(userSet.getString(6));
				response.sendRedirect("../client/register.jsp?errCode=duplicateEmail");
				return;
			} else {

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
						} else {
							insertStatement.setString(j, databaseValues.get(i));
						}
					}
				} else {
					System.out.println("Insufficient parameters received.");
					return;
				}

				// execute statement
				insertStatement.executeUpdate();

				// Close all the connections
				selectStatement.close();
				insertStatement.close();
				con.close();

			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
