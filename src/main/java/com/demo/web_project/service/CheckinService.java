package com.demo.web_project.service;

import com.demo.web_project.dao.CheckinDao;
import com.demo.web_project.dao.impl.CheckinDaoImpl;
import com.demo.web_project.vo.Checkin;

import java.util.List;
import java.util.Map;

public class CheckinService {
    private CheckinDao checkinDao = new CheckinDaoImpl();

    /**
     * 执行签到，验证重复签到 + 组织者权限
     */
    public String doCheckin(int attendeeId, int checkedBy) {
        // 权限校验：只有该会议的组织者才能执行签到
        Integer organizerId = checkinDao.getConferenceOrganizerId(attendeeId);
        if (organizerId == null) {
            return "参会记录不存在";
        }
        if (organizerId != checkedBy) {
            return "您不是该会议的组织者，无权操作签到";
        }

        // 检查是否已签到
        Checkin existing = checkinDao.findByAttendeeId(attendeeId);
        if (existing != null) {
            return "该参会者已签到";
        }
        int rows = checkinDao.doCheckin(attendeeId, checkedBy);
        return rows > 0 ? "success" : "签到失败";
    }

    /**
     * 获取某会议的签到列表（含签到状态）
     */
    public List<Map<String, Object>> getCheckinList(int conferenceId) {
        return checkinDao.getCheckinList(conferenceId);
    }

    /**
     * 获取签到统计
     */
    public Map<String, Integer> getStatistics(int conferenceId) {
        return checkinDao.getStatistics(conferenceId);
    }
}
