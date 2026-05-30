package com.demo.web_project.vo;

import java.time.LocalDateTime;

// 签到记录实体，对应 checkins 表
public class Checkin {
    private int id;
    private int attendeeId;      // attendees.id
    private LocalDateTime checkinTime;
    private int checkedBy;        // conferences.organizer_id

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
    public LocalDateTime getCheckinTime() {
        return checkinTime;
    }
    public void setCheckinTime(LocalDateTime checkinTime) {
        this.checkinTime = checkinTime;
    }
    public int getCheckedBy() {
        return checkedBy;
    }
    public void setCheckedBy(int checkedBy) {
        this.checkedBy = checkedBy;
    }
}
