package com.demo.web_project.dao;
import com.demo.web_project.vo.Attendee;
import com.demo.web_project.vo.Conference;
import java.util.List;
public interface AttendeeDao {
    public int createAttend(Attendee attendee);//根据输入信息插入一条新记录
    public List<Attendee> checkAttendees(int user_id);
    public Attendee checkAttendeesStatus(int user_id,int conf_id);//查看是否已经参加某个会议
    //根据用户ID查找已参加的会议列表
    List<Conference> findByUserId(int user_id);
    public boolean cancelAttendee(int attenID);
}
