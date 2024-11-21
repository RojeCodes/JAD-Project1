package classes;

import java.sql.Time;
import java.util.Date;

public class UserBooking {
	int booking_id;
	Date date;
	Time time;
	double hour_count;
	String service_id;
	int status_id;
	int user_id; 
	int receipt_id; 
	public UserBooking() {
		super();
	}

	public int getBooking_id() {
		return booking_id;
	}

	public void setBooking_id(int booking_id) {
		this.booking_id = booking_id;
	}

	public int getUser_id() {
		return user_id;
	}

	public void setUser_id(int user_id) {
		this.user_id = user_id;
	}

	public int getReceipt_id() {
		return receipt_id;
	}

	public void setReceipt_id(int receipt_id) {
		this.receipt_id = receipt_id;
	}

	public UserBooking(Date date, Time time, double hour_count, String service, int status_id, 
		 int user_id, int booking_id) {
		super();
		this.date = date;
		this.time = time;
		this.hour_count = hour_count;
		this.service_id = service;
		this.status_id = status_id;
		this.booking_id = booking_id; 
		this.user_id = user_id;
	}

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}

	public Time getTime() {
		return time;
	}

	public void setTime(Time time) {
		this.time = time;
	}

	public double getHour_count() {
		return hour_count;
	}

	public int getStatus_id() {
		return status_id;
	}

	public void setStatus_id(int status_id) {
		this.status_id = status_id;
	}

	public void setHour_count(double hour_count) {
		this.hour_count = hour_count;
	}

	public String getService_id() {
		return service_id;
	}

	public void setService_id(String service) {
		this.service_id = service;
	}

}
