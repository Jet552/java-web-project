import com.demo.web_project.dao.AccommodationDao;
import com.demo.web_project.dao.CheckinDao;
import com.demo.web_project.dao.impl.AccommodationDaoImpl;
import com.demo.web_project.dao.impl.CheckinDaoImpl;
import com.demo.web_project.service.AccommodationService;
import com.demo.web_project.vo.Accommodation;
import com.demo.web_project.vo.Checkin;
import org.junit.jupiter.api.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.*;

/**
 * M5 入住日期/退房日期约束验证测试
 *
 * 测试数据说明：
 *   attendee 1 (huanghua): 已签到(2026-06-09), 会议1(全球AI峰会, end=2026-06-12), 有住宿(id=2, 908, 入住中)
 *   attendee 3 (wanglei): 未签到, 无住宿记录
 *   attendee 8 (wangjing): 已签到(2026-03-05), 会议8(5G大会, end=2026-04-20), 住宿已退房(id=4, status=0)
 *   attendee 61: 已签到(2026-06-04), 会议82(123, end=2026-06-26), 住宿已退房(id=5, status=0)
 *
 * 日期约束: checkin_date/checkout_date ∈ [签到日期, 会议结束后3天]
 *   attendee 8: min=2026-03-05, max=2026-04-23
 *   attendee 61: min=2026-06-04, max=2026-06-29
 */
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class AccommodationServiceTest {

    private static AccommodationService service;
    private static AccommodationDao accommodationDao;
    private static CheckinDao checkinDao;
    private static Accommodation backupAccommodation8;

    @BeforeAll
    static void setupAll() {
        service = new AccommodationService();
        accommodationDao = new AccommodationDaoImpl();
        checkinDao = new CheckinDaoImpl();

        // 备份 attendee 8 的住宿记录（测试用完后恢复）
        backupAccommodation8 = accommodationDao.findByAttendeeId(8);

        System.out.println("===== M5 日期约束测试 =====");
    }

    @AfterAll
    static void tearDownAll() {
        // 恢复 attendee 8 的住宿记录
        if (backupAccommodation8 != null) {
            Accommodation existing = accommodationDao.findByAttendeeId(8);
            if (existing == null) {
                // 重新插入原记录
                Accommodation acc = new Accommodation();
                acc.setAttendeeId(8);
                acc.setRoomNumber(backupAccommodation8.getRoomNumber());
                acc.setCheckinDate(backupAccommodation8.getCheckinDate());
                acc.setCheckoutDate(backupAccommodation8.getCheckoutDate());
                accommodationDao.assignRoom(acc);
            }
        }
    }

    // ==================== DAO 层测试 ====================

    @Test
    @Order(1)
    @DisplayName("DAO: getConferenceEndDate 应返回正确的会议结束时间")
    void testGetConferenceEndDate() {
        // attendee 1 → conference 1 (全球人工智能峰会, end_date=2026-06-12 18:00)
        LocalDateTime endDate = accommodationDao.getConferenceEndDate(1);
        assertNotNull(endDate, "会议结束时间不应为 null");
        assertEquals(2026, endDate.getYear());
        assertEquals(6, endDate.getMonthValue());
        assertEquals(12, endDate.getDayOfMonth());
        System.out.println("  ✅ attendee 1 → conference end: " + endDate);

        // attendee 8 → conference 8 (5G大会, end_date=2026-04-20 16:45)
        LocalDateTime endDate8 = accommodationDao.getConferenceEndDate(8);
        assertNotNull(endDate8);
        assertEquals(2026, endDate8.getYear());
        assertEquals(4, endDate8.getMonthValue());
        assertEquals(20, endDate8.getDayOfMonth());
        System.out.println("  ✅ attendee 8 → conference end: " + endDate8);

        // attendee 999 (不存在)
        LocalDateTime endDateNone = accommodationDao.getConferenceEndDate(999);
        assertNull(endDateNone, "不存在的参会者应返回 null");
        System.out.println("  ✅ attendee 999 → null (不存在)");
    }

    @Test
    @Order(2)
    @DisplayName("DAO: checkinDao.findByAttendeeId 应返回正确的签到时间")
    void testFindCheckin() {
        Checkin checkin = checkinDao.findByAttendeeId(1);
        assertNotNull(checkin, "attendee 1 应有签到记录");
        assertEquals(2026, checkin.getCheckinTime().getYear());
        assertEquals(6, checkin.getCheckinTime().getMonthValue());
        assertEquals(9, checkin.getCheckinTime().getDayOfMonth());
        System.out.println("  ✅ attendee 1 checkin time: " + checkin.getCheckinTime());

        Checkin noCheckin = checkinDao.findByAttendeeId(3);
        assertNull(noCheckin, "attendee 3 没有签到记录");
        System.out.println("  ✅ attendee 3 → null (未签到)");
    }

    // ==================== Service 层错误条件测试（只读） ====================

    @Test
    @Order(3)
    @DisplayName("Service: 未签到参会者 → 应拒绝分配房间")
    void testAssignRoom_NotCheckedIn() {
        String result = service.assignRoom(3, "101", "2026-03-05", "2026-03-06");
        assertEquals("该参会者尚未签到，不能分配房间", result);
        System.out.println("  ✅ 未签到 → \"" + result + "\"");
    }

    @Test
    @Order(4)
    @DisplayName("Service: 已有住宿记录 → 应拒绝重复分配")
    void testAssignRoom_AlreadyHasRoom() {
        String result = service.assignRoom(1, "999", "2026-06-09", "2026-06-12");
        assertEquals("该参会者已分配过房间", result);
        System.out.println("  ✅ 已有房间 → \"" + result + "\"");
    }

    // ==================== Service 层日期约束测试（需要清理数据） ====================

    @Test
    @Order(5)
    @DisplayName("Service: 退房日期 ≤ 入住日期 → 应拒绝")
    void testAssignRoom_CheckoutNotAfterCheckin() {
        // 先清理 attendee 8 的住宿记录
        cleanAccommodation(8);

        try {
            String result = service.assignRoom(8, "201", "2026-03-10", "2026-03-09");
            assertEquals("退房日期必须晚于入住日期", result);
            System.out.println("  ✅ 退房≤入住 → \"" + result + "\"");
        } finally {
            restoreAccommodation(8);
        }
    }

    @Test
    @Order(6)
    @DisplayName("Service: 入住日期早于签到日期 → 应拒绝")
    void testAssignRoom_CheckinDateBeforeSignIn() {
        cleanAccommodation(8);

        try {
            // attendee 8 checkin_time = 2026-03-05, min date = 2026-03-05
            String result = service.assignRoom(8, "202", "2026-03-04", "2026-03-10");
            assertTrue(result.contains("入住日期不能早于签到日期"), "实际消息: " + result);
            assertTrue(result.contains("2026-03-05"), "消息应包含最小日期");
            System.out.println("  ✅ 入住日期<签到日 → \"" + result + "\"");
        } finally {
            restoreAccommodation(8);
        }
    }

    @Test
    @Order(7)
    @DisplayName("Service: 入住日期晚于会议结束+3天 → 应拒绝")
    void testAssignRoom_CheckinDateAfterMaxDate() {
        cleanAccommodation(8);

        try {
            // attendee 8 conference end = 2026-04-20, max = 2026-04-23
            String result = service.assignRoom(8, "203", "2026-04-24", "2026-04-25");
            assertTrue(result.contains("入住日期不能晚于会议结束后3天"), "实际消息: " + result);
            assertTrue(result.contains("2026-04-23"), "消息应包含最大日期");
            System.out.println("  ✅ 入住日期>上限 → \"" + result + "\"");
        } finally {
            restoreAccommodation(8);
        }
    }

    @Test
    @Order(8)
    @DisplayName("Service: 入住和退房日期相同 → 应拒绝（退房须晚于入住）")
    void testAssignRoom_CheckoutDateNotAfterCheckin() {
        cleanAccommodation(8);

        try {
            // 同一天入住和退房 → 第一项校验"退房日期必须晚于入住日期"触发
            String result = service.assignRoom(8, "204", "2026-03-06", "2026-03-06");
            assertEquals("退房日期必须晚于入住日期", result);
            System.out.println("  ✅ 入住=退房 → \"" + result + "\"");
        } finally {
            restoreAccommodation(8);
        }
    }

    @Test
    @Order(9)
    @DisplayName("Service: 入住日期早于签到日且退房日期也越界 → 入住检查先触发")
    void testAssignRoom_BothDatesBeforeMinDate() {
        cleanAccommodation(8);

        try {
            // attendee 8 min=2026-03-05，两个日期都在签到日之前
            String result = service.assignRoom(8, "204A", "2026-03-01", "2026-03-02");
            assertTrue(result.contains("入住日期不能早于签到日期"), "实际消息: " + result);
            System.out.println("  ✅ 两个日期都<签到日 → \"" + result + "\"");
        } finally {
            restoreAccommodation(8);
        }
    }

    @Test
    @Order(10)
    @DisplayName("Service: 退房日期晚于会议结束+3天 → 应拒绝")
    void testAssignRoom_CheckoutDateAfterMaxDate() {
        cleanAccommodation(8);

        try {
            // attendee 8 conference end = 2026-04-20, max = 2026-04-23
            String result = service.assignRoom(8, "205", "2026-04-22", "2026-04-24");
            assertTrue(result.contains("退房日期不能晚于会议结束后3天"), "实际消息: " + result);
            assertTrue(result.contains("2026-04-23"), "消息应包含最大日期");
            System.out.println("  ✅ 退房日期>上限 → \"" + result + "\"");
        } finally {
            restoreAccommodation(8);
        }
    }

    // ==================== Service 层成功路径测试 ====================

    @Test
    @Order(11)
    @DisplayName("Service: 合法日期 → 分配成功，然后清理")
    void testAssignRoom_SuccessWithValidDates() {
        cleanAccommodation(8);

        try {
            // attendee 8: min=2026-03-05, max=2026-04-23
            // 使用边界值：入住=签到日，退房=会议结束+3天
            String result = service.assignRoom(8, "BOUNDARY", "2026-03-05", "2026-04-23");
            assertEquals("success", result);
            System.out.println("  ✅ 合法日期[" + "2026-03-05" + " → " + "2026-04-23" + "] → 分配成功");

            // 验证已插入数据库
            Accommodation inserted = accommodationDao.findByAttendeeId(8);
            assertNotNull(inserted);
            assertEquals("BOUNDARY", inserted.getRoomNumber());
            assertEquals(LocalDate.of(2026, 3, 5), inserted.getCheckinDate());
            assertEquals(LocalDate.of(2026, 4, 23), inserted.getCheckoutDate());
            System.out.println("  ✅ 数据库记录验证：房号=" + inserted.getRoomNumber()
                + ", 入住=" + inserted.getCheckinDate() + ", 退房=" + inserted.getCheckoutDate());
        } finally {
            // 清理测试中创建的住宿记录
            cleanAccommodation(8);
            // 恢复原始住宿记录
            restoreAccommodation(8);
            Accommodation restored = accommodationDao.findByAttendeeId(8);
            assertNotNull(restored, "恢复后的住宿记录应存在");
            System.out.println("  ✅ 已恢复 attendee 8 的原始住宿记录");
        }
    }

    @Test
    @Order(12)
    @DisplayName("Service: 合法日期（中间值）→ 分配成功")
    void testAssignRoom_SuccessWithMiddleDates() {
        cleanAccommodation(8);

        try {
            // 正常范围中间值
            String result = service.assignRoom(8, "606", "2026-03-10", "2026-04-15");
            assertEquals("success", result);
            System.out.println("  ✅ 合法日期[" + "2026-03-10" + " → " + "2026-04-15" + "] → 分配成功");

            // 清理
            cleanAccommodation(8);
        } finally {
            restoreAccommodation(8);
        }
    }

    // ==================== 辅助方法 ====================

    /**
     * 清理某个参会者的住宿记录（用于测试前置）
     */
    private void cleanAccommodation(int attendeeId) {
        Accommodation acc = accommodationDao.findByAttendeeId(attendeeId);
        if (acc != null) {
            // checkoutRoom 只是改 status，这里需要真正删除记录
            // 使用 JDBC 直接删除（因为 DAO 没有 delete 方法）
            java.sql.Connection conn = null;
            try {
                conn = com.demo.web_project.dao.JDBCUtil.getConnection();
                java.sql.PreparedStatement ps = conn.prepareStatement(
                    "DELETE FROM accommodations WHERE attendee_id = ?");
                ps.setInt(1, attendeeId);
                int rows = ps.executeUpdate();
                if (rows > 0) {
                    System.out.println("  [清理] 删除了 attendee " + attendeeId + " 的住宿记录");
                }
                ps.close();
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (conn != null) {
                    try { conn.close(); } catch (Exception ignored) {}
                }
            }
        }
    }

    /**
     * 恢复备份的住宿记录
     */
    private void restoreAccommodation(int attendeeId) {
        // 用备份数据重新插入
        Accommodation backup = null;
        if (attendeeId == 8 && backupAccommodation8 != null) {
            backup = backupAccommodation8;
        }

        if (backup != null) {
            Accommodation existing = accommodationDao.findByAttendeeId(attendeeId);
            if (existing == null) {
                Accommodation acc = new Accommodation();
                acc.setAttendeeId(attendeeId);
                acc.setRoomNumber(backup.getRoomNumber());
                acc.setCheckinDate(backup.getCheckinDate());
                acc.setCheckoutDate(backup.getCheckoutDate());
                accommodationDao.assignRoom(acc);
                System.out.println("  [恢复] 恢复了 attendee " + attendeeId + " 的住宿记录");
            }
        }
    }
}
