package classes;

public class AdminService {
	private int service_id;
	private String service_name;
	private String description;
	private String img_url;
	private double price;
	private int category_id;
	private String category_name;
	
	public AdminService(int service_id, String service_name, String description, String img_url, double price,
			int category_id, String category_name) {
		super();
		this.service_id = service_id;
		this.service_name = service_name;
		this.description = description;
		this.img_url = img_url;
		this.price = price;
		this.category_id = category_id;
		this.category_name = category_name;
	}
	public AdminService() {
		super();
		// TODO Auto-generated constructor stub
	}
	public int getService_id() {
		return service_id;
	}
	public void setService_id(int service_id) {
		this.service_id = service_id;
	}
	public String getService_name() {
		return service_name;
	}
	public void setService_name(String service_name) {
		this.service_name = service_name;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getImg_url() {
		return img_url;
	}
	public void setImg_url(String img_url) {
		this.img_url = img_url;
	}
	public double getPrice() {
		return price;
	}
	public void setPrice(double price) {
		this.price = price;
	}
	public int getCategory_id() {
		return category_id;
	}
	public void setCategory_id(int category_id) {
		this.category_id = category_id;
	}
	public String getCategory_name() {
		return category_name;
	}
	public void setCategory_name(String category_name) {
		this.category_name = category_name;
	} 
	
	
}
