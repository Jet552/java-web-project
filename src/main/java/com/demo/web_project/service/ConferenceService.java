package com.demo.web_project.service;
import com.demo.web_project.dao.ConferenceDao;
import com.demo.web_project.dao.impl.ConferenceDaoImpl;
import com.demo.web_project.vo.Conference;

import java.util.List;
import java.util.Random;

public class ConferenceService {
    private ConferenceDao conferenceDao= new ConferenceDaoImpl();
    public Conference findByCodes(String invite_codes){
        return conferenceDao.findByCodes(invite_codes);
    }
    public List<Conference> findAll(String keyword){
        return conferenceDao.findAll(keyword);
    }
    public  List<Conference> findDefault(){
        return conferenceDao.findDefault();
    }
    public Conference findByConfID(String confID ){
        return  conferenceDao.findByConfID(confID);
    }

    public List<Conference> findByOrganizerId(int organizerId) {
        return conferenceDao.findByOrganizerId(organizerId);
    }

    /**
     * 创建新会议
     * @param conference 会议对象
     * @return 生成的会议ID，失败返回-1
     */
    public int createConference(Conference conference) {
        return conferenceDao.create(conference);
    }

    /**
     * 更新会议信息
     * @param conference 会议对象
     * @param organizerId 当前登录用户ID
     * @return true成功，false失败
     */
    public boolean updateConference(Conference conference, int organizerId) {
        Conference existing = conferenceDao.findById(conference.getId());
        // 验证：会议存在且是当前用户创建的且状态为待审核
        if (existing == null || existing.getOrganizer_id() != organizerId || !"pending".equals(existing.getStatus())) {
            return false;
        }
        return conferenceDao.update(conference) > 0;
    }

    /**
     * 删除会议
     * @param conferenceId 会议ID
     * @param organizerId 当前登录用户ID
     * @return true成功，false失败
     */
    public boolean deleteConference(int conferenceId, int organizerId) {
        Conference existing = conferenceDao.findById(conferenceId);
        // 验证：会议存在且是当前用户创建的
        if (existing == null || existing.getOrganizer_id() != organizerId) {
            return false;
        }
        return conferenceDao.delete(conferenceId) > 0;
    }

    /**
     * 获取会议详情
     * @param conferenceId 会议ID
     * @return 会议对象
     */
    public Conference getConferenceById(int conferenceId) {
        return conferenceDao.findById(conferenceId);
    }

    /**
     * 生成9位随机邀请码（大写字母+数字）
     * @param conferenceId 会议ID
     * @param organizerId 当前登录用户ID
     * @return 生成的邀请码，失败返回null
     */
    public String generateInviteCode(int conferenceId, int organizerId) {
        Conference existing = conferenceDao.findById(conferenceId);
        // 验证：会议存在且是当前用户创建的且状态为已通过
        if (existing == null || existing.getOrganizer_id() != organizerId || !"approved".equals(existing.getStatus())) {
            return null;
        }

        // 生成9位随机邀请码
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder sb = new StringBuilder(9);
        Random random = new Random();
        for (int i = 0; i < 9; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        String inviteCode = sb.toString();

        // 更新到数据库
        int result = conferenceDao.updateInviteCode(conferenceId, inviteCode);
        return result > 0 ? inviteCode : null;
    }
}
