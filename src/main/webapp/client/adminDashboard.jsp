<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Dashboard</title>
<%@ include file="include/bootstrap.html"%>
<%@ include file="include/tailwind.html"%>
<!-- Font Awesome for Icons -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<style>
.calendar-grid {
	width: 100%;
}

.calendar-grid table.table {
	width: 100%;
	table-layout: fixed;
	margin-bottom: 0;
}

.calendar-grid .table th, .calendar-grid .table td {
	width: calc(100%/ 7);
	text-align: center;
	padding: 8px;
}
</style>
</head>
<body class="bg-gray-100">
	<%@ page import="java.time.*"%>
	<%@ page import="java.time.format.TextStyle"%>
	<%@ page import="java.util.*"%>
	<%@ page import="classes.*"%>

	<%@include file="adminNavBar.jsp"%>

	<%
	LoggedInUser user = new LoggedInUser();
	user = (LoggedInUser) session.getAttribute("user");
	String errCode = request.getParameter("errCode");
	String errTitle = "";
	String errMsg = "";
	if (errCode != null) {
		switch (errCode) {
		case "invalidLogin":
			errTitle = "You have been logged out.";
			errMsg = "Please log in again.";
			break;
		case "unauthorized":
			errTitle = "You are not authorized to access this page.";
			errMsg = "Please log in again.";
			break;
		}
	}

	if (user == null || errCode != null) {
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
	}

	int thisMonthsBookingCount = (Integer) request.getAttribute("thisMonthsBookingCount");
	int thisYearBookingCount = (Integer) request.getAttribute("thisYearBookingCount");
	int upcomingBookingCount = (Integer) request.getAttribute("upcomingBookingCount");
	%>
	<div class="container-fluid py-5">
		<div class="row justify-content-center">
			<h1 class="text-4xl font-bold text-center mb-12 relative">Admin
				Dashboard</h1>


			<div class="col-12 col-md-10 col-lg-8 col-xl-10">
				<div class="row g-4">
					<!-- Upcoming Bookings Card -->
					<div class="col-12 col-sm-6 col-lg-4">
						<div
							class="bg-white shadow rounded-3 p-4 d-flex align-items-center">
							<div class="me-4">
								<i class="fas fa-calendar-check text-primary fs-2"></i>
							</div>
							<div>
								<h3 class="text-muted small mb-1">Upcoming Bookings</h3>
								<p class="h2 fw-bold mb-0"><%=upcomingBookingCount%></p>
							</div>
						</div>
					</div>

					<!-- Clients This Month Card -->
					<div class="col-12 col-sm-6 col-lg-4">
						<div
							class="bg-white shadow rounded-3 p-4 d-flex align-items-center">
							<div class="me-4">
								<i class="fas fa-users text-success fs-2"></i>
							</div>
							<div>
								<h3 class="text-muted small mb-1">Clients This Month</h3>
								<p class="h2 fw-bold mb-0"><%=thisMonthsBookingCount%></p>
							</div>
						</div>
					</div>

					<!-- Clients This Year Card -->
					<div class="col-12 col-sm-6 col-lg-4">
						<div
							class="bg-white shadow rounded-3 p-4 d-flex align-items-center">
							<div class="me-4">
								<i class="fas fa-chart-line text-info fs-2"></i>
							</div>
							<div>
								<h3 class="text-muted small mb-1">Clients This Year</h3>
								<p class="h2 fw-bold mb-0"><%=thisYearBookingCount%></p>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<%
	Map<LocalDate, List<UserBooking>> allBookings = new HashMap<>();
	Map<LocalDate, List<UserBooking>> selectedBookings = new HashMap<>();
	Map<LocalDate, List<UserBooking>> adminBookings = new HashMap<>();

	// Get current date or requested month
	LocalDate currentDate = (LocalDate) session.getAttribute("currentDate");

	System.out.println("line 152 " + currentDate);
	// a 2D list where each inner list represents a week in the calendar,
	// each LocalDate represents a day.
	List<List<LocalDate>> calendarMatrix = (List<List<LocalDate>>) session.getAttribute("calendarMatrix");

	if (currentDate == null) {
		currentDate = LocalDate.now(); // Fallback to today's date
	}
/* 	
	System.out.println("Jsp line 160 "+ currentDate);
	System.out.println("Jsp line 161 "+ currentDate.getMonthValue());
	System.out.println("Jsp line 162 "+ currentDate.getYear());

 */
	// admin bookings to display dropdown, calendar, monthly bookings 
	adminBookings = (Map<LocalDate, List<UserBooking>>) session.getAttribute("adminBookings");

	selectedBookings = (Map<LocalDate, List<UserBooking>>) request.getAttribute("selectedBookings");

	if (selectedBookings == null) {
		allBookings = adminBookings;
	} else {
		allBookings = selectedBookings;
	}
	%>
	<div class="row">
		<div class="col-md-6 ">
			<div class="bg-white shadow-md rounded-lg p-4">
				<div class="d-flex justify-content-between align-items-center mb-3">

					<!-- every time the previous or next button is clicked, 
