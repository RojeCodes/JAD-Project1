package classes;

public class Review {
	private int starCount;
	private String reviewTitle;
	private String description;
	private String authorName;
	
	public Review (int starCount, String reviewTitle, String description, String authorName) {
		this.starCount = starCount;
		this.reviewTitle = reviewTitle;
		this.description = description;
		this.authorName = authorName;
	}
	
	public int getStarCount() {
		return this.starCount;
	}
	public String getReviewTitle() {
		return this.reviewTitle;
	}
	public String getDescription() {
		return this.description;
	}
	public String authorName() {
		return this.authorName;
	}
	
	public void setStarCount(int starCount) {
		this.starCount = starCount;
	}
	public void setReviewTitle(String reviewTitle) {
		this.reviewTitle = reviewTitle;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public void setAuthorName(String authorName) {
		this.authorName = authorName;
	}
}
