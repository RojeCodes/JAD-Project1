<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <%@ include file="include/bootstrap.html" %>
    <style>
    .card {
    	min-height: 200px;
    }
    </style>
    <title>Services We Offer</title>
</head>
<body>
    <h1 class="text-center">Services We Offer</h1>
    <%
    String dbURL = "jdbc:postgresql://ep-sweet-meadow-a1jt5uuo.ap-southeast-1.aws.neon.tech:5432/JAD_DB?sslmode=require";
    String user = "JAD_DB_owner";
    String password = "Hi21hXqUSoKO";

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        // Load PostgreSQL JDBC driver
        Class.forName("org.postgresql.Driver");

        // Establish connection
        conn = DriverManager.getConnection(dbURL, user, password);

        // Execute the query to get all services
        stmt = conn.createStatement();
        String sql = "SELECT * FROM service;";
        rs = stmt.executeQuery(sql);
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } /*finally {
        // Close resources
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (stmt != null) stmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }*/
    %>
 <div class="container mt-4">
        <div class="row">
        <%
        	int cardCount = 0; // Counter to track the number of cards
            while (rs.next()) {
            	String serviceName = rs.getString("service_name");
                String description = rs.getString("description");

                // Create a card for each result
        %>
                	<div class="col-md-3 mb-4 card h-100">
                    	<div class="card-body">
                        	<h5 class="card-title"><%= serviceName %></h5>
                            <p class="card-text"><%= description %></p>
                        </div>
                    </div>
        <%
                cardCount++;
                // Close the row after every 4 cards
                if (cardCount % 4 == 0) {
        %>
        	</div>
        		<div class="row">
       	<%
                }
         	}
        %>
        </div>
    </div>
</body>
</html>
