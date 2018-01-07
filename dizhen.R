# 载入需要的包
# library(XML)
# library(xml2)
# library(rvest)
library(rjson)
library(bitops)
library(RCurl)
library(tidyverse)
library(sp)
library(maptools)

wd0<-getwd()
setwd("D:/dizhen")

######################
#第一部分：清理数据
######################

dizhen<-read.csv("eq.data.csv",stringsAsFactors=F)
dizhen<-as_tibble(dizhen)
dizhen.new<-filter(dizhen,zhenji>=2,jingdu >= 73.4 & jingdu <= 135.2, weidu>=3.52 & weidu<=53.33)

# 最东端 东经135度2分30秒 黑龙江和乌苏里江交汇处 
# 最西端 东经73度40分 帕米尔高原乌兹别里山口（乌恰县） 
# 最南端 北纬3度52分 南沙群岛曾母暗沙 
# 最北端 北纬53度33分 漠河以北黑龙江主航道（漠河)https://zhidao.baidu.com/question/305112660.html

dates<-paste(dizhen.new$dates,dizhen.new$time, sep = " ")
dates<-strptime(dates, "%Y/%m/%d %H:%M")
dates.year<-format(dates,"%Y")
dates.month<-format(dates,"%m")
dates.weekday<-weekdays(dates)
dates.day<-format(dates,"%d")
dates.hour<-format(dates,"%H")

dizhen<-tibble(year=dates.year,month=dates.month, weekday=dates.weekday,day=dates.day,hour=dates.hour,
               weidu=dizhen.new$weidu,jingdu=dizhen.new$jingdu,shendu=dizhen.new$shendu,zhenji=dizhen.new$zhenji,
               diming=dizhen.new$diming)

dizhen$shendu[dizhen$shendu==999]<-NA
dizhen$diming[dizhen$diming==""]<-NA

write.csv(dizhen,"dizhen.csv")

######################
#第二部分：搜集数据
######################
#输入高德地图的key
key<-c("8c0671ce17604a6f3e22a2daa81d9aad",
       "15d13f0776ad866fdf643414ef8adbfb",
       "66279873dfd26bcb159007c253565590",
       "c8eb8d2bb7394d904eb95369dec4aefd",
       "1dc9410699af52908b478ac97495351d")
