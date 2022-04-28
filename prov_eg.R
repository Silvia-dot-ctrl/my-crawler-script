################################################################################
# Project: Government Reports
# Task: Scrape Data
################################################################################

################################################################################
# 0. Environment
################################################################################

# Start

rm(list = ls())
setwd("/Users/Desktop/GovReport") # Mac

# Packages

library(tidyverse)
library(rvest)
library(xml2)
library(httr)

################################################################################
# 1. Example: Beijing 2021
################################################################################

bj_2021 = read_html("http://www.beijing.gov.cn/gongkai/jihua/zfgzbg/202102/t20210201_2249908.html")

bj_2021 %>% html_elements("p")
bj_2021 %>% html_elements("div")

bj_2021_txt = bj_2021 %>% 
  html_elements("p") %>% 
  html_text2()

View(bj_2021_txt)

write.table(bj_2021_txt, file = "1.rawdatas/beijing_2021.txt", append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)

################################################################################
# 1. Beijing: 2002-2021                                                        
################################################################################

rm(list = ls())

# URL

url1 = "http://www.beijing.gov.cn/gongkai/jihua/zfgzbg/"

html1 = read_html(url1)

url2 = html1 %>% 
  html_elements("a") %>% 
  html_attr("href")

View(url2)

url3 = url2[5:24] %>%
  str_sub(3, -1)

View(url3)

# Text: Example

url = str_c(url1, url3[7])
html = read_html(url)

text = html %>%
  html_elements("p") %>% 
  html_text2()

text = html %>%
  html_elements("div") %>% 
  html_text2()

View(text)

row = min(str_which(text, "您访问的链接即将离开“首都之窗”门户网站 是否继续？")[1] - 1, length(text), na.rm = TRUE)
text = text[1:row]

# Text

year = c("2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", 
         "2009", "2008", "2007", "2006", "2005", "2004", "2003", "2002")

for(i in 1:20){
  url = str_c(url1, url3[i])
  html = read_html(url)
  text = html %>%
    html_elements("p") %>% 
    html_text2()
  row = min(str_which(text, "您访问的链接即将离开“首都之窗”门户网站 是否继续？")[1] - 1, length(text), na.rm = TRUE)
  text = text[1:row]
  report = tibble(text = text) %>%
    filter(text != "")
  path = str_c("1.rawdatas/beijing_", year[i], ".txt")
  write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)
}

View(text)

# Text: Supplement

## 2015

url = "http://www.beijing.gov.cn/gongkai/jihua/zfgzbg/201903/t20190321_1838382.html"
html = read_html(url)
text = html %>%
  html_elements("div") %>% 
  html_text2()
text = c(text[5], text[18:87])
text[1] = str_sub(text[1], 1, 46)
report = tibble(text = text) %>%
  filter(text != "")
path = "1.rawdatas/beijing_2015.txt"
write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)

################################################################################
# 2. Tianjin: 2003-2021
################################################################################

rm(list = ls())

# URL

url1_1 = "http://www.tj.gov.cn/zwgk/zfgzbg/index.html"
url1_2 = "http://www.tj.gov.cn/zwgk/zfgzbg/index_1.html"

html1_1 = read_html(url1_1)
html1_2 = read_html(url1_2)

url2_1 = html1_1 %>% 
  html_elements("a") %>% 
  html_attr("onclick")

url2_2 = html1_2 %>% 
  html_elements("a") %>% 
  html_attr("onclick")

View(url2_1)
View(url2_2)

url3_1 = url2_1[13:27] %>%
  str_sub(17, -3)

url3_2 = url2_2[13:16] %>%
  str_sub(17, -3)

View(url3_1)
View(url3_2)

url1 = "http://www.tj.gov.cn/zwgk/zfgzbg/"
url3 = c(url3_1, url3_2)

View(url3)

# Text: Example

url = str_c(url1, url3[1])
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()

View(text)

row = min(str_which(text, "附件：")[1] - 1, length(text), na.rm = TRUE)
text = text[1:row]

# Text

year = c("2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", 
         "2009", "2008", "2007", "2006", "2005", "2004", "2003")

for(i in 1:19){
  url = str_c(url1, url3[i])
  html = read_html(url)
  text = html %>%
    html_elements("p") %>% 
    html_text2()
  row = min(str_which(text, "附件：")[1] - 1, length(text), na.rm = TRUE)
  text = text[1:row]
  report = tibble(text = text) %>%
    filter(text != "")
  path = str_c("1.rawdatas/tianjin_", year[i], ".txt")
  write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)
}

View(text)

################################################################################
# 3. Hebei: 2003-2021, Miss 2015
################################################################################

rm(list = ls())

# URL

url1 = "http://www.hebei.gov.cn/hebei/14462058/14471802/14471805/index.html"

html1 = read_html(url1)

url2 = html1 %>% 
  html_elements("a") %>% 
  html_attr("href")

View(url2)

url3 = c(url2[48:53], url2[55:66]) # 2015 "Page Not Found"

View(url3)

# Text: Example

url = url3[1]
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()

View(text)

row = min(str_which(text, "　　来源：河北新闻网")[1] - 1, 
          str_which(text, "关于本站 | 联系我们 | 法律声明 | 网站地图") - 1, 
          length(text), na.rm = TRUE)
text = text[1:row]

# Text

year = c("2021", "2020", "2019", "2018", "2017", "2016", "2014", "2013", "2012", "2011", "2010", 
         "2009", "2008", "2007", "2006", "2005", "2004", "2003")

for(i in 1:18){
  url = url3[i]
  html = read_html(url)
  text = html %>%
    html_elements("p") %>% 
    html_text2()
  row = min(str_which(text, "　　来源：河北新闻网")[1] - 1, 
            str_which(text, "关于本站 | 联系我们 | 法律声明 | 网站地图") - 1, 
            length(text), na.rm = TRUE)
  text = text[1:row]
  report = tibble(text = text) %>%
    filter(text != "")
  path = str_c("1.rawdatas/hebei_", year[i], ".txt")
  write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)
}

View(text)

################################################################################
# 4. Shanxi                                                                      
################################################################################

rm(list = ls())

# URL

