package com.demo.web_project.dao;

import com.demo.web_project.vo.Checkin;
import java.util.List;
import java.util.Map;

// 签到表数据访问接口
public interface CheckinDao {
    /**
     * 执行签到
     * @param attendeeId 参会记录ID
     * @param checkedBy 签到操作者（组织者ID）
     * @return 影响行数
     */
    int doCheckin(int attendeeId, int checkedBy);

    /**
     * 查询某参会记录是否已签到
     * @param attendeeId 参会记录ID
     * @return 已签到返回 Checkin 对象，否则返回 null
     */
    Checkin findByAttendeeId(int attendeeId);

    /**
     * 查询某会议的签到统计
     * @param conferenceId 会议ID
     * @return [{username, phone, checkinTime, checkedIn}, ...]
     */
    List<Map<String, Object>> getCheckinList(int conferenceId);

    /**
     * 签到统计数字
     * @param conferenceId 会议ID
     * @return {total, checkedIn, unchecked}
     */
    Map<String, Integer> getStatistics(int conferenceId);
}
