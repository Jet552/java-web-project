package com.demo.web_project.dao.impl;

import com.demo.web_project.dao.UserDao;
import com.demo.web_project.dao.JDBCUtil;
import com.demo.web_project.vo.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

//用户表数据访问实现类,负责：具体执行SQL语句，与MySQL数据库交互
public class UserDaoImpl implements UserDao {
    /**
     * 根据用户名查询用户（用于登录验证）
     */
    @Override
    public User findByUsername(String username) {
        String sql = "SELECT id, username, password, role, phone, email, status, created_date " +
                "FROM users WHERE username = ?";

        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getInt("role"));
                user.setPhone(rs.getString("phone"));
                user.setEmail(rs.getString("email"));
                user.setStatus(rs.getInt("status"));
                Timestamp timestamp = rs.getTimestamp("created_date");
                if (timestamp != null) {
                    user.setCreatedAt(timestamp.toLocalDateTime());
                }
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    @Override
    public User findByPhone(String phone) {
        String sql = "SELECT id, username, password, role, phone, email, status, created_date " +
                "FROM users WHERE phone = ?";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getInt("role"));
                user.setPhone(rs.getString("phone"));
                user.setEmail(rs.getString("email"));
                user.setStatus(rs.getInt("status"));
                Timestamp timestamp = rs.getTimestamp("created_date");
                if (timestamp != null) {
                    user.setCreatedAt(timestamp.toLocalDateTime());
                }
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    @Override
    public User findByEmail(String email) {
        String sql = "SELECT id, username, password, role, phone, email, status, created_date " +
                "FROM users WHERE email = ?";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getInt("role"));
                user.setPhone(rs.getString("phone"));
                user.setEmail(rs.getString("email"));
                user.setStatus(rs.getInt("status"));
                Timestamp timestamp = rs.getTimestamp("created_date");
                if (timestamp != null) {
                    user.setCreatedAt(timestamp.toLocalDateTime());
                }
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    /**
     * 保存新用户（注册）
     */
    @Override
    public boolean save(User user) {
        String sql = "INSERT INTO users (username, password, phone, email,created_date) " +
                "VALUES (?, ?, ?, ?,?)";
        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getEmail());
            ps.setTimestamp(5,java.sql.Timestamp.valueOf(user.getCreatedDate()));
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    /**
     * 更新用户状态（管理员禁用/启用用户）
     */
    @Override
    public boolean updateStatus(int id, int status) {
        String sql = "UPDATE users SET status = ? WHERE id = ?";

        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, status);
            ps.setInt(2, id);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    /**
     * 查询所有用户（管理员用）
     */
    @Override
    public List<User> findAll() {
        List<User> userList = new ArrayList<>();
        String sql = "SELECT id, username, role, phone, email, status, created_date FROM users";

        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setRole(rs.getInt("role"));
                user.setPhone(rs.getString("phone"));
                user.setEmail(rs.getString("email"));
                user.setStatus(rs.getInt("status"));
                Timestamp timestamp = rs.getTimestamp("created_date");
                if (timestamp != null) {
                    user.setCreatedAt(timestamp.toLocalDateTime());
                }
                userList.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return userList;
    }

    @Override
    public boolean updateUserInfo(int id,String phone,String email)
    {
        String sql = "UPDATE users SET phone = ?,email=? WHERE id = ?";

        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            ps.setString(2, email);
            ps.setInt(3,id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updateUserPassword(int id,String password)
    {
        String sql = "UPDATE users SET password=? WHERE id = ?";

        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, password);
            ps.setInt(2,id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<User> findByRole(int role) {
        List<User> userList = new ArrayList<>();
        String sql = "SELECT id, username, role, phone, email, status, created_date FROM users WHERE role = ?";

        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, role);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setRole(rs.getInt("role"));
                user.setPhone(rs.getString("phone"));
                user.setEmail(rs.getString("email"));
                user.setStatus(rs.getInt("status"));
                Timestamp timestamp = rs.getTimestamp("created_date");
                if (timestamp != null) {
                    user.setCreatedAt(timestamp.toLocalDateTime());
                }
                userList.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return userList;
    }

    @Override
    public List<User> findByStatus(int status) {
        List<User> userList = new ArrayList<>();
        String sql = "SELECT id, username, role, phone, email, status, created_date FROM users WHERE status = ?";

        try (Connection conn = JDBCUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, status);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setRole(rs.getInt("role"));
                user.setPhone(rs.getString("phone"));
                user.setEmail(rs.getString("email"));
                user.setStatus(rs.getInt("status"));
                Timestamp timestamp = rs.getTimestamp("created_date");
                if (timestamp != null) {
                    user.setCreatedAt(timestamp.toLocalDateTime());
                }
                userList.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return userList;
    }
}