url1 = "http://www.shanxi.gov.cn/szf/zfgzbg/szfgzbg/"

html1 = read_html(url1)

html1 = url1 %>% GET(., timeout(30)) %>% read_html

################################################################################
# 5. Neimenggu: 1999-2021, Miss 2007                                                                      
################################################################################

rm(list = ls())

# URL

url1_1 = "http://www.nmg.gov.cn/zwgk/zfggbg/zzq/index.html"
url1_2 = "http://www.nmg.gov.cn/zwgk/zfggbg/zzq/index_1.html"

html1_1 = read_html(url1_1)
html1_2 = read_html(url1_2)

url2_1 = html1_1 %>% 
  html_elements("a") %>% 
  html_attr("href")

url2_2 = html1_2 %>% 
  html_elements("a") %>% 
  html_attr("href")

View(url2_1)
View(url2_2)

url3_1 = url2_1[43:57] %>%
  str_sub(3, -1)

url3_2 = url2_2[43:49] %>%
  str_sub(3, -1)

View(url3_1)
View(url3_2)

url1 = "http://www.nmg.gov.cn/zwgk/zfggbg/zzq/"
url3 = c(url3_1, url3_2)

View(url3)

# Text: Example

url = str_c(url1, url3[1])
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()

View(text)

row = min(str_which(text, "已收藏")[1] - 1L, length(text), na.rm = TRUE)
text = text[1:row]

# Text

year = c("2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", 
         "2009", "2008", "2006", "2005", "2004", "2003", "2002", "2001", "2000", "1999")

for(i in 1:22){
  url = str_c(url1, url3[i])
  html = read_html(url)
  text = html %>%
    html_elements("p") %>% 
    html_text2()
  row = min(str_which(text, "已收藏")[1] - 1L, length(text), na.rm = TRUE)
  text = text[1:row]
  report = tibble(text = text) %>%
    filter(text != "")
  path = str_c("1.rawdatas/neimenggu_", year[i], ".txt")
  write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)
}

View(text)

# Text: Supplement

## 2018

url = "http://www.nmg.gov.cn/zwgk/zfggbg/zzq/201807/t20180730_229821.html"
html = read_html(url)
text = html %>%
  html_elements("div") %>% 
  html_text2()
text = text[28:106]
report = tibble(text = text) %>%
  filter(text != "")
path = "1.rawdatas/neimenggu_2018.txt"
write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)

################################################################################
# 6. Liaoning:  2000-2021                                  
################################################################################

rm(list = ls())

# URL

url1_1 = "http://www.ln.gov.cn/zwgkx/zfgzbg/index.html"
url1_2 = "http://www.ln.gov.cn/zwgkx/zfgzbg/index_1.html"

html1_1 = read_html(url1_1)
html1_2 = read_html(url1_2)

url2_1 = html1_1 %>% 
  html_elements("a") %>% 
  html_attr("href")

url2_2 = html1_2 %>% 
  html_elements("a") %>% 
  html_attr("href")

View(url2_1)
View(url2_2)

url3_1 = c(url2_1[7], url2_1[9], url2_1[11:28]) %>%
  str_sub(3, -1)

url3_2 = url2_2[7:8] %>%
  str_sub(3, -1)

View(url3_1)
View(url3_2)

url1 = "http://www.ln.gov.cn/zwgkx/zfgzbg/"
url3 = c(url3_1, url3_2)

View(url3)

# Text: Example

url = str_c(url1, url3[11])
html = read_html(url, encoding = "GB18030")
text = html %>%
  html_elements("div") %>% 
  html_text2()

View(text)

# Text

year = c("2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", 
         "2009", "2008", "2007", "2006", "2005", "2004", "2003", "2002", "2001", "2000")

for(i in 1:22){
  url = str_c(url1, url3[i])
  html = read_html(url, encoding = "GB18030")
  text = html %>%
    html_elements("p") %>% 
    html_text2()
  report = tibble(text = text) %>%
    filter(text != "")
  path = str_c("1.rawdatas/liaoning_", year[i], ".txt")
  write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)
}

View(text)

# Text: Supplement

## 2011

url = "http://www.ln.gov.cn/zwgkx/zfgzbg/szfgzbg/201101/t20110127_617130.html"
html = read_html(url, encoding = "GB18030")
text = html %>%
  html_elements("div") %>% 
  html_text2()
View(text)
text = c(text[5:6], text[8], text[11])
locate = str_locate(text[4], "各位代表：")[1]
text[4] = str_sub(text[4], locate, -1)
report = tibble(text = text) %>%
  filter(text != "")
path = "1.rawdatas/liaoning_2011.txt"
write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)

## 2009

url = "http://www.ln.gov.cn/zwgkx/zfgzbg/szfgzbg/200901/t20090120_326248.html"
html = read_html(url, encoding = "GB18030")
text = html %>%
  html_elements("div") %>% 
  html_text2()
View(text)
text = c(text[5:6], text[8], text[11])
locate = str_locate(text[4], "各位代表：")[1]
text[4] = str_sub(text[4], locate, -1)
report = tibble(text = text) %>%
  filter(text != "")
path = "1.rawdatas/liaoning_2009.txt"
write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)

## 2008

url = "http://www.ln.gov.cn/zwgkx/zfgzbg/szfgzbg/200801/t20080130_161641.html"
html = read_html(url, encoding = "GB18030")
text = html %>%
  html_elements("div") %>% 
  html_text2()
View(text)
text = c(text[5:6], text[8], text[11])
locate = str_locate(text[4], "各位代表：")[1]
text[4] = str_sub(text[4], locate, -1)
report = tibble(text = text) %>%
  filter(text != "")
path = "1.rawdatas/liaoning_2008.txt"
write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)

## 2004

url = "http://www.ln.gov.cn/zwgkx/zfgzbg/szfgzbg/200709/t20070913_129044.html"
html = read_html(url, encoding = "GB18030")
text = html %>%
  html_elements("table") %>% 
  html_text2()
View(text)
text = c(text[4], text[6])
locate = str_locate(text[2], "各位代表：")[1]
text[2] = str_sub(text[2], locate, -1)
report = tibble(text = text) %>%
  filter(text != "")
