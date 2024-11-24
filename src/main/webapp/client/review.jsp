<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="classes.Review"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reviews Carousel</title>
    <%@include file="include/bootstrap.html"%>

    <style>
        body {
            background-color: #f8f9fa; /* Light background */
        }
        h1 {
            font-family: 'Poppins', sans-serif;
            margin-bottom: 2rem;
            color: #343a40;
        }
        .carousel-indicators button {
            background-color: #343a40; /* Darker indicators */
        }
        .carousel-item {
            padding: 20px;
        }
        .card {
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Subtle shadow */
            border: none;
        }
        .card-title {
            font-size: 1.5rem;
            color: #007bff;
        }
        .card-text {
            font-size: 1rem;
            color: #6c757d;
        }
        .text-muted {
            font-style: italic;
            color: #495057;
        }
        .stars {
            color: #ffc107; /* Yellow for stars */
            font-size: 1.2rem;
        }
        /* Custom styles for carousel controls */
        .carousel-control-prev-icon,
        .carousel-control-next-icon {
            filter: invert(1); /* Ensures icons are visible on light backgrounds */
        }
        .carousel-control-prev, 
        .carousel-control-next {
            background-color: rgba(52, 58, 64, 0.5); /* Semi-transparent dark background */
            width: 5%; /* Slightly wider for better clickability */
        }
    </style>
</head>
<body>
    <%@include file="navBar.jsp" %> <!-- Navigation bar -->

    <div class="container mt-5">
        <h1 class="text-center mb-4 h1">Customer Reviews</h1>
        
        <%
        List<Review> reviews = (List<Review>) request.getAttribute("reviews");
        System.out.println(reviews);
        if (reviews != null && !reviews.isEmpty()) {
        %>
        <div id="reviewsCarousel" class="carousel slide" data-bs-ride="carousel">
            <!-- Indicators -->
            <div class="carousel-indicators">
                <%
                for (int i = 0; i < reviews.size(); i++) {
                %>
                <button 
                    type="button" 
                    data-bs-target="#reviewsCarousel" 
                    data-bs-slide-to="<%= i %>" 
                    class="<%= i == 0 ? "active" : "" %>" 
                    aria-current="<%= i == 0 ? "true" : "false" %>" 
                    aria-label="Slide <%= i + 1 %>"></button>
                <%
                }
                %>
            </div>

            <!-- Carousel Items -->
            <div class="carousel-inner">
                <%
                for (int i = 0; i < reviews.size(); i++) {
                    Review review = reviews.get(i);
                %>
                <div class="carousel-item <%= i == 0 ? "active" : "" %>">
                    <div class="card text-center">
                        <div class="card-body">
                            <h5 class="card-title h5"><%= review.getReviewTitle() %></h5>
                            <p class="stars">
                            	<strong>Rating: </strong>
                                <!-- Render yellow stars based on the star count -->
                                <%
                                int starCount = review.getStarCount();
                                for (int j = 0; j < starCount; j++) {
                                %>
                                &#9733; <!-- Unicode for a filled star (★) -->
                                <%
                                }
                                %>
                            </p>
                            <p class="card-text">
                                <%= review.getDescription() %>
                            </p>
                            <p class="text-muted">
                                <em>Reviewed by: <%= review.authorName() %></em>
                            </p>
                        </div>
                    </div>
                </div>
                <%
                }
                %>
            </div>

            <!-- Carousel Controls -->
            <button class="carousel-control-prev" type="button" data-bs-target="#reviewsCarousel" data-bs-slide="prev">
                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Previous</span>
            </button>
            <button class="carousel-control-next" type="button" data-bs-target="#reviewsCarousel" data-bs-slide="next">
                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                <span class="visually-hidden">Next</span>
            </button>
        </div>
        <%
        } else {
        %>
        <p class="text-center text-muted">No reviews available.</p>
        <%
        }
        %>
       	<button class="btn btn-lg btn-secondary" onclick="window.location.href='home.jsp'">Home</button>
    	<button class="btn btn-lg btn-primary" onclick="window.location.href='client/services.jsp'">Explore Services</button>
    </div>
</body>
</html>
