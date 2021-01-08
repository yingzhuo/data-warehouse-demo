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

import org.apache.commons.lang3.RandomUtils;

import java.util.UUID;

public class DeviceInfo {

    public static void main(String[] args) {

        for (int i = 0; i < 1000; i++) {
            String deviceId = UUID.randomUUID().toString();
            String osType = randomOSType();
            String model = randomModel(osType);
            String brand = model.split(" ")[0];

            System.out.println(
                    new StringBuilder()
                            .append(deviceId).append(",")
                            .append(osType).append(",")
                            .append(brand).append(",")
                            .append(model)
            );
        }
    }

    private static String randomOSType() {
        int n = RandomUtils.nextInt(0, 100);
        if (n < 75) return "Android";
        if (n >= 95) return "IOS";
        return "WindowsPhone";
    }

    private static String randomModel(String osType) {
        final String[] pool;
        if ("Android".equalsIgnoreCase(osType)) {
            pool = new String[]{
                    "Huawei Meta 20",
                    "Huawei Meta 30",
                    "Huawei Meta 40",
                    "Huawei Meta 40 5G",
                    "Xiaomi 3",
                    "Xiaomi 4",
                    "Xiaomi 5",
                    "Xiaomi 6 Pro",
                    "荣耀 10",
            };
        } else if ("IOS".equalsIgnoreCase(osType)) {
            pool = new String[]{
                    "iphone 4s",
                    "iphone 5",
                    "iphone 6",
                    "iphone 7",
                    "iphone 8",
                    "iphone 9",
                    "iphone x",
                    "iphone 11",
                    "iphone 12",
            };
        } else {
            pool = new String[]{
                    "Lumia 1+",
                    "Lumia 2",
            };
        }
        return pool[RandomUtils.nextInt(0, pool.length)];
    }

}
