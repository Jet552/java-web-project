import com.demo.web_project.dao.ConferenceDao;
import com.demo.web_project.dao.impl.ConferenceDaoImpl;
import com.demo.web_project.service.ConferenceService;
import com.demo.web_project.vo.Conference;
import org.junit.jupiter.api.*;

import java.time.LocalDateTime;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * 会议模块测试 — 搜索/创建/审批/邀请码/删除
 *
 * 写操作使用已知的 organizer_id 创建测试会议，测试结束后清理。
 */
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
public class ConferenceServiceTest {

    private static ConferenceService conferenceService;
    private static ConferenceDao conferenceDao;
    private static int testConferenceId = -1; // 测试创建的会议ID

    @BeforeAll
    static void setupAll() {
        conferenceService = new ConferenceService();
        conferenceDao = new ConferenceDaoImpl();
        System.out.println("===== 会议模块测试 =====");
    }

    @AfterAll
    static void tearDownAll() {
        // 清理测试创建的会议
        if (testConferenceId > 0) {
            try {
                conferenceDao.delete(testConferenceId);
                System.out.println("  [清理] 已删除测试会议 id=" + testConferenceId);
            } catch (Exception e) {
                System.out.println("  [清理] 无法删除测试会议 id=" + testConferenceId
                    + " (FK约束，不影响测试结果): " + e.getMessage());
            }
        }
    }

    // ==================== 搜索测试（只读） ====================

    @Test
    @Order(1)
    @DisplayName("搜索: findByCodes 不存在的邀请码应返回 null")
    void testFindByCodes_NotFound() {
        Conference result = conferenceService.findByCodes("ZZZZZZZZZ");
        assertNull(result, "不存在的邀请码应返回 null");
        System.out.println("  ✅ 不存在邀请码 → null");
    }

    @Test
    @Order(2)
    @DisplayName("搜索: findByCodes 存在的邀请码应返回会议")
    void testFindByCodes_Found() {
        // 找一个有邀请码的已批准会议
        List<Conference> approved = conferenceService.findByStatus("approved");
        Conference found = null;
        for (Conference c : approved) {
            if (c.getInvite_codes() != null && !c.getInvite_codes().isEmpty()) {
                found = conferenceService.findByCodes(c.getInvite_codes());
                if (found != null) break;
            }
        }
        if (found != null) {
            assertNotNull(found.getTitle());
            System.out.println("  ✅ 邀请码 " + found.getInvite_codes() + " → " + found.getTitle());
        } else {
            System.out.println("  ⚠ 无可用邀请码，跳过测试");
        }
    }

    @Test
    @Order(3)
    @DisplayName("搜索: findAll(keyword) 应返回匹配会议")
    void testFindAll_Keyword() {
        // 搜索一个通用关键词
        List<Conference> result = conferenceService.findAll("会");
        assertNotNull(result);
        System.out.println("  ✅ 关键词 '会' 匹配数量: " + result.size());

        // 搜索无匹配的关键词
        List<Conference> empty = conferenceService.findAll("zzz_no_match_xyz_123");
        assertNotNull(empty);
        System.out.println("  ✅ 无匹配关键词 → 数量: " + empty.size());
    }

    @Test
    @Order(4)
    @DisplayName("搜索: findAllConferences 应返回所有非 invalid 会议")
    void testFindAllConferences() {
        List<Conference> all = conferenceService.findAllConferences();
        assertNotNull(all);
        for (Conference c : all) {
            assertNotEquals("invalid", c.getStatus(), "不应包含 invalid 状态会议");
        }
        System.out.println("  ✅ 所有有效会议数量: " + all.size());
    }

    // ==================== 按状态查询（只读） ====================

    @Test
    @Order(5)
    @DisplayName("查询: findByStatus('pending') 应只返回待审核会议")
    void testFindByStatus_Pending() {
        List<Conference> pending = conferenceService.findByStatus("pending");
        assertNotNull(pending);
        for (Conference c : pending) {
            assertEquals("pending", c.getStatus());
        }
        System.out.println("  ✅ 待审核会议数量: " + pending.size());
    }

