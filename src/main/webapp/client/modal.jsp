<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Modal</title>
</head>
<body>
<%@ page import = "classes.LoggedInUser" %>
<%

    // Get the Referer header from the request
        String referer = request.getHeader("Referer");
LoggedInUser user = (LoggedInUser) session.getAttribute("user");

        if (referer != null) {
        	
        	// taking out the errCode 
        	if (referer.contains("errCode")) {
        		 referer = referer.replaceAll("([&?])errCode=[^&]*", "");
                 referer = referer.replaceAll("[&?]$", "");
                 System.out.print(referer);
        	} 
        	
        	if (session == null  || user == null) { 
                response.sendRedirect("../client/login.jsp");
        	} else {
            // Redirect to the originating URL (Referer)
            response.sendRedirect(referer);
        	}
        } else {
            // If no Referer header is found, you can redirect to a default page
            response.sendRedirect("/client/home.jsp");
        }
%>
</body>
</html>