path = "1.rawdatas/liaoning_2004.txt"
write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)

## 2003

url = "http://www.ln.gov.cn/zwgkx/zfgzbg/szfgzbg/200709/t20070913_129075.html"
html = read_html(url, encoding = "GB18030")
text = html %>%
  html_elements("table") %>% 
  html_text2()
View(text)
text = c(text[4], text[6])
locate = str_locate(text[2], "各位代表：")[1]
text[2] = str_sub(text[2], locate, -1)
report = tibble(text = text) %>%
  filter(text != "")
path = "1.rawdatas/liaoning_2003.txt"
write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)

## 2002

url = "http://www.ln.gov.cn/zwgkx/zfgzbg/szfgzbg/200709/t20070913_129087.html"
html = read_html(url, encoding = "GB18030")
text = html %>%
  html_elements("table") %>% 
  html_text2()
View(text)
text = c(text[4], text[6])
locate = str_locate(text[2], "各位代表：")[1]
text[2] = str_sub(text[2], locate, -1)
report = tibble(text = text) %>%
  filter(text != "")
path = "1.rawdatas/liaoning_2002.txt"
write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)

################################################################################
# 7. Jilin: 1999-2021; Miss 2019, 2018, 2006, 2005            
################################################################################

rm(list = ls())

# URL

url1_1 = "http://www.jl.gov.cn/zw/jcxxgk/gzbg/szfgzbg/index.html"
url1_2 = "http://www.jl.gov.cn/zw/jcxxgk/gzbg/szfgzbg/index_1.html"

html1_1 = read_html(url1_1)
html1_2 = read_html(url1_2)

url2_1 = html1_1 %>% 
  html_elements("a") %>% 
  html_attr("href")

url2_2 = html1_2 %>% 
  html_elements("a") %>% 
  html_attr("href")

View(url2_1)
View(url2_2)

url3_1 = url2_1[165:179] %>%
  str_sub(3, -1)

url3_2 = url2_2[165:168] %>%
  str_sub(3, -1)

View(url3_1)
View(url3_2)

url1 = "http://www.jl.gov.cn/zw/jcxxgk/gzbg/szfgzbg/"
url3 = c(url3_1, url3_2)

View(url3)

# Text: Example

url = str_c(url1, url3[1])
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()

View(text)

row1 = max(str_which(text, "当前位置")[1] + 1L, 1, na.rm = TRUE)
row2 = min(str_which(text, "网站地图")[1] - 1L, length(text), na.rm = TRUE)
text = text[row1:row2]

# Text

year = c("2021", "2020", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", 
         "2009", "2008", "2007", "2004", "2003", "2002", "2000", "1999", "2001")

for(i in 1:19){
  url = str_c(url1, url3[i])
  html = read_html(url)
  text = html %>%
    html_elements("p") %>% 
    html_text2()
  row1 = max(str_which(text, "当前位置")[1] + 1L, 1, na.rm = TRUE)
  row2 = min(str_which(text, "网站地图")[1] - 1L, length(text), na.rm = TRUE)
  text = text[row1:row2]
  report = tibble(text = text) %>%
    filter(text != "")
  path = str_c("1.rawdatas/jilin_", year[i], ".txt")
  write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)
}

View(text)

################################################################################
# 8. Heilongjiang: 2003-2021
################################################################################

rm(list = ls())

# URL

url1_1 = "https://www.hlj.gov.cn/31/40/68/index.html"
url1_2 = "https://www.hlj.gov.cn/31/40/68/index2.html"

html1_1 = read_html(url1_1)
html1_2 = read_html(url1_2)

url2_1 = html1_1 %>% 
  html_elements("a") %>% 
  html_attr("href")

url2_2 = html1_2 %>% 
  html_elements("a") %>% 
  html_attr("href")

View(url2_1)
View(url2_2)

url3_1 = url2_1[33:47] %>%
  str_sub(2, -1)

url3_2 = url2_2[33:36] %>%
  str_sub(2, -1)

View(url3_1)
View(url3_2)

url1 = "https://www.hlj.gov.cn/"
url3 = c(url3_1, url3_2)

View(url3)

# Text: Example

url = str_c(url1, url3[1])
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()

View(text)

# Text

year = c("2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", 
         "2009", "2008", "2007", "2006", "2005", "2004", "2003")

for(i in 1:19){
  url = str_c(url1, url3[i])
  html = read_html(url)
  text = html %>%
    html_elements("p") %>% 
    html_text2()
  report = tibble(text = text) %>%
    filter(text != "")
  path = str_c("1.rawdatas/heilongjiang_", year[i], ".txt")
  write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)
}

View(text)

################################################################################
# 9. Shanghai: 2004-2021
################################################################################

rm(list = ls())

# URL

url1 = "https://www.shanghai.gov.cn/nw12336/index.html"

html1 = read_html(url1)

url2 = html1 %>% 
  html_elements("a") %>% 
  html_attr("href")

View(url2)

url3 = url2[6:23] %>%
  str_sub(2, -1)

View(url3)

url1 = "https://www.shanghai.gov.cn/"

# Text: Example

url = str_c(url1, url3[1])
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()

View(text)

# Text

year = c("2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", 
         "2009", "2008", "2007", "2006", "2005", "2004")

for(i in 1:18){
  url = str_c(url1, url3[i])
  html = read_html(url)
  text = html %>%
    html_elements("p") %>% 
    html_text2()
  report = tibble(text = text) %>%
    filter(text != "")
  path = str_c("1.rawdatas/shanghai_", year[i], ".txt")
  write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)
}

View(text)

################################################################################
# 10. Jiangsu: 2003-2021
################################################################################

rm(list = ls())

# URL

url1 = "http://www.jiangsu.gov.cn/col/col33720/index.html"

html1 = read_html(url1)

url2 = html1 %>% 
  html_elements("script") %>%
  html_text2()
  
View(url2)

url3 = url2[4] %>%
  str_split("href='/") %>%
  .[[1]] %>%
  .[2:20] %>%
  str_extract("(.)+(.html)")

View(url3)

url1 = "http://www.jiangsu.gov.cn/"

# Text: Example