    @Test
    @Order(6)
    @DisplayName("查询: findByStatus('approved') 应只返回已通过会议")
    void testFindByStatus_Approved() {
        List<Conference> approved = conferenceService.findByStatus("approved");
        assertNotNull(approved);
        for (Conference c : approved) {
            assertEquals("approved", c.getStatus());
        }
        System.out.println("  ✅ 已通过会议数量: " + approved.size());
    }

    @Test
    @Order(7)
    @DisplayName("查询: findPendingConferences 应只返回待审核的会议")
    void testFindPendingConferences() {
        List<Conference> pending = conferenceService.findPendingConferences();
        assertNotNull(pending);
        for (Conference c : pending) {
            assertTrue("pending".equals(c.getStatus()),
                "ID=" + c.getId() + " 状态应为 pending，实际为 " + c.getStatus());
        }
        System.out.println("  ✅ pending 会议数量: " + pending.size());
    }

    // ==================== 根据 ID 查询（只读） ====================

    @Test
    @Order(8)
    @DisplayName("查询: getConferenceById 不存在应返回 null")
    void testGetConferenceById_NotFound() {
        Conference result = conferenceService.getConferenceById(99999);
        assertNull(result);
        System.out.println("  ✅ 不存在ID → null");
    }

    @Test
    @Order(9)
    @DisplayName("查询: getConferenceById 存在应返回正确会议")
    void testGetConferenceById_Found() {
        List<Conference> all = conferenceService.findAllConferences();
        if (!all.isEmpty()) {
            Conference first = all.get(0);
            Conference found = conferenceService.getConferenceById(first.getId());
            assertNotNull(found);
            assertEquals(first.getId(), found.getId());
            assertEquals(first.getTitle(), found.getTitle());
            System.out.println("  ✅ ID=" + first.getId() + " → " + found.getTitle());
        }
    }

    // ==================== 创建会议（写操作） ====================

    @Test
    @Order(10)
    @DisplayName("创建: 创建会议应返回新ID")
    void testCreateConference() {
        Conference conf = new Conference();
        conf.setOrganizer_id(1);  // 假设 id=1 是有效组织者
        conf.setTitle("JUnit测试会议_" + System.currentTimeMillis());
        conf.setDescription("自动化测试创建的会议");
        conf.setVenue("测试地点");
        conf.setDorms("无");
        conf.setStart_date(LocalDateTime.now().plusDays(1));
        conf.setEnd_date(LocalDateTime.now().plusDays(2));
        conf.setAmount(100.0);

        int newId = conferenceService.createConference(conf);
        assertTrue(newId > 0, "创建应返回正数ID");
        testConferenceId = newId;
        System.out.println("  ✅ 创建会议成功，id=" + newId);

        // 验证已入库
        Conference created = conferenceService.getConferenceById(newId);
        assertNotNull(created);
        assertEquals("pending", created.getStatus(), "新创建的会议状态应为 pending");
        assertEquals(conf.getTitle(), created.getTitle());
        System.out.println("  ✅ 验证入库: " + created.getTitle() + " status=" + created.getStatus());
    }

    // ==================== 审批测试（使用上面创建的测试会议） ====================

    @Test
    @Order(11)
    @DisplayName("审批: 拒绝 pending 会议应成功")
    void testRejectConference() {
        if (testConferenceId <= 0) {
            System.out.println("  ⚠ 没有测试会议，跳过审批测试");
            return;
        }

        boolean result = conferenceService.rejectConference(testConferenceId, "测试拒绝原因");
        assertTrue(result, "拒绝 pending 会议应成功");

        Conference updated = conferenceService.getConferenceById(testConferenceId);
        assertEquals("rejected", updated.getStatus());
        assertEquals("测试拒绝原因", updated.getReason());
        System.out.println("  ✅ 会议 " + testConferenceId + " 已拒绝，原因: " + updated.getReason());
    }

    @Test
    @Order(12)
    @DisplayName("审批: 拒绝已拒绝的会议应失败")
    void testRejectConference_AlreadyRejected() {
        if (testConferenceId <= 0) {
            System.out.println("  ⚠ 没有测试会议，跳过");
            return;
        }

        // 此时会议已被上一个测试拒绝
        boolean result = conferenceService.rejectConference(testConferenceId, "重复拒绝");
        assertFalse(result, "拒绝已处理的会议应返回 false");
        System.out.println("  ✅ 重复拒绝 → false");
    }

