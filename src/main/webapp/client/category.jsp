<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Category page</title>
</head>
<body>
<%@page import="java.util.List"%>
<%@page import="classes.Category"%>

<% 
List<Category> categories = (List<Category>) request.getAttribute("categories");

System.out.println(categories); 
%>

<%@include file = "navBar.jsp" %>
<div class="container mx-auto px-4 py-8">
    <% 
    for (int i = 0; i < categories.size(); i++) { 
        Category item = categories.get(i);
    %>
        <div class="row align-items-center <%= i % 2 == 0 ? "" : "flex-row-reverse" %> mb-5 shadow-lg rounded-lg overflow-hidden">
            <div class="col-md-6 p-0">
                <img 
                    src="<%= item.getImg_url() %>" 
                    alt="<%= item.getCategory_name() %>" 
                    class="w-full h-auto object-cover"
                >
            </div>
            <div class="col-md-6 p-4 bg-white">
                <h2 class="text-2xl font-bold mb-3"><%= item.getCategory_name() %></h2>
                <p class="text-gray-600"><%= item.getDescription() %></p>
                
<!--                  go to service route
 -->                <form action = "./service" method = "GET">
                <button class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded-full"> See our services </button>
                </form>
            </div>
        </div>
    <% } %>
</div>

<%-- <%for (Category item : categories) { %>
	<ul>
	<li> <%=item.getCategory_name()%> </li>
	<li> <%=item.getDescription()%></li>
	<li> <img src= <%=item.getImg_url() %>> </li>
	</ul>
<%}%> --%>
</body>
</html>