package com.demo.web_project.service;

import com.demo.web_project.dao.AccommodationDao;
import com.demo.web_project.dao.CheckinDao;
import com.demo.web_project.dao.impl.AccommodationDaoImpl;
import com.demo.web_project.dao.impl.CheckinDaoImpl;
import com.demo.web_project.vo.Accommodation;
import com.demo.web_project.vo.Checkin;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

public class AccommodationService {
    private AccommodationDao accommodationDao = new AccommodationDaoImpl();
    private CheckinDao checkinDao = new CheckinDaoImpl();

    /**
     * 分配房间（前提：该参会者已签到）
     * 入住/退房日期约束：范围必须在 [签到时间日期, 会议结束后3天] 内
     */
    public String assignRoom(int attendeeId, String roomNumber, String checkinDate, String checkoutDate) {
        // 校验是否已签到
        Checkin checkin = checkinDao.findByAttendeeId(attendeeId);
        if (checkin == null) {
            return "该参会者尚未签到，不能分配房间";
        }
        // 校验是否已分配过房间
        Accommodation existing = accommodationDao.findByAttendeeId(attendeeId);
        if (existing != null) {
            return "该参会者已分配过房间";
        }

        // ---- 日期范围校验 ----
        LocalDate ciDate = LocalDate.parse(checkinDate);
        LocalDate coDate = LocalDate.parse(checkoutDate);

        // 退房日期必须晚于入住日期
        if (!coDate.isAfter(ciDate)) {
            return "退房日期必须晚于入住日期";
        }

        // 获取日期约束边界
        LocalDateTime checkinTime = checkin.getCheckinTime();
        LocalDate minDate = checkinTime.toLocalDate();  // 签到日期（下限）

        LocalDateTime conferenceEnd = accommodationDao.getConferenceEndDate(attendeeId);
        if (conferenceEnd == null) {
            return "无法获取会议信息";
        }
        LocalDate maxDate = conferenceEnd.toLocalDate().plusDays(3);  // 会议结束后3天（上限）

        // 校验入住日期和退房日期均须在 [minDate, maxDate] 范围内
        if (ciDate.isBefore(minDate)) {
            return "入住日期不能早于签到日期（" + minDate + "）";
        }
        if (ciDate.isAfter(maxDate)) {
            return "入住日期不能晚于会议结束后3天（" + maxDate + "）";
        }
        if (coDate.isBefore(minDate)) {
            return "退房日期不能早于签到日期（" + minDate + "）";
        }
        if (coDate.isAfter(maxDate)) {
            return "退房日期不能晚于会议结束后3天（" + maxDate + "）";
        }

        Accommodation acc = new Accommodation();
        acc.setAttendeeId(attendeeId);
        acc.setRoomNumber(roomNumber);
        acc.setCheckinDate(ciDate);
        acc.setCheckoutDate(coDate);
        boolean ok = accommodationDao.assignRoom(acc);
        return ok ? "success" : "房间分配失败";
    }

    /**
     * 查询某会议的入住列表
     */
    public List<Accommodation> getRoomList(int conferenceId) {
        return accommodationDao.getRoomList(conferenceId);
    }

    /**
     * 退房：仅将 status 改为 0
     */
    public boolean checkout(int accommodationId) {
        return accommodationDao.checkoutRoom(accommodationId);
    }
}