url = str_c(url1, url3[1])
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()

View(text)

# Text

year = c("2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", 
         "2009", "2008", "2007", "2006", "2005", "2004", "2003")

for(i in 1:19){
  url = str_c(url1, url3[i])
  html = read_html(url)
  text = html %>%
    html_elements("p") %>% 
    html_text2()
  report = tibble(text = text) %>%
    filter(text != "")
  path = str_c("1.rawdatas/jiangsu_", year[i], ".txt")
  write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)
}

View(text)

# Text: Supplement

## 2012

url = "http://www.jiangsu.gov.cn/art/2012/2/20/art_33720_2516916.html"
html = read_html(url)
text = html %>%
  html_elements("div") %>% 
  html_text2()
View(text)
text = c(text[10], text[12], text[14])
report = tibble(text = text) %>%
  filter(text != "")
path = "1.rawdatas/jiangsu_2012.txt"
write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)

## 2005

url = "http://www.jiangsu.gov.cn/art/2005/3/22/art_33720_2516909.html"
html = read_html(url)
text = html %>%
  html_elements("div") %>% 
  html_text2()
View(text)
text = c(text[7], text[11])
report = tibble(text = text) %>%
  filter(text != "")
path = "1.rawdatas/jiangsu_2005.txt"
write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)

################################################################################
# 11. Zhejiang: 1979-2021; Miss 1980
################################################################################

rm(list = ls())

# URL

url1 = "http://www.zj.gov.cn/col/col1229019379/index.html"

html1 = read_html(url1)

url2 = html1 %>% 
  html_elements("script") %>%
  html_text2()

View(url2)

url3 = url2[15] %>%
  str_split("\\<a") %>%
  .[[1]] %>%
  .[3:44] %>%
  str_extract("(http)(.)+(.html)")

View(url3)

# Text: Example

url = url3[1]
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()

View(text)

# Text

year = c("2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", 
         "2009", "2008", "2007", "2006", "2005", "2004", "2003", "2002", "2001", "2000", "1999", "1998", 
         "1997", "1996", "1995", "1994", "1993", "1992", "1991", "1990", "1989", "1988", "1987", "1986", 
         "1985", "1984", "1983", "1982", "1981", "1979")

for(i in 1:42){
  url = url3[i]
  html = read_html(url)
  text = html %>%
    html_elements("p") %>% 
    html_text2()
  report = tibble(text = text) %>%
    filter(text != "")
  path = str_c("1.rawdatas/zhejiang_", year[i], ".txt")
  write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)
}

View(text)

################################################################################
# 12. Anhui: 2002-2021
################################################################################

rm(list = ls())

# URL

url1 = "http://www.ah.gov.cn/public/column/1681?type=4&catId=6708531&action=list"

html1 = read_html(url1)

url2 = html1 %>% 
  html_elements("a") %>% 
  html_attr("href")

View(url2)

url3 = url2[54:89] %>%
  unique()

View(url3)

# Text: Example

url = url3[1]
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()

View(text)

# Text

year = c("2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", 
         "2009", "2008", "2007", "2006", "2005", "2004")

for(i in 1:18){
  url = url3[i]
  html = read_html(url)
  text = html %>%
    html_elements("p") %>% 
    html_text2()
  report = tibble(text = text) %>%
    filter(text != "")
  path = str_c("1.rawdatas/anhui_", year[i], ".txt")
  write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)
}

View(text)

# Text: Supplement

## 2015

url = "http://www.ah.gov.cn/public/1681/7965171.html"
html = read_html(url)
text = html %>%
  html_elements("div") %>% 
  html_text2()
View(text)
text = text[24]
report = tibble(text = text) %>%
  filter(text != "")
path = "1.rawdatas/anhui_2015.txt"
write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)

## 2003

url = "http://www.ah.gov.cn/public/1681/7965291.html"
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()
View(text)
report = tibble(text = text) %>%
  filter(text != "")
path = "1.rawdatas/anhui_2003.txt"
write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)

## 2002

url = "http://www.ah.gov.cn/public/1681/7965301.html"
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()
View(text)
report = tibble(text = text) %>%
  filter(text != "")
path = "1.rawdatas/anhui_2002.txt"
write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)

################################################################################
# 13. Fujian
################################################################################

# Government

rm(list = ls())

# URL

url1 = "http://www.fujian.gov.cn/szf/gzbg/zfgzbg/"

html1 = read_html(url1)

# CNKI

url1 = "https://pdf.unicom.d.cnki.net/cjfdsearch/getpdfdownload.asp?display=&encode=gb&zt=G108&m=&filename=mUFxGUUdmQhdETBFGODFlYMF2SPNzTKpHVQJTQEBFR5NjWudka0lzMwg2QMNXbJFkenVjT3EUa0UXZJp1bHtGaDhETwc1aMVzZQVFcvcUeU1EVuZjTv0EVPJFWB9UOI9Ga3U1dapUTs1mQNJEeOFnW=0TPRd2SrM1d3gUWLNEOSJGUWFzMXVUakFHOrB1Uz8kSrZUMKNlRz0GUxcEevtyaZp3TYNUdn9kWlJGNmVFZu1WQkh1M1lWUaNkaWR3Zr1GaNVnZwF2NLJXaxUzTxwWUS5UaNhHO61URrgDSndXWnp&filetitle=%D5%FE%B8%AE%B9%A4%D7%F7%B1%A8%B8%E6%5F2021%C4%EA1%D4%C224%C8%D5%D4%DA%B8%A3%BD%A8%CA%A1%B5%DA%CA%AE%C8%FD%BD%EC%C8%CB%C3%F1%B4%FA%B1%ED%B4%F3%BB%E1%B5%DA%CE%E5%B4%CE%BB%E1%D2%E9%C9%CF&pager=4-19&doi=CNKI:SUN:FJZB.0.2021-03-001&nettype=cnet&tnm=&u=WEEvREcwSlJHSldSdmVqMDh6a1dpNndxSnc1OE9NcFhZOG1KMDdXU09zMD0=$9A4hF_YAuvQ5obgVAqNKPCYcEjKensW4IQMovwHtwkF4VYPoHbKxJw!!&p=cjfz&cflag=&downtype=pdf4"

