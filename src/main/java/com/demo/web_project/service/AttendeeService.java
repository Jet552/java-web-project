package com.demo.web_project.service;
import com.demo.web_project.dao.AttendeeDao;
import com.demo.web_project.dao.impl.AttendeeDaoImpl;
import com.demo.web_project.vo.Attendee;
import com.demo.web_project.vo.Conference;

import java.util.List;
public class AttendeeService {
    private AttendeeDao attendeeDao=new AttendeeDaoImpl();
    public int createAttend(Attendee attendee){
        return attendeeDao.createAttend(attendee);
    }
    public List<Attendee> checkAttendees(int user_id){
        return attendeeDao.checkAttendees(user_id);
    }
    public  int checkAttendeesStatus(int user_id,int confID){
        return  attendeeDao.checkAttendeesStatus(user_id,confID);
    }

    public List<Conference> findByUserId(int user_id){return attendeeDao.findByUserId(user_id);}
    public boolean cancelAttendee(int attenID){
        return attendeeDao.cancelAttendee(attenID);
    }
}
