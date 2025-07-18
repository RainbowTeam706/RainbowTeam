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
@TableName("activity_member")
public class ActivityMember {
    @TableId(value = "id", type = IdType.AUTO)
    private int id;
    private int activityId;
    private int userId;
    private String nickname;
    private Date joinTime;
}