html1 = read_html(url1)

################################################################################
# 14. Jiangxi: 2004-2021
################################################################################

rm(list = ls())

# URL

url1 = "http://www.jiangxi.gov.cn/col/col392/index.html"

html1 = read_html(url1)

url2 = html1 %>% 
  html_elements("script") %>%
  html_text2()

View(url2)

url3 = url2[5] %>%
  str_split("href=\\\"") %>%
  .[[1]] %>%
  .[3:38] %>%
  str_extract("(http)(.)+(.html)") %>%
  unique()

View(url3)

# Text: Example

url = url3[1]
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()

View(text)

text[1] = str_replace(text[1], "\\<\\$\\[标题\\]\\>begin", "")
text[1] = str_replace(text[1], "\\<\\$\\[标题\\]\\>end", "")

# Text

year = c("2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", 
         "2009", "2008", "2007", "2006", "2005", "2004")

for(i in 1:18){
  url = url3[i]
  html = read_html(url)
  text = html %>%
    html_elements("p") %>% 
    html_text2()
  text[1] = str_replace(text[1], "\\<\\$\\[标题\\]\\>begin", "")
  text[1] = str_replace(text[1], "\\<\\$\\[标题\\]\\>end", "")
  report = tibble(text = text) %>%
    filter(text != "")
  path = str_c("1.rawdatas/jiangxi_", year[i], ".txt")
  write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)
}

View(text)

################################################################################
# 15. Shandong: 1994-2021
################################################################################

rm(list = ls())

# URL

url1 = "http://www.shandong.gov.cn/col/col101626/index.html?uid=243310&pageNum=1"

html1 = read_html(url1)

url2 = html1 %>% 
  html_elements("script") %>%
  html_text2()

View(url2)

url3 = url2[6] %>%
  str_split("\\<a") %>%
  .[[1]] %>%
  .[3:30] %>%
  str_extract("(http)(.)+(.html)")

View(url3)

# Text: Example

url = url3[1]
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()

View(text)

# Text

year = c("2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", 
         "2009", "2008", "2007", "2006", "2005", "2004", "2003", "2002", "2001", "2000", "1999", "1998", 
         "1997", "1996", "1995", "1994")

for(i in 1:28){
  url = url3[i]
  html = read_html(url)
  text = html %>%
    html_elements("p") %>% 
    html_text2()
  report = tibble(text = text) %>%
    filter(text != "")
  path = str_c("1.rawdatas/shandong_", year[i], ".txt")
  write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)
}

View(text)

################################################################################
# 16. Henan: 2001-2021
################################################################################

rm(list = ls())

# URL

url1 = "https://www.henan.gov.cn/zwgk/zfgzbg/"

html1 = read_html(url1)

url2 = html1 %>% 
  html_elements("a") %>% 
  html_attr("href")

View(url2)

url3 = url2[3:23]

View(url3)

# Text: Example

url = url3[1]
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()

View(text)

row1 = max(str_which(text, "首页 > 政务公开 > 政府工作报告")[1] + 1L, 1, na.rm = TRUE)
row2 = min(str_which(text, "扫一扫在手机打开当前页")[1] - 1L, length(text), na.rm = TRUE)
text = text[row1:row2]

# Text

year = c("2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", 
         "2009", "2008", "2007", "2006", "2005", "2004", "2003", "2002", "2001")

for(i in 1:21){
  url = url3[i]
  html = read_html(url)
  text = html %>%
    html_elements("p") %>% 
    html_text2()
  row1 = max(str_which(text, "首页 > 政务公开 > 政府工作报告")[1] + 1L, 1, na.rm = TRUE)
  row2 = min(str_which(text, "扫一扫在手机打开当前页")[1] - 1L, length(text), na.rm = TRUE)
  text = text[row1:row2]
  report = tibble(text = text) %>%
    filter(text != "")
  path = str_c("1.rawdatas/henan_", year[i], ".txt")
  write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)
}

View(text)

################################################################################
# 17. Hubei: 412 recondition Failed
################################################################################

rm(list = ls())

# URL

url1 = "https://www.hubei.gov.cn/szf/zfgzbg/"

html1 = read_html(url1)

################################################################################
# 18. Hunan: 2002-2021
################################################################################

rm(list = ls())

# URL

url1_1 = "https://www.hunan.gov.cn/hnszf/szf/zfgzbg/tygl_zrpx.html"
url1_2 = "https://www.hunan.gov.cn/hnszf/szf/zfgzbg/tygl_zrpx_2.html"

html1_1 = read_html(url1_1)
html1_2 = read_html(url1_2)

url2_1 = html1_1 %>% 
  html_elements("a") %>% 
  html_attr("href")

url2_2 = html1_2 %>% 
  html_elements("a") %>% 
  html_attr("href")

View(url2_1)
View(url2_2)

url3_1 = url2_1[22:39] %>%
  str_sub(2, -1)

url3_2 = url2_2[22:23] %>%
  str_sub(2, -1)

View(url3_1)
View(url3_2)

url1 = "https://www.hunan.gov.cn/"
url3 = c(url3_1, url3_2)

View(url3)

# Text: Example

url = str_c(url1, url3[1])
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()

View(text)

# Text

year = c("2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", 
         "2009", "2008", "2007", "2006", "2005", "2004", "2003", "2002")

for(i in 1:20){
  url = str_c(url1, url3[i])
  html = read_html(url)
  text = html %>%
    html_elements("p") %>% 
    html_text2()
  report = tibble(text = text) %>%
    filter(text != "")
  path = str_c("1.rawdatas/hunan_", year[i], ".txt")
  write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)
}

View(text)

################################################################################
# 19. Guangdong: 2000-2021
################################################################################

rm(list = ls())

# URL

url1 = "http://www.gd.gov.cn/zwgk/zfgzbg/index.html"

html1 = read_html(url1)

url2 = html1 %>% 
  html_elements("a") %>% 
  html_attr("href")

View(url2)

url3 = url2[14:35]

View(url3)

# Text: Example

url = url3[1]
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()

View(text)

row = min(str_which(text, "020-83135078")[1] - 1L, length(text), na.rm = TRUE)
text = text[1:row]

