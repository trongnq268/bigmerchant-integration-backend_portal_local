#!/usr/bin/python
from ctypes import sizeof
from operator import index, le
from re import T
from urllib import response
from numpy import size
import psycopg2
from config import config
import pandas as pd
from Param import Param
import json
from Util import create_vpc_param
from connect import connect
import urllib.parse


def get_by_id(id):
    try:
        conn = connect()
    # create a cursor
        cur = conn.cursor()

        # execute a statement
        sql = (
            "select * from bigmerchant.paraminput where group_case_id = %s order by id asc")
        cur.execute(sql, (id,))
        # close the communication with the PostgreSQL
        data = pd.DataFrame(cur.fetchall())
        list = []
        # print (data)
        for row in data.itertuples():
            param = Param()
            setValue(param, row)
            list.append(param)
        # for i in range(len(list)):
        #     param = list[i]
            # print(param.titleTestCase, param.request, param.reponse, param.url)
        return list
    finally:
        if conn is not None:
            conn.close()
            cur.close()


def get_json_data(id):
    list = get_by_id(id)
    jsonInput = []
    for i in range(len(list)):
        jsonInputParam = dict()
        param = list[i]
        data = dict()
        jsonInputParam["name"] = param.titleTestCase
        jsonInputParam["data"] = data
        c1 = dict()
        data["c1"] = c1
        request = dict()
        c1["request"] = request
        request["url"] = param.url
        request["method"] = param.method
        request["query_param"] = json.loads(param.request)
        c1["response"] = json.loads(param.response)
        jsonInput.append(jsonInputParam)
    return jsonInput


def get_map_Param(queryparam):
    return create_vpc_param(queryparam)

def get_map_Param(queryparam):
    return create_vpc_param(queryparam)


def setValue(param, row):
    if not checkNull(row[2]):
        param.titleTestCase = row[2]
    if not checkNull(row[3]):
        param.request = row[3]
    if not checkNull(row[4]):
        param.response = row[4]
    if not checkNull(row[6]):
        param.url = row[6]
    if not checkNull(row[7]):
        param.method = row[7]


def checkNull(input):
    return input is None or input == ''


def getListResponseBody(input):
    return input.split(",")


def checkResponseContains(responseBody, responseValueExpect, responseRegexExpect, responseContainExpect, mapParam):
    dictResponseBody = getDictResponseBody(responseBody)
    dictResponseValueExpect = getDictResponse(responseValueExpect)
    dictResponseRegexExpect = getDictResponse(responseRegexExpect)
    dictResponseContainExpect = getListResponseBody(responseContainExpect)

    flgCheck = True
    listObjectFail = []
    for key in dictResponseValueExpect.keys():
            if (key not in dictResponseBody.keys() and key != ''):
                listObjectFail.append(key)
                flgCheck = False
            if (key in dictResponseBody.keys() and dictResponseValueExpect[key] != dictResponseBody[key] and key != ''):
                listObjectFail.append(key)
                flgCheck = False
    for key in dictResponseContainExpect:

            if (key not in dictResponseBody.keys() and key != ''):
                listObjectFail.append(key)
                flgCheck = False
            if (key != '' and key in dictResponseBody.keys() and key in mapParam.keys() and dictResponseBody[key] != urllib.parse.quote_plus(mapParam[key]) and key != 'vpc_SecureHash'):
                listObjectFail.append(key)
                flgCheck = False

    return flgCheck, listObjectFail


def getDictResponseBody(responseBody):
    dictResponseBody = dict()
    if (len(responseBody) > 0):
        listResponseBody = responseBody.split("&")
        for respbody in listResponseBody:
            if (respbody != ''):
                x = respbody.split("=")
                dictResponseBody[x[0]] = x[1]
        return dictResponseBody


def getDictResponse(responseValue):
    dictResponse = dict()
    if (len(responseValue) > 0):
        listResponseBody = responseValue.split(",")
        for respbody in listResponseBody:
            if (respbody != ''):
                x = respbody.split("=")
                dictResponse[x[0]] = x[1]
        return dictResponse
    else:
        return dict()


if __name__ == '__main__':
    responseBody = 'vpc_Command=pay&vpc_Amount=1000000&vpc_AuthorizeId=831000&vpc_Card=VC&vpc_CardExp=0524&vpc_CardNum=400000xxx0002&vpc_CardUid=INS-kjBjd-ULTK7gUAB_AQBDlQ&vpc_MerchTxnRef=REF_1666149347206&vpc_Merchant=TESTONEPAY&vpc_Message=Approved&vpc_OrderInfo=Ma+Don+Hang&vpc_PayChannel=WEB&vpc_TransactionNo=PAY-Xz1OcTFySqutuCbv4kCfTA&vpc_TxnResponseCode=0&vpc_Version=2&vpc_BinCountry=US&vpc_Locale=en&vpc_PaymentTime=20221019T031549Z&vpc_MerchantAdviceCode=01&vpc_NetworkTransactionID=016153570198200&vpc_AcqResponseCode=00&vpc_CavvResponseCode=2&vpc_SecureHash=4447268CEE4EE6968839C2F2CBD98C466635656D9E559F7253B3B3E01C0E5FE3'
    responseValueExpect = 'vpc_TxnResponseCode=4'
    a = ''
    b = ''
    mapParam = {'vpc_SHIP_City': 'Ha Noi', 'vpc_OrderInfo': 'Ma Don Hang', 'vpc_Merchant': 'TESTONEPAY', 'vpc_Card': 'VC', 'vpc_Customer_Id': 'test', 'AgainLink': 'https://dev.onepay.vn/client/qt/dr/', 'mode': 'TEST_PAYGATE', 'vpc_ClientIP': '192.168.166.148', 'vpc_SHIP_Street01': '194 Tran Quang Khai', 'vpc_SHIP_Province': 'Hoan Kiem', 'vpc_Locale': 'en', 'vpc_Amount': '1000000', 'vpc_Version': '2', 'vpc_Currency': 'VND', 'vpc_Command': 'pay', 'vpc_Customer_Email': 'test@onepay.vn', 'Title': 'PHP+VPC+3-Party',
                'vpc_ReturnURL': 'https://dev.onepay.vn/client/qt/dr/', 'vpc_Customer_Phone': '84987654321', 'vpc_CardNum': '4000000000000002', 'vpc_AccessCode': '6BEB2546', 'vpc_TicketNo': '192.168.166.148', 'vpc_CardHolderName': 'NGUYEN VAN A', 'vpc_SHIP_Country': 'Viet Nam', 'vpc_3DSType': '2D', 'vpc_CardYear': '24', 'vpc_CardSecurityCode': '123', 'vpc_Customer_Name': 'Test User', 'vpc_CardMonth': '05', 'vpc_MerchTxnRef': 'REF_1666149443471', 'vpc_SecureHash': '7E908131F5DB4D6FE81C879A8190A4B3BE59317FF91A4E9439C08C2B65DC9D91'}
    checkResponseContains(responseBody, responseValueExpect, a, b, mapParam)
