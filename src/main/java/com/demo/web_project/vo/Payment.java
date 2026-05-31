package com.demo.web_project.vo;

import java.time.LocalDateTime;

public class Payment
{
    private int id;
    private int attendee_id;
    private double amount;
    private String status;//枚举类型
    private LocalDateTime paid_at;

    //关联查询
    private int conference_id;
    private String conferenceTitle;
    private String username;
    private String conferenceDate; //会议开始时间（格式化后的字符串）


    public int getConference_id() {return conference_id;}

    public void setConference_id(int conference_id) {
        this.conference_id = conference_id;
    }

    public String getConferenceTitle() {return conferenceTitle;}

    public void setConferenceTitle(String conferenceTitle) {
        this.conferenceTitle = conferenceTitle;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getConferenceDate() {
        return conferenceDate;
    }

    public void setConferenceDate(String conferenceDate) {
        this.conferenceDate = conferenceDate;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getAttendee_id() {
        return attendee_id;
    }

    public void setAttendee_id(int attendee_id) {
        this.attendee_id = attendee_id;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getPaid_at() {
        return paid_at;
    }

    public void setPaid_at(LocalDateTime paid_at) {
        this.paid_at = paid_at;
    }
}
