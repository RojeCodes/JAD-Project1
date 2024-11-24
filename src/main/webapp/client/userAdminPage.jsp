<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.ResultSet"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="include/bootstrap.html" %>
<%
	ResultSet rs = (ResultSet) request.getAttribute("users");
%>
<style>
        body {
            background-color: #f8f9fa;
        }
        .status {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .status .green {
            color: #28a745;
        }
        .status .red {
            color: #dc3545;
        }
        .circle {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            display: inline-block;
        }
        .circle.green {
            background-color: #28a745;
        }
        .circle.red {
            background-color: #dc3545;
        }
    </style>
    <title>User Management</title>
</head>
<body>
<%@ include file="adminNavBar.jsp" %> <!-- Include navigation -->

<div class="container mt-5">
    <h1 class="text-center mb-4 h1">Users</h1>
    <div class="row">
        <%
            int cardCount = 0; // Counter to track the number of cards
            try {
                while (rs.next()) {
                	int userId = rs.getInt("user_id");
                    String fullName = rs.getString("full_name");
                    String email = rs.getString("email");
                    String phone = rs.getString("phone");
                    String address = rs.getString("address");
                    boolean isBanned = rs.getBoolean("banned");
        %>
        <div class="col-sm-6 col-md-4 col-lg-3 mb-4">
            <div class="card h-100 py-3 shadow">
                <div class="card-body">
                    <h5 class="card-title text-primary"><%= fullName %></h5>
                    <p class="card-text text-muted"><strong>Email:</strong> <%= email %></p>
                    <p class="card-text text-muted"><strong>Phone:</strong> <%= phone %></p>
                    <p class="card-text text-muted"><strong>Address:</strong> <%= address %></p>
                    <p class="status">
                        <span class="circle <%= isBanned ? "red" : "green" %>"></span>
                        <span class="<%= isBanned ? "red" : "green" %>">
                            <strong>Status:</strong> <%= isBanned ? "Banned" : "Active" %>
                        </span>
                    </p>
                    <form action="ShowUsersServlet?userId=<%=userId %>&banned=<%=isBanned %>" method="POST">
                    	<button class="btn btn-sm btn-dark"><%= isBanned ? "Unban" : "Ban" %></button>
                    </form>
                </div>
            </div>
        </div>
        <%
                    cardCount++;
                }

                if (cardCount == 0) {
        %>
        <div class="col-12 text-center">
            <p class="text-danger">No users found.</p>
        </div>
        <%
                }
            } catch (Exception e) {
        %>
        <div class="col-12 text-center">
            <p class="text-danger">An error occurred while loading users: <%= e.getMessage() %></p>
        </div>
        <%
            }
        %>
    </div>
</div>
</body>
</html>
