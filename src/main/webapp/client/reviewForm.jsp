<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="include/bootstrap.html" %>
<!-- Author : IDIA ROJE ANGELO PETROLA
Adm No : 2342335
Class : DIT/FT/2B/01
Date : 25/11/2024
Description : ST0510-JAD-Assignment1 -->
<title>Make Review</title>
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
      <h3 class="text-primary h3 mb-3">
        Make Review
      </h3>
      <p class="text-muted mb-4">
       	Tell us about your experience
      </p>
		<form action="<%=request.getContextPath() %>/ReviewServlet" method="POST">
		    <div class="mb-3">
		        <label for="rating" class="form-label">Rating:</label>
		        <select id="rating" name="rating" class="form-control" required>
		            <% for (int i = 1; i <= 5; i++) { %>
		                <option value="<%= i %>"><%= i %></option>
		            <% } %>
		        </select>
		    </div>
		    <div class="mb-3">
		        <label for="title" class="form-label">Review Title:</label>
		        <input id="title" name="title" class="form-control" required>
		    </div>
		    <div class="mb-3">
		        <label for="description" class="form-label">Describe your experience:</label>
		        <textarea id="description" name="description" class="form-control" required></textarea>
		    </div>
		    <div class="mb-3">
		        <input type="hidden" name="booking_id" value="<%= request.getAttribute("booking_id") %>">
		    </div>
		    <button type="submit" class="btn btn-dark btn-lg w-100">Submit</button>
		    <button type="button" class="btn btn-outline-dark btn-lg w-20" onClick="window.location.href='profile.jsp'">Back</button>
		</form>

    </div>
  </div>
</div>
</body>
</html>
