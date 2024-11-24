<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Booking Form</title>
<%
    String serviceName = request.getParameter("serviceName");
    String description = request.getParameter("description");
    double price = Double.parseDouble(request.getParameter("price"));
    int service_id = Integer.parseInt(request.getParameter("service_id"));
%>
<%@ include file="include/bootstrap.html" %>
<style>
    body {
        background-color: #f8f9fa; /* Soft gray background */
    }
    .container {
        margin-top: 50px;
        background: #ffffff; /* White card background */
        border-radius: 8px; /* Rounded corners */
        box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1); /* Subtle shadow */
        padding: 30px;
    }
    .form-label {
        font-weight: bold; /* Emphasize labels */
    }
    .form-control, .btn {
        border-radius: 5px; /* Rounded inputs */
    }
    .btn-outline-dark {
        transition: 0.3s ease-in-out; /* Smooth hover effect */
    }
    .btn-outline-dark:hover {
        background-color: #343a40; /* Darker background on hover */
        color: #fff;
    }
    .text-primary {
        font-weight: 600; /* Highlight service name */
    }
    .price-display {
        font-size: 1.2rem;
        font-weight: bold;
        color: #28a745; /* Green for price */
    }
</style>
<script>
    function updatePrice() {
        const pricePerHour = <%= price %>; // Price per hour from the server
        const hours = document.getElementById("hourCount").value; // Selected hours
        const totalPrice = pricePerHour * hours; // Calculate total price
        document.getElementById("priceDisplay").innerText = totalPrice.toFixed(2); // Update price display
    }
</script>
</head>
<body>
<%@ include file="navBar.jsp" %>
	<%
	System.out.println("bookingForm.jsp navigated");
	LoggedInUser user = new LoggedInUser();
	user = (LoggedInUser) session.getAttribute("user");
	
	String htmlContent = (String) request.getAttribute("htmlContent");
	System.out.println("HTML content rendered");
	String errCode = request.getParameter("errCode"); 

	if (user == null || (errCode != null && errCode.equals("invalidLogin"))) {
		System.out.println("user is null");
		String errTitle ="You have been logged out.";
		String errMsg = "Please log in again."; 
		/*response.sendRedirect("login.jsp"); */ // Redirect to login if the user is not logged in %>
	<div id="errorModal" class="modal flex items-center justify-center">
		<div class="modal-content w-80 p-6 mx-4">
			<div class="text-center">
				<div class="mb-4">
					<svg class="mx-auto h-12 w-12 text-red-500" fill="none"
						stroke="currentColor" viewBox="0 0 24 24">
						<!-- icon -->
                        <path stroke-linecap="round"
							stroke-linejoin="round" stroke-width="2"
							d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                    </svg>
				</div>
				<h3 class="text-lg font-medium text-gray-900 mb-2"><%=errTitle %></h3>
				<p class="text-sm text-gray-600 mb-4"><%=errMsg%></p>
				<form method="POST" action="<%=contextPath %>/client/modal.jsp">
					<button type="submit" id="closebtn"
						class="w-full py-2 px-4 bg-red-500 text-white rounded-full hover:bg-red-600 transition-colors">
						Close</button>
				</form>
			</div>
		</div>
	</div>
	<%		 
		return;
	}
	%>
	<%
		request.setAttribute("user_id", user.getUser_id());
	%>
<div class="container">
  <div class="row align-items-center">
    <!-- Image Content -->
    <div class="col-md-6">
      <img 
        src="https://res.cloudinary.com/dniamky93/image/upload/v1732243176/Best-Cleaning-Service-Sydney_hwqtts.jpg"
        alt="Cleaning Service"
        class="rounded shadow w-100"
      >
    </div>
    <!-- Text Content -->
    <div class="col-md-6">
      <h3 class="text-primary mb-3">
        <%= serviceName %>
      </h3>
      <p class="text-muted mb-4">
        <%= description %>
      </p>
      <form action="<%=contextPath %>/BookingServlet" method="POST">
        <div class="mb-3">
          <label for="hourCount" class="form-label">Number of Hours:</label>
          <select id="hourCount" name="hourCount" class="form-control" required onchange="updatePrice()">
            <% for (int i = 1; i <= 24; i++) { %>
              <option value="<%= i %>"><%= i %></option>
            <% } %>
          </select>
        </div>
        <div class="mb-3">
          <label for="date" class="form-label">Select Date:</label>
          <input type="date" id="date" name="date" class="form-control" required>
        </div>
        <div class="mb-3">
          <label for="time" class="form-label">Select Time:</label>
          <input type="time" id="time" name="time" class="form-control" required>
        </div>
        <div class="mb-3">
        <input type="hidden" name="service_id" value="<%= service_id%>">
        <input type="hidden" name="price" value="<%= price %>">
          <strong>Price: $<span id="priceDisplay" class="price-display"><%= price %></span></strong>
        </div>
        <button type="submit" class="btn btn-dark btn-lg w-100">Add to Cart</button>
        <button type="button" class="btn btn-outline-dark btn-lg w-20" onClick="window.location.href='services.jsp'">Back</button>
      </form>
    </div>
  </div>
</div>
</body>
</html>