# Text

year = c("2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", 
         "2009", "2008", "2007", "2006", "2005", "2004", "2003", "2002", "2001", "2000")

for(i in 1:22){
  url = url3[i]
  html = read_html(url)
  text = html %>%
    html_elements("p") %>% 
    html_text2()
  row = min(str_which(text, "020-83135078")[1] - 1L, length(text), na.rm = TRUE)
  text = text[1:row]
  report = tibble(text = text) %>%
    filter(text != "")
  path = str_c("1.rawdatas/guangdong_", year[i], ".txt")
  write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)
}

View(text)

# Text: Supplement

## 2018

url = "http://www.gd.gov.cn/gkmlpt/content/0/146/post_146621.html#45"
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()
View(text)
row = min(str_which(text, "020-83135078")[1] - 1L, length(text), na.rm = TRUE)
text = text[1:row]
report = tibble(text = text) %>%
  filter(text != "")
path = "1.rawdatas/guangdong_2018.txt"
write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)

## 2017

url = "http://www.gd.gov.cn/gkmlpt/content/0/145/post_145789.html#45"
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()
View(text)
row = min(str_which(text, "020-83135078")[1] - 1L, length(text), na.rm = TRUE)
text = text[1:row]
report = tibble(text = text) %>%
  filter(text != "")
path = "1.rawdatas/guangdong_2017.txt"
write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)

## 2016

url = "http://www.gd.gov.cn/gkmlpt/content/0/144/post_144667.html#45"
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()
View(text)
row = min(str_which(text, "020-83135078")[1] - 1L, length(text), na.rm = TRUE)
text = text[1:row]
report = tibble(text = text) %>%
  filter(text != "")
path = "1.rawdatas/guangdong_2016.txt"
write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)

################################################################################
# 20. Guangxi: 2003-2021
################################################################################

rm(list = ls())

# URL

url1 = "http://www.gxzf.gov.cn/zwgk/gzbg/zfgzbg/"

html1 = read_html(url1)

url2 = html1 %>% 
  html_elements("a") %>% 
  html_attr("href")

View(url2)

url3 = url2[21:39] %>%
  str_sub(3, -1)

View(url3)

# Text: Example

url = str_c(url1, url3[1])
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()

View(text)

row = min(str_which(text, "文件下载：")[1] - 1L, length(text), na.rm = TRUE)
text = text[1:row]

# Text

year = c("2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", 
         "2009", "2008", "2007", "2006", "2005", "2004", "2003")

for(i in 1:19){
  url = str_c(url1, url3[i])
  html = read_html(url)
  text = html %>%
    html_elements("p") %>% 
    html_text2()
  row = min(str_which(text, "文件下载：")[1] - 1L, length(text), na.rm = TRUE)
  text = text[1:row]
  report = tibble(text = text) %>%
    filter(text != "")
  path = str_c("1.rawdatas/guangxi_", year[i], ".txt")
  write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)
}

View(text)

################################################################################
# 21. Hainan: 1999-2021; Miss 2006, 2011
################################################################################

rm(list = ls())

# URL

url1_1 = "https://www.hainan.gov.cn/hainan/szfgzbg/list3.shtml"
url1_2 = "https://www.hainan.gov.cn/hainan/szfgzbg/list3_2.shtml"

html1_1 = read_html(url1_1)
html1_2 = read_html(url1_2)

url2_1 = html1_1 %>% 
  html_elements("a") %>% 
  html_attr("href")

url2_2 = html1_2 %>% 
  html_elements("a") %>% 
  html_attr("href")

View(url2_1)
View(url2_2)

url3_1 = url2_1[25:36] %>%
  str_sub(2, -1)

url3_2 = url2_2[25:33] %>%
  str_sub(2, -1)

View(url3_1)
View(url3_2)

url1 = "https://www.hainan.gov.cn/"
url3 = c(url3_1, url3_2)

View(url3)

# Text: Example

url = str_c(url1, url3[1])
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()

View(text)

row = min(str_which(text, "相关稿件")[1] - 1L, length(text), na.rm = TRUE)
text = text[1:row]

# Text

year = c("2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012", "2010", 
         "2009", "2008", "2007", "2005", "2004", "2003", "2002", "2001", "2000", "1999")

for(i in 1:21){
  url = str_c(url1, url3[i])
  html = read_html(url)
  text = html %>%
    html_elements("p") %>% 
    html_text2()
  row = min(str_which(text, "相关稿件")[1] - 1L, length(text), na.rm = TRUE)
  text = text[1:row]
  report = tibble(text = text) %>%
    filter(text != "")
  path = str_c("1.rawdatas/hainan_", year[i], ".txt")
  write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)
}

View(text)

################################################################################
# 22. Chongqing: 2003-2021; Miss 2017, 2016, 2015, 2014, 2012, 2011, 2010, 2009
################################################################################

rm(list = ls())

# URL

url1 = "http://www.cq.gov.cn/zwgk/zfxxgkml/zfgzbg/"

html1 = read_html(url1)

url2 = html1 %>% 
  html_elements("a") %>% 
  html_attr("href")

View(url2)

url3 = url2[27:37] %>%
  str_sub(3, -1)

View(url3)

# Text: Example

url = str_c(url1, url3[1])
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()

View(text)

row1 = max(str_which(text, "首页>")[1] + 1L, 1, na.rm = TRUE)
row2 = min(str_which(text, "版权所有")[1] - 1L, length(text), na.rm = TRUE)
text = text[row1:row2]

# Text

year = c("2021", "2020", "2019", "2018", "2013", "2008", "2007", "2006", "2005", "2004", "2003")

for(i in 1:11){
  url = str_c(url1, url3[i])
  html = read_html(url)
  text = html %>%
    html_elements("p") %>% 
    html_text2()
  row1 = max(str_which(text, "首页>")[1] + 1L, 1, na.rm = TRUE)
  row2 = min(str_which(text, "版权所有")[1] - 1L, length(text), na.rm = TRUE)
  text = text[row1:row2]
  report = tibble(text = text) %>%
    filter(text != "")
  path = str_c("1.rawdatas/chongqing_", year[i], ".txt")
  write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)
}

