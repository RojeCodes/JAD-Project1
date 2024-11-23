<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Category Management</title>
<%@include file="adminNavBar.jsp"%>
<%@ include file="include/bootstrap.html"%>
<%@ include file="include/tailwind.html"%>
<style>
body {
background-color: #B0C7DD;
}

.category-card {
	transition: all 0.3s ease;
	box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px
		rgba(0, 0, 0, 0.06);
}

.category-card:hover {
	transform: translateY(-10px);
	box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px
		rgba(0, 0, 0, 0.04);
}

.category-image {
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
	z-index: 9999;
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
	List<Category> categories = (ArrayList<Category>) request.getAttribute("categories");
	%>

	<div class="container-fluid py-5 px-4">
		<div class="row mb-4">
			<div class="col-12 d-flex justify-content-between align-items-center">

				<h1 class="text-4xl font-bold text-center mb-12 relative">
					Category Management</h1>


				<a href="#addCategoryModal" class="btn btn-primary">+ Add
					Category</a>


			</div>
		</div>
		<div class="row g-4">
			<%
			for (Category category : categories) {
			%>
			<div class="col-md-4">
				<form action="<%=contextPath%>/getCategory" method="POST">
					<input type="hidden" name="category_id"
						value="<%=category.getCategory_id()%>">
					<div class="card category-card border-0 rounded-lg overflow-hidden">
						<img src="<%=category.getImg_url()%>" name="img_url"
							class="card-img-top category-image" alt="Category Image">
						<div class="card-body bg-white p-4">
							<h5 class="card-title font-bold mb-2" name="category_name">
								<%=category.getCategory_name()%>
							</h5>
							<p name="description" class="card-text text-gray-600 mb-3">
								<%=category.getDescription()%>
							</p>
							<a href="#modal<%=category.getCategory_id()%>"
								class="btn btn-sm btn-outline-primary me-2">Edit</a>
							<button type="submit" class="btn btn-sm btn-outline-danger"
								name="action" value="delete">Delete</button>
						</div>
					</div>
				</form>
			</div>

			<!-- Modal for each category -->
			<div class="modal" id="modal<%=category.getCategory_id()%>">
				<div class="modal-content">
					<a href="" class="close-modal">&times;</a>
					<h3 class="mb-4">Edit Category</h3>

					<form method="POST" action="<%=contextPath%>/getCategory"
						enctype="multipart/form-data">
						<!-- 					hidden input types to be sent to the servlet  -->
						<input type="hidden" name="action" value="update"> <input
							type="hidden" name="category_id"
							value="<%=category.getCategory_id()%>">

						<div class="mb-3">
							<label class="form-label">Category Name</label> <input
								type="text" class="form-control" name="category_name"
								value="<%=category.getCategory_name()%>" required>
						</div>

						<div class="mb-3">
							<label class="form-label">Description</label>
							<textarea class="form-control" name="description" rows="3"
								required><%=category.getDescription()%></textarea>
						</div>

						<div class="mb-3">
							<label class="form-label">Current Image</label> <input type="url"
								class="form-control" name="img_url"
								value="<%=category.getImg_url()%>" readonly>
						</div>

						<div class="mb-3">
							<label class="form-label">Upload New Image (if necessary)
								:</label> <input type="file" name="img_url_picture" class="form-control"
								accept=".png, .jpeg, .jpg">
						</div>

						<div class="text-end">
							<a href="" class="btn btn-secondary me-2">Cancel</a>
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


		<!-- Add Category Modal -->
		<div class="modal" id="addCategoryModal">
			<div class="modal-content">
				<a href="" class="close-modal">&times;</a>
				<h3 class="mb-4">Add Category</h3>

				<form method="POST" action="<%=contextPath%>/getCategory"
					enctype="multipart/form-data">
					<input type="hidden" name="action" value="insert">

					<div class="mb-3">
						<label class="form-label">Category Name</label> <input type="text"
							class="form-control" name="category_name" required>
					</div>

					<div class="mb-3">
						<label class="form-label">Description</label>
						<textarea class="form-control" name="description" rows="3"
							required></textarea>
					</div>

					<div class="mb-3">
						<label class="form-label">Upload New Image :</label>
						<input type="file" name="img_url" class="form-control"
							accept=".png, .jpeg, .jpg" required>
					</div>

					<div class="text-end">
						<a href="" class="btn btn-secondary me-2">Cancel</a>
						<button type="submit" class="btn btn-primary">Save
							Category</button>
					</div>
				</form>
			</div>
		</div>
	</div>

</body>

</html>
