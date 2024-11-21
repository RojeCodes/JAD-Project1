<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Booking confirmation page</title>

<style>
body {
	background: linear-gradient(135deg, #f6f8f9 0%, #e5ebee 100%);
}

.booking-card {
	box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
	border-radius: 15px;
	overflow: hidden;
}

.confirmation-header {
	background: linear-gradient(45deg, #4a90e2, #50c878);
	color: white;
	padding: 2rem;
	text-align: center;
}

.detail-section {
	background-color: white;
	padding: 2rem;
}
</style>
<script>

window.onload = function() {
    document.getElementById("confirmationForm").submit();
};
</script>



<!-- Tailwind CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/tailwindcss@3.0.24/dist/tailwind.min.css"
	rel="stylesheet">

<!-- Bootstrap CSS -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/5.3.0/css/bootstrap.min.css">

<!-- Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</head>

<body>

<%@page import = "classes.LoggedInUser" %>

	<%
	LoggedInUser user = new LoggedInUser();
	user = (LoggedInUser) session.getAttribute("user");
	
	String errCode = request.getParameter("errCode"); 

	if (user == null || (errCode != null && errCode.equals("invalidLogin"))) {
		String errTitle ="You have been logged out.";
		String errMsg = "Please log in again."; 
	/* 	response.sendRedirect("login.jsp"); */ // Redirect to login if the user is not logged in %>
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
				<form method="POST" action="modal.jsp">
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


	<div class="booking-card w-full max-w-3xl">
		<div class="confirmation-header">
			<h1 class="text-4xl font-bold mb-3">Booking Confirmed</h1>
			<p class="text-xl opacity-80">Your reservation is now complete</p>
		</div>

		<div class="detail-section">
			<div class="grid md:grid-cols-2 gap-6">
				<div>
					<h2 class="text-2xl font-semibold mb-4 text-gray-700">Booking
						Details</h2>
					<div class="space-y-3">
						<div class="flex justify-between border-b pb-2">
							<span class="font-medium text-gray-600">Booking ID</span> <span
								class="font-bold">#BK2024-5678</span>
						</div>
						<div class="flex justify-between border-b pb-2">
							<span class="font-medium text-gray-600">Date</span> <span>June
								15, 2024</span>
						</div>
						<div class="flex justify-between border-b pb-2">
							<span class="font-medium text-gray-600">Time</span> <span>2:00
								PM</span>
						</div>
					</div>
				</div>

				<div>
					<h2 class="text-2xl font-semibold mb-4 text-gray-700">Customer
						Information</h2>
					<div class="space-y-3">
						<div class="flex justify-between border-b pb-2">
							<span class="font-medium text-gray-600">Name</span> <span>John
								Doe</span>
						</div>
						<div class="flex justify-between border-b pb-2">
							<span class="font-medium text-gray-600">Email</span> <span>john.doe@example.com</span>
						</div>
						<div class="flex justify-between border-b pb-2">
							<span class="font-medium text-gray-600">Phone</span> <span>+1
								(555) 123-4567</span>
						</div>
					</div>
				</div>
			</div>

			<div class="mt-8">
				<h2 class="text-2xl font-semibold mb-4 text-gray-700">Booking
					Summary</h2>
				<div class="bg-gray-50 p-4 rounded-lg">
					<div class="flex justify-between mb-2">
						<span>Room Reservation</span> <span class="font-bold">$250.00</span>
					</div>
					<div class="flex justify-between mb-2">
						<span>Additional Services</span> <span class="font-bold">$50.00</span>
					</div>
					<hr class="my-2 border-gray-300">
					<div class="flex justify-between text-xl font-bold text-green-600">
						<span>Total</span> <span>$300.00</span>
					</div>
				</div>
			</div>

			<div class="flex justify-center space-x-4 mt-8">
				<button onclick="window.print()"
					class="btn btn-outline-primary px-6 py-3 rounded-full">
					Print Receipt</button>
			</div>
		</div>
	</div>
 	
			<!-- Form to send content to the backend -->
			<form id="confirmationForm" action="../bookingEmail" method="POST">
				Hidden field containing the page content
				<input type="hidden" name="htmlContent" id="htmlContent">
			</form> 

	    <script>
        // Copy the confirmation content to the hidden input
        document.getElementById("htmlContent").value = document.getElementById("booking-card").innerHTML;
    </script>
    
</body>
</html>