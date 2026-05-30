package com.demo.web_project.dao.impl;
import com.demo.web_project.dao.ConferenceDao;
import com.demo.web_project.dao.JDBCUtil;
import com.demo.web_project.vo.Conference;
import com.demo.web_project.vo.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ConferenceDaoImpl implements ConferenceDao {
    public Conference findByCodes(String invite_codes ){
        String sql = "SELECT title, start_date,end_date,venue,dorms " +
                "FROM conferences WHERE invite_codes = ? and status='approved'";

        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, invite_codes);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Conference conference = new Conference();
                conference.setTitle(rs.getString("title"));
                conference.setVenue(rs.getString("venue"));
                conference.setDorms(rs.getString("dorms"));
                Timestamp timestamp1 = rs.getTimestamp("start_date");
                Timestamp timestamp2 = rs.getTimestamp("end_date");
                if (timestamp1 != null) {
                    conference.setStart_date(timestamp1.toLocalDateTime());
                }
                if (timestamp2!=null){
                    conference.setEnd_date(timestamp2.toLocalDateTime());
                }
                return conference;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    public List<Conference> findAll(String keyword){
        List<Conference> conferenceList = new ArrayList<>();
        String sql = "SELECT title, start_date,end_date,venue,dorms FROM conferences";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Conference conference = new Conference();
                conference.setTitle(rs.getString("title"));
                conference.setVenue(rs.getString("venue"));
                conference.setDorms(rs.getString("dorms"));
                Timestamp timestamp1 = rs.getTimestamp("start_date");
                Timestamp timestamp2 = rs.getTimestamp("end_date");
                if (timestamp1 != null) {
                    conference.setStart_date(timestamp1.toLocalDateTime());
                }
                if (timestamp2!=null){
                    conference.setEnd_date(timestamp2.toLocalDateTime());
                }
                conferenceList.add(conference);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return conferenceList;
    }

}
