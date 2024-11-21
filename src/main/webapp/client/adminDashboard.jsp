<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Dashboard</title>
<!-- Tailwind CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/tailwindcss@3.0.24/dist/tailwind.min.css"
	rel="stylesheet">

<!-- Bootstrap CSS -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/5.3.0/css/bootstrap.min.css">

<!-- Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
<!-- Bootstrap 5 JS and Popper.js -->
<script
	src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>

<!-- Font Awesome for Icons -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<style>
.calendar-grid {
	display: grid;
	grid-template-columns: repeat(7, 1fr);
	gap: 0.25rem;
	text-align: center;
}
</style>
</head>
<body class="bg-gray-100">
<%@ page import="java.time.*"%>
<%@ page import="java.time.format.TextStyle"%>
<%@ page import="java.util.*"%>
<%@ page import = "classes.*" %>
	<%@include file="adminNavBar.jsp"%>
	<div class="container-fluid py-5">
		<div class="row justify-content-center">
			<h1 class="text-3xl font-bold mb-6">Admin Dashboard</h1>


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
								<p class="h2 fw-bold mb-0">15</p>
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
								<p class="h2 fw-bold mb-0">42</p>
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
								<p class="h2 fw-bold mb-0">350</p>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

<%
	// Get current date or requested month
	LocalDate currentDate = (LocalDate) request.getAttribute("currentDate");

	// a 2D list where each inner list represents a week in the calendar,
	// each LocalDate represents a day.
	List<List<LocalDate>> calendarMatrix = (List<List<LocalDate>>) request.getAttribute("calendarMatrix");

	if (currentDate == null) {
		currentDate = LocalDate.now(); // Fallback to today's date
	}

	Map<LocalDate, List<UserBooking>> adminBookings = (Map<LocalDate, List<UserBooking>>) request
			.getAttribute("adminBookings");
	%>
	<div class="row">
		<div class="col-md-6">
			<div class="bg-white shadow-md rounded-lg p-4">
				<div class="d-flex justify-content-between align-items-center mb-3">

					<!-- every time the previous or next button is clicked, 
it sends a request to the servlet -->

					<!-- getMonthValue() gives the number of month 
getYear() gives the number of year -->
					<a
						href="./AdminCalendar?month=<%=currentDate.minusMonths(1).getMonthValue()%>&year=<%=currentDate.minusMonths(1).getYear()%>"
						class="btn btn-outline-primary me-2">Previous</a> <span class="h4">
						<!-- getDisplayName(TextStyle.FULL, Locale.ENGLISH) converts the Month object into 
					a full, readable name of the month (e.g., "January", "February") in English.
 --> <%=currentDate.getMonth().getDisplayName(TextStyle.FULL, Locale.ENGLISH)%>
						<%=currentDate.getYear()%>
					</span> <a
						href="./AdminCalendar?month=<%=currentDate.plusMonths(1).getMonthValue()%>&year=<%=currentDate.plusMonths(1).getYear()%>"
						class="btn btn-outline-primary ms-2">Next</a>
				</div>
				<div class="calendar-grid text-center">
					<table class="table table-bordered">
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
									cellClass = "cursor-pointer table-info"; // to highlight booked dates 
										} else {
									cellClass = "cursor-pointer"; // no booking, make it clickable 
										}
										dataDate = day.toString();
										dayOfMonth = String.valueOf(day.getDayOfMonth());

									}
								%>
								<td class="<%=cellClass%>" data-date="<%=dataDate%>"><%=dayOfMonth%>
								</td>
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
		<div class=" col-md-6">
			<div class="bg-white shadow-md rounded-lg p-4 mt-4 p-4"
				id="bookingsSection">
				<h3 class="mb-4 text-center display-6">Bookings</h3>
				<div class="scroll-container bg-gray-50 p-4 rounded-lg"
					id="selectedDateBookings">

					<%
						if (adminBookings.entrySet().isEmpty() || adminBookings.entrySet() == null) {
						%>
					<div class=" d-flex justify-content-between align-items-center">
						<p>You do not have any bookings this month.</p>
					</div>
					<%
						} else {
							// Loop through each entry (date and bookings list) in the map
							for (Map.Entry<LocalDate, List<UserBooking>> entry : adminBookings.entrySet()) {
								LocalDate date = entry.getKey(); // The date key
								List<UserBooking> bookingList = entry.getValue(); // The list of bookings for this date
						%>
					<div class="booking-date-section">
						<div class="d-flex justify-content-center align-items-center mb-3">

							<h4><%=date%></h4>
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
												Service:
												<%=booking.getService_id()%></p>
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