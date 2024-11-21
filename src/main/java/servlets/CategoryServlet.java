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

import classes.Category;
import classes.LoggedInUser;
import classes.UserBooking;
/**
 * Servlet implementation class CategoryServlet
 */
@WebServlet("/getCategory")
public class CategoryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CategoryServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		if (session == null) {

			// only 1 response.send can be done at each time
			// response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "User is not logged
			// in.");
			response.sendRedirect("./client/login.jsp");
			return;
		}

		List<Category> categories = getCategories();
		System.out.println("categories in CategoryServlet" + categories);

		// Add bookings to the request scope
		// session.setAttribute("categories", categories);
		// request.setAttribute("bookings", bookings);

		// Forward to the JSP page

	     request.setAttribute("categories", categories);
	     request.getRequestDispatcher("./client/category.jsp").forward(request, response);
		
//		RequestDispatcher dispatcher = request.getRequestDispatcher("./client/profile.jsp");
//		dispatcher.forward(request, response);

//		 response.sendRedirect("/ST0510_JAD_Proj/client/home.jsp");

		return;
	}

	
	private List<Category> getCategories() {
		List<Category> categories = new ArrayList<>();
		
		try { 
			Connection conn = DatabaseConnection.initializeDatabase();
			
			String selectStr = "SELECT * FROM \"category\"";

			PreparedStatement userStatement = conn.prepareStatement(selectStr);

			ResultSet userSet = userStatement.executeQuery();
			
			while(userSet.next()) { 
				Category category = new Category(); 
				category.setCategory_name(userSet.getString("category_name"));
				category.setDescription(userSet.getString("description"));
				category.setImg_url(userSet.getString("img_url"));
				categories.add(category);
			}
			
		} catch (Exception e) { 
			e.printStackTrace();
		}
		return categories; 
	}
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
