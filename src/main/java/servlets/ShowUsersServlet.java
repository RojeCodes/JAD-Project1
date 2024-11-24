package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * Servlet implementation class ShowUsersServlet
 */
@WebServlet("/ShowUsersServlet")
public class ShowUsersServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ShowUsersServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
		
		ResultSet userSet = getUsers();
		request.setAttribute("users", userSet);
		
		request.getRequestDispatcher("./client/userAdminPage.jsp").forward(request, response);
		return;
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		try {
			int userId = Integer.parseInt(request.getParameter("userId"));
			boolean banned = Boolean.parseBoolean(request.getParameter("banned"));
			
			System.out.println(userId);
			System.out.println(banned);
			toggleBanUser(userId, banned);
			
		} catch (NumberFormatException e) {
			e.printStackTrace();
		}
		doGet(request, response);
//		request.getRequestDispatcher("./client/userAdminPage.jsp").forward(request, response);
//		return;
	}
	
	private ResultSet getUsers() {
		ResultSet rs = null;
		
		try { 
			Connection conn = DatabaseConnection.initializeDatabase();
			
			String selectStr = "SELECT * FROM \"user\"";

			PreparedStatement userStatement = conn.prepareStatement(selectStr);

			rs = userStatement.executeQuery();
			
		} catch (Exception e) { 
			e.printStackTrace();
		}
		return rs; 
	}
	
	private void toggleBanUser(int userId, boolean banned) {
		try { 
			Connection conn = DatabaseConnection.initializeDatabase();
			
			String selectStr = "UPDATE \"user\" SET banned=? WHERE user_id=?;";

			PreparedStatement userStatement = conn.prepareStatement(selectStr);
			
			userStatement.setBoolean(1, !banned);
			userStatement.setInt(2, userId);

			int rowsAffected = userStatement.executeUpdate();
			
	        if (rowsAffected > 0) {
	            System.out.println("User status updated successfully.");
	        } else {
	            System.out.println("No user found with the specified ID.");
	        }
	        
	        userStatement.close();
			conn.close();
		} catch (Exception e) { 
			e.printStackTrace();
		}
	}
}
