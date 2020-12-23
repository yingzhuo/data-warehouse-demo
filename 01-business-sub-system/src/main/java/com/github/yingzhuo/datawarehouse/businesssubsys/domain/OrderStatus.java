package com.github.yingzhuo.datawarehouse.businesssubsys.domain;

import java.io.Serializable;

/**
 * 订单状态
 */
public enum OrderStatus implements Serializable {

    未支付(0),
    已支付(1),
    已取消(-1),
    配送中(2),
    待评价(3),
    已评价(4);

    private final int value;

    OrderStatus(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }

}
