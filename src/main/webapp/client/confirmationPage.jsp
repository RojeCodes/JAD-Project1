<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Booking confirmation page</title>

<%@ include file="include/bootstrap.html"%>
<%@ include file="include/tailwind.html"%>

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

</head>

<body>
	<%@include file="navBar.jsp"%>

	<%
	LoggedInUser user = new LoggedInUser();
	user = (LoggedInUser) session.getAttribute("user");
	
	String htmlContent = (String) request.getAttribute("htmlContent");
	
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

<div class="container d-flex justify-content-center align-items-center vh-100">
	<div class="booking-card w-full max-w-3xl ">
		<div class="confirmation-header">
			<h1 class="text-4xl font-bold mb-3">Booking Confirmed</h1>
			<p class="text-xl opacity-80">Your reservation is now complete</p>
		</div>
		<div class="py-2" style="font-size: 16px; color: #555;">
			<strong>Email Sent To:</strong> <span style="color: #333;"><%=user.getEmail() %></span>
		</div>

		<div>

			<%=htmlContent %>
		</div>
		</div>

		<div class="flex justify-center space-x-4 mt-8">
			<button onclick="window.print()"
				class="btn btn-outline-primary px-6 py-3 rounded-full">
				Print Receipt</button>
		</div>
	</div>
	</div>

</body>
</html>
