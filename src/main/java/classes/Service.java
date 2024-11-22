package classes;

public class Service {
	private String serviceName;
	private String description;
	private String imgURL;
	private double price;
	
	public Service(String serviceName, String description, String imgURL, double price) {
		this.serviceName = serviceName;
		this.description = description;
		this.imgURL = imgURL;
		this.price = price;
	}
	
	public String getName() {
		return this.serviceName;
	}
	public String getDescription() {
		return this.description;
	}
	public String getImgURL() {
		return this.imgURL;
	}
	public double getPrice() {
		return this.price;
	}
	
	public void setName(String name) {
		this.serviceName = name;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public void setImgURL(String url) {
		this.imgURL = url;
	}
	public void setPrice(double price) {
		this.price = price;
	}
}
