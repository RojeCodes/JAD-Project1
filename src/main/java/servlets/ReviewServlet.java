package servlets;


/*Author :IDIA ROJE ANGELO PETROLA 
Adm No : 2342335
Class : DIT/FT/2B/01
Date : 25/11/2024
Description : ST0510-JAD-Assignment1
*/

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
import classes.Review;

/**
 * Servlet implementation class ReviewServlet
 */
@WebServlet("/ReviewServlet")
public class ReviewServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ReviewServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
		
		HttpSession session = request.getSession(false);
		List<Review> reviews = getReviews();
		
	     request.setAttribute("reviews", reviews);
	     request.getRequestDispatcher("./client/review.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		List<Review> reviews = new ArrayList<>();
		System.out.println("doPost called in ReviewServlet");////////////////
		try {
			int star_count = Integer.parseInt(request.("rating"));
			String title = request.getParameter("title");
			String description = request.getParameter("description");
			int booking_id = Integer.parseInt(request.getParameter("booking_id"));
			
			System.out.println("Rating: " + star_count);///////////////////
			System.out.println("Title: " + title);/////////////////////
			System.out.println("Description: " + description);//////////////////////
			System.out.println("Booking ID: " + booking_id);////////////////////////

			Connection conn = DatabaseConnection.initializeDatabase();
			System.out.println("Database Connection established and parameters retrieved")///////////////
			String selectStr = "INSERT INTO review(star_count, review_title, description, booking_id) VALUES (?,?,?,?);";

			PreparedStatement userStatement = conn.prepareStatement(selectStr);
			
			userStatement.setInt(1, star_count);
			userStatement.setString(2, title);
			userStatement.setString(3, description);
			userStatement.setInt(4, booking_id);
			
			int rowsAffected = userStatement.executeUpdate();
			System.out.println("Query executed successfully. Rows affected: " + rowsAffected);
			
			conn.close();

			request.setAttribute("reviewSubmitted", true);
		} catch (Exception e) {
			e.printStackTrace();
		}
	    request.getRequestDispatcher("./client/profile.jsp").forward(request, response);
	}

	private List<Review> getReviews() {
		System.out.println("getReviews() called");
		List<Review> reviews = new ArrayList<>();

		try {
			Connection conn = DatabaseConnection.initializeDatabase();

			String selectStr = "SELECT review.star_count, review.review_title, review.description, \"user\".full_name FROM review INNER JOIN booking ON review.booking_id = booking.booking_id INNER JOIN \"user\" ON booking.user_id = \"user\".user_id;";

			PreparedStatement userStatement = conn.prepareStatement(selectStr);

			ResultSet userSet = userStatement.executeQuery();
			
			while(userSet.next()) {  
				int starCount = userSet.getInt("star_count");
				String reviewTitle = userSet.getString("review_title");
				String description = userSet.getString("description");
				String authorName = userSet.getString("full_name");
				
				Review review = new Review(starCount, reviewTitle, description, authorName);
				reviews.add(review);
			}
			
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
		return reviews;
	}

}
