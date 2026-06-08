package com.demo.web_project.dao;

import com.demo.web_project.vo.User;
import java.util.List;

//用户表数据访问接口,定义对 users 表的所有操作
public interface UserDao
{
    /**
     * 根据用户名查询用户
     * @param username 用户名
     * @return 用户对象，不存在返回 null
     */
    User findByUsername(String username);
    User findByPhone(String username);
    User findByEmail(String username);
    /**
     * 保存新用户
     * @param user 用户对象
     * @return 是否保存成功
     */
    boolean save(User user);
    /**
     * 查询所有用户
     * @return 用户列表
     */
    List<User> findAll();
    /**
     * 更新用户状态（启用/禁用）
     * @param id 用户ID
     * @param status 状态（1启用/0禁用）
     * @return 是否更新成功
     */
    boolean updateStatus(int id, int status);

    /**
     * （个人中心）更新用户信息
     * @param id 用户ID
     * @param email 邮箱
     * @param phone 电话
     * @return 是否更新成功
     */
    boolean updateUserInfo(int id,String phone,String email);

    /**
     * （个人中心）更新用户密码
     * @param id 用户ID
     * @param password 密码
     * @return 是否更新成功
     */
    boolean updateUserPassword(int id,String password);

    List<User> findByRole(int role);

    List<User> findByStatus(int status);
}
