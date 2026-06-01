package com.demo.web_project.dao.impl;
import com.demo.web_project.dao.ConferenceDao;
import com.demo.web_project.dao.JDBCUtil;
import com.demo.web_project.vo.Conference;
import com.demo.web_project.vo.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class ConferenceDaoImpl implements ConferenceDao {
    public Conference findByCodes(String invite_codes ){
        String sql = "SELECT id,organizer_id,title, start_date,end_date,venue,dorms,invite_codes,amount " +
                "FROM conferences WHERE invite_codes = ? and status='approved'";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, invite_codes);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Conference conference = new Conference();
                conference.setId(rs.getInt("id"));
                conference.setOrganizer_id(rs.getInt("organizer_id"));
                conference.setTitle(rs.getString("title"));
                conference.setVenue(rs.getString("venue"));
                conference.setDorms(rs.getString("dorms"));
                Timestamp timestamp1 = rs.getTimestamp("start_date");
                Timestamp timestamp2 = rs.getTimestamp("end_date");
                conference.setInvite_codes(rs.getString("invite_codes"));
                conference.setAmount(rs.getDouble("amount"));
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
        //三级搜索，第一次like用于匹配子串，第二级匹配非连续子串，第三次返回包含其中任意一个关键字即可
        String sql = "SELECT id,organizer_id, title, start_date,end_date,venue,dorms,invite_codes,amount FROM conferences" +
                " WHERE title LIKE ? and status='approved'";//先子串匹配看有没有现成的
        List<Conference> conferenceList=searchDB(sql,keyword);//先按模糊匹配，看有没有子串匹配
        if(conferenceList.isEmpty()){//模糊搜索返回为空,改成非连续匹配看是否有结果
            String[] chars = keyword.split("");   // 每个字符拆开，注意第一个元素可能是空字符串
            String loosePattern = "%" + String.join("%", chars) + "%";   // 结果如 %全%会%
            conferenceList=searchDB(sql,loosePattern);
        }
        if(conferenceList.isEmpty()){
            Set<Integer> seen=new HashSet<>();
            List<Conference> uniqueList=new ArrayList<>();
            List<String> chars = new ArrayList<>();
            for (char c : keyword.toCharArray()) {
                chars.add("%" + c + "%");
            }
            if (!chars.isEmpty()) {
                for (int i = 0; i < chars.size(); i++) {
                    uniqueList=searchDB(sql,chars.get(i));
                    for(Conference c : uniqueList){
                       if( seen.add(c.getId())){//去除重复号
                           conferenceList.add(c);
                       }
                    }
                }
            }
        }
        return conferenceList;
    }
    public List<Conference> findDefault(){ //检索全部会议
        List<Conference> conferenceList = new ArrayList<>();
        String sql = "SELECT id,organizer_id, title, start_date,end_date,venue,dorms,invite_codes,amount FROM conferences" +
                " WHERE status='approved'";//先子串匹配看有没有现成的
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Conference conference = new Conference();
                conference.setId(rs.getInt("id"));
                conference.setOrganizer_id(rs.getInt("organizer_id"));
                conference.setTitle(rs.getString("title"));
                conference.setVenue(rs.getString("venue"));
                conference.setDorms(rs.getString("dorms"));
                conference.setInvite_codes(rs.getString("invite_codes"));
                Timestamp timestamp1 = rs.getTimestamp("start_date");
                Timestamp timestamp2 = rs.getTimestamp("end_date");
                conference.setAmount(rs.getDouble("amount"));
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
        return conferenceList;//返回搜索结果
    }
    public List<Conference> searchDB(String sql,String keyword){
        List<Conference> conferenceList = new ArrayList<>();
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, keyword);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Conference conference = new Conference();
                conference.setId(rs.getInt("id"));
                conference.setOrganizer_id(rs.getInt("organizer_id"));
                conference.setInvite_codes(rs.getString("invite_codes"));
                conference.setTitle(rs.getString("title"));
                conference.setVenue(rs.getString("venue"));
                conference.setDorms(rs.getString("dorms"));
                Timestamp timestamp1 = rs.getTimestamp("start_date");
                Timestamp timestamp2 = rs.getTimestamp("end_date");
                conference.setAmount(rs.getDouble("amount"));
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
        return conferenceList;//返回搜索结果
    }
}
