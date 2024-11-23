<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register</title>
<%@ include file="include/bootstrap.html"%>
<%@ include file="include/tailwind.html"%>

</head>
<style>
/* :root {
	--primary: #B0C7DD;
	--secondary: #7C7D80;
	--accent: #F2E3D0;
	--dark: #000000;
} */
.register-container {
	background-color: #F2E3D0;
	min-height: calc(100vh - 60px);
	padding-top: 2rem;
	padding-bottom: 2rem;
}

.custom-shape {
	position: fixed;
	border-radius: 50%;
	z-index: 0;
}

.shape-1 {
	width: 150px;
	height: 150px;
	background-color: #B0C7DD;
	top: 20%;
	left: 5%;
	opacity: 0.6;
}

.shape-2 {
	width: 100px;
	height: 100px;
	background-color: #7C7D80;
	bottom: 15%;
	right: 5%;
	opacity: 0.4;
}

.input-field {
	background-color: rgba(255, 255, 255, 0.9);
	border: 2px solid #B0C7DD;
	border-radius: 25px;
	padding: 8px 16px; /* Reduced padding */
	transition: all 0.3s ease;
}

.input-field:focus {
	border-color: #000000;
	box-shadow: 0 0 15px rgba(176, 199, 221, 0.3);
}

.submit-btn {
	background-color: #B0C7DD;
	border-radius: 25px;
	transition: all 0.3s ease;
}

.submit-btn:hover {
	background-color: #000000;
	transform: translateY(-2px);
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

.modal-content {
	background-color: white;
	border-radius: 15px;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
	animation: modalSlideDown 0.3s ease-out;
}
/* 
@
keyframes modalSlideDown {from { transform:translateY(-50px);
	opacity: 0;
}

to {
	transform: translateY(0);
	opacity: 1;
}

}
.error-input {
	border-color: #EF4444;
} */
</style>
</head>
<body>
	<%@include file="navBar.jsp"%>

	<%
	String errCode = request.getParameter("errCode");
	String errTitle = "";
	String errMsg = "";
	if (errCode != null) {
		switch (errCode) {
		case "passwordMismatch":
			errTitle = "Password Mismatch";
			errMsg = "The passwords you entered do not match. Please try again.";
			break;
		case "duplicateEmail":
			errTitle = "Invalid Credentials";
			errMsg = "Please check your credentials and try again.";
			break;
		case "ageRestricted":
			errTitle = "Age Restricted";
			errMsg = "You must be at least 18 years old to register or access this service.";
			break;
		case "banned":
			errTitle = "Registration Blocked";
			errMsg = "Your registration attempt has been blocked. This may be due to a restriction on your account or previous activity."
			+ "For further assistance, contact support at jadproject@zohomail.com.";
			break;
		}
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
	}
	%>

	<div class="register-container">
		<div class="custom-shape shape-1"></div>
		<div class="custom-shape shape-2"></div>

		<div class="container mt-5">
			<div class="row">
        <!-- Column for Image -->
<div class="col-md-5 d-flex justify-content-center align-items-center">
    <div class="container mx-auto relative z-10 image-column flex items-center justify-center">
        <img
            src="https://res.cloudinary.com/dw54pefsm/image/upload/v1731429414/man-clean-oval_u3ecs4.png"
            alt="Big Picture"
            class="img-fluid mx-auto d-block"
            style="max-height: auto; width: auto;"
        >
    </div>
</div>
        <!-- Column for Register Form -->
        <div class="col-md-7">
 <div class="max-w-2xl mx-auto bg-white bg-opacity-95 rounded-3xl shadow-xl p-6 relative z-10">
							<div class="text-center mb-6">
								<h2 class="text-2xl font-bold text-gray-800 mb-2">
									SQUEAKYCLEAN</h2>
								<p class="text-sm text-gray-600">Experience squeaky cleaning
									services</p>
							</div>

							<form class="space-y-4" action="<%=contextPath%>/user/register"
								method="POST">
								<div class="space-y-3">
									<div class="mb-3">
										<label for="full_name" class="form-label"></label> <input
											type="text" name="full_name" placeholder="Full Name"
											class="input-field w-full text-sm" required>
									</div>
									<div class="mb-3">
										<label for="phone" class="form-label"></label> <input
											type="tel" name="phone" placeholder="Phone Number"
											class="input-field w-full text-sm" required>
									</div>
									<div class="mb-3">
										<label for="address" class="form-label"></label> <input
											type="text" name="address" placeholder="Address"
											class="input-field w-full text-sm" required>
									</div>
									<div class="mb-3">
										<label for="birthdate" class="form-label"></label> <input
											type="date" name="birthdate"
											class="input-field w-full text-sm" required>
									</div>
									<div class="mb-3">
										<label for="email" class="form-label"></label> <input
											type="email" name="email" placeholder="Email Address"
											class="input-field w-full text-sm" required>
									</div>
									<div class="mb-3">
										<label for="password" class="form-label"></label> <input
											type="password" name="password" placeholder="Password"
											class="input-field w-full text-sm" required>
									</div>

									<div class="mb-3">
										<label for="confirmpassword" class="form-label"></label> <input
											type="password" name="confirmpassword"
											placeholder="Confirm Password"
											class="input-field w-full text-sm" required>
									</div>
								</div>
								<button type="submit"
									class="submit-btn w-full py-2 px-4 text-white text-sm font-medium hover:bg-opacity-90">
									Create Account</button>
							</form>

							<p class="text-center mt-4 text-xs text-gray-600">
								<!-- Reduced margin and text size -->
								Already have an account? <a href="./login.jsp"
									class="text-blue-600 hover:underline">Sign in</a>
							</p>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
