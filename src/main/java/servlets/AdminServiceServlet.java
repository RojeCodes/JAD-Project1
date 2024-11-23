package servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import classes.AdminService;
import classes.Category;
import classes.LoggedInUser;

/**
 * Servlet implementation class AdminAdminServiceServlet
 */
@MultipartConfig
@WebServlet("/adminServiceServlet")

/**
 * Servlet implementation class AdminAdminServiceServlet
 */
public class AdminServiceServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String UPLOAD_DIR = "uploads";

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		List<AdminService> services = getAdminServices();
		request.setAttribute("services", services);

		List<Category> categories = getCategories();
		request.setAttribute("categories", categories);

		HttpSession session = request.getSession(false);
		if (session != null) {

			LoggedInUser user = (LoggedInUser) session.getAttribute("user");

			if (user != null) {
				if (user.getRole_id() == 2) {
					request.getRequestDispatcher("./client/service.jsp").forward(request, response);
					return;
				} else if (user.getRole_id() == 1) {
					request.getRequestDispatcher("./client/adminServiceManagement.jsp").forward(request, response);
					return;
				}
			} else {
				response.sendRedirect("./client/login.jsp");
				return;
			}
		} else {
			// go to normal service page CHANGE !!
			request.getRequestDispatcher("./client/service.jsp").forward(request, response);
		}
	}

	private List<AdminService> getAdminServices() {
		List<AdminService> services = new ArrayList<>();

		try {
			Connection conn = DatabaseConnection.initializeDatabase();

			String selectStr = "SELECT * FROM service";

			PreparedStatement userStatement = conn.prepareStatement(selectStr);

			ResultSet userSet = userStatement.executeQuery();

			while (userSet.next()) {

				AdminService service = new AdminService();
				service.setService_id(userSet.getInt("service_id"));
				service.setService_name(userSet.getString("service_name"));
				service.setDescription(userSet.getString("description"));
				service.setImg_url(userSet.getString("img_url"));
				service.setPrice(userSet.getDouble("price"));

				int category_id = userSet.getInt("category_id");

				String categoryStr = "SELECT * FROM category WHERE category_id = ?";

				PreparedStatement categoryStatement = conn.prepareStatement(categoryStr);
				categoryStatement.setInt(1, category_id);
				ResultSet category = categoryStatement.executeQuery();

				while (category.next()) {
					service.setCategory_name(category.getString("category_name"));
				}
				services.add(service);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return services;
	}

	private List<Category> getCategories() {
		List<Category> categories = new ArrayList<>();

		try {
			Connection conn = DatabaseConnection.initializeDatabase();

			String selectStr = "SELECT * FROM category";

			PreparedStatement userStatement = conn.prepareStatement(selectStr);

			ResultSet userSet = userStatement.executeQuery();

			while (userSet.next()) {

				Category category = new Category();
				category.setCategory_id(userSet.getInt("category_id"));
				category.setCategory_name(userSet.getString("category_name"));

				categories.add(category);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return categories;
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// config
		String action = "";
		Connection conn = null;
		String service_name = "";
		String description = "";
		double price = 0.0;
		String price_str = "";
		int category_id = 0;
		int service_id = 0;
		String img_url = "";
		String service_id_str = "";
		String category_id_str = "";
		Collection<Part> fileParts = null;

		String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
		System.out.println(uploadPath);
		action = (String) request.getParameter("action");
		System.out.println("action : " + action);
		try {
			conn = DatabaseConnection.initializeDatabase();
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		}

		if (action == "") {
			doGet(request, response);
		} else {

			service_name = request.getParameter("service_name");
			description = request.getParameter("description");
			service_id_str = request.getParameter("service_id");
			category_id_str = request.getParameter("category");
			System.out.println("category " + category_id_str);
			price_str = request.getParameter("price");

			try {

				if (service_id_str != null) {
					service_id = Integer.parseInt(service_id_str);
				}

				if (category_id_str != null) {
					category_id = Integer.parseInt(category_id_str);
				}
				if (price_str != null) {
				price = Double.parseDouble(price_str);
				}
			} catch (NumberFormatException e) {
				e.printStackTrace();
			}

			switch (action) {
			case "insert":
				fileParts = request.getParts();
				img_url = storeImg(fileParts, uploadPath);
				insertAdminService(conn, service_name, description, img_url, price, category_id);
				break;
			case "delete":
				deleteAdminService(conn, service_id);
				break;
			case "update":
				String contentType = request.getContentType();
				System.out.println(contentType);
				if (contentType != null && contentType.startsWith("multipart/form-data")) {
					fileParts = request.getParts();
					img_url = storeImg(fileParts, uploadPath);

					if (img_url.equals("")) {
						img_url = request.getParameter("img_url");
						System.out.println("img_url");
					}
				}
				updateAdminService(conn, service_id, service_name, description, img_url, price, category_id);
				break;
			}
		}

		try {
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		// call doGet again to get service data
		doGet(request, response);

	}

	private String storeImg(Collection<Part> partList, String uploadPath) throws IOException, ServletException {

		String fileUrl = "";
		// Create the directory if it does not exist
		File uploadDir = new File(uploadPath);
		if (!uploadDir.exists()) {
			uploadDir.mkdir();
		}
		System.out.println(uploadDir.exists()); // shows true

		System.out.println(partList.getClass());
		List<Part> fileParts = new ArrayList<>(partList);

		for (Part part : fileParts) {

			System.out.println("Part Name: " + part.getName());
			System.out.println("Content Type: " + part.getContentType()); // null for non-file parts
			System.out.println("Size: " + part.getSize());

			// Check if it's a file part
			if (part.getSubmittedFileName() != null) {
				System.out.println("This is a file part.");

				String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
				if (!fileName.isEmpty()) { // Only process file parts with a name
					System.out.println("Processing file: " + fileName);

					// Construct the file path and save the file
					String filePath = uploadPath + File.separator + fileName;
					System.out.println("File path: " + filePath);

					part.write(filePath); // Save the file on the server

					// Construct the file URL (relative path for database storage)
					fileUrl = "uploads/" + fileName;
					System.out.println("File URL: " + fileUrl);
				} else {
					System.out.println("Skipped part without a file name.");
				}
			} else {
				System.out.println("This is a form field, not a file.");
				// Process the form field
			}
		}
		System.out.println("SUCCESS");
		return fileUrl;
	}

	private void insertAdminService(Connection conn, String service_name, String description, String img_url,
			double price, int category_id) {
		String insertStr = "";

		try {
			insertStr = "INSERT INTO public.\"service\" (service_name, description, img_url, price, category_id) VALUES (?, ?, ?, ?, ?)";

			PreparedStatement insertStatement = conn.prepareStatement(insertStr);

			insertStatement.setString(1, service_name);

			insertStatement.setString(2, description);

			insertStatement.setString(3, img_url);

			insertStatement.setDouble(4, price);

			insertStatement.setInt(5, category_id);

			int insertedRows = insertStatement.executeUpdate();

			System.out.println("insertedRows : " + insertedRows);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void updateAdminService(Connection conn, int service_id, String service_name, String description,
			String img_url, double price, int category_id) {
		String updateStr = "";

		try {
			updateStr = "UPDATE service SET service_name=?, description =?, img_url =?, price =?, category_id =? WHERE service_id = ?";

			PreparedStatement updateStatement = conn.prepareStatement(updateStr);

			updateStatement.setString(1, service_name);
			updateStatement.setString(2, description);
			updateStatement.setString(3, img_url);
			updateStatement.setDouble(4, price);
			updateStatement.setInt(5, category_id);
			updateStatement.setInt(6, service_id);

			int updatedRows = updateStatement.executeUpdate();

			System.out.println("updatedRows : " + updatedRows);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void deleteAdminService(Connection conn, int service_id) {
		String deleteStr = "";

		try {
			deleteStr = "DELETE FROM service WHERE service_id=?";

			PreparedStatement deleteStatement = conn.prepareStatement(deleteStr);

			deleteStatement.setInt(1, service_id);

			int deletedRows = deleteStatement.executeUpdate();

			System.out.println("deletedRows : " + deletedRows);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
