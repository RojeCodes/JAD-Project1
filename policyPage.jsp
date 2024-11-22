<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<%@ include file="include/bootstrap.html" %>
<title>Policy Page</title>
<!-- Google Fonts -->
<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
<!-- Font Awesome Icons -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
<!-- Custom CSS -->
<style>
    body {
        font-family: 'Roboto', sans-serif;
        background-color: #f8f9fa;
        color: #343a40;
    }

    .container {
        max-width: 800px;
    }

    h1 {
        font-weight: 700;
        color: #495057;
        text-transform: uppercase;
    }

    .accordion-item {
        border: 1px solid #dee2e6;
        border-radius: 8px;
        margin-bottom: 15px;
        box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
    }

    .accordion-header button {
        font-weight: 500;
        background: black;
        color: #fff;
        border: none;
        border-radius: 8px;
        padding: 15px;
        transition: background 0.2s, transform 0.2s;
    }

    .accordion-header button:hover {
        background: grey;
        transform: scale(1.015);
    }

    .accordion-body {
        background-color: #fff;
        border-top: 1px solid #dee2e6;
        padding: 15px;
        font-size: 1rem;
    }

    .accordion ul {
        list-style: none;
        padding-left: 0;
    }

    .accordion ul li {
        padding: 5px 0;
    }

    .accordion ul li::before {
        content: "\f00c";
        font-family: "Font Awesome 6 Free";
        font-weight: 900;
        margin-right: 10px;
        color: #198754;
    }
</style>
</head>
<body>
<%@ include file="navBar.jsp" %>

<div class="container mt-5">
    <h1 class="text-center mb-4 h1"><i class="fas fa-info-circle"></i> Our Policies</h1>
    <div class="accordion" id="policyAccordion">
        <!-- Service Terms and Conditions -->
        <div class="accordion-item">
            <h2 class="accordion-header" id="headingTerms">
                <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTerms" aria-expanded="" aria-controls="collapseTerms">
                    <i class="fas fa-file-alt me-2"></i> Service Terms and Conditions
                </button>
            </h2>
            <div id="collapseTerms" class="accordion-collapse collapse show" aria-labelledby="headingTerms" data-bs-parent="#policyAccordion">
                <div class="accordion-body">
                    <ul>
                        <li>We provide a range of services including residential and commercial cleaning.</li>
                        <li>Customers are responsible for providing access to the property and securing valuables.</li>
                        <li>Our staff follow strict health and safety guidelines for all cleaning tasks.</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Booking and Cancellation Policy -->
        <div class="accordion-item">
            <h2 class="accordion-header" id="headingBooking">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseBooking" aria-expanded="false" aria-controls="collapseBooking">
                    <i class="fas fa-calendar-check me-2"></i> Booking and Cancellation Policy
                </button>
            </h2>
            <div id="collapseBooking" class="accordion-collapse collapse" aria-labelledby="headingBooking" data-bs-parent="#policyAccordion">
                <div class="accordion-body">
                    <ul>
                        <li>Bookings can be made online or via phone. A confirmation email will be sent upon successful booking.</li>
                        <li>Cancellations made within 24 hours of the scheduled service will incur a $20 fee.</li>
                        <li>Rescheduling is allowed up to 24 hours before the appointment without penalty.</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Payment Policy -->
        <div class="accordion-item">
            <h2 class="accordion-header" id="headingPayment">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapsePayment" aria-expanded="false" aria-controls="collapsePayment">
                    <i class="fas fa-credit-card me-2"></i> Payment Policy
                </button>
            </h2>
            <div id="collapsePayment" class="accordion-collapse collapse" aria-labelledby="headingPayment" data-bs-parent="#policyAccordion">
                <div class="accordion-body">
                    <ul>
                        <li>We accept payments via credit card, bank transfer, or cash.</li>
                        <li>A deposit may be required for large bookings, which is refundable upon cancellation with sufficient notice.</li>
                        <li>Late payments may incur additional fees.</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Refund Policy -->
        <div class="accordion-item">
            <h2 class="accordion-header" id="headingRefund">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseRefund" aria-expanded="false" aria-controls="collapseRefund">
                    <i class="fas fa-undo me-2"></i> Refund Policy
                </button>
            </h2>
            <div id="collapseRefund" class="accordion-collapse collapse" aria-labelledby="headingRefund" data-bs-parent="#policyAccordion">
                <div class="accordion-body">
                    <ul>
                        <li>Refunds are issued in cases of unsatisfactory service or booking errors.</li>
                        <li>Refund requests can be made by contacting our support team within 7 days of the service.</li>
                        <li>Refunds are processed within 5-10 business days.</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Contact Information -->
        <div class="accordion-item">
            <h2 class="accordion-header" id="headingContact">
                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseContact" aria-expanded="false" aria-controls="collapseContact">
                    <i class="fas fa-address-card me-2"></i> Contact Information
                </button>
            </h2>
            <div id="collapseContact" class="accordion-collapse collapse" aria-labelledby="headingContact" data-bs-parent="#policyAccordion">
                <div class="accordion-body">
                    <p>For any inquiries about our policies, please contact us:</p>
                    <ul>
                        <li>Email: support@squeakyclean.com</li>
                        <li>Phone: (+65) 9777-5738</li>
                        <li>500 Dover Road, Singapore 139651</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    <button class="btn btn-lg btn-secondary" onclick="window.location.href='home.jsp'">Home</button>
    <button class="btn btn-lg btn-primary" onclick="window.location.href='services.jsp'">Explore Services</button>
</div>
</body>
</html>

