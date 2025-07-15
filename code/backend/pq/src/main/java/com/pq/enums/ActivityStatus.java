package com.pq.enums;

public enum ActivityStatus {
    UNSTART(0, "未开始"),
    RUNNING(1, "活动进行中"),
    ENDED(2, "活动已结束");

    private final int code;
    private final String description;

    ActivityStatus(int code, String description) {
        this.code = code;
        this.description = description;
    }

    public int getCode() {
        return code;
    }

    public String getDescription() {
        return description;
    }

    public static ActivityStatus fromCode(int code) {
        for (ActivityStatus status : values()) {
            if (status.code == code) {
                return status;
            }
        }
        throw new IllegalArgumentException("Invalid status code: " + code);
    }
}
