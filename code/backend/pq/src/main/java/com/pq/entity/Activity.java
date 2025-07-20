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
@TableName("activity")
public class Activity {
    @TableId(value = "id", type = IdType.AUTO)
    private int id;

    private int createId;

    private String title;

    private String content;

    private String location;

    private Date startTime;

    private Date endTime;

    private String inviteCode;

    private Date createTime;

    private int Status;

    private int curNum;


    @com.baomidou.mybatisplus.annotation.TableField(exist = false)
    private String createName;
}
