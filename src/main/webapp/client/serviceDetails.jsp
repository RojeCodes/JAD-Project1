<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<%
	String serviceName = request.getParameter("serviceName");
    String description = request.getParameter("description");
    double price = Double.parseDouble(request.getParameter("price"));
    int service_id = Integer.parseInt(request.getParameter("service_id"));
%>
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
<div class="container bg-white py-4">
  <div class="row align-items-center">
    <!-- Text Content -->
    <div class="col-md-6 left-text">
      <h1 class="h1 mb-3 text-center text-md-start">
        <%=serviceName %>
      </h1>
      <p class="text-muted mb-4 text-center text-md-start">
		<%=description %>
      </p>
      <h3 class="h3">Price: <span class="text-success"><%=price %>0/hr</span></h3>
      <div class="text-center text-md-start">
      	<a href="bookingForm.jsp?serviceName=<%= serviceName %>&description=<%= description %>&price=<%=price%>&service_id=<%=service_id%>"><button class="btn btn-primary btn-lg">Add to Cart</button></a>
        <a href="services.jsp"><button class="btn btn-outline-dark btn-lg">Other Services</button></a>
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
