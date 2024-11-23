package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import classes.LoggedInUser;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

/**
 * Servlet implementation class UserEditServlet
 */
@WebServlet("/editProfile")
public class UserEditServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public UserEditServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String editValue = request.getParameter("newDetail"); 
		HttpSession session = request.getSession(false); 
		LoggedInUser user = (LoggedInUser) session.getAttribute("user");
		
		if (user == null) { 
			response.sendRedirect("./client/login.jsp?errCode=invalidLogin");
			return;
		}

		String editField = request.getParameter("inputField");
		System.out.println(editField); // full_name
		System.out.println(editValue);
		try { 
			// Initialize the database
			Connection conn = DatabaseConnection.initializeDatabase();
			String updateStr = "UPDATE \"user\"  SET " + editField + "= ? WHERE user_id = ?";	
			
			PreparedStatement userStatement = conn.prepareStatement(updateStr);
			
			if (editField.equals("birthdate")) {
				java.sql.Date sqlDate = java.sql.Date.valueOf(editValue);
				userStatement.setDate(1, sqlDate);
			} else {
			userStatement.setString(1, editValue);
			}

			userStatement.setInt(2, user.getUser_id());

			int rows=userStatement.executeUpdate();
			
			  if (rows > 0) {
			        // Update the LoggedInUser object in the session
			        switch (editField) {
			        case "full_name" : 
			        	user.setFull_name(editValue);
			        	break; 
			        case "birthdate" : 
			        	user.setbirthdate(editValue);
			        	break; 
			        case "phone" : 
			        	user.setPhone(editValue);
			        	break; 
			        case "email" : 
			        	user.setEmail(editValue);
			        	break; 
			        case "address" :
			        	user.setAddress(editValue);
			        	break;
 			        }
			  }
			  
			  conn.close();
			  response.sendRedirect("./client/profile.jsp");
		} catch (Exception e) { 
			e.printStackTrace();
		}
	}

}