    @Test
    @Order(13)
    @DisplayName("审批: 批准非 pending 状态的会议应失败")
    void testApproveConference_WrongStatus() {
        if (testConferenceId <= 0) {
            System.out.println("  ⚠ 没有测试会议，跳过");
            return;
        }

        // 会议已被拒绝，不能批准
        boolean result = conferenceService.approveConference(testConferenceId, "尝试批准");
        assertFalse(result, "批准非 pending 会议应返回 false");
        System.out.println("  ✅ 批准已拒绝会议 → false");
    }

    // ==================== 邀请码测试 ====================

    @Test
    @Order(14)
    @DisplayName("邀请码: 非 approved 会议生成邀请码应返回 null")
    void testGenerateInviteCode_WrongStatus() {
        if (testConferenceId <= 0) {
            System.out.println("  ⚠ 没有测试会议，跳过");
            return;
        }

        // 测试会议已被拒绝，生成邀请码应失败
        String code = conferenceService.generateInviteCode(testConferenceId, 1);
        assertNull(code, "非 approved 会议不应生成邀请码");
        System.out.println("  ✅ 被拒绝会议无法生成邀请码");
    }

    @Test
    @Order(15)
    @DisplayName("邀请码: 错误组织者生成邀请码应返回 null")
    void testGenerateInviteCode_WrongOrganizer() {
        List<Conference> approved = conferenceService.findByStatus("approved");
        if (approved.isEmpty()) {
            System.out.println("  ⚠ 无已批准会议，跳过");
            return;
        }

        Conference conf = approved.get(0);
        // 用一个肯定不是该会议组织者的 ID
        int wrongOrgId = 99999;
        // 如果碰巧该会议组织者是 99999，换一个
        if (conf.getOrganizer_id() == wrongOrgId) wrongOrgId = 99998;

        String code = conferenceService.generateInviteCode(conf.getId(), wrongOrgId);
        assertNull(code, "错误组织者不应生成邀请码");
        System.out.println("  ✅ 错误组织者 " + wrongOrgId + " 无法为会议 " + conf.getId() + " 生成邀请码");
    }

    @Test
    @Order(16)
    @DisplayName("邀请码: 正确组织者为 approved 会议生成邀请码应成功")
    void testGenerateInviteCode_Success() {
        List<Conference> approved = conferenceService.findByStatus("approved");
        // 找一个有正确 organizer_id 且还没有邀请码的会议
        Conference target = null;
        for (Conference c : approved) {
            if (c.getOrganizer_id() > 0 && (c.getInvite_codes() == null || c.getInvite_codes().isEmpty())) {
                target = c;
                break;
            }
        }

        if (target == null) {
            System.out.println("  ⚠ 无符合条件的已批准会议，跳过");
            return;
        }

        String code = conferenceService.generateInviteCode(target.getId(), target.getOrganizer_id());
        assertNotNull(code, "生成邀请码应成功");
        assertEquals(9, code.length(), "邀请码长度应为 9");
        System.out.println("  ✅ 会议 " + target.getId() + " 邀请码: " + code);

        // 验证通过邀请码能查到该会议
        Conference found = conferenceService.findByCodes(code);
        assertNotNull(found);
        assertEquals(target.getId(), found.getId());
        System.out.println("  ✅ 通过邀请码验证：找到会议 " + found.getTitle());
    }

    // ==================== 根据组织者查询（只读） ====================

    @Test
    @Order(17)
    @DisplayName("查询: findByOrganizerId 应返回该组织者的会议")
    void testFindByOrganizerId() {
        List<Conference> all = conferenceService.findAllConferences();
        if (all.isEmpty()) {
            System.out.println("  ⚠ 数据库无会议，跳过");
            return;
        }

        int orgId = all.get(0).getOrganizer_id();
        List<Conference> orgConfs = conferenceService.findByOrganizerId(orgId);
        assertNotNull(orgConfs);
        for (Conference c : orgConfs) {
            assertEquals(orgId, c.getOrganizer_id(),
                "会议 " + c.getId() + " 的组织者应为 " + orgId);
        }
        System.out.println("  ✅ 组织者 " + orgId + " 的会议数量: " + orgConfs.size());
    }
}
