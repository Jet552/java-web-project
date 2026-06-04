package com.demo.web_project.service;

import com.demo.web_project.dao.UserDao;
import com.demo.web_project.dao.impl.UserDaoImpl;
import com.demo.web_project.vo.User;

import java.util.List;


public class UserService {
    private UserDao userDao = new UserDaoImpl();

    //根据用户名查询用户
    public User findByUsername(String username) {
        return userDao.findByUsername(username);
    }
    public User findByPhone(String phone) {
        return userDao.findByPhone(phone);
    }
    public User findByEmail(String email) {
        return userDao.findByEmail(email);
    }
    //保存新用户（注册）
    public boolean save(User user) {
        return userDao.save(user);
    }
    //更新用户状态（管理员禁用/启用用户）
    public boolean updateStatus(int id, int status) {
        return userDao.updateStatus(id, status);
    }
    //查询所有用户（管理员用）
    public List<User> findAll() {
        return userDao.findAll();
    }
    /**
     * 用户登录验证
     * @param username 用户名
     * @param password 明文密码
     * @return 验证成功返回 User 对象，失败返回 null
     */
    public User login(String username, String password) {
        if (username == null || username.trim().isEmpty()) {
            return null;
        }
        if (password == null || password.isEmpty()) {
            return null;
        }
        User user = userDao.findByUsername(username);
        if (user == null) {
            return null;
        }
        if (!password.equals(user.getPassword())) {
            return null;  // 密码错误
        }
        return user;
    }

    public boolean updateUserInfo(int id,String phone,String email) {return userDao.updateUserInfo(id,phone,email);}

    public boolean updateUserPassword(int id,String password) {return userDao.updateUserPassword(id,password);}

    public List<User> findByRole(int role) {
        return userDao.findByRole(role);
    }

    public List<User> findByStatus(int status) {
        return userDao.findByStatus(status);
    }
}