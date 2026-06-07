package com.demo.web_project.service;

import com.demo.web_project.dao.JDBCUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public class StatisticsService {

    /**
     * 获取系统统计数据
     * @return 包含各类统计数据的Map
     */
    public Map<String, Object> getStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        // 获取会议统计
        stats.put("totalConferences", getTotalConferences());
        stats.put("pendingConferences", getPendingConferences());
        stats.put("approvedConferences", getApprovedConferences());
        stats.put("rejectedConferences", getRejectedConferences());
        stats.put("invalidConferences", getInvalidConferences());
        
        // 获取用户统计
        stats.put("totalUsers", getTotalUsers());
        stats.put("activeUsers", getActiveUsers());
        stats.put("adminUsers", getAdminUsers());
        stats.put("bannedUsers", getBannedUsers());
        
        // 获取参会统计
        stats.put("totalAttendees", getTotalAttendees());
        stats.put("paidAttendees", getPaidAttendees());
        
        // 获取缴费统计
        stats.put("totalPayments", getTotalPayments());
        stats.put("totalAmount", getTotalAmount());
        
        // 获取签到统计
        stats.put("checkedInCount", getCheckedInCount());
        
        return stats;
    }

    /**
     * 获取会议总数
     */
    public int getTotalConferences() {
        String sql = "SELECT COUNT(*) FROM conferences WHERE status != 'invalid'";
        return executeCountQuery(sql);
    }

    /**
     * 获取待审核会议数
     */
    public int getPendingConferences() {
        String sql = "SELECT COUNT(*) FROM conferences WHERE status = 'pending'";
        return executeCountQuery(sql);
    }

    /**
     * 获取已通过会议数
     */
    public int getApprovedConferences() {
        String sql = "SELECT COUNT(*) FROM conferences WHERE status = 'approved'";
        return executeCountQuery(sql);
    }

    /**
     * 获取已拒绝会议数
     */
    public int getRejectedConferences() {
        String sql = "SELECT COUNT(*) FROM conferences WHERE status = 'rejected'";
        return executeCountQuery(sql);
    }

    /**
     * 获取已过期会议数
     */
    public int getInvalidConferences() {
        String sql = "SELECT COUNT(*) FROM conferences WHERE status = 'invalid'";
        return executeCountQuery(sql);
    }

    /**
     * 获取用户总数
     */
    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM users";
        return executeCountQuery(sql);
    }

    /**
     * 获取活跃用户数
     */
    public int getActiveUsers() {
        String sql = "SELECT COUNT(*) FROM users WHERE status = 1";
        return executeCountQuery(sql);
    }

    /**
     * 获取管理员用户数
     */
    public int getAdminUsers() {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 1";
        return executeCountQuery(sql);
    }

    /**
     * 获取被封禁用户数
     */
    public int getBannedUsers() {
        String sql = "SELECT COUNT(*) FROM users WHERE status = 0";
        return executeCountQuery(sql);
    }

    /**
     * 获取参会总人数
     */
    public int getTotalAttendees() {
        String sql = "SELECT COUNT(*) FROM attendees";
        return executeCountQuery(sql);
    }

    /**
     * 获取已缴费人数
     */
    public int getPaidAttendees() {
        String sql = "SELECT COUNT(DISTINCT a.id) FROM attendees a " +
                     "JOIN payments p ON a.id = p.attendee_id WHERE p.status = 'paid'";
        return executeCountQuery(sql);
    }

    /**
     * 获取缴费总笔数
     */
    public int getTotalPayments() {
        String sql = "SELECT COUNT(*) FROM payments";
        return executeCountQuery(sql);
    }

    /**
     * 获取缴费总金额
     */
    public double getTotalAmount() {
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM payments WHERE status = 'paid'";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    /**
     * 获取已签到人数
     */
    public int getCheckedInCount() {
        String sql = "SELECT COUNT(*) FROM checkins";
        return executeCountQuery(sql);
    }

    /**
     * 执行计数查询
     */
    private int executeCountQuery(String sql) {
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}