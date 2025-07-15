package com.pq.entity;

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
    private int id;
    private int activityId;
    private int userId;
    private String nickname;
    private Date joinTime;
}
