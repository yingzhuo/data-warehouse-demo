-- 时间维度表
drop table if exists date_dim;
create table date_dim
(
    `date`         string comment '日期',
    `year`         int comment '年 (如: 2018)',
    `month`        int comment '月 (如: 7)',
    `day`          int comment '日 (如: 15)',
    `quarter`      int comment '季度 (如: 1)',
    `week`         int comment '星期 (如: 7星期日 6星期六)',
    `weekend`      boolean comment '是否是周末',
    `week_of_year` int comment '周在一年中的顺序'
)
    comment '日期维度表' row format delimited
    fields terminated by '\001'
    stored as
        inputformat 'com.hadoop.mapred.DeprecatedLzoTextInputFormat'
        outputformat 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
    location '/hive/data-warehouse-demo/other/date_dim';