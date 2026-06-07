package com.demo.web_project.dao;

import com.demo.web_project.vo.Accommodation;
import java.util.List;

// 住宿表数据访问接口
public interface AccommodationDao {
    /**
     * 分配房间
     * @param acc 住宿对象
     * @return 是否成功
     */
    boolean assignRoom(Accommodation acc);

    /**
     * 查询某会议的住宿列表（含参会者姓名）
     * @param conferenceId 会议ID
     * @return [{attendeeId, username, roomNumber, checkinDate, checkoutDate, status}, ...]
     */
    List<Accommodation> getRoomList(int conferenceId);

    /**
     * 更新房间信息或退房
     * @param id 住宿记录ID
     * @param roomNumber 新房号
     * @param status 状态
     * @return 是否成功
     */
    boolean updateRoom(int id, String roomNumber, int status);

    /**
     * 查询某参会者的住宿记录
     * @param attendeeId 参会记录ID
     * @return 住宿对象，无记录返回 null
     */
    Accommodation findByAttendeeId(int attendeeId);

    /**
     * 退房：仅将 status 改为 0
     */
    boolean checkoutRoom(int accommodationId);
}
