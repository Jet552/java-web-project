package com.demo.web_project.dao.impl;
import com.demo.web_project.dao.ConferenceDao;
import com.demo.web_project.dao.JDBCUtil;
import com.demo.web_project.vo.Conference;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class ConferenceDaoImpl implements ConferenceDao {
    public Conference findByCodes(String invite_codes ){
        String sql = "SELECT id,organizer_id,description,title, start_date,end_date,venue,dorms,invite_codes,amount " +
                "FROM conferences WHERE invite_codes = ? and status='approved'";
        return searchOneConf(sql,invite_codes);
    }
    public Conference findByConfID(int confID ){
        String sql = "SELECT id,organizer_id,title, start_date,end_date,venue,dorms,invite_codes,amount " +
                "FROM conferences WHERE id = ? and status='approved'";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, confID);
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
        String sql = "SELECT id,description,organizer_id, title, start_date,end_date,venue,dorms,invite_codes,amount FROM conferences" +
                " WHERE title LIKE ? and status='approved' ORDER BY id";//先子串匹配看有没有现成的
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
                       if( seen.add(c.getId())){
                           conferenceList.add(c);
                       }
                    }
                }
            }
        }
        return conferenceList;
    }
    public List<Conference> findDefault(){
        List<Conference> conferenceList = new ArrayList<>();
        String sql = "SELECT id,description,organizer_id, title, start_date,end_date,venue,dorms,invite_codes,amount FROM conferences" +
                " WHERE status='approved' ORDER BY id";//先子串匹配看有没有现成的
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
                conference.setDescription(rs.getString("description"));
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
    public Conference searchOneConf(String sql,String keyword){
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, keyword);
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
                conference.setDescription(rs.getString("description"));
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
                conference.setDescription(rs.getString("description"));
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

    @Override
    public List<Conference> findByOrganizerId(int organizerId) {
        List<Conference> list = new ArrayList<>();
        String sql = "SELECT id, organizer_id, title, description, venue, dorms, invite_codes, " +
                     "start_date, end_date, status, created_date, reason " +
                     "FROM conferences WHERE organizer_id = ? ORDER BY id";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, organizerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Conference c = new Conference();
                c.setId(rs.getInt("id"));
                c.setOrganizer_id(rs.getInt("organizer_id"));
                c.setTitle(rs.getString("title"));
                c.setDescription(rs.getString("description"));
                c.setVenue(rs.getString("venue"));
                c.setDorms(rs.getString("dorms"));
                c.setInvite_codes(rs.getString("invite_codes"));
                Timestamp start = rs.getTimestamp("start_date");
                if (start != null) c.setStart_date(start.toLocalDateTime());
                Timestamp end = rs.getTimestamp("end_date");
                if (end != null) c.setEnd_date(end.toLocalDateTime());
                c.setStatus(rs.getString("status"));
                Timestamp created = rs.getTimestamp("created_date");
                if (created != null) c.setCreated_date(created.toLocalDateTime());
                c.setReason(rs.getString("reason"));
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public int create(Conference conference) {
        String sql = "INSERT INTO conferences (organizer_id, title, description, venue, dorms, start_date, end_date, amount, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'pending')";

        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, conference.getOrganizer_id());
            ps.setString(2, conference.getTitle());
            ps.setString(3, conference.getDescription());
            ps.setString(4, conference.getVenue());
            ps.setString(5, conference.getDorms());
            ps.setTimestamp(6, Timestamp.valueOf(conference.getStart_date()));
            ps.setTimestamp(7, Timestamp.valueOf(conference.getEnd_date()));
            ps.setDouble(8, conference.getAmount());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1); // 返回生成的会议ID
                }
            }
            return -1;
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    @Override
    public int update(Conference conference) {
        String sql = "UPDATE conferences SET title = ?, description = ?, venue = ?, dorms = ?, " +
                "start_date = ?, end_date = ?, amount = ? WHERE id = ? AND status = 'pending'";

        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, conference.getTitle());
            ps.setString(2, conference.getDescription());
            ps.setString(3, conference.getVenue());
            ps.setString(4, conference.getDorms());
            ps.setTimestamp(5, Timestamp.valueOf(conference.getStart_date()));
            ps.setTimestamp(6, Timestamp.valueOf(conference.getEnd_date()));
            ps.setDouble(7, conference.getAmount());
            ps.setInt(8, conference.getId());

            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int delete(int id) {
        Connection conn = null;
        try {
            conn = JDBCUtil.getConnection();
            conn.setAutoCommit(false);

            String sql1 = "DELETE a FROM accommodations a " +
                    "JOIN attendees att ON a.attendee_id = att.id " +
                    "WHERE att.conference_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql1)) {
                ps.setInt(1, id);
                ps.executeUpdate();
            }

            String sql2 = "DELETE c FROM checkins c " +
                    "JOIN attendees att ON c.attendee_id = att.id " +
                    "WHERE att.conference_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql2)) {
                ps.setInt(1, id);
                ps.executeUpdate();
            }

            // 删除缴费记录
            String sql3 = "DELETE p FROM payments p " +
                    "JOIN attendees att ON p.attendee_id = att.id " +
                    "WHERE att.conference_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql3)) {
                ps.setInt(1, id);
                ps.executeUpdate();
            }

            // 删除参会记录
            String sql4 = "DELETE FROM attendees WHERE conference_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql4)) {
                ps.setInt(1, id);
                ps.executeUpdate();
            }

            // 最后删除会议本身
            String sql5 = "DELETE FROM conferences WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql5)) {
                ps.setInt(1, id);
                int result = ps.executeUpdate();

                // 3. 所有操作都成功，提交事务
                conn.commit();
                return result;
            }

        } catch (SQLException e) {
            // 4. 任何一步出错，回滚事务
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return 0;
        } finally {
            // 5. 恢复自动提交并关闭连接
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    @Override
    public Conference findById(int id) {
        String sql = "SELECT id, organizer_id, title, description, venue, dorms, invite_codes, " +
                "start_date, end_date, status, created_date, reason " +
                "FROM conferences WHERE id = ?";

        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Conference c = new Conference();
                c.setId(rs.getInt("id"));
                c.setOrganizer_id(rs.getInt("organizer_id"));
                c.setTitle(rs.getString("title"));
                c.setDescription(rs.getString("description"));
                c.setVenue(rs.getString("venue"));
                c.setDorms(rs.getString("dorms"));
                c.setInvite_codes(rs.getString("invite_codes"));
                Timestamp start = rs.getTimestamp("start_date");
                if (start != null) c.setStart_date(start.toLocalDateTime());
                Timestamp end = rs.getTimestamp("end_date");
                if (end != null) c.setEnd_date(end.toLocalDateTime());
                c.setStatus(rs.getString("status"));
                Timestamp created = rs.getTimestamp("created_date");
                if (created != null) c.setCreated_date(created.toLocalDateTime());
                c.setReason(rs.getString("reason"));
                return c;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int updateInviteCode(int conferenceId, String inviteCode) {
        String sql = "UPDATE conferences SET invite_codes = ? WHERE id = ? AND status = 'approved'";

        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, inviteCode);
            ps.setInt(2, conferenceId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public List<Conference> findByStatus(String status) {
        List<Conference> list = new ArrayList<>();
        String sql = "SELECT id, organizer_id, title, description, venue, dorms, " +
                "start_date, end_date, status, created_date, reason " +
                "FROM conferences WHERE status = ? ORDER BY id";

        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Conference c = new Conference();
                c.setId(rs.getInt("id"));
                c.setOrganizer_id(rs.getInt("organizer_id"));
                c.setTitle(rs.getString("title"));
                c.setDescription(rs.getString("description"));
                c.setVenue(rs.getString("venue"));
                c.setDorms(rs.getString("dorms"));
                Timestamp start = rs.getTimestamp("start_date");
                if (start != null) c.setStart_date(start.toLocalDateTime());
                Timestamp end = rs.getTimestamp("end_date");
                if (end != null) c.setEnd_date(end.toLocalDateTime());
                c.setStatus(rs.getString("status"));
                Timestamp created = rs.getTimestamp("created_date");
                if (created != null) c.setCreated_date(created.toLocalDateTime());
                c.setReason(rs.getString("reason"));
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Conference> findPendingConferences() {
        List<Conference> list = new ArrayList<>();
        String sql = "SELECT id, organizer_id, title, description, venue, dorms, " +
                "start_date, end_date, status, created_date, reason " +
                "FROM conferences WHERE status = 'pending' ORDER BY id";

        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Conference c = new Conference();
                c.setId(rs.getInt("id"));
                c.setOrganizer_id(rs.getInt("organizer_id"));
                c.setTitle(rs.getString("title"));
                c.setDescription(rs.getString("description"));
                c.setVenue(rs.getString("venue"));
                c.setDorms(rs.getString("dorms"));
                Timestamp start = rs.getTimestamp("start_date");
                if (start != null) c.setStart_date(start.toLocalDateTime());
                Timestamp end = rs.getTimestamp("end_date");
                if (end != null) c.setEnd_date(end.toLocalDateTime());
                c.setStatus(rs.getString("status"));
                Timestamp created = rs.getTimestamp("created_date");
                if (created != null) c.setCreated_date(created.toLocalDateTime());
                c.setReason(rs.getString("reason"));
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Conference> findAllConferences() {
        List<Conference> list = new ArrayList<>();
        String sql = "SELECT id, organizer_id, title, description, venue, dorms, " +
                "start_date, end_date, status, created_date, reason " +
                "FROM conferences WHERE status != 'pending' AND status != 'invalid' ORDER BY id";

        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Conference c = new Conference();
                c.setId(rs.getInt("id"));
                c.setOrganizer_id(rs.getInt("organizer_id"));
                c.setTitle(rs.getString("title"));
                c.setDescription(rs.getString("description"));
                c.setVenue(rs.getString("venue"));
                c.setDorms(rs.getString("dorms"));
                Timestamp start = rs.getTimestamp("start_date");
                if (start != null) c.setStart_date(start.toLocalDateTime());
                Timestamp end = rs.getTimestamp("end_date");
                if (end != null) c.setEnd_date(end.toLocalDateTime());
                c.setStatus(rs.getString("status"));
                Timestamp created = rs.getTimestamp("created_date");
                if (created != null) c.setCreated_date(created.toLocalDateTime());
                c.setReason(rs.getString("reason"));
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public int approveConference(int id, String reason) {
        String sql = "UPDATE conferences SET status = 'approved', reason = ? WHERE id = ? AND status = 'pending'";

        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, reason);
            ps.setInt(2, id);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public int rejectConference(int id, String reason) {
        String sql = "UPDATE conferences SET status = 'rejected', reason = ? WHERE id = ? AND status = 'pending'";

        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, reason);
            ps.setInt(2, id);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }
}