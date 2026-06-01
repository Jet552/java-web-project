package com.demo.web_project.dao.impl;

import com.demo.web_project.dao.AttendeeDao;
import com.demo.web_project.dao.JDBCUtil;
import com.demo.web_project.vo.Attendee;
import com.demo.web_project.vo.Conference;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AttendeeDaoImpl implements AttendeeDao {
    public boolean createAttend(Attendee attendee){//根据输入信息插入一条新记录
        String sql = "INSERT INTO attendees (user_id,conference_id,arrival_time,departure_time,accommodation_type,requirements)" +
                " VALUES(?,?,?,?,?,?) ";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, attendee.getUserid());
            ps.setInt(2,attendee.getConference_id());
            ps.setTimestamp(3,java.sql.Timestamp.valueOf(attendee.getArrival_time()));
            ps.setTimestamp(4,java.sql.Timestamp.valueOf(attendee.getDeparture_time()));
            ps.setString(5,attendee.getAccommodation_type());
            ps.setString(6,attendee.getRequirements());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public List<Attendee> checkAttendees(int user_id){
        String sql = "SELECT user_id,conference_id,arrival_time,departure_time,accommodation_type,requirements,status " +
                "FROM attendees WHERE userid = ?";
        List<Attendee> attendeeList=searchDB(sql,user_id);
        return attendeeList;
    }
    public int checkAttendeesStatus(int user_id,int conf_id){
        String sql = "SELECT id,user_id,conference_id,arrival_time,departure_time,accommodation_type,requirements " +
                "FROM attendees WHERE user_id = ? and conference_id=? and status=1";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, user_id);
            ps.setInt(2,conf_id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {// 已报名
                return rs.getInt("id");
            } else {// 未报名
                return 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    public List<Attendee> checkMyAttendeesStatus(int user_id) {
        return null;
    }
//    public List<Attendee> checkMyAttendeesStatus(int user_id){//根据用户ID和会议ID来检索自己已参加的会议
//        String sql = "SELECT conferences.title,start_date,end_date,venue,dorms,amount,arrival_time,departure_time,accommodation_type,requirements,attendees.`status` " +
//                "FROM attendees,conferences " +
//                "WHERE attendees.conference_id=conferences.id and attendees.user_id=?";
//        try (Connection conn = JDBCUtil.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, user_id);
//            ResultSet rs = ps.executeQuery();
//            while (rs.next()) {
//                Attendee attendee = new Attendee();
//                attendee.setUserid(rs.getInt("user_id"));
//                attendee.setConference_id(rs.getInt("conference_id"));
//                Timestamp timestamp1 = rs.getTimestamp("arrival_time");
//                Timestamp timestamp2 = rs.getTimestamp("departure_time");
//                attendee.setAccommodation_type(rs.getString("accommodation_type"));
//                attendee.setRequirements(rs.getString("requirements"));
//                if (timestamp1 != null) {
//                    attendee.setArrival_time(timestamp1.toLocalDateTime());
//                }
//                if (timestamp2!=null){
//                    attendee.setDeparture_time(timestamp2.toLocalDateTime());
//                }
//                attendeeList.add(attendee);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return attendeeList;//返回搜索结果
//    }
    public List<Attendee> searchDB(String sql,int keyword){
        List<Attendee> attendeeList = new ArrayList<>();
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, keyword);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Attendee attendee = new Attendee();
                attendee.setUserid(rs.getInt("user_id"));
                attendee.setConference_id(rs.getInt("conference_id"));
                Timestamp timestamp1 = rs.getTimestamp("arrival_time");
                Timestamp timestamp2 = rs.getTimestamp("departure_time");
                attendee.setAccommodation_type(rs.getString("accommodation_type"));
                attendee.setRequirements(rs.getString("requirements"));
                if (timestamp1 != null) {
                    attendee.setArrival_time(timestamp1.toLocalDateTime());
                }
                if (timestamp2!=null){
                    attendee.setDeparture_time(timestamp2.toLocalDateTime());
                }
                attendeeList.add(attendee);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return attendeeList;//返回搜索结果
    }


    public List<Conference> findByUserId(int userId) {
        List<Conference> conferenceList = new ArrayList<>();

        String sql = "SELECT c.id, c.title, c.description, c.venue,c.dorms c.start_date,c.invite_codes, c.end_date, c.status, c.created_date, c.reason," +
                "a.id AS attendee_id, a.arrival_time, a.departure_time, a.accommodation_type, a.requirements, a.status AS attendee_status" +
                "FROM attendees a " +
                "JOIN conferences c ON a.conference_id = c.id " +
                "WHERE a.user_id = ? " +
                "ORDER BY c.start_date DESC";

        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Conference conference = new Conference();
                conference.setId(rs.getInt("c.id"));
                conference.setTitle(rs.getString("c.title"));
                conference.setDescription(rs.getString("c.description"));
                conference.setVenue(rs.getString("c.venue"));
                conference.setDorms(rs.getString("c.dorms"));
                conference.setInvite_codes(rs.getString("c.invite_codes"));

                // 处理日期
                Timestamp startTimestamp = rs.getTimestamp("c.start_date");
                if (startTimestamp != null) {
                    conference.setStart_date(startTimestamp.toLocalDateTime());
                }

                Timestamp endTimestamp = rs.getTimestamp("c.end_date");
                if (endTimestamp != null) {
                    conference.setEnd_date(endTimestamp.toLocalDateTime());
                }
                conference.setStatus(rs.getString("c.status"));
                conference.setReason(rs.getString("c.reason"));

                Timestamp createTimestamp = rs.getTimestamp("c.created_date");
                if (endTimestamp != null) {
                    conference.setCreated_date(createTimestamp.toLocalDateTime());
                }

                conferenceList.add(conference);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return conferenceList;
    }
}
