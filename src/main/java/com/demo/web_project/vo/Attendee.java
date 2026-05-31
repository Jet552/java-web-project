package com.demo.web_project.vo;
import java.time.LocalDateTime;
public class Attendee {
    private int userid;
    private int conference_id;
    private LocalDateTime arrival_time;
    private LocalDateTime departure_time;
    private String accommodation_type;
    private String requirements;
    private int status;
    public Attendee(){

    }
    public Attendee(int userid,int conference_id,LocalDateTime arrival_time,LocalDateTime departure_time,String accommodation_type,String requirements){
        this.userid=userid;
        this.conference_id=conference_id;
        this.arrival_time=arrival_time;
        this.departure_time=departure_time;
        this.accommodation_type=accommodation_type;
        this.requirements=requirements;
    }
    public int getUserid() {
        return userid;
    }

    public void setUserid(int userid) {
        this.userid = userid;
    }

    public int getConference_id() {
        return conference_id;
    }

    public void setConference_id(int conference_id) {
        this.conference_id = conference_id;
    }

    public LocalDateTime getArrival_time() {
        return arrival_time;
    }

    public void setArrival_time(LocalDateTime arrival_time) {
        this.arrival_time = arrival_time;
    }

    public LocalDateTime getDeparture_time() {
        return departure_time;
    }

    public void setDeparture_time(LocalDateTime departure_time) {
        this.departure_time = departure_time;
    }

    public String getAccommodation_type() {
        return accommodation_type;
    }

    public void setAccommodation_type(String accommodation_type) {
        this.accommodation_type = accommodation_type;
    }

    public String getRequirements() {
        return requirements;
    }

    public void setRequirements(String requirements) {
        this.requirements = requirements;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }
}