View(text)

################################################################################
# 23. Sichuan: 2012-2021
################################################################################

rm(list = ls())

# URL

url1 = "http://www.sc.gov.cn/10462/10464/10699/10700/zfgzbglist.shtml"

html1 = read_html(url1)

url2 = html1 %>% 
  html_elements("a") %>% 
  html_attr("href")

View(url2)

url3 = url2[24:33] %>%
  str_sub(2, -1)

View(url3)

url1 = "http://www.sc.gov.cn/"

# Text: Example

url = str_c(url1, url3[1])
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()

View(text)

row1 = max(str_which(text, "20")[1] + 1L, 1, na.rm = TRUE)
row2 = min(str_which(text, "主管单位：")[1] - 1L, length(text), na.rm = TRUE)
text = text[row1:row2]

# Text

year = c("2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012")

for(i in 1:10){
  url = str_c(url1, url3[i])
  html = read_html(url)
  text = html %>%
    html_elements("p") %>% 
    html_text2()
  row1 = max(str_which(text, "20")[1] + 1L, 1, na.rm = TRUE)
  row2 = min(str_which(text, "主管单位：")[1] - 1L, length(text), na.rm = TRUE)
  text = text[row1:row2]
  report = tibble(text = text) %>%
    filter(text != "")
  path = str_c("1.rawdatas/sichuan_", year[i], ".txt")
  write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)
}

View(text)

################################################################################
# 24. Guizhou: 2007-2021
################################################################################

rm(list = ls())

# URL

url1 = "http://www.guizhou.gov.cn/zwgk/gzbg_8219/szfgzbg/"

html1 = read_html(url1)

url2 = html1 %>% 
  html_elements("a") %>% 
  html_attr("href")

View(url2)

url3 = url2[27:41]

View(url3)

# Text: Example

url = url3[1]
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()

View(text)

row = min(str_which(text, "扫一扫")[1] - 1L, length(text), na.rm = TRUE)
text = text[1:row]

# Text

year = c("2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", 
         "2009", "2008", "2007")

for(i in 1:15){
  url = url3[i]
  html = read_html(url)
  text = html %>%
    html_elements("p") %>% 
    html_text2()
  row = min(str_which(text, "扫一扫")[1] - 1L, length(text), na.rm = TRUE)
  text = text[1:row]
  report = tibble(text = text) %>%
    filter(text != "")
  path = str_c("1.rawdatas/guizhou_", year[i], ".txt")
  write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)
}

View(text)

################################################################################
# 25. Yunnan: 2015-2021
################################################################################

rm(list = ls())

# URL

url1 = "http://www.yn.gov.cn/zwgk/zfxxgk/zfgzbg/"

html1 = read_html(url1)

url2 = html1 %>% 
  html_elements("a") %>% 
  html_attr("href")

View(url2)

url3 = url2[22:28] %>%
  str_sub(3, -1)

View(url3)

# Text: Example

url = str_c(url1, url3[1])
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()

View(text)

# Text

year = c("2021", "2020", "2019", "2018", "2017", "2016", "2015")

for(i in 1:7){
  url = str_c(url1, url3[i])
  html = read_html(url)
  text = html %>%
    html_elements("p") %>% 
    html_text2()
  report = tibble(text = text) %>%
    filter(text != "")
  path = str_c("1.rawdatas/yunnan_", year[i], ".txt")
  write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)
}

View(text)

################################################################################
# 26. Xizang: 2009-2021
################################################################################

rm(list = ls())

# URL

url1 = "http://www.xizang.gov.cn/zwgk/xxfb/zfgzbg/"

html1 = read_html(url1)

url2 = html1 %>% 
  html_elements("a") %>% 
  html_attr("href")

View(url2)

url3 = url2[25:37] %>%
  str_sub(3, -1)

View(url3)

# Text: Example

url = str_c(url1, url3[1])
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()

View(text)

row1 = max(str_which(text, "小 中 大")[1] + 1L, 1, na.rm = TRUE)
row2 = min(str_which(text, "中央各部委网站")[1] - 1L, length(text), na.rm = TRUE)
text = text[row1:row2]

# Text

year = c("2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", 
         "2009")

for(i in 1:13){
  url = str_c(url1, url3[i])
  html = read_html(url)
  text = html %>%
    html_elements("p") %>% 
    html_text2()
  row1 = max(str_which(text, "小 中 大")[1] + 1L, 1, na.rm = TRUE)
  row2 = min(str_which(text, "中央各部委网站")[1] - 1L, length(text), na.rm = TRUE)
  text = text[row1:row2]
  report = tibble(text = text) %>%
    filter(text != "")
  path = str_c("1.rawdatas/xizang_", year[i], ".txt")
  write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)
}

View(text)

################################################################################
# 27. Shannxi: 2001-2021; Miss 2001
################################################################################

rm(list = ls())

# URL

url1_1 = "http://www.shaanxi.gov.cn/zfxxgk/zfgzbg/szfgzbg/index.html"
url1_2 = "http://www.shaanxi.gov.cn/zfxxgk/zfgzbg/szfgzbg/index_1.html"

html1_1 = read_html(url1_1)
html1_2 = read_html(url1_2)

url2_1 = html1_1 %>% 
  html_elements("a") %>% 
  html_attr("href")

url2_2 = html1_2 %>% 
  html_elements("a") %>% 
  html_attr("href")

View(url2_1)
View(url2_2)

url3_1 = url2_1[31:50] %>%
  str_sub(3, -1)

url3_2 = url2_2[31] %>%
  str_sub(3, -1)

View(url3_1)
View(url3_2)

url1 = "http://www.shaanxi.gov.cn/zfxxgk/zfgzbg/szfgzbg/"
url3 = c(url3_1, url3_2)

View(url3)

# Text: Example

url = str_c(url1, url3[21])
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()

View(text)

row = min(str_which(text, "扫一扫")[1] - 1L, length(text), na.rm = TRUE)
text = text[1:row]

# Text

year = c("2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", 
         "2009", "2008", "2007", "2006", "2005", "2002", "2003", "2001", "2004")

