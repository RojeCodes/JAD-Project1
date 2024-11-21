package classes;

public class LoggedInUser implements java.io.Serializable{

	int user_id; 
	String full_name; 
	String email; 
	String birthdate;
	String address;
	String phone;
	int role_id; 
	
	public LoggedInUser(int id, String full_name, int role_id, String birthdate, String email, String address, String phone) {
		super();
		this.user_id = id;
		this.full_name = full_name;
		this.role_id = role_id;
		this.email = email;
		this.address = address;
		this.phone = phone;
		this.birthdate = birthdate;
	}
	
	public LoggedInUser() {
		super();
		// TODO Auto-generated constructor stub
	}
	public int getUser_id() {
		return user_id;
	}
	public void setUser_id(int id) {
		this.user_id = id;
	}
	public String getFull_name() {
		return full_name;
	}
	public void setFull_name(String full_name) {
		this.full_name = full_name;
	}
	public int getRole_id() {
		return role_id;
	}
	public void setRole_id(int role_id) {
		this.role_id = role_id;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getBirthdate() {
		return birthdate;
	}
	public void setbirthdate(String birthdate) {
		this.birthdate = birthdate;
	}
	
	
}
