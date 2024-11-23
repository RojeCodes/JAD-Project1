<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Responsive Cleaning Service Page</title>
<style>
  .left-text {
    margin-top: 50px;
  }
  img {
    max-width: 100%;
    height: auto;
  }
</style>
</head>
<body class="bg-dark">
<%@ include file="include/bootstrap.html" %>
<%@ include file="navBar.jsp" %>

<%
	String code = request.getParameter("code");
	String title = "";
	String msg = "";
	if (code != null) {
		switch (code) {
		case "successfulRegistration":
			title = "Registration Successful";
			msg = "Please log in to access your account.";
			break;
		}
	%>
	<div id="errorModal" class="modal flex items-center justify-center">
		<div class="modal-content w-80 p-6 mx-4">
			<div class="text-center">
				<div class="mb-4">
					<svg class="mx-auto h-12 w-12 text-green-500" fill="none"
						stroke="currentColor" viewBox="0 0 24 24">
  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
							d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
</svg>
				</div>
				<h3 class="text-lg font-medium text-gray-900 mb-2"><%=title%></h3>
				<p class="text-sm text-gray-600 mb-4"><%=msg%></p>
				<form method="POST" action="modal.jsp">
					<button type="submit" id="closebtn"
						class="w-full py-2 px-4 bg-red-500 text-white rounded-full hover:bg-red-600 transition-colors">
						Close</button>
				</form>
			</div>
		</div>
	</div>
	<%
	}
	%>

<div class="container bg-white py-4">
  <div class="row align-items-center">
    <!-- Text Content -->
    <div class="col-md-6 left-text">
      <h1 class="h1 mb-3 text-center text-md-start">
        The widest range of services from $16/hour
      </h1>
      <p class="text-muted mb-4 text-center text-md-start">
        Your trusted partner for spotless spaces! At SqueakyClean, we specialize 
        in delivering top-notch cleaning solutions tailored to your home, office, 
        and commercial needs. Our professional team is committed to ensuring every 
        corner shines, using eco-friendly products and industry-leading techniques.
        <br><br>
        Whether it's a one-time deep clean or regular upkeep, we’re here to make 
        your life easier and your environment healthier. Experience the joy of 
        a pristine space with SqueakyClean—because a clean place is a happy place!
        <br><br>
        Schedule your cleaning today and let us take care of the mess!
      </p>
      <div class="text-center text-md-start">
        <button class="btn btn-outline-dark btn-lg">Book a Service</button>
      </div>
    </div>

    <!-- Image Content -->
    <div class="col-md-6">
      <img 
        src="https://res.cloudinary.com/dniamky93/image/upload/v1732243176/Best-Cleaning-Service-Sydney_hwqtts.jpg"
        alt="Cleaning Service"
        class="rounded shadow"
      >
    </div>
  </div>
</div>
</body>
</html>
