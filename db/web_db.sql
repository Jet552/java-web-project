/*
 Navicat Premium Dump SQL

 Source Server         : 123
 Source Server Type    : MySQL
 Source Server Version : 80023 (8.0.23)
 Source Host           : localhost:3306
 Source Schema         : web_db

 Target Server Type    : MySQL
 Target Server Version : 80023 (8.0.23)
 File Encoding         : 65001

 Date: 26/05/2026 21:15:18
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for accommodations
-- ----------------------------
DROP TABLE IF EXISTS `accommodations`;
CREATE TABLE `accommodations`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `attendee_id` int NOT NULL,
  `room_number` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `checkin_date` date NOT NULL,
  `checkout_date` date NOT NULL,
  `status` tinyint NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_attendee`(`attendee_id` ASC) USING BTREE,
  CONSTRAINT `accommodations_ibfk_1` FOREIGN KEY (`attendee_id`) REFERENCES `attendees` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `accommodations_chk_1` CHECK (`status` in (0,1))
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of accommodations
-- ----------------------------
INSERT INTO `accommodations` VALUES (2, 1, '908', '2026-06-09', '2026-06-12', 1);
INSERT INTO `accommodations` VALUES (3, 2, '605B', '2026-07-05', '2026-07-07', 1);
INSERT INTO `accommodations` VALUES (4, 8, '1012', '2026-03-05', '2026-03-06', 0);

-- ----------------------------
-- Table structure for attendees
-- ----------------------------
DROP TABLE IF EXISTS `attendees`;
CREATE TABLE `attendees`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `conference_id` int NOT NULL,
  `arrival_time` datetime NOT NULL,
  `departure_time` datetime NOT NULL,
  `accommodation_type` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `requirements` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_user_conference`(`user_id` ASC, `conference_id` ASC) USING BTREE,
  INDEX `idx_user`(`user_id` ASC) USING BTREE,
  INDEX `idx_conference`(`conference_id` ASC) USING BTREE,
  CONSTRAINT `attendees_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `attendees_ibfk_2` FOREIGN KEY (`conference_id`) REFERENCES `conferences` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `attendees_chk_1` CHECK (`status` in (0,1))
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of attendees
-- ----------------------------
INSERT INTO `attendees` VALUES (1, 78, 1, '2026-06-09 14:30:00', '2026-06-12 20:00:00', '单人间', '需要清真餐', 1);
INSERT INTO `attendees` VALUES (2, 32, 2, '2026-07-05 08:00:00', '2026-07-07 22:00:00', '双人间', '无特殊要求', 1);
INSERT INTO `attendees` VALUES (3, 91, 3, '2026-08-15 07:15:00', '2026-08-17 18:00:00', '单人间', '需要无障碍设施', 1);
INSERT INTO `attendees` VALUES (4, 14, 4, '2026-09-01 12:00:00', '2026-09-03 21:30:00', '不需住宿', '需要素食餐', 1);
INSERT INTO `attendees` VALUES (5, 67, 5, '2026-10-22 09:00:00', '2026-10-24 16:00:00', '单人间', '无特殊要求', 1);
INSERT INTO `attendees` VALUES (6, 5, 6, '2025-11-12 10:00:00', '2025-11-14 17:00:00', '双人间', '需要加床', 1);
INSERT INTO `attendees` VALUES (7, 89, 7, '2026-03-05 13:00:00', '2026-03-06 19:00:00', '单人间', '无特殊要求', 1);
INSERT INTO `attendees` VALUES (8, 22, 8, '2026-04-18 08:00:00', '2026-04-20 16:00:00', '不需住宿', '需要会议资料电子版', 1);
INSERT INTO `attendees` VALUES (9, 45, 9, '2026-05-10 09:30:00', '2026-05-12 15:00:00', '单人间', '因航班取消无法参会', 0);
INSERT INTO `attendees` VALUES (10, 100, 10, '2026-05-25 10:00:00', '2026-05-26 11:30:00', '双人间', '临时有紧急会议', 0);

-- ----------------------------
-- Table structure for checkins
-- ----------------------------
DROP TABLE IF EXISTS `checkins`;
CREATE TABLE `checkins`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `attendee_id` int NOT NULL,
  `checkin_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `checked_by` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_attendee`(`attendee_id` ASC) USING BTREE,
  INDEX `checked_by`(`checked_by` ASC) USING BTREE,
  CONSTRAINT `checkins_ibfk_1` FOREIGN KEY (`attendee_id`) REFERENCES `attendees` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `checkins_ibfk_2` FOREIGN KEY (`checked_by`) REFERENCES `conferences` (`organizer_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of checkins
-- ----------------------------
INSERT INTO `checkins` VALUES (4, 1, '2026-06-09 09:15:00', 24);
INSERT INTO `checkins` VALUES (5, 2, '2026-07-05 08:30:00', 8);
INSERT INTO `checkins` VALUES (6, 8, '2026-03-05 13:45:00', 2);

-- ----------------------------
-- Table structure for conferences
-- ----------------------------
DROP TABLE IF EXISTS `conferences`;
CREATE TABLE `conferences`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `organizer_id` int NOT NULL,
  `title` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `description` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `venue` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `dorms` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `invite_codes` char(9) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `status` enum('pending','approved','rejected','invalid') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'pending',
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `reason` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '管理员审核理由',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `invite_codes`(`invite_codes` ASC) USING BTREE,
  INDEX `idx_organizer`(`organizer_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  CONSTRAINT `conferences_ibfk_1` FOREIGN KEY (`organizer_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of conferences
-- ----------------------------
INSERT INTO `conferences` VALUES (1, 24, '全球人工智能峰会', '探讨AI前沿技术与产业应用', '上海国际会议中心', '浦东香格里拉大酒店', '7aB9cD2eF', '2026-06-10 09:00:00', '2026-06-12 18:00:00', 'approved', '2026-05-26 18:56:07', NULL);
INSERT INTO `conferences` VALUES (2, 8, '区块链开发者大会', 'Web3.0生态与智能合约实战', '深圳会展中心', '深圳湾万怡酒店', NULL, '2026-07-05 10:30:00', '2026-07-07 17:30:00', 'pending', '2026-05-26 18:56:07', NULL);
INSERT INTO `conferences` VALUES (3, 37, '量子计算国际论坛', '量子算法与硬件突破研讨会', '北京国家会议中心', '中关村皇冠假日酒店', NULL, '2026-08-15 08:45:00', '2026-08-17 16:00:00', 'rejected', '2026-05-26 18:56:07', NULL);
INSERT INTO `conferences` VALUES (4, 15, '2026数字医疗峰会', 'AI在精准医疗中的应用案例', '杭州国际博览中心', '钱江新城万豪酒店', 'S9tU0vW1x', '2026-09-01 13:20:00', '2026-09-03 19:00:00', 'approved', '2026-05-26 18:56:07', NULL);
INSERT INTO `conferences` VALUES (5, 42, '绿色能源技术展', '光伏与储能系统创新方案', '广州琶洲会展中心', '南丰朗豪酒店', 'Y2zA3bC4d', '2026-10-22 09:15:00', '2026-10-24 14:45:00', 'pending', '2026-05-26 18:56:07', NULL);
INSERT INTO `conferences` VALUES (6, 5, '2025金融科技峰会', '数字货币监管与跨境支付', '上海世博中心', '浦东丽思卡尔顿酒店', NULL, '2025-11-12 09:00:00', '2025-11-14 17:30:00', 'invalid', '2026-05-26 18:56:07', NULL);
INSERT INTO `conferences` VALUES (7, 19, '物联网安全研讨会', '工业物联网防护实战', '深圳南山科技园', '深圳科兴科学园亚朵酒店', NULL, '2026-03-05 14:00:00', '2026-03-06 18:00:00', 'invalid', '2026-05-26 18:56:07', NULL);
INSERT INTO `conferences` VALUES (8, 33, '5G+工业互联网大会', '智能制造与边缘计算', '北京亦创国际会展中心', '大兴机场木棉花酒店', NULL, '2026-04-18 08:30:00', '2026-04-20 16:45:00', 'invalid', '2026-05-26 18:56:07', NULL);
INSERT INTO `conferences` VALUES (9, 2, '元宇宙开发者大会', '虚拟现实与数字孪生技术', '杭州未来科技城', '西溪喜来登度假酒店', NULL, '2026-05-10 10:00:00', '2026-05-12 15:30:00', 'invalid', '2026-05-26 18:56:07', NULL);
INSERT INTO `conferences` VALUES (10, 47, '2026网络安全峰会', '零信任架构与攻防演练', '广州白云国际会议中心', '四季酒店珠江新城店', NULL, '2026-05-25 09:20:00', '2026-05-26 12:00:00', 'invalid', '2026-05-26 18:56:07', NULL);

-- ----------------------------
-- Table structure for payments
-- ----------------------------
DROP TABLE IF EXISTS `payments`;
CREATE TABLE `payments`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `attendee_id` int NOT NULL,
  `amount` decimal(10, 2) NOT NULL,
  `status` enum('unpaid','paid') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `paid_at` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_attendee`(`attendee_id` ASC) USING BTREE,
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`attendee_id`) REFERENCES `attendees` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of payments
-- ----------------------------
INSERT INTO `payments` VALUES (1, 1, 285.50, 'paid', '2026-05-20 14:30:00');
INSERT INTO `payments` VALUES (2, 2, 260.00, 'paid', '2026-05-18 09:15:00');
INSERT INTO `payments` VALUES (3, 3, 299.99, 'paid', '2026-05-22 11:20:00');
INSERT INTO `payments` VALUES (4, 6, 245.00, 'paid', '2025-11-10 16:45:00');
INSERT INTO `payments` VALUES (5, 7, 198.50, 'unpaid', '0001-01-01 00:00:00');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `password` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `phone` char(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `email` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` smallint NOT NULL DEFAULT 1,
  `role` smallint NOT NULL DEFAULT 0 COMMENT '0=普通用户, 1=系统管理员',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_username`(`username` ASC) USING BTREE,
  UNIQUE INDEX `phone`(`phone` ASC) USING BTREE,
  UNIQUE INDEX `email`(`email` ASC) USING BTREE,
  CONSTRAINT `chk_phone_email` CHECK ((`phone` is not null) or (`email` is not null)),
  CONSTRAINT `chk_role` CHECK (`role` in (0,1)),
  CONSTRAINT `chk_status` CHECK (`status` in (1,0))
) ENGINE = InnoDB AUTO_INCREMENT = 104 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, 'zhangwei', 'zhangwei123', '13801011001', 'zhangwei@qq.com', '2024-03-15 08:20:30', 1, 0);
INSERT INTO `users` VALUES (2, 'zhangjing', 'zhangjing123', '13901011002', 'zhangjing@163.com', '2024-06-22 14:35:12', 1, 0);
INSERT INTO `users` VALUES (3, 'zhanglei', 'zhanglei123', '15001011003', 'zhanglei@126.com', '2024-09-10 10:05:45', 0, 0);
INSERT INTO `users` VALUES (4, 'zhangfang', 'zhangfang123', '15101011004', 'zhangfang@gmail.com', '2024-11-05 18:40:20', 1, 0);
INSERT INTO `users` VALUES (5, 'zhangqiang', 'zhangqiang123', '18601011005', 'zhangqiang@sina.com', '2025-01-18 07:10:55', 1, 0);
INSERT INTO `users` VALUES (6, 'zhangna', 'zhangna123', '13501011006', 'zhangna@outlook.com', '2025-04-25 16:25:33', 0, 0);
INSERT INTO `users` VALUES (7, 'zhangming', 'zhangming123', '15801011007', 'zhangming@qq.com', '2025-07-30 21:50:08', 1, 0);
INSERT INTO `users` VALUES (8, 'zhanghua', 'zhanghua123', '15901011008', 'zhanghua@163.com', '2025-10-12 11:15:27', 1, 0);
INSERT INTO `users` VALUES (9, 'zhangjun', 'zhangjun123', '18801011009', 'zhangjun@126.com', '2026-01-08 22:45:50', 1, 0);
INSERT INTO `users` VALUES (10, 'zhangxia', 'zhangxia123', '13801011010', 'zhangxia@gmail.com', '2026-04-20 05:30:15', 0, 0);
INSERT INTO `users` VALUES (11, 'liwei', 'liwei123', '13901011011', 'liwei@sina.com', '2024-03-15 08:20:30', 1, 0);
INSERT INTO `users` VALUES (12, 'lijing', 'lijing123', '15001011012', 'lijing@outlook.com', '2024-06-22 14:35:12', 1, 0);
INSERT INTO `users` VALUES (13, 'lilei', 'lilei123', '15101011013', 'lilei@qq.com', '2024-09-10 10:05:45', 0, 0);
INSERT INTO `users` VALUES (14, 'lifang', 'lifang123', '18601011014', 'lifang@163.com', '2024-11-05 18:40:20', 1, 0);
INSERT INTO `users` VALUES (15, 'liqiang', 'liqiang123', '13501011015', 'liqiang@126.com', '2025-01-18 07:10:55', 1, 0);
INSERT INTO `users` VALUES (16, 'lina', 'lina123', '15801011016', 'lina@gmail.com', '2025-04-25 16:25:33', 1, 0);
INSERT INTO `users` VALUES (17, 'liming', 'liming123', '15901011017', 'liming@sina.com', '2025-07-30 21:50:08', 0, 0);
INSERT INTO `users` VALUES (18, 'lihua', 'lihua123', '18801011018', 'lihua@outlook.com', '2025-10-12 11:15:27', 1, 0);
INSERT INTO `users` VALUES (19, 'lijun', 'lijun123', '13801011019', 'lijun@qq.com', '2026-01-08 22:45:50', 1, 0);
INSERT INTO `users` VALUES (20, 'lixia', 'lixia123', '13901011020', 'lixia@163.com', '2026-04-20 05:30:15', 1, 0);
INSERT INTO `users` VALUES (21, 'wangwei', 'wangwei123', '15001011021', 'wangwei@126.com', '2024-03-15 08:20:30', 0, 0);
INSERT INTO `users` VALUES (22, 'wangjing', 'wangjing123', '15101011022', 'wangjing@gmail.com', '2024-06-22 14:35:12', 1, 0);
INSERT INTO `users` VALUES (23, 'wanglei', 'wanglei123', '18601011023', 'wanglei@sina.com', '2024-09-10 10:05:45', 1, 0);
INSERT INTO `users` VALUES (24, 'wangfang', 'wangfang123', '13501011024', 'wangfang@outlook.com', '2024-11-05 18:40:20', 0, 0);
INSERT INTO `users` VALUES (25, 'wangqiang', 'wangqiang123', '15801011025', 'wangqiang@qq.com', '2025-01-18 07:10:55', 1, 0);
INSERT INTO `users` VALUES (26, 'wangna', 'wangna123', '15901011026', 'wangna@163.com', '2025-04-25 16:25:33', 1, 0);
INSERT INTO `users` VALUES (27, 'wangming', 'wangming123', '18801011027', 'wangming@126.com', '2025-07-30 21:50:08', 1, 0);
INSERT INTO `users` VALUES (28, 'wanghua', 'wanghua123', '13801011028', 'wanghua@gmail.com', '2025-10-12 11:15:27', 0, 0);
INSERT INTO `users` VALUES (29, 'wangjun', 'wangjun123', '13901011029', 'wangjun@sina.com', '2026-01-08 22:45:50', 1, 0);
INSERT INTO `users` VALUES (30, 'wangxia', 'wangxia123', '15001011030', 'wangxia@outlook.com', '2026-04-20 05:30:15', 1, 0);
INSERT INTO `users` VALUES (31, 'zhaowei', 'zhaowei123', '15101011031', 'zhaowei@qq.com', '2024-03-15 08:20:30', 0, 0);
INSERT INTO `users` VALUES (32, 'zhaojing', 'zhaojing123', '18601011032', 'zhaojing@163.com', '2024-06-22 14:35:12', 1, 0);
INSERT INTO `users` VALUES (33, 'zhaolei', 'zhaolei123', '13501011033', 'zhaolei@126.com', '2024-09-10 10:05:45', 1, 0);
INSERT INTO `users` VALUES (34, 'zhaofang', 'zhaofang123', '15801011034', 'zhaofang@gmail.com', '2024-11-05 18:40:20', 1, 0);
INSERT INTO `users` VALUES (35, 'zhaoqiang', 'zhaoqiang123', '15901011035', 'zhaoqiang@sina.com', '2025-01-18 07:10:55', 0, 0);
INSERT INTO `users` VALUES (36, 'zhaona', 'zhaona123', '18801011036', 'zhaona@outlook.com', '2025-04-25 16:25:33', 1, 0);
INSERT INTO `users` VALUES (37, 'zhaoming', 'zhaoming123', '13801011037', 'zhaoming@qq.com', '2025-07-30 21:50:08', 1, 0);
INSERT INTO `users` VALUES (38, 'zhaohua', 'zhaohua123', '13901011038', 'zhaohua@163.com', '2025-10-12 11:15:27', 0, 0);
INSERT INTO `users` VALUES (39, 'zhaojun', 'zhaojun123', '15001011039', 'zhaojun@126.com', '2026-01-08 22:45:50', 1, 0);
INSERT INTO `users` VALUES (40, 'zhaoxia', 'zhaoxia123', '15101011040', 'zhaoxia@gmail.com', '2026-04-20 05:30:15', 1, 0);
INSERT INTO `users` VALUES (41, 'chenwei', 'chenwei123', '18601011041', 'chenwei@sina.com', '2024-03-15 08:20:30', 1, 0);
INSERT INTO `users` VALUES (42, 'chenjing', 'chenjing123', '13501011042', 'chenjing@outlook.com', '2024-06-22 14:35:12', 0, 0);
INSERT INTO `users` VALUES (43, 'chenlei', 'chenlei123', '15801011043', 'chenlei@qq.com', '2024-09-10 10:05:45', 1, 0);
INSERT INTO `users` VALUES (44, 'chenfang', 'chenfang123', '15901011044', 'chenfang@163.com', '2024-11-05 18:40:20', 1, 0);
INSERT INTO `users` VALUES (45, 'chenqiang', 'chenqiang123', '18801011045', 'chenqiang@126.com', '2025-01-18 07:10:55', 0, 0);
INSERT INTO `users` VALUES (46, 'chenna', 'chenna123', '13801011046', 'chenna@gmail.com', '2025-04-25 16:25:33', 1, 0);
INSERT INTO `users` VALUES (47, 'chenming', 'chenming123', '13901011047', 'chenming@sina.com', '2025-07-30 21:50:08', 1, 0);
INSERT INTO `users` VALUES (48, 'chenhua', 'chenhua123', '15001011048', 'chenhua@outlook.com', '2025-10-12 11:15:27', 1, 0);
INSERT INTO `users` VALUES (49, 'chenjun', 'chenjun123', '15101011049', 'chenjun@qq.com', '2026-01-08 22:45:50', 0, 0);
INSERT INTO `users` VALUES (50, 'chenxia', 'chenxia123', '18601011050', 'chenxia@163.com', '2026-04-20 05:30:15', 1, 0);
INSERT INTO `users` VALUES (51, 'liuwei', 'liuwei123', '13501011051', 'liuwei@126.com', '2024-03-15 08:20:30', 1, 0);
INSERT INTO `users` VALUES (52, 'liujing', 'liujing123', '15801011052', 'liujing@gmail.com', '2024-06-22 14:35:12', 1, 0);
INSERT INTO `users` VALUES (53, 'liulei', 'liulei123', '15901011053', 'liulei@sina.com', '2024-09-10 10:05:45', 0, 0);
INSERT INTO `users` VALUES (54, 'liufang', 'liufang123', '18801011054', 'liufang@outlook.com', '2024-11-05 18:40:20', 1, 0);
INSERT INTO `users` VALUES (55, 'liuqiang', 'liuqiang123', '13801011055', 'liuqiang@qq.com', '2025-01-18 07:10:55', 1, 0);
INSERT INTO `users` VALUES (56, 'liuna', 'liuna123', '13901011056', 'liuna@163.com', '2025-04-25 16:25:33', 0, 0);
INSERT INTO `users` VALUES (57, 'liuming', 'liuming123', '15001011057', 'liuming@126.com', '2025-07-30 21:50:08', 1, 0);
INSERT INTO `users` VALUES (58, 'liuhua', 'liuhua123', '15101011058', 'liuhua@gmail.com', '2025-10-12 11:15:27', 1, 0);
INSERT INTO `users` VALUES (59, 'liujun', 'liujun123', '18601011059', 'liujun@sina.com', '2026-01-08 22:45:50', 1, 0);
INSERT INTO `users` VALUES (60, 'liuxia', 'liuxia123', '13501011060', 'liuxia@outlook.com', '2026-04-20 05:30:15', 0, 0);
INSERT INTO `users` VALUES (61, 'yangwei', 'yangwei123', '15801011061', 'yangwei@qq.com', '2024-03-15 08:20:30', 1, 0);
INSERT INTO `users` VALUES (62, 'yangjing', 'yangjing123', '15901011062', 'yangjing@163.com', '2024-06-22 14:35:12', 1, 0);
INSERT INTO `users` VALUES (63, 'yanglei', 'yanglei123', '18801011063', 'yanglei@126.com', '2024-09-10 10:05:45', 1, 0);
INSERT INTO `users` VALUES (64, 'yangfang', 'yangfang123', '13801011064', 'yangfang@gmail.com', '2024-11-05 18:40:20', 0, 0);
INSERT INTO `users` VALUES (65, 'yangqiang', 'yangqiang123', '13901011065', 'yangqiang@sina.com', '2025-01-18 07:10:55', 1, 0);
INSERT INTO `users` VALUES (66, 'yangna', 'yangna123', '15001011066', 'yangna@outlook.com', '2025-04-25 16:25:33', 1, 0);
INSERT INTO `users` VALUES (67, 'yangming', 'yangming123', '15101011067', 'yangming@qq.com', '2025-07-30 21:50:08', 1, 0);
INSERT INTO `users` VALUES (68, 'yanghua', 'yanghua123', '18601011068', 'yanghua@163.com', '2025-10-12 11:15:27', 0, 0);
INSERT INTO `users` VALUES (69, 'yangjun', 'yangjun123', '13501011069', 'yangjun@126.com', '2026-01-08 22:45:50', 1, 0);
INSERT INTO `users` VALUES (70, 'yangxia', 'yangxia123', '15801011070', 'yangxia@gmail.com', '2026-04-20 05:30:15', 1, 0);
INSERT INTO `users` VALUES (71, 'huangwei', 'huangwei123', '15901011071', 'huangwei@sina.com', '2024-03-15 08:20:30', 1, 0);
INSERT INTO `users` VALUES (72, 'huangjing', 'huangjing123', '18801011072', 'huangjing@outlook.com', '2024-06-22 14:35:12', 0, 0);
INSERT INTO `users` VALUES (73, 'huanglei', 'huanglei123', '13801011073', 'huanglei@qq.com', '2024-09-10 10:05:45', 1, 0);
INSERT INTO `users` VALUES (74, 'huangfang', 'huangfang123', '13901011074', 'huangfang@163.com', '2024-11-05 18:40:20', 1, 0);
INSERT INTO `users` VALUES (75, 'huangqiang', 'huangqiang123', '15001011075', 'huangqiang@126.com', '2025-01-18 07:10:55', 0, 0);
INSERT INTO `users` VALUES (76, 'huangna', 'huangna123', '15101011076', 'huangna@gmail.com', '2025-04-25 16:25:33', 1, 0);
INSERT INTO `users` VALUES (77, 'huangming', 'huangming123', '18601011077', 'huangming@sina.com', '2025-07-30 21:50:08', 1, 0);
INSERT INTO `users` VALUES (78, 'huanghua', 'huanghua123', '13501011078', 'huanghua@outlook.com', '2025-10-12 11:15:27', 1, 0);
INSERT INTO `users` VALUES (79, 'huangjun', 'huangjun123', '15801011079', 'huangjun@qq.com', '2026-01-08 22:45:50', 0, 0);
INSERT INTO `users` VALUES (80, 'huangxia', 'huangxia123', '15901011080', 'huangxia@163.com', '2026-04-20 05:30:15', 1, 0);
INSERT INTO `users` VALUES (81, 'wuwei', 'wuwei123', '18801011081', 'wuwei@126.com', '2024-03-15 08:20:30', 1, 0);
INSERT INTO `users` VALUES (82, 'wujing', 'wujing123', '13801011082', 'wujing@gmail.com', '2024-06-22 14:35:12', 0, 0);
INSERT INTO `users` VALUES (83, 'wulei', 'wulei123', '13901011083', 'wulei@sina.com', '2024-09-10 10:05:45', 1, 0);
INSERT INTO `users` VALUES (84, 'wufang', 'wufang123', '15001011084', 'wufang@outlook.com', '2024-11-05 18:40:20', 1, 0);
INSERT INTO `users` VALUES (85, 'wuqiang', 'wuqiang123', '15101011085', 'wuqiang@qq.com', '2025-01-18 07:10:55', 1, 0);
INSERT INTO `users` VALUES (86, 'wuna', 'wuna123', '18601011086', 'wuna@163.com', '2025-04-25 16:25:33', 0, 0);
INSERT INTO `users` VALUES (87, 'wuming', 'wuming123', '13501011087', 'wuming@126.com', '2025-07-30 21:50:08', 1, 0);
INSERT INTO `users` VALUES (88, 'wuhua', 'wuhua123', '15801011088', 'wuhua@gmail.com', '2025-10-12 11:15:27', 1, 0);
INSERT INTO `users` VALUES (89, 'wujun', 'wujun123', '15901011089', 'wujun@sina.com', '2026-01-08 22:45:50', 0, 0);
INSERT INTO `users` VALUES (90, 'wuxia', 'wuxia123', '18801011090', 'wuxia@outlook.com', '2026-04-20 05:30:15', 1, 0);
INSERT INTO `users` VALUES (91, 'zhouwei', 'zhouwei123', NULL, 'zhouwei@qq.com', '2024-03-15 08:20:30', 1, 0);
INSERT INTO `users` VALUES (92, 'zhoujing', 'zhoujing123', NULL, 'zhoujing@163.com', '2024-06-22 14:35:12', 1, 0);
INSERT INTO `users` VALUES (93, 'zhoulei', 'zhoulei123', NULL, 'zhoulei@126.com', '2024-09-10 10:05:45', 0, 0);
INSERT INTO `users` VALUES (94, 'zhoufang', 'zhoufang123', NULL, 'zhoufang@gmail.com', '2024-11-05 18:40:20', 1, 0);
INSERT INTO `users` VALUES (95, 'zhouqiang', 'zhouqiang123', NULL, 'zhouqiang@sina.com', '2025-01-18 07:10:55', 1, 0);
INSERT INTO `users` VALUES (96, 'zhouna', 'zhouna123', '13801011091', NULL, '2025-04-25 16:25:33', 1, 0);
INSERT INTO `users` VALUES (97, 'zhouming', 'zhouming123', '13901011092', NULL, '2025-07-30 21:50:08', 0, 0);
INSERT INTO `users` VALUES (98, 'zhouhua', 'zhouhua123', '15001011093', NULL, '2025-10-12 11:15:27', 1, 0);
INSERT INTO `users` VALUES (99, 'zhoujun', 'zhoujun123', '15101011094', NULL, '2026-01-08 22:45:50', 1, 0);
INSERT INTO `users` VALUES (100, 'zhouxia', 'zhouxia123', '18601011095', NULL, '2026-04-20 05:30:15', 0, 0);
INSERT INTO `users` VALUES (101, 'ops_director', 'Meetings$2025!', '13700137001', 'operations@conference-system.com', '2026-05-26 20:18:24', 1, 1);
INSERT INTO `users` VALUES (102, 'finance_admin', 'Finance@2025', '13600136001', 'billing@conference-system.com', '2026-05-26 20:18:24', 1, 1);
INSERT INTO `users` VALUES (103, 'disaster_recovery', 'DRP@ssw0rd!2025', '13500135001', 'drp@conference-system.com', '2026-05-26 20:18:24', 1, 1);

SET FOREIGN_KEY_CHECKS = 1;
