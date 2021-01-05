/*
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *  ____        _         __        __             _                            ____
 * |  _ \  __ _| |_ __ _  \ \      / /_ _ _ __ ___| |__   ___  _   _ ___  ___  |  _ \  ___ _ __ ___   ___
 * | | | |/ _` | __/ _` |  \ \ /\ / / _` | '__/ _ \ '_ \ / _ \| | | / __|/ _ \ | | | |/ _ \ '_ ` _ \ / _ \
 * | |_| | (_| | || (_| |   \ V  V / (_| | | |  __/ | | | (_) | |_| \__ \  __/ | |_| |  __/ | | | | | (_) |
 * |____/ \__,_|\__\__,_|    \_/\_/ \__,_|_|  \___|_| |_|\___/ \__,_|___/\___| |____/ \___|_| |_| |_|\___/
 *
 * https://github.com/yingzhuo/data-warehouse-demo
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 */
package com.github.yingzhuo.datawarehouse.tool.date;

import org.apache.commons.io.FileUtils;

import java.io.File;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoField;

public class DateInfo {

    private static final String DEFAULT_PATTERN = "yyyy-MM-dd";
    private static final DateTimeFormatter DEFAULT_DATE_FORMAT = DateTimeFormatter.ofPattern(DEFAULT_PATTERN);
    private static final String DEFAULT_DELIMITER = ",";
    private static final File FILE = new File("./dim_date");

    public static void main(String[] args) throws Throwable {
        LocalDate start = LocalDate.parse("2020-01-01", DEFAULT_DATE_FORMAT);
        LocalDate end = LocalDate.parse("2100-01-01", DEFAULT_DATE_FORMAT);

        LocalDate it = start;

        FileUtils.deleteQuietly(FILE);

        while (!it.equals(end)) {

            String date = it.format(DEFAULT_DATE_FORMAT);
            String year = Integer.toString(it.getYear());
            String month = Integer.toString(it.getMonth().getValue());
            String day = Integer.toString(it.getDayOfMonth());
            String quarter = Integer.toString((it.getMonth().getValue() / 3) + 1);
            String week = getWeek(it);
            String weekend = isWeekend(it);
            String week_of_year = getWeekOfYear(it);

            StringBuilder line = new StringBuilder()
                    .append(date).append(DEFAULT_DELIMITER)
                    .append(year).append(DEFAULT_DELIMITER)
                    .append(month).append(DEFAULT_DELIMITER)
                    .append(day).append(DEFAULT_DELIMITER)
                    .append(quarter).append(DEFAULT_DELIMITER)
                    .append(week).append(DEFAULT_DELIMITER)
                    .append(weekend).append(DEFAULT_DELIMITER)
                    .append(week_of_year).append("\n");

            FileUtils.write(FILE, line, StandardCharsets.UTF_8, true);

            it = it.plusDays(1L);
        }

        System.out.println("Done!");
    }

    private static String getWeek(LocalDate date) {
        switch (date.getDayOfWeek()) {
            case SUNDAY:
                return "7";
            case MONDAY:
                return "1";
            case TUESDAY:
                return "2";
            case WEDNESDAY:
                return "3";
            case THURSDAY:
                return "4";
            case FRIDAY:
                return "5";
            case SATURDAY:
                return "6";
        }
        return null;
    }

    private static String isWeekend(LocalDate date) {
        switch (date.getDayOfWeek()) {
            case SUNDAY:
            case SATURDAY:
                return "true";
            case MONDAY:
            case TUESDAY:
            case WEDNESDAY:
            case THURSDAY:
            case FRIDAY:
                return "false";
        }
        return null;
    }

    private static String getWeekOfYear(LocalDate date) {
        int n = date.get(ChronoField.ALIGNED_WEEK_OF_YEAR);
        return Integer.toString(n);
    }

}
