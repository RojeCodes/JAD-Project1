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

import classes.Category;
import classes.LoggedInUser;
import classes.UserBooking;

/**
 * Servlet implementation class CategoryServlet
 */
@WebServlet("/getCategory")
@MultipartConfig
public class CategoryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String UPLOAD_DIR = "uploads";

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public CategoryServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		List<Category> categories = getCategories();
		request.setAttribute("categories", categories);

		HttpSession session = request.getSession(false);

		System.out.println("session " + session);

		if (session != null) {

			LoggedInUser user = (LoggedInUser) session.getAttribute("user");

			if (user != null) {
				System.out.println("user role in category " + user.getRole_id());
				if (user.getRole_id() == 1) { // admin
					request.getRequestDispatcher("./client/adminCategoryManagement.jsp").forward(request, response);
					return;
				} else if (user.getRole_id() == 2) {
					request.getRequestDispatcher("./client/category.jsp").forward(request, response);
					return;
				}
			} else {
				session.invalidate();
				request.getRequestDispatcher("./client/category.jsp").forward(request, response);
				return;
			}
		} else {
			request.getRequestDispatcher("./client/category.jsp").forward(request, response);
			return;
		}
	}

	private List<Category> getCategories() {
		List<Category> categories = new ArrayList<>();

		try {
			Connection conn = DatabaseConnection.initializeDatabase();

			String selectStr = "SELECT * FROM \"category\"";

			PreparedStatement userStatement = conn.prepareStatement(selectStr);

			ResultSet userSet = userStatement.executeQuery();

			while (userSet.next()) {
				Category category = new Category();
				category.setCategory_id(userSet.getInt("category_id"));
				category.setCategory_name(userSet.getString("category_name"));
				category.setDescription(userSet.getString("description"));
				category.setImg_url(userSet.getString("img_url"));
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
		String category_name = "";
		String description = "";
		int category_id = 0;
		String img_url = "";
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

			category_name = request.getParameter("category_name");
			description = request.getParameter("description");
			category_id_str = request.getParameter("category_id");

			try {
				category_id = Integer.parseInt(category_id_str);
				System.out.println(category_id);
			} catch (NumberFormatException e) {
				e.printStackTrace();
			}

			switch (action) {
			case "insert":
				fileParts = request.getParts();
				img_url = storeImg(fileParts, uploadPath);
				insertCategory(conn, category_name, description, img_url);
				break;
			case "delete":
				deleteCategory(conn, category_id);
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
				updateCategory(conn, category_id, category_name, description, img_url);
				break;
			}
		}
		// call doGet again to get category data
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

	private void insertCategory(Connection conn, String category_name, String description, String img_url) {
		String insertStr = "";

		try {
			insertStr = "INSERT INTO public.\"category\" (category_name, description, img_url) VALUES (?, ?, ?)";

			PreparedStatement insertStatement = conn.prepareStatement(insertStr);

			insertStatement.setString(1, category_name);

			insertStatement.setString(2, description);

			insertStatement.setString(3, img_url);

			int insertedRows = insertStatement.executeUpdate();

			System.out.println("insertedRows : " + insertedRows);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void updateCategory(Connection conn, int category_id, String category_name, String description,
			String img_url) {
		String updateStr = "";

		try {
			updateStr = "UPDATE category SET category_name=?, description =?, img_url =? " + "WHERE category_id = ?";

			PreparedStatement updateStatement = conn.prepareStatement(updateStr);

			updateStatement.setString(1, category_name);
			updateStatement.setString(2, description);
			updateStatement.setString(3, img_url);
			updateStatement.setInt(4, category_id);

			int updatedRows = updateStatement.executeUpdate();

			System.out.println("updatedRows : " + updatedRows);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void deleteCategory(Connection conn, int category_id) {
		String deleteStr = "";

		try {
			deleteStr = "DELETE FROM category WHERE category_id=?";

			PreparedStatement deleteStatement = conn.prepareStatement(deleteStr);

			deleteStatement.setInt(1, category_id);

			int deletedRows = deleteStatement.executeUpdate();

			System.out.println("deletedRows : " + deletedRows);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
