<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Service Management</title>
<%@include file="adminNavBar.jsp"%>
<%@ include file="include/bootstrap.html"%>
<%@ include file="include/tailwind.html"%>
<style>
body {
	background-color: #F2E3D0;
}

.service-card {
	color: #000;
	transition: all 0.3s ease;
	box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px
		rgba(0, 0, 0, 0.06);
}

.service-card:hover {
	transform: translateY(-10px);
	box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px
		rgba(0, 0, 0, 0.04);
}

.service-image {
	height: 200px;
	object-fit: cover;
}

.modal {
	display: none;
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background-color: rgba(0, 0, 0, 0.5);
	z-index: 1000;
}

.modal:target {
	display: flex !important;
	align-items: center;
	justify-content: center;
}

.modal-content {
	background: white;
	padding: 20px;
	border-radius: 8px;
	width: 90%;
	max-width: 500px;
	position: relative;
	margin: 20px;
}

.close-modal {
	position: absolute;
	right: 20px;
	top: 10px;
	text-decoration: none;
	font-size: 24px;
	color: #666;
}

.close-modal:hover {
	color: #333;
}
</style>
</head>
<body>
	<%@ page import="classes.*"%>
	<%@ page import="java.util.List"%>
	<%@ page import="java.util.ArrayList"%>

	<%
	List<AdminService> services = (ArrayList<AdminService>) request.getAttribute("services");
	%>

	<div class="container-fluid py-5 px-4">
		<div class="row mb-4">
			<div class="col-12 d-flex justify-content-between align-items-center">
				<h1 class="text-4xl font-bold text-center mb-12 relative">
					Service Management</h1>

				<a href="#addServiceModal" class="btn btn-primary">+ Add Service</a>
			</div>
		</div>
		<div class="row g-4">
			<%
			for (AdminService service : services) {
			%>
			<div class="col-md-4">
				<form action="<%=contextPath%>/adminServiceServlet" method="POST">
					<input type="hidden" name="service_id"
						value="<%=service.getService_id()%>">
					<div class="card service-card border-0 rounded-lg overflow-hidden">
						<img src="<%=service.getImg_url()%>" name="img_url"
							class="card-img-top service-image" alt="Service Image">
						<div class="card-body bg-white p-4">
							<h5 class="card-title font-bold mb-2" name="service_name">
								<%=service.getService_name()%>
							</h5>
							<p name="description" class="card-text text-gray-600 mb-3">
								<%=service.getDescription()%>
							</p>
							<p name="category_name" class="card-text text-gray-600 mb-3">
								Category :
								<%=service.getCategory_name()%>
							</p>
							<p name="price" class="card-text text-gray-600 mb-3">
								Price :
								<%=service.getPrice()%>
							</p>
							<a href="#modal<%=service.getService_id()%>"
								class="btn btn-sm btn-outline-primary me-2">Edit</a>
							<button type="submit" class="btn btn-sm btn-outline-danger"
								name="action" value="delete">Delete</button>
						</div>
					</div>
				</form>
			</div>

			<!-- Modal for each service -->
			<div class="modal" id="modal<%=service.getService_id()%>">
				<div class="modal-content">
					<a href="#" class="close-modal">&times;</a>
					<h3 class="mb-4">Edit Service</h3>

					<form method="POST" action="<%=contextPath%>/adminServiceServlet"
						enctype="multipart/form-data">
						<!-- 					hidden input types to be sent to the servlet  -->
						<input type="hidden" name="action" value="update"> <input
							type="hidden" name="service_id"
							value="<%=service.getService_id()%>">

						<div class="mb-3">
							<label class="form-label">Service Name</label> <input type="text"
								class="form-control" name="service_name"
								value="<%=service.getService_name()%>" required>
						</div>

						<div class="mb-3">
							<label class="form-label">Description</label>
							<textarea class="form-control" name="description" rows="3"
								required><%=service.getDescription()%></textarea>
						</div>

						<!-- dropdown to choose available categories -->
						<div class="mb-3">
							<label class="form-label">Categories</label> <select
								class="form-control" name="category" required>
								<%
								List<Category> categories = (List<Category>) request.getAttribute("categories");
								if (categories != null) {
									for (Category category : categories) {
								%>
								<option value="<%=category.getCategory_id()%>"
									<%=(service.getCategory_name().equals(category.getCategory_name())) ? "selected" : ""%>>
									<%=category.getCategory_name()%>
								</option>
								<%
								}
								}
								%>
							</select>
						</div>

						<div class="mb-3">
							<label class="form-label">Price</label> <input type="number"
								class="form-control" name="price" step="0.01" min="0"
								value="<%=service.getPrice()%>">
						</div>

						<div class="mb-3">
							<label class="form-label">Current Image</label> <input type="url"
								class="form-control" name="img_url"
								value="<%=service.getImg_url()%>" readonly>
						</div>

						<div class="mb-3">
							<label class="form-label">Upload New Image (if necessary)
								:</label> <input type="file" name="img_url_picture" class="form-control"
								accept=".png, .jpeg, .jpg">
						</div>

						<div class="text-end">
							<a href="#" class="btn btn-secondary me-2">Cancel</a>
							<button type="submit" class="btn btn-primary">Save
								Changes</button>
						</div>
					</form>
				</div>
			</div>
			<%
			}
			%>
		</div>

		<!-- Add Service Modal -->
		<div class="modal" id="addServiceModal">
			<div class="modal-content">
				<a href="" class="close-modal">&times;</a>
				<h3 class="mb-4">Add Service</h3>

				<form method="POST" action="<%=contextPath%>/adminServiceServlet"
					enctype="multipart/form-data">
					<input type="hidden" name="action" value="insert">

					<div class="mb-3">
						<label class="form-label">Service Name</label> <input type="text"
							class="form-control" name="service_name" required>
					</div>

					<!-- dropdown to choose available categories -->
					<div class="mb-3">
						<label class="form-label">Categories</label> <select
							class="form-control" name="category" required>
							<option value="" disabled selected>Select Category</option>
							<%
							List<Category> categories = (List<Category>) request.getAttribute("categories");
							if (categories != null) {
								for (Category category : categories) {
							%>
							<option value="<%=category.getCategory_id()%>">
								<%=category.getCategory_name()%>
							</option>
							<%
							}
							}
							%>
						</select>
					</div>

					<div class="mb-3">
						<label class="form-label">Price</label> <input type="number"
							class="form-control" name="price" required>
					</div>

					<div class="mb-3">
						<label class="form-label">Description</label>
						<textarea class="form-control" name="description" rows="3"
							required></textarea>
					</div>

					<div class="mb-3">
						<label class="form-label">Upload New Image :</label> <input
							type="file" name="img_url" class="form-control"
							accept=".png, .jpeg, .jpg" required>
					</div>

					<div class="text-end">
						<a href="" class="btn btn-secondary me-2">Cancel</a>
						<button type="submit" class="btn btn-primary">Save
							Service</button>
					</div>
				</form>
			</div>
		</div>
	</div>


	<!-- 

	Bootstrap JS
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script> -->
</body>

</html>
