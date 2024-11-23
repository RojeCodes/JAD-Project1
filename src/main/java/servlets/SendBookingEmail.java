package servlets;

import jakarta.servlet.RequestDispatcher;
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
import java.sql.Statement;
import java.util.Properties;

import javax.swing.text.Document;

import classes.LoggedInUser;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

/**
 * Servlet implementation class SendBookingEmail
 */
@WebServlet("/bookingEmail")
public class SendBookingEmail extends HttpServlet {
	private static final long serialVersionUID = 1L;
	// Define email credentials and SMTP settings
	private final String fromEmail = "jadproject@zohomail.com";
	private final String password = "Heather1234!";
	private final String smtpHost = "smtp.zoho.com"; // e.g., smtp.gmail.com
	private final String smtpPort = "587";

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public SendBookingEmail() {
		super();
		// TODO Auto-generated constructor stub
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession httpSession = request.getSession(false);

		if (httpSession == null) {
			System.out.println("user is null");
			response.sendRedirect("./client/confirmationPage.jsp?errCode=invalidLogin");
			return;
		}

		LoggedInUser user = (LoggedInUser) httpSession.getAttribute("user");


		if (user == null) {
			System.out.println("user is null");
			response.sendRedirect("./client/confirmationPage.jsp?errCode=invalidLogin");
			return;
		}
		final String toEmail = user.getEmail();
		final int user_id = user.getUser_id();

		int receipt_id = 0;
		String htmlContent = "";

		Properties props = new Properties();

		props.put("mail.smtp.host", smtpHost);
		props.put("mail.smtp.port", smtpPort);
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");

		String service_name = "";
		double service_price = 0.0;
		double total_price = 0.0;
		String str = "";

		str += "<html><body>";
		str += "<div style=\"font-family: Arial, sans-serif; padding: 20px; background-color: #f4f4f4; max-width: 600px; margin: 0 auto; border-radius: 8px;\">\r\n"
				+ "    <h2 style=\"font-size: 24px; font-weight: 600; color: #333; text-align: center;\">Booking Details</h2>";
		try {
			Connection conn = DatabaseConnection.initializeDatabase();

			String selectStr = "SELECT * FROM receipt WHERE user_id = ? ORDER BY time_added DESC " + "LIMIT 1;";

			PreparedStatement userStatement = conn.prepareStatement(selectStr);

			userStatement.setInt(1, user_id);

			ResultSet receipt = userStatement.executeQuery();

			if (receipt.next()) {
				receipt_id = receipt.getInt("receipt_id");
			}

			String bookingSelectStr = "SELECT * FROM booking WHERE user_id = ? AND receipt_id =?";

			PreparedStatement bookingStatement = conn.prepareStatement(bookingSelectStr);

			bookingStatement.setInt(1, user_id);
			bookingStatement.setInt(2, receipt_id);

			ResultSet booking = bookingStatement.executeQuery();
			// System.out.print(booking.next()); // shows true

			// PRESENTATION
			str += "<br> <h2> Receipt Id : " + receipt_id + " </h2>";

			while (booking.next()) {
				int service_id = booking.getInt("service_id");
				int booking_hour = 0;
				double totalBookingPrice = 0.0;
				booking_hour = booking.getInt("hour_count");
				String serviceStr = "SELECT service_name, price FROM \"service\"" + " WHERE service_id = ?";
				PreparedStatement serviceStatement = conn.prepareStatement(serviceStr);
				serviceStatement.setInt(1, service_id);

				ResultSet serviceSet = serviceStatement.executeQuery();

				if (serviceSet.next()) {
					System.out.println(serviceSet);
					// Get the value of service_name column
					service_name = serviceSet.getString("service_name");
					service_price = serviceSet.getDouble("price");
				} else {
					System.out.println("No service with such id");
				}

				totalBookingPrice = (service_price * booking_hour);
				total_price += totalBookingPrice;

				// close connection
				conn.close();
				
				// presentation
				str += "<div style=\"border-top: 2px solid #4CAF50; padding-top: 15px;\">";
				str += "  <div style=\"display: flex; justify-content: space-between; padding: 10px 0;\">\r\n"
						+ "            <span style=\"font-weight: bold; color: #555;\">Booking Service:</span>\r\n"
						+ "            <span style=\"color: #333;\">" + service_name + "</span>\r\n" + "        </div>";
				str += "   <div style=\"display: flex; justify-content: space-between; padding: 10px 0;\">\r\n"
						+ "            <span style=\"font-weight: bold; color: #555;\">Date:</span>\r\n"
						+ "            <span style=\"color: #333;\">" + booking.getDate("date") + "</span>\r\n"
						+ "        </div>\r\n";
				str += "  <div style=\"display: flex; justify-content: space-between; padding: 10px 0;\">\r\n"
						+ "            <span style=\"font-weight: bold; color: #555;\">Time:</span>\r\n"
						+ "            <span style=\"color: #333;\">" + booking.getTime("time") + "</span>\r\n"
						+ "        </div>\r\n";
				str += "        <div style=\"display: flex; justify-content: space-between; padding: 10px 0;\">\r\n"
						+ "            <span style=\"font-weight: bold; color: #555;\">Hours Booked:</span>\r\n"
						+ "            <span style=\"color: #333;\">" + booking.getInt("hour_count") + "</span>\r\n"
						+ "        </div>\r\n";
				str += "        <div style=\"display: flex; justify-content: space-between; padding: 10px 0;\">\r\n"
						+ "            <span style=\"font-weight: bold; color: #555;\">Price (per hour):</span>\r\n"
						+ "            <span style=\"color: #333;\">" + service_price + "</span>\r\n" + "  </div>";

				str += "<div style=\"display: flex; justify-content: space-between; padding: 10px 0;\">\r\n"
						+ "            <span style=\"font-weight: bold; color: #555;\">Price:</span>\r\n"
						+ "            <span style=\"color: #333;\">" + totalBookingPrice + "</span>\r\n"
						+ "        </div>\r\n" + "    </div>";
			}

			str += " <div style=\"display: flex; justify-content: space-between; padding: 10px 0;\">\r\n"
					+ "            <span style=\"font-weight: bold; color: #4CAF50;\">Total Price:</span>\r\n"
					+ "            <span style=\"color: #333; font-size: 18px; font-weight: bold;\">" + total_price
					+ "</span>\r\n" + "        </div>";
			str += "<br> <p style=\"font-size: 14px; color: #777; line-height: 1.6;\">"
					+ "<strong> Estimated Service Hours:</strong>" + "The number of hours selected is an estimate, "
					+ "and the actual time required may vary depending "
					+ "on the scope of the cleaning service and other factors.</p>";
		} catch (Exception e) {
			e.printStackTrace();
		}

		str += "</div> </div></body></html>";
		htmlContent = str;

		System.out.println(htmlContent);

		System.out.println("HTML Content received: " + htmlContent);

		Session session = Session.getInstance(props, new javax.mail.Authenticator() {
			@Override
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(fromEmail, password);
			}
		});

		// Create the email message
		try {
			MimeMessage message = new MimeMessage(session);
			message.setFrom(new InternetAddress(fromEmail));
			message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
			message.setSubject("SQUEAKYCLEAN Booking Confirmation");

			message.setContent(htmlContent, "text/html; charset=utf-8");
			// Send the email
			Transport.send(message);
			System.out.println(message);

			request.setAttribute("htmlContent", htmlContent);
			RequestDispatcher dispatcher = request.getRequestDispatcher("./client/confirmationPage.jsp");
			dispatcher.forward(request, response);

		} catch (MessagingException e) {
			e.printStackTrace();
			response.getWriter().write("Error sending email: " + e.getMessage());
		}

	}
}
