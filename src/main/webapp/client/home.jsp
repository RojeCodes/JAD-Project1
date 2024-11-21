<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Home</title>
<!-- Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>

</head>
<body>
<%@include file = "navBar.jsp" %>
	<%@page import="classes.LoggedInUser"%>
	<%
	// HttpSession session = request.getSession(false);

	
/*  if (user == null) {
		String errTitle = "You have been logged out";
		String errMsg = "Please log in again";
 } */
	%>
	<h1>This is the home page.</h1>
</body>
</html>