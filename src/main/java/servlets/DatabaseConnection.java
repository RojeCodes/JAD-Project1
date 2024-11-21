package servlets;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
	
	protected static Connection initializeDatabase() throws SQLException, ClassNotFoundException {
		// Database Connection
		Class.forName("org.postgresql.Driver");

		// postgresql://JAD_DB_owner:Hi21hXqUSoKO@ep-sweet-meadow-a1jt5uuo.ap-southeast-1.aws.neon.tech/JAD_DB?sslmode=require
			
		// Step 2: Define Connection URL 
		// the connURL should be in this syntax : jdbc:postgresql://${address}:${port}/{db_name}?sslmode=require";
		String connURL = "jdbc:postgresql://ep-sweet-meadow-a1jt5uuo.ap-southeast-1.aws.neon.tech/JAD_DB?sslmode=require";
		String username = "JAD_DB_owner";
		String password = "Hi21hXqUSoKO";

		// Step 3: Establish connection to URL 
		Connection con = DriverManager.getConnection(connURL, username, password);

		return con;
	}
}