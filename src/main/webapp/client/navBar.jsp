<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>JSP navigation bar</title>
    <%@ include file="include/bootstrap.html"%>
    <%@ include file="include/tailwind.html"%>
    <%@page import = "classes.*" %>
</head>
<body>
<% String contextPath = request.getContextPath(); 

LoggedInUser myUser = (LoggedInUser) session.getAttribute("user"); 
String str = ""; 
String tag = "";

System.out.println("myUser " +myUser);
if (myUser != null) { 
	str = contextPath+"/client/login.jsp\"?\"action=logOut"; 
	tag = "Log Out"; 
} else { 
	str = contextPath+"/client/login.jsp"; 
	tag = "Log In"; 

}
%>

<nav class="navbar sticky-top navbar-expand-lg navbar-dark bg-dark shadow-md">
    <div class="container-fluid">
        <!-- Brand -->
        <a class="navbar-brand font-bold text-xl tracking-wider hover:text-blue-300 transition-colors" 
           href="<%=contextPath%>/client/home.jsp">
            SQUEAKYCLEAN
        </a>

        <!-- Mobile Toggle Button -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Navbar Content -->
        <div class="collapse navbar-collapse" id="navbarNav">
            <!-- Left Side Navigation -->
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link active hover:bg-gray-700 rounded-md px-3 py-2 transition-colors" 
                       href="<%=contextPath%>/client/home.jsp">
                        Home
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link hover:bg-gray-700 rounded-md px-3 py-2 transition-colors" 
                       href="<%=contextPath%>/getCategory">
                        Our Service Category
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link hover:bg-gray-700 rounded-md px-3 py-2 transition-colors" 
                       href="#">
                        Customer Testimonies
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link hover:bg-gray-700 rounded-md px-3 py-2 transition-colors" 
                       href="#">
                        Our Policies
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link hover:bg-gray-700 rounded-md px-3 py-2 transition-colors" 
                       href="<%=contextPath%>/bookingEmail">
                        Dummy confirmation page
                    </a>
                </li>
            </ul>

            <!-- Right Side Navigation -->
            <ul class="navbar-nav ms-auto flex items-center gap-2">
                <li class="nav-item">
                    <a class="nav-link hover:bg-gray-700 rounded-md px-3 py-2 transition-colors" 
                       href="cartPage.jsp">
                        <div class="flex items-center gap-1">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" 
                                 class="bi bi-cart" viewBox="0 0 16 16">
                                <path d="M0 1.5A.5.5 0 0 1 .5 1H2a.5.5 0 0 1 .485.379L2.89 3H14.5a.5.5 0 0 1 .491.592l-1.5 8A.5.5 0 0 1 13 12H4a.5.5 0 0 1-.491-.408L2.01 3.607 1.61 2H.5a.5.5 0 0 1-.5-.5M3.102 4l1.313 7h8.17l1.313-7zM5 12a2 2 0 1 0 0 4 2 2 0 0 0 0-4m7 0a2 2 0 1 0 0 4 2 2 0 0 0 0-4m-7 1a1 1 0 1 1 0 2 1 1 0 0 1 0-2m7 0a1 1 0 1 1 0 2 1 1 0 0 1 0-2"/>
                            </svg>
                            <span class="hidden md:inline">Cart</span>
                        </div>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link hover:bg-gray-700 rounded-md px-3 py-2 transition-colors" 
                       href="<%=contextPath%>/client/profile.jsp">
                        <div class="flex items-center gap-1">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" 
                                 class="bi bi-person-fill" viewBox="0 0 16 16">
                                <path d="M3 14s-1 0-1-1 1-4 6-4 6 3 6 4-1 1-1 1zm5-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6"/>
                            </svg>
                            <span class="hidden md:inline">Profile</span>
                        </div>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link hover:bg-blue-600 rounded-md px-3 py-2 transition-colors flex items-center gap-1" 
                          href="<%=str%>">
                         <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" 
                             class="bi bi-box-arrow-in-right" viewBox="0 0 16 16">
                            <path fill-rule="evenodd" 
                                  d="M6 3.5a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v9a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5v-2a.5.5 0 0 0-1 0v2A1.5 1.5 0 0 0 6.5 14h8a1.5 1.5 0 0 0 1.5-1.5v-9A1.5 1.5 0 0 0 14.5 2h-8A1.5 1.5 0 0 0 5 3.5v2a.5.5 0 0 0 1 0z"/>
                            <path fill-rule="evenodd" 
                                  d="M11.854 8.354a.5.5 0 0 0 0-.708l-3-3a.5.5 0 1 0-.708.708L10.293 7.5H1.5a.5.5 0 0 0 0 1h8.793l-2.147 2.146a.5.5 0 0 0 .708.708l3-3z"/>
                        </svg>
                        <span class="hidden md:inline"><%=tag %></span>
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>
</body>
</html>
