package com.demo.web_project.dao.impl;

import com.demo.web_project.dao.CheckinDao;
import com.demo.web_project.dao.JDBCUtil;
import com.demo.web_project.vo.Checkin;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CheckinDaoImpl implements CheckinDao {

    @Override
    public int doCheckin(int attendeeId, int checkedBy) {
        // attendee_id 设置了 UNIQUE 约束，重复签到会抛 SQLException
        String sql = "INSERT INTO checkins (attendee_id, checkin_time, checked_by) VALUES (?, NOW(), ?)";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, attendeeId);
            ps.setInt(2, checkedBy);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public Checkin findByAttendeeId(int attendeeId) {
        String sql = "SELECT id, attendee_id, checkin_time, checked_by FROM checkins WHERE attendee_id = ?";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, attendeeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Checkin c = new Checkin();
                c.setId(rs.getInt("id"));
                c.setAttendeeId(rs.getInt("attendee_id"));
                Timestamp ts = rs.getTimestamp("checkin_time");
                if (ts != null) {
                    c.setCheckinTime(ts.toLocalDateTime());
                }
                c.setCheckedBy(rs.getInt("checked_by"));
                return c;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Map<String, Object>> getCheckinList(int conferenceId) {
        List<Map<String, Object>> list = new ArrayList<>();
        // LEFT JOIN：所有参会者都列出来，没签到的 checkin_time 为 NULL
        String sql = """
            SELECT a.id AS attendee_id, u.username, u.phone,
                   c.checkin_time, c.id AS checkin_id,
                   a.join_source
            FROM attendees a
            JOIN users u ON a.user_id = u.id
            LEFT JOIN checkins c ON a.id = c.attendee_id
            WHERE a.conference_id = ? AND a.status = 1
            ORDER BY c.checkin_time DESC
            """;
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, conferenceId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("attendeeId", rs.getInt("attendee_id"));
                row.put("username", rs.getString("username"));
                row.put("phone", rs.getString("phone"));
                Timestamp ts = rs.getTimestamp("checkin_time");
                row.put("checkinTime", ts != null ? ts.toLocalDateTime().toString() : null);
                row.put("checkedIn", ts != null);
                row.put("joinSource", rs.getString("join_source"));
                list.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Map<String, Integer> getStatistics(int conferenceId) {
        Map<String, Integer> stats = new HashMap<>();
        String sql = """
            SELECT
                COUNT(a.id) AS total,
                COUNT(c.id) AS checkedIn
            FROM attendees a
            LEFT JOIN checkins c ON a.id = c.attendee_id
            WHERE a.conference_id = ? AND a.status = 1
            """;
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, conferenceId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int total = rs.getInt("total");
                int checkedIn = rs.getInt("checkedIn");
                stats.put("total", total);
                stats.put("checkedIn", checkedIn);
                stats.put("unchecked", total - checkedIn);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }
}
