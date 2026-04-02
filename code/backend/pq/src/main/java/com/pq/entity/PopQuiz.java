package com.pq.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;

import java.util.Date;

@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@TableName("popquiz")
public class PopQuiz {
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;

    @TableField("activityId")
    private Integer activityId;

    @TableField("startTime")
    private Date startTime;

    @TableField("endTime")
    private Date endTime;

    @TableField("status")
    private Integer status;

    /** 文件任务ID（一个测验对应一次文件任务） */
    @TableField("taskId")
    private String taskId;

    /** 发题标记：0-未发题，1-已发题（一个测验只发一次） */
    @TableField("sent")
    private Integer sent;

} 