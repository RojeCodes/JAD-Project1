<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login</title>
<!-- Bootstrap CSS -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/5.3.0/css/bootstrap.min.css">

<!-- Tailwind CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css"
	rel="stylesheet">
<!-- Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>


</head>
<body>
<%@include file = "navBar.jsp" %>

	<%
	String errCode = request.getParameter("errCode");
	String errTitle ="";
	String errMsg = ""; 
	if (errCode != null) {
		switch (errCode) {
		case "invalidLogin":
			errTitle = "Invalid Credentials"; 
			errMsg = "Invalid Email or Password. Please try again."; 
					break; 
		}
	%>
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
	}
	%>
	<div class="container mt-5">
		<div class="row">
			<!-- Column for Image -->
			<div class="col-md-6 image-column  flex items-center justify-center">
				<img
					src=https://res.cloudinary.com/dw54pefsm/image/upload/v1731429414/man-clean-oval_u3ecs4.png
					alt="Big Picture" width=50%>
			</div>

			<!-- Column for Login Form -->
			<div class="col-md-6">
				<div class="loginContainer border-2 rounded-xl px-8 py-8">
					<div class="text-center mb-6">
						<h2 class="text-2xl font-bold text-gray-800 mb-2">
							SQUEAKYCLEAN</h2>
						<p class="text-sm text-gray-600">Experience squeaky cleaning
							services</p>
					</div>
					<form action="/ST0510_JAD_Proj/user/login" method="POST">
						<div class="mb-3">
							<label for="email" class="form-label">email</label> <input
								type="text" class="form-control" id="email" name="email"
								required>
						</div>
						<div class="mb-3">
							<label for="password" class="form-label">Password</label> <input
								type="password" class="form-control" id="password"
								name="password" required>
						</div>
						<button type="submit" class="btn btn-primary">Submit</button>
					</form>
					<p class="text-center mt-4 text-xs text-gray-600">

						Don't have an account? <a href="./register.jsp"
							class="text-blue-600 hover:underline">Sign up</a>
					</p>
				</div>

			</div>
</body>
</html>