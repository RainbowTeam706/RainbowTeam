package com.pq.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.util.Date;

@Data
@TableName("discussion_comment")
public class DiscussionComment {
    @TableId(value = "id", type = IdType.AUTO)
    private Integer id;
    private Integer activityId;
    private Integer userId;
    private String userName;
    private String role;
    private Boolean anonymous;
    private String content;
    private Date time;
    private Integer parentId;
    private Integer replyTo;
} 