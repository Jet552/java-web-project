package com.demo.web_project.service;

import com.demo.web_project.dao.AccommodationDao;
import com.demo.web_project.dao.CheckinDao;
import com.demo.web_project.dao.impl.AccommodationDaoImpl;
import com.demo.web_project.dao.impl.CheckinDaoImpl;
import com.demo.web_project.vo.Accommodation;

import java.time.LocalDate;
import java.util.List;

public class AccommodationService {
    private AccommodationDao accommodationDao = new AccommodationDaoImpl();
    private CheckinDao checkinDao = new CheckinDaoImpl();

    /**
     * 分配房间（前提：该参会者已签到）
     */
    public String assignRoom(int attendeeId, String roomNumber, String checkinDate, String checkoutDate) {
        // 校验是否已签到
        if (checkinDao.findByAttendeeId(attendeeId) == null) {
            return "该参会者尚未签到，不能分配房间";
        }
        // 校验是否已分配过房间
        Accommodation existing = accommodationDao.findByAttendeeId(attendeeId);
        if (existing != null) {
            return "该参会者已分配过房间";
        }
        Accommodation acc = new Accommodation();
        acc.setAttendeeId(attendeeId);
        acc.setRoomNumber(roomNumber);
        acc.setCheckinDate(LocalDate.parse(checkinDate));
        acc.setCheckoutDate(LocalDate.parse(checkoutDate));
        boolean ok = accommodationDao.assignRoom(acc);
        return ok ? "success" : "房间分配失败";
    }

    /**
     * 查询某会议的入住列表
     */
    public List<Accommodation> getRoomList(int conferenceId) {
        return accommodationDao.getRoomList(conferenceId);
    }
}