for(i in 1:21){
  url = str_c(url1, url3[i])
  html = read_html(url)
  text = html %>%
    html_elements("p") %>% 
    html_text2()
  row = min(str_which(text, "扫一扫")[1] - 1L, length(text), na.rm = TRUE)
  text = text[1:row]
  report = tibble(text = text) %>%
    filter(text != "")
  path = str_c("1.rawdatas/shannxi_", year[i], ".txt")
  write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)
}

View(text)

# Text: Supplement

## 2008

url = "http://www.shaanxi.gov.cn/zfxxgk/zfgzbg/szfgzbg/200801/t20080129_1473051.html"
html = read_html(url)
text = html %>%
  html_elements("div") %>% 
  html_text2()
View(text)
text = text[18]
text
locate1 = str_locate(text, "分享")[[1]] - 1L
locate2 = str_locate(text, "各位代表：")[[1]]
locate3 = str_locate(text, "var")[[1]] - 1L
text = c(str_sub(text, 1, locate1), str_sub(text, locate2, locate3))
report = tibble(text = text) %>%
  filter(text != "")
path = "1.rawdatas/shannxi_2008.txt"
write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)

## 2006

url = "http://www.shaanxi.gov.cn/zfxxgk/zfgzbg/szfgzbg/200602/t20060213_1472981.html"
html = read_html(url)
text = html %>%
  html_elements("div") %>% 
  html_text2()
View(text)
text = text[18]
text
locate1 = str_locate(text, "分享")[[1]] - 1L
locate2 = str_locate(text, "各位代表：")[[1]]
locate3 = str_locate(text, "var")[[1]] - 1L
text = c(str_sub(text, 1, locate1), str_sub(text, locate2, locate3))
report = tibble(text = text) %>%
  filter(text != "")
path = "1.rawdatas/shannxi_2006.txt"
write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)

## 2004

url = "http://www.shaanxi.gov.cn/zfxxgk/zfgzbg/szfgzbg/200402/t20040212_1472838.html"
html = read_html(url)
text = html %>%
  html_elements("div") %>% 
  html_text2()
View(text)
text = text[18]
text
locate1 = str_locate(text, "分享")[[1]] - 1L
locate2 = str_locate(text, "各位代表：")[[1]]
locate3 = str_locate(text, "var")[[1]] - 1L
text = c(str_sub(text, 1, locate1), str_sub(text, locate2, locate3))
report = tibble(text = text) %>%
  filter(text != "")
path = "1.rawdatas/shannxi_2004.txt"
write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)

################################################################################
# 28. Gansu: 2008-2021
################################################################################

rm(list = ls())

# URL

url1 = "http://www.gansu.gov.cn/col/col10339/index.html"

html1 = read_html(url1)

url2 = html1 %>% 
  html_elements("a") %>% 
  html_attr("href")

View(url2)

url3 = url2[40:53] %>%
  str_sub(2, -1)

View(url3)

url1 = "http://www.gansu.gov.cn/"

# Text: Example

url = str_c(url1, url3[1])
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()

View(text)

# Text

year = c("2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", 
         "2009", "2008")

for(i in 1:14){
  url = str_c(url1, url3[i])
  html = read_html(url)
  text = html %>%
    html_elements("p") %>% 
    html_text2()
  report = tibble(text = text) %>%
    filter(text != "")
  path = str_c("1.rawdatas/gansu_", year[i], ".txt")
  write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)
}

View(text)

################################################################################
# 29. Qinghai: 2012-2021
################################################################################

rm(list = ls())

# URL

url1 = "http://zwgk.qh.gov.cn/xxgk/gzbg/"

html1 = read_html(url1)

url2 = html1 %>% 
  html_elements("a") %>% 
  html_attr("href")

View(url2)

url3 = url2[14:23] %>%
  str_sub(3, -1)

View(url3)

# Text: Example

url = str_c(url1, url3[5])
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()

View(text)

row1 = max(str_which(text, "发布时间： ")[1] + 1L, 1, na.rm = TRUE)
row2 = min(str_which(text, "主办：")[1] - 1L, length(text), na.rm = TRUE)
text = text[row1:row2]

# Text

year = c("2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012")

for(i in 1:10){
  url = str_c(url1, url3[i])
  html = read_html(url)
  text = html %>%
    html_elements("p") %>% 
    html_text2()
  row1 = max(str_which(text, "发布时间： ")[1] + 1L, 1, na.rm = TRUE)
  row2 = min(str_which(text, "主办：")[1] - 1L, length(text), na.rm = TRUE)
  text = text[row1:row2]
  report = tibble(text = text) %>%
    filter(text != "")
  path = str_c("1.rawdatas/qinghai_", year[i], ".txt")
  write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)
}

View(text)

################################################################################
# 30. Ningxia: 2013-2021; Miss 2017
################################################################################

rm(list = ls())

# URL

url1 = "http://www.nx.gov.cn/zzsl/zfgzbg/"

html1 = read_html(url1)

url2 = html1 %>% 
  html_elements("a") %>% 
  html_attr("href")

View(url2)

url3 = c(url2[17:19], url2[26], url2[32:36]) %>%
  str_sub(3, -1)

View(url3)

# Text: Example

url = str_c(url1, url3[1])
html = read_html(url)
text = html %>%
  html_elements("p") %>% 
  html_text2()

View(text)

row = min(str_which(text, "关于我们")[1] - 1L, length(text), na.rm = TRUE)
text = text[1:row]

# Text

year = c("2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013")

for(i in 1:9){
  url = str_c(url1, url3[i])
  html = read_html(url)
  text = html %>%
    html_elements("p") %>% 
    html_text2()
  row = min(str_which(text, "关于我们")[1] - 1L, length(text), na.rm = TRUE)
  text = text[1:row]
  report = tibble(text = text) %>%
    filter(text != "")
  path = str_c("1.rawdatas/ningxia_", year[i], ".txt")
  write.table(report, path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE)
}

View(text)

################################################################################
# 31. Xinjiang
################################################################################

rm(list = ls())

# URL

url1 = "http://www.xinjiang.gov.cn/xinjiang/gzbg/common_list.shtml"

html1 = read_html(url1)
