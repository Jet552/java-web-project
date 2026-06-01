package com.demo.web_project.dao;

import java.sql.*;
import java.util.*;

public class JDBCUtil
{//建立数据库连接
    private static String DB_URL ="jdbc:mysql://localhost:3306/web_db?allowPublicKeyRetrieval=true&giuseSSL=false";
    private static String DB_DRIVER = "com.mysql.cj.jdbc.Driver";
    static {
        try {
            Class.forName(DB_DRIVER);
        } catch (ClassNotFoundException e) {
            System.out.println("数据库驱动加载失败");
            e.printStackTrace();
        }
    }

    public static Connection getConnection()
    {
        Connection connection = null;
        try {
            connection = DriverManager.getConnection(DB_URL,"root","123456");
        } catch (SQLException e) {
            System.out.println("连接数据库异常");
            e.printStackTrace();
        }
        return connection;
    }
    public static void closeConnection(Connection connection)
    {
        if(connection!=null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}

