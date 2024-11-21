package servlets;

import jakarta.servlet.ServletException;
import classes.LoggedInUser;
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
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Enumeration;

/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/user/login")
public class LoginServlet extends HttpServlet {
	public LoginServlet() {
		super();
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// config
		Enumeration<String> params = request.getParameterNames();
		String paramName = "";
		String[] paramValues = null;
		ArrayList<String> databaseValues = new ArrayList<>();
		LoggedInUser user = new LoggedInUser();

		HttpSession session = request.getSession();
		session.setMaxInactiveInterval(600);
		try {
			// Initialize the database
			Connection conn = DatabaseConnection.initializeDatabase();
			
	          Statement stmt = conn.createStatement();

			String selectStr = "SELECT * FROM \"user\" where email=? AND password=?";
			PreparedStatement userStatement = conn.prepareStatement(selectStr);

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

			for (int i = 0, j = 1; i < databaseValues.size(); i++, j++) {
				// getting datatype
				System.out.println(databaseValues.get(i).getClass().getName());
				userStatement.setString(j, databaseValues.get(i));
			}

			// execute statement
			ResultSet userSet = userStatement.executeQuery();

			// data processing 
			if (userSet.next()) {
				// Get all columns from the ResultSet dynamically
				ResultSetMetaData metaData = userSet.getMetaData();
				int columnCount = metaData.getColumnCount();

				for (int i = 1; i <= columnCount; i++) {

					// getting the column name from the database
					String columnName = metaData.getColumnName(i);

					// getting the value from the database
					Object value = userSet.getObject(i);

					// Skip this column
					if ("password".equalsIgnoreCase(columnName)) {
						continue;
					}

					try {
						// getting the fields of the java class
						Field field = LoggedInUser.class.getDeclaredField(columnName);
						field.setAccessible(true); // Make the private field accessible

						
						// if birthdate
						if ("birthdate".equalsIgnoreCase(columnName)) {
							// since the data fetched from the database is in sql.Date,
							// we have to change it to String
							String birthdateStr = value.toString(); // yyyy-mm-dd format

							field.set(user, birthdateStr); // Set the value as a String

						} else if ("phone".equalsIgnoreCase(columnName)) { 
							String phoneStr = value.toString().replaceAll("\\s", ""); 
							field.set(user, phoneStr);
						} else {
							// For other fields, set the value directly
							field.set(user, value);
						}
					} catch (NoSuchFieldException | IllegalAccessException e) {
						e.printStackTrace();
					}
				}
				
				session.setAttribute("user", user);
				session.setMaxInactiveInterval(30 * 60); // 30 mins 
				
				if (user.getRole_id() == 1) {
					response.sendRedirect("../AdminCalendar");
				} else {
					response.sendRedirect("../GetUserBookings");
				}
			}

			else {
				// user with the email and password not found
				response.sendRedirect("../client/login.jsp?errCode=invalidLogin");
			}
			// Close all the connections
			userStatement.close();
			conn.close();

		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
		}

	}

}
