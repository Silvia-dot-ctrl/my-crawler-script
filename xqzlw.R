#ahmhxc.com scrape data


# Start

rm(list = ls()) #delete all objects
setwd("F:/Text Analysis/ʡ???????????��?")
# Packages

library(tidyverse)
library(rvest)
library(xml2)
library(httr)
library(readxl)

#all URL

URL = read_xlsx("??????????????????��??(1).xlsx")
#n = row_number(URL)
URL = as.matrix(URL)
n = nrow(URL)

#116.149.151.154.298.401.437.519.520.540.581.736.797.878.924.1030.1055.1351.1517.1673.1708.1787
#1904.2124.2130.2184.2187.2280.2364.2385.2424.2456.2563.2620.2940.2965.2993.3255.3357.3393.3443
#3614.3619.3631.3788.3997.4054.4056.4073.4075.4097.4098.4188.4213.4277.4289.4290.4355.4374.4455
#5001.5025.5030.5034.5064.5200 Ҫ??֤??
#6137.6159.6223.6245.6272.6292.6345.6352.6353.6575.6768.6805.6889.6890.6897.6906.6920.6937
for(j in 5200:6999){
  
  report = data.frame(text='text')
  
  url = URL[j,1]
  html = read_html(url,encoding='GBK')
  title = html %>%
    html_nodes(xpath = '/html/head/title') %>%
    html_text()

  for (i in 1:20) {
    if (i==1){
      suburl = url
      #?????     suburl = paste(substr(url,start=1,stop = nchar(url)-5),'_',i,'.html',sep='')
      #?????bhtml = read_html(suburl,encoding='GBK')
    #??ȡhtm subtext = subhtml %>%
      html_nodes("p") %>%
      html_text()
    #??�  subreport = tibble(text = subtext) %>%
      filter(subtext != "")
    
    report = rbind(report,subreport)
    #???nktitle = subhtml %>%
      html_nodes("a") %>%
      html_text()
    #??????�(linktitle=='βҳ')==0){#?????У??ǾͿ???֪??????βҳ?????ü??????????ˣ?????ѭ??
      break
    }
  }
  
  report = data.frame(text = report[-1,])
  
  path = str_c("xqraw/",title,".txt") # set saving path
  write.table(report[2:300,1], path, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE) # write table
  date_time<-Sys.time()
  while((as.numeric(Sys.time()) - as.numeric(date_time))<1){} #dummy while loop
}



zgjjw = read_xlsx("?й???????  ?м?????????.xlsx")
for(m in 84:304){
  report = data.frame(text='text')
  report = data.frame(text = zgjjw[m,3])
  path_inst = str_c("zhjjw/",zgjjw[m,1],".txt") # set saving path
  write.table(report, path_inst, append = FALSE, quote = FALSE, sep = "\n", row.names = FALSE, col.names = FALSE) # write table
}

