package com.demo.web_project.service;

import com.demo.web_project.dao.PaymentDao;
import com.demo.web_project.dao.impl.PaymentDaoImpl;
import com.demo.web_project.vo.Payment;

import java.util.List;

public class PaymentService
{
    private PaymentDao paymentDao=new PaymentDaoImpl();

    //根据用户ID查找缴费记录，dao有具体注释
    public List<Payment> findByUserID(int userID)
    {
        return paymentDao.findByUserID(userID);
    }
    //根据会议记录ID查找缴费记录
    public List<Payment> findByAttendeeId(int attendeeId)
    {
        return paymentDao.findByAttendeeId(attendeeId);
    }
    //根据会议ID查找缴费记录
    public List<Payment> findByConferenceId(int conferenceId, int page, int size)
    {
        return paymentDao.findByConferenceId(conferenceId,page,size);
    }
    //保存缴费记录
    public boolean save(Payment payment)
    {
        return paymentDao.save(payment);
    }
    //更新缴费记录
    public boolean updateStatus(int id, String status)
    {
        return paymentDao.updateStatus(id,status);
    }
    //根据用户ID和会议ID查找记录
    public Payment findByUserIdAndConferenceId(int conferenceId, int userId)
    {
        return paymentDao.findByUserIdAndConferenceId(conferenceId,userId);
    }
}
