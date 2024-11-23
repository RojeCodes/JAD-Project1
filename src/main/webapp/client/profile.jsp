<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Profile</title>

<%@ include file="include/bootstrap.html"%>
<%@ include file="include/tailwind.html"%>

<!-- Font Awesome for icons -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<style>
body {
	background-color: #fffff;
}

.profileContainer {
	background-color: #B0C7DD;
	min-height: calc(100vh - 60px);
	padding-top: 2rem;
	padding-bottom: 2rem;
}

</style>
</head>
<body>


	<%@page import="classes.LoggedInUser"%>
	<%@page import="classes.UserBooking"%>
	<%@page import="java.util.List"%>

	<%@page import="java.util.ArrayList"%>

	<%
	String profileContextPath = request.getContextPath();
	System.out.print(profileContextPath);

	LoggedInUser user = new LoggedInUser();
	user = (LoggedInUser) session.getAttribute("user");
	int user_role = 2;
	List<UserBooking> bookings = new ArrayList<>();

	if (user == null) {
		String errTitle = "You have been logged out.";
		String errMsg = "Please log in again.";
		/* 	response.sendRedirect("login.jsp"); */ // Redirect to login if the user is not logged in
	%>
	<div id="errorModal" class="modal flex items-center justify-center">
		<div class="modal-content w-80 p-6 mx-4">
			<div class="text-center">
				<div class="mb-4">
					<svg class="mx-auto h-12 w-12 text-red-500" fill="none"
						stroke="currentColor" viewBox="0 0 24 24">
						<!-- icon -->
                        <path stroke-linecap="round"
							stroke-linejoin="round" stroke-width="2"
							d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                    </svg>
				</div>
				<h3 class="text-lg font-medium text-gray-900 mb-2"><%=errTitle%></h3>
				<p class="text-sm text-gray-600 mb-4"><%=errMsg%></p>
				<form method="POST" action="modal.jsp">
					<button type="submit" id="closebtn"
						class="w-full py-2 px-4 bg-red-500 text-white rounded-full hover:bg-red-600 transition-colors">
						Close</button>
				</form>
			</div>
		</div>
	</div>
	<%
	return;
	} else {
	user_role = user.getRole_id();
	System.out.print(user_role);
	}

	if (user_role == 2) {
	%>
	<%
	bookings = (List<UserBooking>) session.getAttribute("userBookings");
	System.out.println(bookings.isEmpty());
	}
	int user_id = user.getUser_id();
	int role_id = user.getRole_id();
	String full_name = user.getFull_name();
	String email = user.getEmail();
	String birthdate = user.getBirthdate();
	String phone = user.getPhone();
	String inputName = "";
	String placeHolderValue = "";
	String inputType = "";
	String btn = request.getParameter("btn");
	System.out.println("Full name in profile.jsp " + full_name);

	if (btn != null) {
	switch (btn) {
	case "email":
		inputName = "email";
		inputType = "email";
		placeHolderValue = email;
		break;
	case "birthdate":
		inputName = "birthdate";
		inputType = "date";
		placeHolderValue = birthdate;
		break;
	case "phone":
		System.out.println(phone);
		inputName = "phone";
		inputType = "text";
		placeHolderValue = phone;
		break;
	case "full_name":
		inputName = "full_name";
		inputType = "text";
		placeHolderValue = full_name;
		break;
	}
	%>
	<div id="editModal" class="modal flex items-center justify-center">
		<div class="modal-content w-80 p-6 mx-4">
			<div class="text-center">
				<div class="mb-4">
					<h3 class="text-lg font-medium text-gray-900 mb-2">Edit
						Details</h3>
				</div>

				<form method="POST" action="<%=profileContextPath%>/editProfile">
					<input type="hidden" name="inputField" value=<%=btn%>> <span
						class="input-group-text bg-transparent border-0 fw-bold"> <%=btn%>
					</span> <input type=<%=inputType%> class="form-control bg-transparent"
						name="newDetail" value=<%=placeHolderValue%>>
					<div class="row align-items-center">
						<div class="col-md-6 d-flex gap-2 my-3">
							<button type="submit" id="editbtn"
								class="w-full py-2 px-4 bg-red-500 text-white rounded-full hover:bg-red-600 transition-colors">
								Edit</button>
						</div>
						<div class="col-md-6 d-flex gap-2 my-3">
							<form action="modal.jsp">
								<button type="submit" id="closebtn"
									class="w-full py-2 px-4 bg-red-500 text-white rounded-full hover:bg-red-600 transition-colors">
									Close</button>
							</form>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
	<%
	}
	%>


	<%
	if (user_role == 1) {
	%>
	<jsp:include page="adminNavBar.jsp" />
	<%
	} else if (user_role == 2) {
	%>
	<div class="row d-flex">
		<jsp:include page="navBar.jsp" />
		<div class="row">
			<div class="col-md-6 gap-2">
				<%
				}
				%>
				<div
					class="profileContainer flex items-center justify-center min-h-screen">
					<div class="container">
						<div class="row justify-content-center">
							<div class="col-md-6 rounded-3 shadow-lg p-4"
								style="background-color: white;">
								<div class="text-center mb-4">
									<h1 class="fw-bold text-black">My Profile</h1>
								</div>

								<div class="space-y-3">



									<div class="input-group mb-3 rounded-3 bg-white">
										<span class="input-group-text bg-transparent border-0 fw-bold">Full
											Name</span> <input type="text" class="form-control bg-transparent"
											value="<%=full_name%>" readonly>
										<form method="POST">
											<button id="editButton" name="btn" value="full_name"
												class=" text-black rounded-full p-3">
												<i class="fas fa-pen"></i>
											</button>
										</form>
									</div>

									<div
										class="in put-group mb-3 rounded-3 bg-white  d-flex align-items-center">
										<span class="input-group-text bg-transparent border-0 fw-bold">Birthdate</span>
										<input type="date" class="form-control bg-transparent"
											value="<%=birthdate%>" readonly>
										<form method="POST">
											<button id="editButton" name="btn" value="birthdate"
												class="text-black rounded-full p-3">
												<i class="fas fa-pen"></i>
											</button>
										</form>
									</div>

									<div class="input-group mb-3 rounded-3 bg-white ">
										<span class="input-group-text bg-transparent border-0 fw-bold">Phone</span>
										<input type="tel" class="form-control bg-transparent"
											value="<%=phone%>" readonly>
										<form method="POST">
											<button id="editButton" name="btn" value="phone"
												class="text-black rounded-full p-3">
												<i class="fas fa-pen"></i>
											</button>
										</form>
									</div>

									<div class="input-group mb-3 rounded-3 bg-white">
										<span class="input-group-text bg-transparent border-0 fw-bold">Email</span>
										<input type="email" class="form-control bg-transparent"
											value="<%=email%>" readonly>
										<form method="POST">
											<button id="editButton" name="btn" value="email"
												class="text-black rounded-full p-3">
												<i class="fas fa-pen"></i>
											</button>
										</form>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<%
				if (user_role == 2) {
				%>
			</div>
			<div class="booking-container col-md-6">
				<div class="flex items-center justify-center min-h-screen">
					<div class="container">
						<div class="justify-content-center">
							<div class="text-center mb-4">
								<h1 class="fw-bold text-black">My Bookings</h1>
							</div>
							<div class="rounded-3 p-4 border"
								style="max-height: 300px; overflow-y: auto;">
								<div class="scroll-container space-y-3">

									<ul>
										<%
										if (bookings == null || bookings.isEmpty()) {
										%>
										<div class="d-flex justify-content-between align-items-center">
											<p>You have not booked an appointment with us.</p>
										</div>
										<%
										}
										if (bookings != null) {
										for (UserBooking booking : bookings) {
										%>

										<div class="justify-content-center my-3">
											<ul class="space-y-3">
												<li class="text-xl font-semibold text-black">Service :
													<%=booking.getService_name()%></li>
												<li class="text-gray-700">Date : <%=booking.getDate()%></li>
												<li class="text-gray-700">Time : <%=booking.getTime()%></li>
												<li class="text-gray-700">Hours : <%=booking.getHour_count()%>
													hours
												</li>


												<%
												// if booking is over 
												if (booking.getStatus_id() == 1) {
												%>
												<form method="POST">
													<button type="submit" id="reviewbtn"
														class="w-full py-2 px-4 bg-red-500 text-white rounded-full hover:bg-red-300 transition-colors">
														Review</button>
												</form>
												<%
												}

												}
												}
												%>
											</ul>
										</div>
									</ul>
								</div>
							</div>
						</div>
					</div>
				</div>

				<%
				}
				%>
			</div>

		</div>
	</div>
</body>
</html>
