package com.demo.web_project.dao.impl;

import com.demo.web_project.dao.JDBCUtil;
import com.demo.web_project.dao.PaymentDao;
import com.demo.web_project.vo.Payment;

import java.sql.*;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class PaymentDaoImpl implements PaymentDao {

//    @Override
//    public Payment findById(int id) {
//        String sql = "SELECT id, attendee_id, amount, status, paid_at FROM payments WHERE id = ?";
//
//        try (Connection conn = JDBCUtil.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, id);
//            ResultSet rs = ps.executeQuery();
//
//            if (rs.next()) {
//                return extractPayment(rs);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return null;
//    }

    @Override
    public List<Payment> findByAttendeeId(int attendeeId) {
        List<Payment> paymentList = new ArrayList<>();
        String sql = "SELECT id, attendee_id, amount, status, paid_at FROM payments WHERE attendee_id = ? ORDER BY paid_at DESC";

        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, attendeeId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                paymentList.add(extractPayment(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return paymentList;
    }

    @Override
    public List<Payment> findByUserID(int userID) {
        DateTimeFormatter DATETIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        List<Payment> paymentList = new ArrayList<>();

        // 关联查询，获取会议信息
        String sql = "SELECT p.id, p.attendee_id, p.amount, p.status, p.paid_at, " +
                "c.id as conference_id, c.title as conference_title, c.start_date, c.end_date,a.attendee_status " +
                "FROM payments p " +
                "JOIN attendees a ON p.attendee_id = a.id " +
                "JOIN conferences c ON a.conference_id = c.id " +
                "WHERE a.user_id = ? " +
                "ORDER BY p.paid_at DESC";

        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Payment payment = extractPayment(rs);
                // 设置额外信息
                payment.setConference_id(rs.getInt("conference_id"));
                payment.setConferenceTitle(rs.getString("conference_title"));

                Timestamp startTimestamp = rs.getTimestamp("start_date");
                if (startTimestamp != null) {
                    payment.setConferenceStartDate(startTimestamp.toLocalDateTime().format(DATETIME_FORMATTER));
                }
                Timestamp endTimestamp = rs.getTimestamp("end_date");
                if (endTimestamp != null) {
                    payment.setConferenceEndDate(endTimestamp.toLocalDateTime().format(DATETIME_FORMATTER));
                }
                payment.setAttendeeStatus(rs.getInt("a.attendee_status"));

                paymentList.add(payment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return paymentList;
    }

    @Override
    public List<Payment> findByConferenceId(int conferenceId, int page, int size) {
        List<Payment> paymentList = new ArrayList<>();
        int offset = (page - 1) * size;

        String sql = "SELECT p.id, p.attendee_id, p.amount, p.status, p.paid_at, " +
                "u.username, u.phone " +
                "FROM payments p " +
                "JOIN attendees a ON p.attendee_id = a.id " +
                "JOIN users u ON a.user_id = u.id " +
                "WHERE a.conference_id = ? " +
                "ORDER BY p.paid_at DESC LIMIT ? OFFSET ?";

        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, conferenceId);
            ps.setInt(2, size);
            ps.setInt(3, offset);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Payment payment = extractPayment(rs);
                payment.setUsername(rs.getString("username"));
                paymentList.add(payment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return paymentList;
    }

    public Payment findByUserIdAndConferenceId(int conferenceId, int userId) {
        String sql = "SELECT p.id, p.attendee_id, p.amount, p.status, p.paid_at " +
                "FROM payments p " +
                "JOIN attendees a ON p.attendee_id = a.id " +
                "JOIN conferences c ON a.conference_id = c.id " +
                "WHERE a.user_id = ? AND a.conference_id = ?";

        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, conferenceId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Payment payment = new Payment();
                payment.setId(rs.getInt("id"));
                payment.setAttendee_id(rs.getInt("attendee_id"));
                payment.setAmount(rs.getDouble("amount"));
                payment.setStatus(rs.getString("status"));
                payment.setPaid_at(rs.getTimestamp("paid_at") != null ?
                        rs.getTimestamp("paid_at").toLocalDateTime() : null);
                payment.setConference_id(rs.getInt("conference_id"));
                payment.setConferenceTitle(rs.getString("conference_name"));
                return payment;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

//    @Override
//    public int countByConferenceId(int conferenceId) {
//        String sql = "SELECT COUNT(*) FROM payments p " +
//                "JOIN attendees a ON p.attendee_id = a.id " +
//                "WHERE a.conference_id = ?";
//
//        try (Connection conn = JDBCUtil.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, conferenceId);
//            ResultSet rs = ps.executeQuery();
//
//            if (rs.next()) {
//                return rs.getInt(1);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return 0;
//    }

    @Override
    public boolean save(Payment payment) {
        String sql = "INSERT INTO payments (attendee_id, amount, status, paid_at) VALUES (?, ?, ?, ?)";

        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, payment.getAttendee_id());
            ps.setDouble(2, payment.getAmount());
            ps.setString(3, payment.getStatus());

            if (payment.getPaid_at() != null) {
                ps.setTimestamp(4, Timestamp.valueOf(payment.getPaid_at()));
            } else {
                ps.setTimestamp(4, null);
            }

            int affected = ps.executeUpdate();

            if (affected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    payment.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean updateStatus(int attendeeId, String status) {
        String sql = "UPDATE payments SET status = ?, paid_at = ? WHERE attendee_id = ?";

        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);

            if ("paid".equals(status)) {
                ps.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            } else {
                ps.setTimestamp(2, null);
            }
            ps.setInt(3, attendeeId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

//    @Override
//    public Map<String, Object> getStatistics(int userID) {
//        Map<String, Object> stats = new HashMap<>();
//
//        String sql = "SELECT " +
//                "COUNT(*) as total_count, " +
//                "SUM(CASE WHEN status = 'paid' THEN 1 ELSE 0 END) as paid_count, " +
//                "SUM(CASE WHEN status = 'unpaid' THEN 1 ELSE 0 END) as unpaid_count, " +
//                "SUM(CASE WHEN status = 'paid' THEN amount ELSE 0 END) as total_amount " +
//                "FROM payments p " +
//                "JOIN attendees a ON p.attendee_id = a.id " +
//                "WHERE a.user_id = ?";
//
//        try (Connection conn = JDBCUtil.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, userID);
//            ResultSet rs = ps.executeQuery();
//
//            if (rs.next()) {
//                stats.put("totalCount", rs.getInt("total_count"));
//                stats.put("paidCount", rs.getInt("paid_count"));
//                stats.put("unpaidCount", rs.getInt("unpaid_count"));
//                stats.put("totalAmount", rs.getDouble("total_amount"));
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return stats;
//    }

    /**
     * 从 ResultSet 提取 Payment 对象
     */
    private Payment extractPayment(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setId(rs.getInt("id"));
        payment.setAttendee_id(rs.getInt("attendee_id"));
        payment.setAmount(rs.getDouble("amount"));
        payment.setStatus(rs.getString("status"));

        Timestamp timestamp = rs.getTimestamp("paid_at");
        if (timestamp != null) {
            payment.setPaid_at(timestamp.toLocalDateTime());
        }
        return payment;
    }
}