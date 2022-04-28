# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
#首先要pip install sec_edgar_downloader,然后运行即可
import time
import json
from sec_edgar_downloader import Downloader

dl = Downloader("I:/sec-downloader") #改路径，选择下载的10k放在哪里
f_obj = open("I:/ticker.json") #改路径，确保能找到ticker的文件
dic = json.load(f_obj)
for i in range(3001,10000):#循环控制区  
    dl.get("10-K",dic[str(i)]['ticker'])
    time.sleep(60) 
    

