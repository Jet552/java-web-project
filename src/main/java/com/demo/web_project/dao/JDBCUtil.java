package com.demo.web_project.dao;

import java.sql.*;
import java.util.*;

public class JDBCUtil
{//建立数据库连接
    private static String DB_URL ="jdbc:mysql://localhost:3306/web_db?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=Asia/Shanghai&characterEncoding=UTF-8";
    private static String DB_DRIVER = "com.mysql.cj.jdbc.Driver";
    static {
        try {
            Class.forName(DB_DRIVER);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL驱动加载失败", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, "root", "334203");
    }
}

