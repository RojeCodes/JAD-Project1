package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;

import classes.Booking;
import classes.LoggedInUser;

/**
 * Servlet implementation class BookingServlet
 */
@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BookingServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
		
//		request.getRequestDispatcher("./client/dummy.jsp").forward(request, response);
//		return;
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		System.out.println("nyo");
		try {
			String hourCountString = (String) request.getParameter("hourCount");
			int hourCount = Integer.parseInt(hourCountString);
			
			String serviceIdString = (String) request.getParameter("service_id");
			int serviceId = Integer.parseInt(serviceIdString);
			
			String priceString = (String) request.getParameter("price");
			double price = Double.parseDouble(priceString);
			
			String dateString = (String) request.getParameter("date");
			
            // Define the formatter matching the input date format
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
            
            // Parse the string into a LocalDate object
            LocalDate localDate = LocalDate.parse(dateString, dateFormatter);

            // Convert LocalDate to java.sql.Date
            Date date = Date.valueOf(localDate);
            
			String timeString = (String) request.getParameter("time");
			
            // Define the formatter matching the input time format
            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
            
            // Parse the string into a LocalTime object
            LocalTime localTime = LocalTime.parse(timeString, timeFormatter);
            
            // Convert LocalTime to java.sql.Time
            Time time = Time.valueOf(localTime);

			HttpSession session = request.getSession();
			
			LoggedInUser user = new LoggedInUser();
			user = (LoggedInUser) session.getAttribute("user");
			int userId = user.getUser_id();
			
			Booking booking = new Booking(date, time, hourCount, serviceId, userId, price);
			ArrayList<Booking> cart = (ArrayList<Booking>) session.getAttribute("cart");

			if (cart == null || cart.isEmpty()) {
				ArrayList<Booking> newCart = new ArrayList<Booking>();
				newCart.add(booking);
				session.setAttribute("cart", newCart);

			} else {
				cart.add(booking);
				session.setAttribute("cart", cart);

			}

		} catch (NumberFormatException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}

		request.getRequestDispatcher("./client/cartPage.jsp").forward(request, response);
		return;
		//doGet(request, response);
	}

}
