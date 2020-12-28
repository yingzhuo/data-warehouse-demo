package com.github.yingzhuo.datawarehouse.businesssubsys.support;

import java.lang.annotation.*;

@Documented
@Inherited
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.SOURCE) // 只是起到标记的作用，帮助思考
public @interface SqoopImporting {

    /**
     * 导入策略
     */
    public Policy policy();

    /**
     * 导入时按日期分区
     */
    public boolean partitionedByDate() default true;

    public static enum Policy {
        /* 单次导入 */
        ONCE,

        /* 全表导入 */
        ALL,

        /* 只导入新增 */
        NEW,

        /* 导入新增和更新 */
        NEW_UPDATE,

        /* 无意义 */
        VOID
    }

}
