package classes;

public class Category {
	String category_name; 
	String description; 
	String img_url;
	public Category(String category_name, String description, String img_url) {
		super();
		this.category_name = category_name;
		this.description = description;
		this.img_url = img_url;
	}
	public Category() {
		super();
		// TODO Auto-generated constructor stub
	} 
	public String getCategory_name() {
		return category_name;
	}
	public void setCategory_name(String category_name) {
		this.category_name = category_name;
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
}
