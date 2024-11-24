<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>SqueakyClean</title>
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
    }
%>

<!-- Modal for Error Handling -->
<%
    if (code != null) {
%>
<div id="errorModal" class="modal fade" tabindex="-1" aria-labelledby="errorModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="errorModalLabel"><%=title%></h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body text-center">
        <svg class="mx-auto h-12 w-12 text-green-500" fill="none"
          stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
            d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
        </svg>
        <p class="text-sm text-gray-600 mb-4"><%=msg%></p>
      </div>
      <div class="modal-footer">
        <form method="POST" action="modal.jsp">
          <button type="submit" class="btn btn-danger w-100">Close</button>
        </form>
      </div>
    </div>
  </div>
</div>
<%
    }
%>

<!-- Modal for Booking Confirmation -->
<% 
    Boolean bookingConfirmed = (Boolean) request.getAttribute("bookingConfirmed");
    if (bookingConfirmed != null && bookingConfirmed) {
%>
<div class="modal fade" id="bookingConfirmationModal" tabindex="-1" aria-labelledby="bookingConfirmationModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="bookingConfirmationModalLabel">Booking Confirmed</h5>
      </div>
      <div class="modal-body text-center">
        <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" fill="green" class="bi bi-check-circle" viewBox="0 0 16 16">
          <path d="M16 8a8 8 0 1 1-16 0 8 8 0 0 1 16 0ZM7.293 10.293a1 1 0 0 0 1.414 0L12 6.707l-1.414-1.414L8 8.586l-2.293-2.293-1.414 1.414L7.293 10.293Z"/>
        </svg>
        <p class="mt-3">Your booking has been confirmed successfully!</p>
      </div>
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
        <button class="btn btn-outline-dark btn-lg" onClick="window.location.href='services.jsp'">Book a Service</button>
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

<script>
  // Automatically show the modal if 'bookingConfirmed' attribute is present
  <% if (bookingConfirmed != null && bookingConfirmed) { %>
    var myModal = new bootstrap.Modal(document.getElementById('bookingConfirmationModal'));
    myModal.show();
  <% } %>

  // Automatically show the error modal if the code is set
  <% if (code != null) { %>
    var errorModal = new bootstrap.Modal(document.getElementById('errorModal'));
    errorModal.show();
  <% } %>
</script>

</body>
</html>
