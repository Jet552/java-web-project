package com.demo.web_project.vo;

import java.time.LocalDate;

// 住宿记录实体，对应 accommodations 表
public class Accommodation {
    private int id;
    private int attendeeId;      // attendees.id
    private String roomNumber;
    private LocalDate checkinDate;
    private LocalDate checkoutDate;
    private int status;           // 1=入住中, 0=已退房

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }
    public int getAttendeeId() {
        return attendeeId;
    }
    public void setAttendeeId(int attendeeId) {
        this.attendeeId = attendeeId;
    }
    public String getRoomNumber() {
        return roomNumber;
    }
    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }
    public LocalDate getCheckinDate() {
        return checkinDate;
    }
    public void setCheckinDate(LocalDate checkinDate) {
        this.checkinDate = checkinDate;
    }
    public LocalDate getCheckoutDate() {
        return checkoutDate;
    }
    public void setCheckoutDate(LocalDate checkoutDate) {
        this.checkoutDate = checkoutDate;
    }
    public int getStatus() {
        return status;
    }
    public void setStatus(int status) {
        this.status = status;
    }
}
