package com.demo.web_project.dao.impl;

import com.demo.web_project.dao.AccommodationDao;
import com.demo.web_project.dao.JDBCUtil;
import com.demo.web_project.vo.Accommodation;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AccommodationDaoImpl implements AccommodationDao {

    @Override
    public boolean assignRoom(Accommodation acc) {
        String sql = "INSERT INTO accommodations (attendee_id, room_number, checkin_date, checkout_date, status) VALUES (?, ?, ?, ?, 1)";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, acc.getAttendeeId());
            ps.setString(2, acc.getRoomNumber());
            ps.setDate(3, Date.valueOf(acc.getCheckinDate()));
            ps.setDate(4, Date.valueOf(acc.getCheckoutDate()));
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Accommodation> getRoomList(int conferenceId) {
        List<Accommodation> list = new ArrayList<>();
        String sql = """
            SELECT ac.id, ac.attendee_id, ac.room_number, ac.checkin_date,
                   ac.checkout_date, ac.status, u.username
            FROM accommodations ac
            JOIN attendees a ON ac.attendee_id = a.id
            JOIN users u ON a.user_id = u.id
            WHERE a.conference_id = ?
            ORDER BY ac.room_number
            """;
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, conferenceId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Accommodation ac = new Accommodation();
                ac.setId(rs.getInt("id"));
                ac.setAttendeeId(rs.getInt("attendee_id"));
                ac.setRoomNumber(rs.getString("room_number"));
                Date checkin = rs.getDate("checkin_date");
                if (checkin != null) ac.setCheckinDate(checkin.toLocalDate());
                Date checkout = rs.getDate("checkout_date");
                if (checkout != null) ac.setCheckoutDate(checkout.toLocalDate());
                ac.setStatus(rs.getInt("status"));
                ac.setUsername(rs.getString("username"));
                list.add(ac);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public boolean updateRoom(int id, String roomNumber, int status) {
        String sql = "UPDATE accommodations SET room_number = ?, status = ? WHERE id = ?";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, roomNumber);
            ps.setInt(2, status);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public Accommodation findByAttendeeId(int attendeeId) {
        String sql = "SELECT id, attendee_id, room_number, checkin_date, checkout_date, status FROM accommodations WHERE attendee_id = ?";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, attendeeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Accommodation ac = new Accommodation();
                ac.setId(rs.getInt("id"));
                ac.setAttendeeId(rs.getInt("attendee_id"));
                ac.setRoomNumber(rs.getString("room_number"));
                Date checkin = rs.getDate("checkin_date");
                if (checkin != null) ac.setCheckinDate(checkin.toLocalDate());
                Date checkout = rs.getDate("checkout_date");
                if (checkout != null) ac.setCheckoutDate(checkout.toLocalDate());
                ac.setStatus(rs.getInt("status"));
                return ac;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean checkoutRoom(int accommodationId) {
        String sql = "UPDATE accommodations SET status = 0 WHERE id = ?";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accommodationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public java.time.LocalDateTime getConferenceEndDate(int attendeeId) {
        String sql = """
            SELECT c.end_date
            FROM conferences c
            JOIN attendees a ON a.conference_id = c.id
            WHERE a.id = ?
            """;
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, attendeeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Timestamp end = rs.getTimestamp("end_date");
                if (end != null) {
                    return end.toLocalDateTime();
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
