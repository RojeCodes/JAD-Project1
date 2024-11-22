<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP navigation bar</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
	crossorigin="anonymous">
<link
	href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css"
	rel="stylesheet">
</head>
<body>
	<%
	String contextPath = request.getContextPath();
	System.out.println(contextPath);
	%>
	<nav class="navbar sticky-top navbar-expand-lg navbar-dark bg-dark">
		<a class="navbar-brand" href="<%=contextPath%>/client/home.jsp">SQUEAKYCLEAN</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse"
			data-target="#navbarNav" aria-controls="navbarNav"
			aria-expanded="false" aria-label="Toggle navigation">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div class="collapse navbar-collapse" id="navbarNav">
			<ul class="navbar-nav">
				<li class="nav-item active"><a class="nav-link"
					href="<%=contextPath%>/client/home.jsp">Home<span
						class="sr-only">(current)</span></a></li>
				<li class="nav-item"><a class="nav-link"
					href="<%=contextPath%>/getCategory">Our Service Category</a></li>
				<li class="nav-item"><a class="nav-link" href="#">Customer
						Testimonies</a></li>
				<li class="nav-item"><a class="nav-link" 
					href="<%=contextPath%>/client/policyPage.jsp">Our
						Policies</a></li>
				<li class="nav-item"><a class="nav-link"
					href="<%=contextPath%>/client/confirmationPage.jsp">Dummy
						confirmation page</a></li>
				<ul class="navbar-nav ms-auto">
					<li class="nav-item ml-auto"><a class="nav-link"
						href="cartPage.jsp"> <svg xmlns="http://www.w3.org/2000/svg"
								width="24" height="24" fill="currentColor" class="bi bi-cart"
								viewBox="0 0 16 16">
      <path
									d="M0 1.5A.5.5 0 0 1 .5 1H2a.5.5 0 0 1 .485.379L2.89 3H14.5a.5.5 0 0 1 .491.592l-1.5 8A.5.5 0 0 1 13 12H4a.5.5 0 0 1-.491-.408L2.01 3.607 1.61 2H.5a.5.5 0 0 1-.5-.5M3.102 4l1.313 7h8.17l1.313-7zM5 12a2 2 0 1 0 0 4 2 2 0 0 0 0-4m7 0a2 2 0 1 0 0 4 2 2 0 0 0 0-4m-7 1a1 1 0 1 1 0 2 1 1 0 0 1 0-2m7 0a1 1 0 1 1 0 2 1 1 0 0 1 0-2" />
    </svg>
					</a></li>
					<li class="nav-item ml-auto"><a class="nav-link"
						href="<%=contextPath%>/client/profile.jsp"> <svg
								xmlns="http://www.w3.org/2000/svg" width="24" height="24"
								fill="currentColor" class="bi bi-person-fill"
								viewBox="0 0 16 16">
  <path
									d="M3 14s-1 0-1-1 1-4 6-4 6 3 6 4-1 1-1 1zm5-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6" />
</svg>
					</a></li>
				</ul>
			</ul>
		</div>
	</nav>
</body>
</html>
