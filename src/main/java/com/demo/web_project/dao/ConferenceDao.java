package com.demo.web_project.dao;

import com.demo.web_project.vo.Conference;
import java.util.List;

public interface ConferenceDao {
    Conference findByCodes(String invite_codes);
    List<Conference> findAll(String keyword);
    List<Conference> findByOrganizerId(int organizerId);
    int create(Conference conference); // 创建新会议
    int update(Conference conference); // 更新会议信息
    int delete(int id); // 删除会议
    Conference findById(int id); // 根据ID查询会议详情
    int updateInviteCode(int conferenceId, String inviteCode); // 更新会议邀请码
}
