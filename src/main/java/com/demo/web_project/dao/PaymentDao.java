package com.demo.web_project.dao;

import com.demo.web_project.vo.Payment;

import java.util.List;

public interface PaymentDao
{
    /**
     * 根据用户ID查询缴费记录
     * @param userID 用户ID
     * @return 缴费记录对象，不存在返回 null
     */
    List<Payment> findByUserID(int userID);
    /**
     * 根据参会记录ID查询缴费记录
     * @param attendeeId 参会记录ID
     * @return 缴费记录对象，不存在返回 null
     */
    List<Payment> findByAttendeeId(int attendeeId);
    /**
     * 根据会议ID查询缴费记录
     * @param conferenceId 会议ID
     * @param page 页面位置
     * @param size
     * @return 缴费记录对象，不存在返回 null
     */
    List<Payment> findByConferenceId(int conferenceId, int page, int size);
    /**
     * 保存缴费记录
     * @param payment 缴费记录
     * @return
     */
    boolean save(Payment payment);
    /**
     * 更新缴费状态
     * @param status 缴费状态
     * @return
     */
    boolean updateStatus(int id, String status);

    Payment findByUserIdAndConferenceId(int conferenceId, int userId);
}
