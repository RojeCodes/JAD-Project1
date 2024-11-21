package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

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
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession httpSession = request.getSession(false);
		LoggedInUser user = (LoggedInUser) httpSession.getAttribute("user"); 
		
		if (user == null) { 
			response.sendRedirect("../client/confirmationPage.jsp?errCode=invalidLogin");
		}
		final String toEmail = user.getEmail();

		String htmlContent = "";
		Properties props = new Properties();
		
		props.put("mail.smtp.host", smtpHost);
		props.put("mail.smtp.port", smtpPort);
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		String str = "";

		str += "<html><body>" + "<h1>Booking Confirmation</h1>" + "<p>Your booking has been confirmed.</p>"
				+ "-----------------------------------------";
		str += "<br> <p>Booking details fetched from the session or db</p>";
		str += "</body></html>";
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
			message.setSubject("Test Email from Servlet");

			message.setContent(htmlContent, "text/html; charset=utf-8");
			// Send the email
			Transport.send(message);
			System.out.println(message);

		} catch (MessagingException e) {
			e.printStackTrace();
			response.getWriter().write("Error sending email: " + e.getMessage());
		}

	}
}
