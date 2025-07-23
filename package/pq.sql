/*
 Navicat Premium Dump SQL

 Source Server         : 922106840320
 Source Server Type    : MySQL
 Source Server Version : 80035 (8.0.35)
 Source Host           : localhost:3306
 Source Schema         : pq

 Target Server Type    : MySQL
 Target Server Version : 80035 (8.0.35)
 File Encoding         : 65001

 Date: 22/07/2025 22:52:42
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for activity
-- ----------------------------
DROP TABLE IF EXISTS `activity`;
CREATE TABLE `activity`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `createId` int NOT NULL,
  `Title` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标题',
  `Content` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '详情',
  `Location` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '地点',
  `startTime` datetime NULL DEFAULT NULL,
  `endTime` datetime NULL DEFAULT NULL,
  `inviteCode` char(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `createTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态',
  `curNum` int NOT NULL DEFAULT 0 COMMENT '当前人数',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of activity
-- ----------------------------
INSERT INTO `activity` VALUES (8, 1, '李正鹏的课堂', 'no contene', '云南', '2025-07-13 18:00:00', '2025-07-18 20:00:00', '411166', '2025-07-12 10:53:18', 2, 3);
INSERT INTO `activity` VALUES (14, 1, '李正鹏的课堂', 'no contene', '云南', '2025-06-30 18:00:00', '2025-07-01 20:00:00', '269766', '2025-07-13 13:23:57', 2, 1);
INSERT INTO `activity` VALUES (15, 1, '666', NULL, NULL, '2025-07-13 14:23:34', '2025-07-13 14:23:36', '666666', '2025-07-13 14:23:49', 2, 1);

-- ----------------------------
-- Table structure for activity_member
-- ----------------------------
DROP TABLE IF EXISTS `activity_member`;
CREATE TABLE `activity_member`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `activityId` int NOT NULL,
  `userId` int NOT NULL,
  `nickName` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '活动内昵称',
  `joinTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of activity_member
-- ----------------------------
INSERT INTO `activity_member` VALUES (2, 8, 2, 'gy nb 666', '2025-07-13 12:27:47');
INSERT INTO `activity_member` VALUES (3, 8, 3, 'ljs', '2025-07-13 14:24:29');

-- ----------------------------
-- Table structure for popquiz
-- ----------------------------
DROP TABLE IF EXISTS `popquiz`;
CREATE TABLE `popquiz`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `activityId` int NOT NULL COMMENT '所属测试id',
  `startTime` datetime NOT NULL COMMENT '开始时间',
  `endTime` datetime NOT NULL COMMENT '结束时间',
  `status` int NOT NULL COMMENT '状态（进行中/已结束）0/1',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of popquiz
-- ----------------------------
INSERT INTO `popquiz` VALUES (48, 8, '2025-07-19 15:52:38', '2025-07-19 15:53:38', 1);
INSERT INTO `popquiz` VALUES (49, 8, '2025-07-19 16:02:21', '2025-07-19 16:03:21', 1);
INSERT INTO `popquiz` VALUES (50, 8, '2025-07-19 16:07:15', '2025-07-19 16:08:15', 1);
INSERT INTO `popquiz` VALUES (51, 8, '2025-07-19 16:10:24', '2025-07-19 16:11:24', 1);
INSERT INTO `popquiz` VALUES (52, 8, '2025-07-19 16:11:18', '2025-07-19 16:12:18', 1);
INSERT INTO `popquiz` VALUES (53, 8, '2025-07-19 16:11:43', '2025-07-19 16:12:43', 1);
INSERT INTO `popquiz` VALUES (54, 8, '2025-07-19 16:16:20', '2025-07-19 16:17:20', 1);
INSERT INTO `popquiz` VALUES (55, 8, '2025-07-19 16:20:30', '2025-07-19 16:21:30', 1);
INSERT INTO `popquiz` VALUES (56, 8, '2025-07-19 16:23:45', '2025-07-19 16:24:45', 1);
INSERT INTO `popquiz` VALUES (57, 8, '2025-07-19 16:24:08', '2025-07-19 16:25:08', 1);
INSERT INTO `popquiz` VALUES (58, 8, '2025-07-19 16:24:35', '2025-07-19 16:25:35', 1);
INSERT INTO `popquiz` VALUES (59, 8, '2025-07-19 16:27:51', '2025-07-19 16:28:51', 1);
INSERT INTO `popquiz` VALUES (60, 8, '2025-07-19 16:28:10', '2025-07-19 16:29:10', 1);
INSERT INTO `popquiz` VALUES (61, 8, '2025-07-19 16:29:53', '2025-07-19 16:30:53', 1);
INSERT INTO `popquiz` VALUES (62, 8, '2025-07-19 16:31:42', '2025-07-19 16:32:42', 1);
INSERT INTO `popquiz` VALUES (63, 8, '2025-07-19 16:34:41', '2025-07-19 16:35:41', 1);
INSERT INTO `popquiz` VALUES (64, 8, '2025-07-19 16:38:13', '2025-07-19 16:39:13', 1);
INSERT INTO `popquiz` VALUES (65, 8, '2025-07-19 16:40:46', '2025-07-19 16:41:46', 1);
INSERT INTO `popquiz` VALUES (66, 8, '2025-07-19 16:43:57', '2025-07-19 16:44:57', 1);
INSERT INTO `popquiz` VALUES (67, 8, '2025-07-19 16:46:19', '2025-07-19 16:47:19', 1);
INSERT INTO `popquiz` VALUES (68, 8, '2025-07-19 16:48:47', '2025-07-19 16:49:47', 1);
INSERT INTO `popquiz` VALUES (69, 8, '2025-07-19 16:50:46', '2025-07-19 16:51:46', 1);
INSERT INTO `popquiz` VALUES (70, 8, '2025-07-19 16:52:18', '2025-07-19 16:53:18', 1);
INSERT INTO `popquiz` VALUES (71, 8, '2025-07-19 16:54:53', '2025-07-19 16:55:53', 1);
INSERT INTO `popquiz` VALUES (72, 8, '2025-07-19 16:56:36', '2025-07-19 16:57:36', 1);
INSERT INTO `popquiz` VALUES (73, 8, '2025-07-19 17:00:27', '2025-07-19 17:01:27', 1);
INSERT INTO `popquiz` VALUES (74, 8, '2025-07-19 17:01:37', '2025-07-19 17:02:37', 1);
INSERT INTO `popquiz` VALUES (75, 8, '2025-07-19 17:08:15', '2025-07-19 17:09:15', 1);
INSERT INTO `popquiz` VALUES (76, 8, '2025-07-19 17:27:48', '2025-07-19 17:28:48', 1);
INSERT INTO `popquiz` VALUES (77, 8, '2025-07-19 17:30:16', '2025-07-19 17:31:16', 1);
INSERT INTO `popquiz` VALUES (78, 8, '2025-07-19 17:39:28', '2025-07-19 17:40:28', 1);
INSERT INTO `popquiz` VALUES (79, 8, '2025-07-19 17:45:21', '2025-07-19 17:46:21', 1);
INSERT INTO `popquiz` VALUES (81, 8, '2025-07-20 16:50:12', '2025-07-20 17:00:12', 1);
INSERT INTO `popquiz` VALUES (82, 8, '2025-07-20 16:50:49', '2025-07-20 17:00:49', 1);
INSERT INTO `popquiz` VALUES (83, 8, '2025-07-20 16:52:50', '2025-07-20 17:02:50', 1);
INSERT INTO `popquiz` VALUES (85, 8, '2025-07-20 17:01:48', '2025-07-20 17:11:48', 1);
INSERT INTO `popquiz` VALUES (86, 8, '2025-07-20 17:11:45', '2025-07-20 17:21:45', 1);
INSERT INTO `popquiz` VALUES (87, 8, '2025-07-20 17:19:43', '2025-07-20 17:29:43', 1);
INSERT INTO `popquiz` VALUES (88, 8, '2025-07-20 17:21:58', '2025-07-20 17:31:58', 1);
INSERT INTO `popquiz` VALUES (89, 8, '2025-07-20 17:21:59', '2025-07-20 17:31:59', 1);
INSERT INTO `popquiz` VALUES (90, 8, '2025-07-20 17:23:38', '2025-07-20 17:33:38', 1);
INSERT INTO `popquiz` VALUES (93, 8, '2025-07-20 17:38:29', '2025-07-20 17:48:29', 1);
INSERT INTO `popquiz` VALUES (94, 8, '2025-07-20 17:42:42', '2025-07-20 17:52:42', 1);
INSERT INTO `popquiz` VALUES (95, 8, '2025-07-20 17:51:49', '2025-07-20 18:01:49', 1);
INSERT INTO `popquiz` VALUES (96, 8, '2025-07-20 17:53:27', '2025-07-20 18:03:27', 1);
INSERT INTO `popquiz` VALUES (97, 8, '2025-07-20 17:53:51', '2025-07-20 18:03:51', 1);
INSERT INTO `popquiz` VALUES (99, 8, '2025-07-20 18:08:02', '2025-07-20 18:18:02', 1);
INSERT INTO `popquiz` VALUES (100, 8, '2025-07-20 18:10:25', '2025-07-20 18:20:25', 1);

-- ----------------------------
-- Table structure for popquiz_question
-- ----------------------------
DROP TABLE IF EXISTS `popquiz_question`;
CREATE TABLE `popquiz_question`  (
  `id` int NOT NULL,
  `popquizId` int NOT NULL COMMENT '题目所属的popquiz',
  `questionId` int NOT NULL COMMENT '题目',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of popquiz_question
-- ----------------------------
INSERT INTO `popquiz_question` VALUES (1, 1, 1);
INSERT INTO `popquiz_question` VALUES (2, 1, 2);

-- ----------------------------
-- Table structure for question_bank
-- ----------------------------
DROP TABLE IF EXISTS `question_bank`;
CREATE TABLE `question_bank`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `popQuizId` int NOT NULL COMMENT '该题目所属活动id',
  `content` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '题目内容',
  `options` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '选项（json形式）',
  `answer` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '正确答案',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 803 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of question_bank
-- ----------------------------
INSERT INTO `question_bank` VALUES (441, 48, '题目：这里出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (442, 48, '题目：这里出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (443, 48, '题目：这里出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (444, 48, '题目：这里出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (445, 48, '题目：这里出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (446, 48, '题目：这里出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (447, 48, '题目：这里出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (448, 48, '题目：这里出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (449, 48, '题目：这里出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (450, 48, '题目：这里出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (451, 49, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (452, 49, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (453, 49, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (454, 49, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (455, 49, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (456, 49, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (457, 49, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (458, 49, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (459, 49, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (460, 49, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (461, 50, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (462, 50, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (463, 50, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (464, 50, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (465, 50, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (466, 50, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (467, 50, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (468, 50, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (469, 50, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (470, 50, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (471, 51, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (472, 51, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (473, 51, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (474, 51, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (475, 51, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (476, 51, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (477, 51, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (478, 51, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (479, 51, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (480, 51, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (481, 52, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (482, 52, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (483, 52, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (484, 52, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (485, 52, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (486, 52, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (487, 52, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (488, 52, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (489, 52, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (490, 52, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (491, 53, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (492, 53, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (493, 53, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (494, 53, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (495, 53, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (496, 53, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (497, 53, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (498, 53, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (499, 53, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (500, 53, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (501, 54, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (502, 54, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (503, 54, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (504, 54, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (505, 54, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (506, 54, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (507, 54, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (508, 54, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (509, 54, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (510, 54, '题目：提米谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (511, 55, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (512, 55, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (513, 55, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (514, 55, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (515, 55, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (516, 55, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (517, 55, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (518, 55, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (519, 55, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (520, 55, '题目：出题谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (521, 56, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (522, 56, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (523, 56, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (524, 56, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (525, 56, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (526, 56, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (527, 56, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (528, 56, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (529, 56, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (530, 56, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (531, 57, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (532, 57, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (533, 57, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (534, 57, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (535, 57, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (536, 57, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (537, 57, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (538, 57, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (539, 57, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (540, 57, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (541, 58, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (542, 58, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (543, 58, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (544, 58, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (545, 58, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (546, 58, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (547, 58, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (548, 58, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (549, 58, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (550, 58, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (551, 59, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (552, 59, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (553, 59, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (554, 59, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (555, 59, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (556, 59, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (557, 59, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (558, 59, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (559, 59, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (560, 59, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (561, 60, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (562, 60, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (563, 60, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (564, 60, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (565, 60, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (566, 60, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (567, 60, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (568, 60, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (569, 60, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (570, 60, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (571, 61, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (572, 61, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (573, 61, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (574, 61, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (575, 61, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (576, 61, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (577, 61, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (578, 61, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (579, 61, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (580, 61, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (581, 62, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (582, 62, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (583, 62, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (584, 62, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (585, 62, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (586, 62, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (587, 62, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (588, 62, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (589, 62, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (590, 62, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (591, 63, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (592, 63, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (593, 63, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (594, 63, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (595, 63, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (596, 63, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (597, 63, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (598, 63, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (599, 63, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (600, 63, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (601, 64, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (602, 64, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (603, 64, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (604, 64, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (605, 64, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (606, 64, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (607, 64, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (608, 64, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (609, 64, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (610, 64, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (611, 65, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (612, 65, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (613, 65, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (614, 65, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (615, 65, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (616, 65, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (617, 65, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (618, 65, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (619, 65, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (620, 65, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (621, 66, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (622, 66, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (623, 66, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (624, 66, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (625, 66, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (626, 66, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (627, 66, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (628, 66, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (629, 66, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (630, 66, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (631, 67, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (632, 67, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (633, 67, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (634, 67, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (635, 67, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (636, 67, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (637, 67, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (638, 67, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (639, 67, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (640, 67, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (641, 68, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (642, 68, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (643, 68, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (644, 68, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (645, 68, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (646, 68, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (647, 68, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (648, 68, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (649, 68, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (650, 68, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (651, 69, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (652, 69, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (653, 69, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (654, 69, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (655, 69, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (656, 69, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (657, 69, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (658, 69, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (659, 69, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (660, 69, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (661, 70, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (662, 70, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (663, 70, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (664, 70, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (665, 70, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (666, 70, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (667, 70, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (668, 70, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (669, 70, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (670, 70, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (671, 71, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (672, 71, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (673, 71, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (674, 71, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (675, 71, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (676, 71, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (677, 71, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (678, 71, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (679, 71, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (680, 71, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (681, 72, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (682, 72, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (683, 72, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (684, 72, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (685, 72, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (686, 72, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (687, 72, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (688, 72, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (689, 72, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (690, 72, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (691, 73, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (692, 73, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (693, 73, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (694, 73, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (695, 73, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (696, 73, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (697, 73, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (698, 73, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (699, 73, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (700, 73, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (701, 74, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (702, 74, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (703, 74, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (704, 74, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (705, 74, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (706, 74, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (707, 74, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (708, 74, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (709, 74, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (710, 74, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (711, 75, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (712, 75, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (713, 75, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (714, 75, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (715, 75, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (716, 75, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (717, 75, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (718, 75, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (719, 75, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (720, 75, '题目：dsd谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (721, 76, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (722, 76, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (723, 76, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (724, 76, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (725, 76, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (726, 76, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (727, 76, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (728, 76, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (729, 76, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (730, 76, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (731, 77, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (732, 77, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (733, 77, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (734, 77, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (735, 77, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (736, 77, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (737, 77, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (738, 77, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (739, 77, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (740, 77, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (741, 78, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (742, 78, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (743, 78, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (744, 78, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (745, 78, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (746, 78, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (747, 78, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (748, 78, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (749, 78, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'D');
INSERT INTO `question_bank` VALUES (750, 78, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (751, 79, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (752, 79, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (753, 79, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (754, 79, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (755, 79, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (756, 79, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'B');
INSERT INTO `question_bank` VALUES (757, 79, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (758, 79, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (759, 79, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'C');
INSERT INTO `question_bank` VALUES (760, 79, '题目：pq谁最聪明', '[\"喜羊羊\",\"刘健顺\",\"郭钰\",\"李正鹏\"]', 'A');
INSERT INTO `question_bank` VALUES (761, 81, '关于\'11123456kjgmdxhfmgcvh\'的第1道题目', '[\"选项A\",\"选项B\",\"选项C\",\"选项D\"]', 'A');
INSERT INTO `question_bank` VALUES (762, 82, '关于\'11123456kjgmdxhfmgcvh\'的第1道题目', '[\"选项A\",\"选项B\",\"选项C\",\"选项D\"]', 'B');
INSERT INTO `question_bank` VALUES (763, 83, '关于\'11123456kjgmdxhfmgcvh\'的第1道题目', '[\"选项A\",\"选项B\",\"选项C\",\"选项D\"]', 'A');
INSERT INTO `question_bank` VALUES (764, 85, '关于\'这是一条长文本\'的第1道题目', '[\"选项A\",\"选项B\",\"选项C\",\"选项D\"]', 'C');
INSERT INTO `question_bank` VALUES (765, 86, '关于\'这是一条长文本\'的第1道题目', '[\"选项A\",\"选项B\",\"选项C\",\"选项D\"]', 'A');
INSERT INTO `question_bank` VALUES (766, 87, '关于\'这是一条长文本\'的第1道题目', '[\"选项A\",\"选项B\",\"选项C\",\"选项D\"]', 'A');
INSERT INTO `question_bank` VALUES (767, 88, '关于\'这是一条长文本\'的第1道题目', '[\"选项A\",\"选项B\",\"选项C\",\"选项D\"]', 'D');
INSERT INTO `question_bank` VALUES (768, 89, '关于\'这是一条长文本\'的第1道题目', '[\"选项A\",\"选项B\",\"选项C\",\"选项D\"]', 'A');
INSERT INTO `question_bank` VALUES (769, 90, '关于\'如果你看到这条消息并且能理解，那么请你直接出一道小学数学选择题就可以\'的第1道题目', '[\"选项A\",\"选项B\",\"选项C\",\"选项D\"]', 'C');
INSERT INTO `question_bank` VALUES (770, 93, '关于\'封装是指将数据和操作数据的方法组合在一起，通过访问修饰符（如private、public、protected）来控制对类内部数据的访问。这样可以隐藏实现细节，提高代码的安全性和可维护性。\'的第1道题目', '[\"选项A\",\"选项B\",\"选项C\",\"选项D\"]', 'C');
INSERT INTO `question_bank` VALUES (771, 93, '关于\'封装是指将数据和操作数据的方法组合在一起，通过访问修饰符（如private、public、protected）来控制对类内部数据的访问。这样可以隐藏实现细节，提高代码的安全性和可维护性。\'的第2道题目', '[\"选项A\",\"选项B\",\"选项C\",\"选项D\"]', 'B');
INSERT INTO `question_bank` VALUES (772, 94, '封装通过访问修饰符（如private、public、protected）控制对类内部数据访问的主要目的是什么？', '[\"隐藏实现细节，提高代码的安全性和可维护性\",\"提高代码的执行效率\",\"简化代码的编写过程\",\"实现类的多态性\"]', 'A');
INSERT INTO `question_bank` VALUES (773, 94, '根据封装的定义，其核心组成部分包括以下哪项？', '[\"仅数据\",\"数据和操作数据的方法\",\"仅操作数据的方法\",\"数据和类的继承关系\"]', 'B');
INSERT INTO `question_bank` VALUES (774, 95, '封装通过以下哪种方式实现隐藏类内部实现细节的目的？', '[\"将所有成员变量设为public\",\"仅在类中定义数据而不定义方法\",\"不使用任何访问修饰符\",\"使用访问修饰符控制对类内部数据的访问\"]', 'D');
INSERT INTO `question_bank` VALUES (775, 95, '下列关于封装的描述中，正确的是？', '[\"仅包含数据成员，不包含任何成员方法\",\"将数据成员和成员方法分别定义在不同的类中\",\"只提供对数据的直接访问，不通过方法\",\"将数据和操作数据的方法组合在一起\"]', 'D');
INSERT INTO `question_bank` VALUES (776, 96, '封装的核心目的是什么？', '[\"A. 隐藏实现细节，提高代码的安全性和可维护性\",\"B. 提高代码的执行效率\",\"C. 简化代码的编写过程\",\"D. 方便类的继承操作\"]', 'A');
INSERT INTO `question_bank` VALUES (777, 96, '在封装中，通过什么来控制对类内部数据的访问？', '[\"A. 访问修饰符（如private、public、protected）\",\"B. 构造方法\",\"C. 静态方法\",\"D. 接口\"]', 'A');
INSERT INTO `question_bank` VALUES (778, 97, '封装是指将什么和操作数据的方法组合在一起？', '[\"A.数据\",\"B.类名\",\"C.继承关系\",\"D.多态接口\"]', 'A');
INSERT INTO `question_bank` VALUES (779, 97, '封装通过访问修饰符控制对类内部数据的访问，其主要目的是？', '[\"A.隐藏实现细节，提高安全性和可维护性\",\"B.允许外部任意修改类内部数据\",\"C.实现类的继承\",\"D.支持方法的重载\"]', 'A');
INSERT INTO `question_bank` VALUES (790, 99, 'Java的“一次编写，到处运行”特性主要通过以下哪种机制实现？', '[\"A.JVM\",\"B.JRE\",\"C.JDK\",\"D.JIT\"]', 'A');
INSERT INTO `question_bank` VALUES (791, 99, 'Java的垃圾回收机制（GC）主要作用是？', '[\"A.减少内存泄漏风险\",\"B.提高代码运行速度\",\"C.增强代码可读性\",\"D.优化网络数据传输\"]', 'A');
INSERT INTO `question_bank` VALUES (792, 99, '以下哪项不是Java的主要应用领域？', '[\"A.企业级开发\",\"B.Android应用开发\",\"C.大数据处理\",\"D.iOS应用开发\"]', 'D');
INSERT INTO `question_bank` VALUES (793, 99, '下列哪个是Java生态系统中的第三方框架？', '[\"A.Spring\",\"B.Django\",\"C.React\",\"D.Flask\"]', 'A');
INSERT INTO `question_bank` VALUES (794, 99, 'Java中的JIT编译技术主要用于提升什么性能？', '[\"A.运行时性能\",\"B.编译时速度\",\"C.代码安全性\",\"D.内存分配效率\"]', 'A');
INSERT INTO `question_bank` VALUES (795, 99, '以下哪项机制有助于保障Java代码的安全性？', '[\"A.沙箱机制\",\"B.垃圾回收\",\"C.多线程支持\",\"D.动态类型检查\"]', 'A');
INSERT INTO `question_bank` VALUES (796, 99, '根据文本，以下哪个是Java的较新版本？', '[\"A.Java 21\",\"B.Java 8\",\"C.Java 10\",\"D.Java 15\"]', 'A');
INSERT INTO `question_bank` VALUES (797, 99, 'Java的自动内存管理主要通过什么实现？', '[\"A.垃圾回收机制（GC）\",\"B.手动内存分配\",\"C.栈内存溢出检查\",\"D.静态代码分析\"]', 'A');
INSERT INTO `question_bank` VALUES (798, 99, 'Java适用于高并发场景的重要原因之一是其支持？', '[\"A.多线程\",\"B.动态类型\",\"C.解释执行\",\"D.无类型检查\"]', 'A');
INSERT INTO `question_bank` VALUES (799, 99, 'Java特别适合长期维护的大型项目，主要得益于其？', '[\"A.强大的生态系统和持续更新\",\"B.语法简单易学\",\"C.执行速度比所有语言快\",\"D.仅支持单机部署\"]', 'A');
INSERT INTO `question_bank` VALUES (800, 100, 'Java实现“一次编写，到处运行”特性的核心机制是？', '[\"A:Java虚拟机（JVM）\",\"B:Java开发工具包（JDK）\",\"C:垃圾回收机制（GC）\",\"D:字节码校验器\"]', 'A');
INSERT INTO `question_bank` VALUES (801, 100, 'Java中自动管理内存、减少内存泄漏风险的机制是？', '[\"A:沙箱机制\",\"B:垃圾回收机制（GC）\",\"C:JIT编译\",\"D:强类型检查\"]', 'B');
INSERT INTO `question_bank` VALUES (802, 100, '下列哪项是Java生态系统中提升开发效率的第三方框架？', '[\"A:Spring\",\"B:Java虚拟机（JVM）\",\"C:字节码\",\"D:多线程支持\"]', 'A');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `nickname` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`, `username`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'user1', 'abc12345', 'lzp666');
INSERT INTO `user` VALUES (2, 'user2', 'abc12345', 'gy NB');
INSERT INTO `user` VALUES (3, 'user3', 'abc12345', 'ljs');

-- ----------------------------
-- Table structure for user_answer
-- ----------------------------
DROP TABLE IF EXISTS `user_answer`;
CREATE TABLE `user_answer`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `userId` int NOT NULL COMMENT '答题人ID',
  `popQuizId` int NOT NULL,
  `questionIds` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '题目id集合',
  `options` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '所选选项',
  `answerTime` datetime NULL DEFAULT NULL COMMENT '答题时间',
  `isCorrect` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否正确',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 184 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_answer
-- ----------------------------
INSERT INTO `user_answer` VALUES (87, 1, 48, '444,448,449', ',,', NULL, ',,');
INSERT INTO `user_answer` VALUES (88, 2, 48, '443,449,446', 'A,C,', '2025-07-19 15:53:39', '0,1,0');
INSERT INTO `user_answer` VALUES (89, 3, 48, '443,449,441', ',,', NULL, ',,');
INSERT INTO `user_answer` VALUES (90, 2, 49, '451,460,457,454', ',,,', '2025-07-19 16:03:22', '0,0,0,0');
INSERT INTO `user_answer` VALUES (91, 3, 49, '459,458,457,453', ',,,', NULL, ',,,');
INSERT INTO `user_answer` VALUES (92, 2, 50, '469,466,470,463', ',,,', '2025-07-19 16:08:16', '0,0,0,0');
INSERT INTO `user_answer` VALUES (93, 3, 50, '467,468,461,463', 'A,B,C,', '2025-07-19 16:08:16', '0,0,0,0');
INSERT INTO `user_answer` VALUES (94, 2, 51, '479,475,480,476', 'A,B,A,A', '2025-07-19 16:10:31', '0,0,0,1');
INSERT INTO `user_answer` VALUES (95, 3, 51, '471,480,475,478', ',,,', NULL, ',,,');
INSERT INTO `user_answer` VALUES (96, 2, 52, '481,486,488,489', ',,,', NULL, ',,,');
INSERT INTO `user_answer` VALUES (97, 3, 52, '486,481,488,485', ',,,', NULL, ',,,');
INSERT INTO `user_answer` VALUES (98, 2, 53, '500,495,497,499', 'A,B,B,A', '2025-07-19 16:11:51', '0,0,0,0');
INSERT INTO `user_answer` VALUES (99, 3, 53, '497,494,496,500', ',,,', NULL, ',,,');
INSERT INTO `user_answer` VALUES (100, 2, 54, '505,501,502,504', 'A,B,C,D', '2025-07-19 16:16:29', '0,0,0,1');
INSERT INTO `user_answer` VALUES (101, 3, 54, '508,507,510,506', 'A,B,C,D', '2025-07-19 16:16:34', '0,0,0,0');
INSERT INTO `user_answer` VALUES (102, 2, 55, '515,514,511,520', ',,,', '2025-07-19 16:21:31', '0,0,0,0');
INSERT INTO `user_answer` VALUES (103, 3, 55, '511,512,517,519', ',,,', '2025-07-19 16:21:31', '0,0,0,0');
INSERT INTO `user_answer` VALUES (104, 2, 56, '525,522,521', 'A,B,B', '2025-07-19 16:24:04', '0,0,1');
INSERT INTO `user_answer` VALUES (105, 3, 56, '523,528,522', ',,', NULL, ',,');
INSERT INTO `user_answer` VALUES (106, 2, 57, '534,540,535', 'D,D,D', '2025-07-19 16:24:31', '0,0,0');
INSERT INTO `user_answer` VALUES (107, 3, 57, '534,532,535', ',,', NULL, ',,');
INSERT INTO `user_answer` VALUES (108, 2, 58, '550,548,544', ',,', '2025-07-19 16:25:37', '0,0,0');
INSERT INTO `user_answer` VALUES (109, 3, 58, '549,548,546', ',,', '2025-07-19 16:25:38', '0,0,0');
INSERT INTO `user_answer` VALUES (110, 2, 59, '553,551,556', 'A,B,C', '2025-07-19 16:27:57', '1,0,0');
INSERT INTO `user_answer` VALUES (111, 3, 59, '554,559,553', 'A,C,D', '2025-07-19 16:28:03', '0,0,0');
INSERT INTO `user_answer` VALUES (112, 2, 60, '561,569,566', ',,', '2025-07-19 16:29:12', '0,0,0');
INSERT INTO `user_answer` VALUES (113, 3, 60, '566,568,569', ',,', '2025-07-19 16:29:12', '0,0,0');
INSERT INTO `user_answer` VALUES (114, 2, 61, '573,575,577', ',,', '2025-07-19 16:31:35', '0,0,0');
INSERT INTO `user_answer` VALUES (115, 3, 61, '580,578,579', ',,', '2025-07-19 16:31:40', '0,0,0');
INSERT INTO `user_answer` VALUES (116, 2, 62, '581,589,586', ',,', '2025-07-19 16:32:44', '0,0,0');
INSERT INTO `user_answer` VALUES (117, 3, 62, '583,589,586', ',,', '2025-07-19 16:32:45', '0,0,0');
INSERT INTO `user_answer` VALUES (118, 2, 63, '595,600,597', ',,', '2025-07-19 16:35:42', '0,0,0');
INSERT INTO `user_answer` VALUES (119, 3, 63, '592,598,593', ',,', '2025-07-19 16:35:43', '0,0,0');
INSERT INTO `user_answer` VALUES (120, 2, 64, '610,609,604', ',,', '2025-07-19 16:39:40', '0,0,0');
INSERT INTO `user_answer` VALUES (121, 3, 64, '603,610,604', ',,', '2025-07-19 16:39:39', '0,0,0');
INSERT INTO `user_answer` VALUES (122, 2, 65, '620,612,619', ',,', '2025-07-19 16:41:47', '0,0,0');
INSERT INTO `user_answer` VALUES (123, 3, 65, '614,619,612', 'A,C,', '2025-07-19 16:41:47', '0,1,0');
INSERT INTO `user_answer` VALUES (124, 2, 66, '623,629,621', ',,', '2025-07-19 16:45:00', '0,0,0');
INSERT INTO `user_answer` VALUES (125, 3, 66, '621,629,627', ',,', '2025-07-19 16:45:00', '0,0,0');
INSERT INTO `user_answer` VALUES (126, 2, 67, '640,636,637', ',,', '2025-07-19 16:47:21', '0,0,0');
INSERT INTO `user_answer` VALUES (127, 3, 67, '635,633,639', 'A,C,D', '2025-07-19 16:46:31', '0,1,1');
INSERT INTO `user_answer` VALUES (128, 2, 68, '642,646,647', ',,', '2025-07-19 16:49:50', '0,0,0');
INSERT INTO `user_answer` VALUES (129, 3, 68, '643,645,647', ',,', NULL, ',,');
INSERT INTO `user_answer` VALUES (130, 2, 69, '655,651,652', 'A,C,C', '2025-07-19 16:50:51', '0,0,0');
INSERT INTO `user_answer` VALUES (131, 3, 69, '656,659,653', ',,', NULL, ',,');
INSERT INTO `user_answer` VALUES (132, 2, 70, '670,666,664', ',,', '2025-07-19 16:53:20', '0,0,0');
INSERT INTO `user_answer` VALUES (133, 3, 70, '665,666,668', ',,', NULL, ',,');
INSERT INTO `user_answer` VALUES (134, 2, 71, '679,674,677', ',,', '2025-07-19 16:55:54', '0,0,0');
INSERT INTO `user_answer` VALUES (135, 3, 71, '673,677,680', ',,', NULL, ',,');
INSERT INTO `user_answer` VALUES (136, 2, 72, '688,690,686', ',,', '2025-07-19 16:57:37', '0,0,0');
INSERT INTO `user_answer` VALUES (137, 3, 72, '684,682,688', ',,', NULL, ',,');
INSERT INTO `user_answer` VALUES (138, 2, 73, '694,692,698', 'A,B,D', '2025-07-19 17:00:32', '0,1,0');
INSERT INTO `user_answer` VALUES (139, 3, 73, '697,699,696', ',,', NULL, ',,');
INSERT INTO `user_answer` VALUES (140, 2, 74, '709,701,710', 'A,B,', '2025-07-19 17:02:39', '0,1,0');
INSERT INTO `user_answer` VALUES (141, 3, 74, '705,703,710', ',,', NULL, ',,');
INSERT INTO `user_answer` VALUES (142, 2, 75, '715,716,718', 'A,C,', '2025-07-19 17:09:16', '0,0,0');
INSERT INTO `user_answer` VALUES (143, 3, 75, '715,714,713', 'A,C,D', '2025-07-19 17:08:20', '0,1,0');
INSERT INTO `user_answer` VALUES (144, 2, 76, '721,724,723', ',,', '2025-07-19 17:28:50', '0,0,0');
INSERT INTO `user_answer` VALUES (145, 3, 76, '729,728,727', ',,', '2025-07-19 17:28:50', '0,0,0');
INSERT INTO `user_answer` VALUES (146, 2, 77, '734,738,731', 'A,C,C', '2025-07-19 17:31:17', '0,1,0');
INSERT INTO `user_answer` VALUES (147, 3, 77, '735,738,737', ',,', '2025-07-19 17:31:17', '0,0,0');
INSERT INTO `user_answer` VALUES (148, 2, 78, '741,749,744', ',,', '2025-07-19 17:40:30', '0,0,0');
INSERT INTO `user_answer` VALUES (149, 3, 78, '747,743,742', ',,', '2025-07-19 17:40:30', '0,0,0');
INSERT INTO `user_answer` VALUES (150, 2, 79, '753,759,752', 'A,B,C', '2025-07-19 17:45:26', '0,0,1');
INSERT INTO `user_answer` VALUES (151, 3, 79, '753,758,752', 'A,B,C', '2025-07-19 17:46:23', '0,0,1');
INSERT INTO `user_answer` VALUES (152, 2, 81, '761', '', NULL, '');
INSERT INTO `user_answer` VALUES (153, 3, 81, '761', '', NULL, '');
INSERT INTO `user_answer` VALUES (154, 2, 82, '762', '', NULL, '');
INSERT INTO `user_answer` VALUES (155, 3, 82, '762', '', NULL, '');
INSERT INTO `user_answer` VALUES (156, 2, 83, '763', '', NULL, '');
INSERT INTO `user_answer` VALUES (157, 3, 83, '763', '', NULL, '');
INSERT INTO `user_answer` VALUES (158, 2, 85, '764', 'A', '2025-07-20 17:26:15', '0');
INSERT INTO `user_answer` VALUES (159, 3, 85, '764', '', NULL, '');
INSERT INTO `user_answer` VALUES (160, 2, 86, '765', '', NULL, '');
INSERT INTO `user_answer` VALUES (161, 3, 86, '765', '', NULL, '');
INSERT INTO `user_answer` VALUES (162, 2, 87, '766', '', NULL, '');
INSERT INTO `user_answer` VALUES (163, 3, 87, '766', '', NULL, '');
INSERT INTO `user_answer` VALUES (164, 2, 88, '767', '', NULL, '');
INSERT INTO `user_answer` VALUES (165, 3, 88, '767', '', NULL, '');
INSERT INTO `user_answer` VALUES (166, 2, 89, '768', '', NULL, '');
INSERT INTO `user_answer` VALUES (167, 3, 89, '768', '', NULL, '');
INSERT INTO `user_answer` VALUES (168, 2, 90, '769', '', NULL, '');
INSERT INTO `user_answer` VALUES (169, 3, 90, '769', '', NULL, '');
INSERT INTO `user_answer` VALUES (170, 2, 93, '770,771', 'B,D', '2025-07-20 17:40:58', '0,0');
INSERT INTO `user_answer` VALUES (171, 3, 93, '770,771', ',', NULL, ',');
INSERT INTO `user_answer` VALUES (172, 2, 94, '772,773', ',', NULL, ',');
INSERT INTO `user_answer` VALUES (173, 3, 94, '773,772', ',', NULL, ',');
INSERT INTO `user_answer` VALUES (174, 2, 95, '774,775', 'B,C', '2025-07-20 17:52:21', '0,0');
INSERT INTO `user_answer` VALUES (175, 3, 95, '775,774', ',', NULL, ',');
INSERT INTO `user_answer` VALUES (176, 2, 96, '777,776', 'B,C', '2025-07-20 17:53:41', '0,0');
INSERT INTO `user_answer` VALUES (177, 3, 96, '776,777', ',', NULL, ',');
INSERT INTO `user_answer` VALUES (178, 2, 97, '779,778', 'B,D', '2025-07-20 17:54:06', '0,0');
INSERT INTO `user_answer` VALUES (179, 3, 97, '779,778', ',', NULL, ',');
INSERT INTO `user_answer` VALUES (180, 2, 99, '791,799,795,794,797,790,792,798,796,793', 'A,C,B,D,B,D,C,B,C,D', '2025-07-20 18:09:10', '1,0,0,0,0,0,0,0,0,0');
INSERT INTO `user_answer` VALUES (181, 3, 99, '793,798,790,791,795,796,797,792,794,799', ',,,,,,,,,', NULL, ',,,,,,,,,');
INSERT INTO `user_answer` VALUES (182, 2, 100, '801,800,802', 'B,D,D', '2025-07-20 18:11:10', '1,0,0');
INSERT INTO `user_answer` VALUES (183, 3, 100, '802,800,801', ',,', NULL, ',,');

SET FOREIGN_KEY_CHECKS = 1;
