<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.ArrayList, classes.Booking"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Cart</title>
    <%@ include file="include/bootstrap.html" %> <!-- Include Bootstrap -->
    <style>
        body {
            background-color: #f8f9fa; /* Light background color */
        }
        .container {
            margin-top: 50px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1); /* Subtle shadow */
            padding: 30px;
        }
        .table th, .table td {
            text-align: center;
            vertical-align: middle;
        }
        .table th {
            background-color: #343a40;
            color: white;
        }
        .table-striped tbody tr:nth-child(odd) {
            background-color: #f2f2f2;
        }
        .btn-custom {
            background-color: #28a745;
            color: white;
        }
        .btn-custom:hover {
            background-color: #218838;
        }
        .modal-content {
            border-radius: 8px;
        }
    </style>
</head>
<body>

<%@ include file="navBar.jsp" %>

<% 
// Check if the user is logged in or not
LoggedInUser user = (LoggedInUser) session.getAttribute("user");
String errCode = request.getParameter("errCode");

if (user == null || (errCode != null && errCode.equals("invalidLogin"))) {
    String errTitle = "You have been logged out.";
    String errMsg = "Please log in again."; 
%>
    <!-- Modal for error message -->
    <div id="errorModal" class="modal fade show" style="display: block;">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><%= errTitle %></h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p><%= errMsg %></p>
                </div>
                <div class="modal-footer">
                    <form method="POST" action="<%= contextPath %>/client/modal.jsp">
                        <button type="submit" class="btn btn-danger">Close</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <% 
    return; 
} 
%>

<% 
// Retrieve the cart from the session
ArrayList<Booking> cart = (ArrayList<Booking>) session.getAttribute("cart"); 

if (cart == null || cart.isEmpty()) {
%>
    <div class="container">
        <p class="text-center text-danger">Your cart is currently empty. Please add some items to your cart.</p>
    </div>
<% 
} else {
%>
    <div class="container">
        <h2 class="text-center mb-4 h2"><strong>Your Cart</strong></h2>

        <table class="table table-striped table-bordered">
            <thead>
                <tr>
                    <th>Service ID</th>
                    <th>Date</th>
                    <th>Time</th>
                    <th>Hours</th>
                    <th>Price</th>
                </tr>
            </thead>
            <tbody>
                <% 
                double totalPrice = 0.0;
                // Loop through the cart ArrayList and display each Booking's details
                for (Booking booking : cart) { 
                    totalPrice += booking.getPrice();
                %>
                    <tr>
                        <td><%= booking.getServiceId() %></td>
                        <td><%= booking.getDate() %></td>
                        <td><%= booking.getTime() %></td>
                        <td><%= booking.getHourCount() %></td>
                        <td>$<%= String.format("%.2f", booking.getPrice()) %></td>
                    </tr>
                <% 
                } 
                %>
            </tbody>
        </table>

        <div class="text-right">
            <h4>Total Price: $<%= String.format("%.2f", totalPrice) %></h4>
        </div>

        <div class="text-center mt-4">
        	<form action="<%=contextPath%>/CheckoutServlet" method="GET">
        		<button class="btn btn-custom btn-lg">Checkout</button>
        	</form>
        </div>
    </div>
<% 
} 
%>

<!-- Include Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>
