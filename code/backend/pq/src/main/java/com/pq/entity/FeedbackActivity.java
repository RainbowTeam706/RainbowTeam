package com.pq.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@TableName("feedback_activity")
public class FeedbackActivity {
    @TableId(value = "id", type = IdType.AUTO)
    private int id;

    private int activityId; // 关联活动ID
    private int userId; // 反馈学生ID
    private int feedbackData_Pace; // 0fast, 1normal, 2slow
    private int feedbackData_Difficulty; // 0hard, 1normal, 2easy
    private int feedbackData_Understanding; // 0clear, 1confused
} 