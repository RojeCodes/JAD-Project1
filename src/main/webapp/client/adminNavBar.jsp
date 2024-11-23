<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin navigation bar</title>
    <%@ include file="include/bootstrap.html"%>
    <%@ include file="include/tailwind.html"%>
</head>
<body>
<% String contextPath = request.getContextPath(); %>

<nav class="navbar sticky-top navbar-expand-lg navbar-dark bg-dark shadow-md">
    <div class="container-fluid">
        <!-- Brand -->
        <a class="navbar-brand font-bold text-xl tracking-wider hover:text-blue-300 transition-colors">
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
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link active hover:bg-gray-700 rounded-md px-3 py-2 transition-colors" 
                       href="<%=contextPath%>/adminDashboard">
                        Booking Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link hover:bg-gray-700 rounded-md px-3 py-2 transition-colors" 
                       href="<%=contextPath%>/user"> <!--  change to ban user servlet -->
                        Ban User Servlet 
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link hover:bg-gray-700 rounded-md px-3 py-2 transition-colors" 
                       href="<%=contextPath%>/getCategory">
                        Category
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link hover:bg-gray-700 rounded-md px-3 py-2 transition-colors" 
                       href="<%=contextPath%>/adminServiceServlet">
                        Service
                    </a>
                </li>
            </ul>

            <!-- Right Side Navigation -->
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link hover:bg-gray-700 rounded-md px-3 py-2 transition-colors" 
                       href="<%=contextPath%>/client/profile.jsp">
                        <div class="flex items-center gap-2">
                            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" 
                                 class="bi bi-person-fill" viewBox="0 0 16 16">
                                <path d="M3 14s-1 0-1-1 1-4 6-4 6 3 6 4-1 1-1 1zm5-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6"/>
                            </svg>
                            Profile
                        </div>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link hover:bg-red-600 rounded-md px-3 py-2 transition-colors flex items-center gap-2" 
                       href="<%=contextPath%>/user/login?action=logOut">
                        <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" 
                             class="bi bi-box-arrow-right" viewBox="0 0 16 16">
                            <path fill-rule="evenodd" 
                                  d="M10 12.5a.5.5 0 0 1-.5.5h-8a.5.5 0 0 1-.5-.5v-9a.5.5 0 0 1 .5-.5h8a.5.5 0 0 1 .5.5v2a.5.5 0 0 0 1 0v-2A1.5 1.5 0 0 0 9.5 2h-8A1.5 1.5 0 0 0 0 3.5v9A1.5 1.5 0 0 0 1.5 14h8a1.5 1.5 0 0 0 1.5-1.5v-2a.5.5 0 0 0-1 0z"/>
                            <path fill-rule="evenodd" 
                                  d="M15.854 8.354a.5.5 0 0 0 0-.708l-3-3a.5.5 0 0 0-.708.708L14.293 7.5H5.5a.5.5 0 0 0 0 1h8.793l-2.147 2.146a.5.5 0 0 0 .708.708z"/>
                        </svg>
                        Logout
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>
</body>
</html>
