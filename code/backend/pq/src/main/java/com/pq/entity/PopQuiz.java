package com.pq.entity;

import com.baomidou.mybatisplus.annotation.IdType;
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

    private Integer activityId;

    private Date startTime;

    private Date endTime;

    private Integer status;

} 