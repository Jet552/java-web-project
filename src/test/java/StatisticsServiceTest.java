import com.demo.web_project.service.StatisticsService;
import org.junit.jupiter.api.*;

import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

/**
 * 统计模块测试 — 系统统计各项指标非负且合理
 */
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class StatisticsServiceTest {

    private static StatisticsService statisticsService;

    @BeforeAll
    static void setupAll() {
        statisticsService = new StatisticsService();
        System.out.println("===== 统计模块测试 =====");
    }

    @Test
    @Order(1)
    @DisplayName("统计: getStatistics 应返回所有指标")
    void testGetStatistics_AllKeys() {
        Map<String, Object> stats = statisticsService.getStatistics();

        // 所有 key 都应存在
        String[] expectedKeys = {
            "totalConferences", "pendingConferences", "approvedConferences",
            "rejectedConferences", "invalidConferences",
            "totalUsers", "activeUsers", "adminUsers", "bannedUsers",
            "totalAttendees", "paidAttendees",
            "totalPayments", "totalAmount",
            "checkedInCount"
        };

        for (String key : expectedKeys) {
            assertTrue(stats.containsKey(key), "应包含 key: " + key);
            assertNotNull(stats.get(key), key + " 的值不应为 null");
        }
        System.out.println("  ✅ 所有 " + expectedKeys.length + " 个指标都存在");
    }

    @Test
    @Order(2)
    @DisplayName("统计: 所有计数指标应为非负数")
    void testStatistics_NonNegative() {
        Map<String, Object> stats = statisticsService.getStatistics();

        for (Map.Entry<String, Object> entry : stats.entrySet()) {
            Object value = entry.getValue();
            if (value instanceof Integer) {
                assertTrue((Integer) value >= 0,
                    entry.getKey() + " 应为非负数，实际: " + value);
            } else if (value instanceof Double) {
                assertTrue((Double) value >= 0,
                    entry.getKey() + " 应为非负数，实际: " + value);
            }
        }
        System.out.println("  ✅ 所有指标非负");
    }

    @Test
    @Order(3)
    @DisplayName("统计: 各状态会议数之和应等于总数（不含 invalid）")
    void testConferenceCounts_Consistent() {
        Map<String, Object> stats = statisticsService.getStatistics();

        int total = (Integer) stats.get("totalConferences");
        int pending = (Integer) stats.get("pendingConferences");
        int approved = (Integer) stats.get("approvedConferences");
        int rejected = (Integer) stats.get("rejectedConferences");

        assertEquals(total, pending + approved + rejected,
            "totalConferences(" + total + ") 应 = pending(" + pending
            + ") + approved(" + approved + ") + rejected(" + rejected + ")");
        System.out.println("  ✅ 会议状态统计一致: total=" + total);
    }

    @Test
    @Order(4)
    @DisplayName("统计: 活跃+封禁用户数应等于总用户数")
    void testUserCounts_Consistent() {
        Map<String, Object> stats = statisticsService.getStatistics();

        int totalUsers = (Integer) stats.get("totalUsers");
        int activeUsers = (Integer) stats.get("activeUsers");
        int bannedUsers = (Integer) stats.get("bannedUsers");

        assertEquals(totalUsers, activeUsers + bannedUsers,
            "totalUsers(" + totalUsers + ") 应 = active(" + activeUsers
            + ") + banned(" + bannedUsers + ")");
        System.out.println("  ✅ 用户状态统计一致: totalUsers=" + totalUsers);
    }

    @Test
    @Order(5)
    @DisplayName("统计: 管理员用户数应 <= 总用户数")
    void testAdminCount_Reasonable() {
        Map<String, Object> stats = statisticsService.getStatistics();

        int totalUsers = (Integer) stats.get("totalUsers");
        int adminUsers = (Integer) stats.get("adminUsers");

        assertTrue(adminUsers <= totalUsers,
            "管理员数(" + adminUsers + ") 应 <= 总用户数(" + totalUsers + ")");
        System.out.println("  ✅ 管理员数(" + adminUsers + ") <= 总用户数(" + totalUsers + ")");
    }

    @Test
    @Order(6)
    @DisplayName("统计: 已缴费人数应 <= 总参会人数")
    void testPaidAttendees_Reasonable() {
        Map<String, Object> stats = statisticsService.getStatistics();

        int totalAttendees = (Integer) stats.get("totalAttendees");
        int paidAttendees = (Integer) stats.get("paidAttendees");

        assertTrue(paidAttendees <= totalAttendees,
            "已缴费人数(" + paidAttendees + ") 应 <= 总参会人数(" + totalAttendees + ")");
        System.out.println("  ✅ 已缴费(" + paidAttendees + ") <= 总参会(" + totalAttendees + ")");
    }

    @Test
    @Order(7)
    @DisplayName("统计: individual 查询方法应与 getStatistics 一致")
    void testIndividualMethods_Consistent() {
        Map<String, Object> stats = statisticsService.getStatistics();

        assertEquals(stats.get("totalConferences"), statisticsService.getTotalConferences());
        assertEquals(stats.get("pendingConferences"), statisticsService.getPendingConferences());
        assertEquals(stats.get("approvedConferences"), statisticsService.getApprovedConferences());
        assertEquals(stats.get("rejectedConferences"), statisticsService.getRejectedConferences());
        assertEquals(stats.get("totalUsers"), statisticsService.getTotalUsers());
        assertEquals(stats.get("activeUsers"), statisticsService.getActiveUsers());
        assertEquals(stats.get("adminUsers"), statisticsService.getAdminUsers());
        assertEquals(stats.get("bannedUsers"), statisticsService.getBannedUsers());
        assertEquals(stats.get("checkedInCount"), statisticsService.getCheckedInCount());

        System.out.println("  ✅ 所有 individual 方法与 getStatistics 一致");
    }
}