it sends a request to the servlet -->

					<!-- getMonthValue() gives the number of month 
getYear() gives the number of year -->
					<a
						href="<%=contextPath%>/adminDashboard?month=<%=currentDate.minusMonths(1).getMonthValue()%>&year=<%=currentDate.minusMonths(1).getYear()%>"
						class="btn btn-outline-primary me-2">Previous</a>
					<!-- getDisplayName(TextStyle.FULL, Locale.ENGLISH) converts the Month object into 
					a full, readable name of the month (e.g., "January", "February") in English.
 -->
					<span class="h4"> <%=currentDate.getMonth().getDisplayName(TextStyle.FULL, Locale.ENGLISH)%>
						<%=currentDate.getYear()%>
					</span> <a
						href="<%=contextPath%>/adminDashboard?month=<%=currentDate.plusMonths(1).getMonthValue()%>&year=<%=currentDate.plusMonths(1).getYear()%>"
						class="btn btn-outline-primary ms-2">Next</a>
				</div>
				<p>Blue days indicate the days you have bookings.*</p>
				<div class="calendar-grid text-center ">
					<table class="table table-bordered ">
						<thead>
							<tr>
								<th>Mon</th>
								<th>Tue</th>
								<th>Wed</th>
								<th>Thu</th>
								<th>Fri</th>
								<th>Sat</th>
								<th>Sun</th>
							</tr>
						</thead>
						<tbody>
							<%
							// This loop iterates through each week in the calendarMatrix. 
							// Each week is a List<LocalDate>, representing one row of the calendar.
							for (List<LocalDate> week : calendarMatrix) {
							%>
							<tr>
								<%
								// for each day in the week 
								for (LocalDate day : week) {
									String cellClass = "";
									String dataDate = "";
									String dayOfMonth = "";

									if (day == null) {
										cellClass = "bg-light"; // day is null/blank - make it gray
										dataDate = "";
										dayOfMonth = "";
									} else {
										// Set the class based on bookings for the day
										if (adminBookings.containsKey(day)) {
									cellClass = "table-info"; // to highlight booked dates 
										}
										dataDate = day.toString();
										dayOfMonth = String.valueOf(day.getDayOfMonth());
									}
								%>
								<td class="<%=cellClass%>" data-date="<%=dataDate%>"><%=dayOfMonth%></td>
								<%
								}
								%>

							</tr>
							<%
							}
							%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<!-- Bookings Section -->
		<div class="scroll-container col-md-6">
			<div class="bg-white shadow-md rounded-lg p-4 mt-4 p-4"
				id="bookingsSection">
				<h3 class="mb-4 text-center display-6">Bookings</h3>

				<!-- filter according to available date -->
				<form action="<%=contextPath%>/adminDashboard" method="POST">
					<div class="d-flex justify-content-between align-items-center mb-3">
						<p>Filter by date:</p>
						<select class="form-select" id="dateFilterDropdown"
							name="selectedDate">
							<%
							// Populate the dropdown with unique dates from the adminBookings map
							Set<LocalDate> uniqueDates = adminBookings.keySet();
							for (LocalDate date : uniqueDates) {
							%>
							<option value="<%=date%>"><%=date%></option>
							<%
							}
							%>
						</select>
						<button type="submit" class="btn btn-primary">Filter</button>
					</div>
				</form>
				<div class="bg-gray-50 p-4 rounded-lg" id="selectedDateBookings"
					style="max-height: 300px; overflow-y: auto;">

					<%
					if ((selectedBookings == null || selectedBookings.entrySet().isEmpty())
							&& (adminBookings == null || adminBookings.entrySet().isEmpty())) {
					%>
					<div class=" d-flex justify-content-between align-items-center">
						<p>You do not have any bookings this month.</p>
					</div>
					<%
					} else {
					// Loop through each entry (date and bookings list) in the map
					for (Map.Entry<LocalDate, List<UserBooking>> entry : allBookings.entrySet()) {
						LocalDate date = entry.getKey(); // The date key
						List<UserBooking> bookingList = entry.getValue(); // The list of bookings for this date
					%>
					<div class="booking-date-section">
						<div class="d-flex justify-content-center align-items-center mb-3">

							<h2><%=date%></h2>
						</div>

						<!-- Display the date -->
						<div class="list-group">
							<%
							// Loop through the list of bookings for this date
							for (UserBooking booking : bookingList) {
							%>
							<div
								class="list-group-item d-flex justify-content-between align-items-center">
								<div>
									<ul>
																			<li>
											<p class="mb-1 fw-bold">
												Booking Id:
												<%=booking.getBooking_id()%></p>
										</li>
										<li>
											<p class="mb-1 fw-bold">
												Service:
												<%=booking.getService_name()%></p>
										</li>
										
										<li>Time: <%=booking.getTime()%></li>
										<li>Hour Count: <%=booking.getHour_count()%></li>
									</ul>
								</div>
							</div>
							<%
							}
							%>
						</div>
						<%
						}
						}
						%>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
