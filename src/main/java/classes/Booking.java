package classes;

import java.sql.Date;
import java.sql.Time;

public class Booking {
	private int booking_id;
	private Date date;
	private Time time;
	private int hour_count;
	private int service_id;
	private int user_id;
	private int receipt_id;
	private double price;
	
	public Booking (int booking_id, Date date, Time time,
			int hour_count, int service_id, int user_id, int receipt_id) {
		this.booking_id = booking_id;
		this.date = date;
		this.time = time;
		this.hour_count = hour_count;
		this.service_id = service_id;
		this.user_id = user_id;
		this.receipt_id = receipt_id;
	}
	
	public Booking (Date date, Time time, int hour_count, int service_id, int user_id, double price) {
		this.date = date;
		this.time = time;
		this.hour_count = hour_count;
		this.service_id = service_id;
		this.user_id = user_id;
		this.price = price;
	}
	
	public int getBookingId() {
		return this.booking_id;
	}
	public Date getDate() {
		return this.date;
	}
	public Time getTime() {
		return this.time;
	}
	public int getHourCount() {
		return this.hour_count;
	}
	public int getServiceId() {
		return this.service_id;
	}
	public int getUserId() {
		return this.user_id;
	}	
	public int getReceiptId() {
		return this.receipt_id;
	}
	public double getPrice() {
		return this.price;
	}
	
	public void setDate(Date date) {
		this.date = date;
	}
	public void setTime(Time time) {
		this.time = time;
	}
	public void setHourCount(int hour_count) {
		this.hour_count = hour_count;
	}
	public void setServiceId(int service_id) {
		this.service_id = service_id;
	}
}

