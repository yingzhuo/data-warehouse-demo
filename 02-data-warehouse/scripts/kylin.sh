#!/usr/bin/env bash
#-----------------------------------------------------------------------------------------------------------------------
# 作者: 应卓
#-----------------------------------------------------------------------------------------------------------------------

if [[ "x$1" != "x" ]]
then
  CUR_DATE=$1
else
  CUR_DATE=$(date -d '-1 day' +%F)
fi

#获取00:00时间戳
start_date_unix=`date -d "$CUR_DATE 08:00:00" +%s`
start_date=$(($start_date_unix * 1000))

#获取24:00的时间戳
stop_date=$(($start_date + 86400000))

# 麒麟
kylin_username=ADMIN
kylin_password=KYLIN
kylin_hostname=192.168.99.130
kylin_port=7070

function build() {
  # $1: cube名称
  curl -X 'PUT' \
    -u "$kylin_username:$kylin_password" \
    -H 'Content-Type: application/json;charset=utf-8' \
    -d "{\"buildType\": \"BUILD\", \"startTime\": \"$start_date\", \"endTime\": \"$stop_date\"}" \
    "http://$kylin_hostname:$kylin_port/kylin/api/cubes/$1/build"
}

cube_list="cube1 cube2 cube2"
for cube in $cube_list
do
  build "$cube"
done
