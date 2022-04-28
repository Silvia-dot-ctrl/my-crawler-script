# -*- coding: utf-8 -*-
"""
Created on Tue May  4 20:20:52 2021

@author: Administrator
"""

import logging
from logging import Formatter
from urllib.request import Request, urlopen
import json
from threading import Thread
from urllib import parse, error
from logging.handlers import TimedRotatingFileHandler
from queue import Queue,Empty
import time

#日志路径
LOG_PATH = 'log'
log_file_handler = TimedRotatingFileHandler(filename=LOG_PATH, when="D", interval=1)
log_file_handler.setFormatter(Formatter('%(asctime)s,%(thread)d :  %(levelname)s  %(message)s'))
logging.basicConfig(level='DEBUG')
log = logging.getLogger()
log.addHandler(log_file_handler)


# 获取数据URL 参数 : area: 0, word: 关键词, startDate: 开始日期(yyyy-MM-dd), endDate: 结束日期(可空)
API_URL="http://index.baidu.com/api/SearchApi/index?%s"
# 默认开始日期
DEFAULT_START_DATE='2020-01-01'
# 默认area
DEFAULT_AREA = 0
# 编码
API_ENCODING = 'utf-8'
DEFAULT_USER_AGNET='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3554.0 Safari/537.36'
# 获取解密key URL 参数 : uniqid: API_URL 获取的数据的['uniqid']
DECRYPT_URL='http://index.baidu.com/Interface/ptbk?%s'

THREAD_COUNT = 5

# 如果空就返回 default_val
def get_default_if_empty(item,key,default_val):
    if key in item and item[key].strip() != '':
        return item[key].strip()
    else:
        return default_val

# 获取关键词列表
# 返回格式 [ {'area': 0, 'word': '','startDate':'2020-02-01','endDate':''}, ]
def get_param_queue():
    param_queue = Queue()
    #for item in results:
    #    word = get_default_if_empty(item,'word','')
    #    if word != '':
    #        param = {
    #            'area': DEFAULT_AREA,
    #            'word': word,
    #            'startDate': get_default_if_empty(item,'startDate',DEFAULT_START_DATE),
    #            'endDate': get_default_if_empty(item,'endDate','')
    #        }
    #        param_queue.put(param,True)
    return param_queue

# 保存结果
def save_result(word,start_date,end_date,decrypt_arr):
    pass

# 获取登录百度的 cookie
def get_cookie():
	return ''

def get_one_request(url, reqnum=5):
	# 提前处理好 cookie 不然 api 会提示要登录
	cookie_str = get_cookie()
    req = Request(url, method="GET",headers={
        'Cookie': cookie_str,
        'User-Agent': DEFAULT_USER_AGNET
    })
    try:
        response = urlopen(req)
        info = response.read().decode(API_ENCODING)
        data = json.loads(info)
        return data
    except error.HTTPError as e:
        print(e.code)
        if reqnum > 0:
            time.sleep(5)
            return get_one_request(url, reqnum-1)
        else:
            log.error('%s 请求错误, 重试次数超过' % (url))
            log.error(e)
    except Exception as e:
        log.error(e)
        log.error('%s 请求失败, 正在重试 %s' % (url, 6-reqnum))
        if reqnum > 0:
            time.sleep(5)
            return get_one_request(url, reqnum-1)
        else:
            log.error('%s 请求失败, 重试次数超过' % (url))
    # 超出重试次数 返回空
    return None

# 解密
def decrypt_api_data(data,decrypt_key):
    try:
        tmp = {}
        for i in range(len(decrypt_key)//2):
            tmp[decrypt_key[i]] = decrypt_key[len(decrypt_key)//2+i]
        ret_data = ''
        for i in range(len(data)):
            ret_data += tmp[data[i]]
        return ret_data.split(',') 
    except Exception as e:
        log.error('解密出错')
        log.error('data: %s',data)
        log.error('decrypt_key: %s'%decrypt_key)
        log.error(e)
    return []

# 处理一次请求
def handle_one_request(param_queue:Queue,):
    while True:
        try:
            param = param_queue.get(True,1)
            
            param_data = parse.urlencode(param, encoding=API_ENCODING)
            url = API_URL % param_data
            log.info(url)
            data = get_one_request(url)
            if data is not None:
                uniqid = data['data']['uniqid']
                decrypt_url = DECRYPT_URL%parse.urlencode({'uniqid': uniqid},encoding=API_ENCODING)
                decrypt_ret =get_one_request(decrypt_url)
                if decrypt_ret is not None:
                    decrypt_arr = decrypt_api_data(data['data']['userIndexes'][0]['all']['data'],decrypt_ret['data'])
                    start_date = data['data']['userIndexes'][0]['all']['startDate']
                    end_date = data['data']['userIndexes'][0]['all']['endDate']
                    word = data['data']['userIndexes'][0]['word']
                    log.info('%s, %s, %s, %s',word,start_date,end_date,decrypt_arr)
                    save_result(word,start_date,end_date,decrypt_arr)
            param_queue.task_done()
            time.sleep(1)
        except Empty as e:
            # 队列已空
            log.info('empty queue')
            break
        except Exception as e:
            log.error(e)
            log.error(param)
            param_queue.task_done()
            break
        finally:
            pass

if __name__ == '__main__':
    param_queue = get_param_queue()
    log.info('queue length: %s'% param_queue.qsize())
    pool = []
    for i in range(THREAD_COUNT):
        th = Thread(target=handle_one_request,args=(param_queue))
        pool.append(th)
        th.setDaemon(False)
        th.start()
    
    param_queue.join()
    for th in pool:
        th.join()

    log.info('finish job')
