package com.demo.web_project.dao;

import java.sql.*;
import java.util.*;

public class JDBCUtil
{//建立数据库连接
    private static String DB_URL ="jdbc:mysql://localhost:3306/web_db?allowPublicKeyRetrieval=true&giuseSSL=false";
    private static String DB_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static Connection connection = null;
    public static Connection getConnection()
    {
        try {
            Class.forName(DB_DRIVER);
            connection = DriverManager.getConnection(DB_URL,"root","334203");
        } catch (ClassNotFoundException e) {
            System.out.println("ClassNotFoundException");
            e.printStackTrace();
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

