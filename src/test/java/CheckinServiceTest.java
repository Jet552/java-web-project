import com.demo.web_project.dao.CheckinDao;
import com.demo.web_project.dao.impl.CheckinDaoImpl;
import com.demo.web_project.service.CheckinService;
import com.demo.web_project.vo.Checkin;
import org.junit.jupiter.api.*;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

/**
 * 签到模块测试 — doCheckin 权限/重复/成功 + 签到列表 + 统计
 *
 * 测试数据:
 *   attendee 1 → 已签到，组织者需要查库获取
 *   attendee 3 (wanglei) → 未签到
 */
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class CheckinServiceTest {

    private static CheckinService checkinService;
    private static CheckinDao checkinDao;
    private static int testedAttendeeId = -1; // 记录成功签到的 attendee，用于清理

    @BeforeAll
    static void setupAll() {
        checkinService = new CheckinService();
        checkinDao = new CheckinDaoImpl();
        System.out.println("===== 签到模块测试 =====");
    }

    @AfterAll
    static void tearDownAll() {
        // 清理测试中创建的签到记录
        if (testedAttendeeId > 0) {
            try (Connection conn = com.demo.web_project.dao.JDBCUtil.getConnection();
                 PreparedStatement ps = conn.prepareStatement(
                     "DELETE FROM checkins WHERE attendee_id = ?")) {
                ps.setInt(1, testedAttendeeId);
                int rows = ps.executeUpdate();
                if (rows > 0) {
                    System.out.println("  [清理] 已删除 attendee " + testedAttendeeId + " 的签到记录");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    // ==================== 签到失败场景（只读） ====================

    @Test
    @Order(1)
    @DisplayName("签到: 不存在的参会记录 → 应拒绝")
    void testDoCheckin_AttendeeNotFound() {
        String result = checkinService.doCheckin(99999, 1);
        assertEquals("参会记录不存在", result);
        System.out.println("  ✅ 不存在参会记录 → \"" + result + "\"");
    }

    @Test
    @Order(2)
    @DisplayName("签到: 非组织者操作 → 应拒绝")
    void testDoCheckin_WrongOrganizer() {
        // attendee 3 存在，但用错误组织者去操作
        String result = checkinService.doCheckin(3, 99999);
        assertEquals("您不是该会议的组织者，无权操作签到", result);
        System.out.println("  ✅ 非组织者操作 → \"" + result + "\"");
    }

    @Test
    @Order(3)
    @DisplayName("签到: 已有签到记录的参会者 → 应拒绝重复签到")
    void testDoCheckin_AlreadyCheckedIn() {
        // attendee 1 已签到（根据测试数据）
        Checkin existing = checkinDao.findByAttendeeId(1);
        if (existing == null) {
            System.out.println("  ⚠ attendee 1 未签到，跳过重复签到测试");
            return;
        }

        // 获取正确的组织者
        Integer organizerId = checkinDao.getConferenceOrganizerId(1);
        assertNotNull(organizerId);

        String result = checkinService.doCheckin(1, organizerId);
        assertEquals("该参会者已签到", result);
        System.out.println("  ✅ 重复签到 → \"" + result + "\"");
    }

    // ==================== 签到成功场景（写操作） ====================

    @Test
    @Order(4)
    @DisplayName("签到: 未签到参会者 + 正确组织者 → 签到成功")
    void testDoCheckin_Success() {
        // attendee 3 (wanglei) 未签到
        Checkin existing = checkinDao.findByAttendeeId(3);
        if (existing != null) {
            System.out.println("  ⚠ attendee 3 已签到，跳过成功测试");
            return;
        }

        Integer organizerId = checkinDao.getConferenceOrganizerId(3);
        assertNotNull(organizerId, "attendee 3 应有对应的组织者");

        String result = checkinService.doCheckin(3, organizerId);
        assertEquals("success", result);
        testedAttendeeId = 3;
        System.out.println("  ✅ 签到成功 attendee=3 checkedBy=" + organizerId);

        // 验证签到记录已入库
        Checkin saved = checkinDao.findByAttendeeId(3);
        assertNotNull(saved, "签到后应有记录");
        assertEquals(3, saved.getAttendeeId());
        assertEquals(organizerId, saved.getCheckedBy());
        assertNotNull(saved.getCheckinTime());
        System.out.println("  ✅ 签到时间: " + saved.getCheckinTime());
    }

    // ==================== 签到列表测试 ====================

    @Test
    @Order(5)
    @DisplayName("列表: 有参会者的会议应返回签到列表")
    void testGetCheckinList() {
        // 用 attendee 1 参与的会议
        Integer organizerId = checkinDao.getConferenceOrganizerId(1);
        if (organizerId == null) {
            System.out.println("  ⚠ attendee 1 无会议，跳过");
            return;
        }

        // 通过 organizer_id 找会议
        List<Map<String, Object>> list = checkinService.getCheckinList(1); // conference 1
        assertNotNull(list);
        System.out.println("  ✅ 会议1 签到列表大小: " + list.size());
    }

    @Test
    @Order(6)
    @DisplayName("列表: 不存在参会者的会议应返回空列表")
    void testGetCheckinList_Empty() {
        List<Map<String, Object>> list = checkinService.getCheckinList(99999);
        assertNotNull(list);
        assertTrue(list.isEmpty(), "不存在参会者的会议应返回空列表");
        System.out.println("  ✅ 无效会议 → 空列表");
    }

    // ==================== 签到统计测试 ====================

    @Test
    @Order(7)
    @DisplayName("统计: 有签到记录的会议应返回正确数字")
    void testGetStatistics() {
        Map<String, Integer> stats = checkinService.getStatistics(1);
        assertNotNull(stats);
        assertTrue(stats.containsKey("total"), "应包含 total");
        assertTrue(stats.containsKey("checkedIn"), "应包含 checkedIn");
        assertTrue(stats.containsKey("unchecked"), "应包含 unchecked");

        int total = stats.get("total");
        int checkedIn = stats.get("checkedIn");
        int unchecked = stats.get("unchecked");

        assertEquals(total, checkedIn + unchecked,
            "total(" + total + ") 应 = checkedIn(" + checkedIn + ") + unchecked(" + unchecked + ")");
        System.out.println("  ✅ 会议1 签到统计: total=" + total + " checkedIn=" + checkedIn + " unchecked=" + unchecked);
    }

    @Test
    @Order(8)
    @DisplayName("统计: 不存在参会者的会议统计应为全0")
    void testGetStatistics_Empty() {
        Map<String, Integer> stats = checkinService.getStatistics(99999);
        assertNotNull(stats);
        assertEquals(0, stats.get("total"));
        assertEquals(0, stats.get("checkedIn"));
        assertEquals(0, stats.get("unchecked"));
        System.out.println("  ✅ 无效会议 → total=0 checkedIn=0 unchecked=0");
    }
}
