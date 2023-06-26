#!/usr/bin/python
from ctypes import sizeof
from operator import index, le
from re import T
from unicodedata import name
from urllib import response
from numpy import size
import psycopg2
import pandas as pd
import json
import urllib.parse
from csv import DictReader
import csv
import os
from os.path import dirname as up
import xlrd

def check_response_content(statusCode, resText, resExpect):

    # Response To Robot Script
    flgCheck = True
    listObjectFail = []
    totalPassed = 0
    totalFailed = 0
    body = json.loads(resText)



    transactions = body["transactions"]
    
    # ================ Check Response Valid ==================#
    if("total_items" not in body):
        flgCheck = False

                
    # ================ Check Response Valid ==================#
    # listCheck = list(eval(resExpect))
    for val in resExpect:
        if val["field"] != "" and val["field"] is not None:
            for tran in transactions:
                jsonTran = flatten_json(tran)
                if val["condition"] == "equal" and val["value"] != jsonTran[val["field"]]:
                    flgCheck = False
                    listObjectFail.append(jsonTran["transaction_id"] + "-"+ val["field"] + "-" + jsonTran[val["field"]])
                    totalFailed += 1
                if val["condition"] == "less" and jsonTran[val["field"]] >= val["value"]:
                    flgCheck = False
                    listObjectFail.append(jsonTran["transaction_id"] + "-"+ val["field"] + "-" + jsonTran[val["field"]])
                    totalFailed += 1
                if val["condition"] == "more" and jsonTran[val["field"]] <= val["value"]:
                    flgCheck = False
                    listObjectFail.append(jsonTran["transaction_id"] + "-"+ val["field"] + "-" + jsonTran[val["field"]])
                    totalFailed += 1
                else:
                    totalPassed +=1

    return flgCheck, listObjectFail, totalPassed, totalFailed

def check_response_detail(statusCode, resText, resExpect):
    # Response To Robot Script
    flgCheck = True
    listObjectFail = []
    totalPassed = 0
    totalFailed = 0
    tran = json.loads(resText)



    # transactions = body["transactions"]
    
    # ================ Check Response Valid ==================#
    # if("total_items" not in body):
    #     flgCheck = False

                
    # ================ Check Response Valid ==================#
    # listCheck = list(eval(resExpect))
    for val in resExpect:
        if val["field"] != "" and val["field"] is not None:
            # for tran in transactions:
                jsonTran = flatten_json(tran)
                if val["condition"] == "equal" and val["value"] != jsonTran[val["field"]]:
                    flgCheck = False
                    listObjectFail.append(jsonTran["transaction_id"] + "-"+ val["field"] + "-" + jsonTran[val["field"]])
                    totalFailed += 1
                if val["condition"] == "less" and jsonTran[val["field"]] >= val["value"]:
                    flgCheck = False
                    listObjectFail.append(jsonTran["transaction_id"] + "-"+ val["field"] + "-" + jsonTran[val["field"]])
                    totalFailed += 1
                if val["condition"] == "more" and jsonTran[val["field"]] <= val["value"]:
                    flgCheck = False
                    listObjectFail.append(jsonTran["transaction_id"] + "-"+ val["field"] + "-" + jsonTran[val["field"]])
                    totalFailed += 1
                else:
                    totalPassed +=1

    return flgCheck, listObjectFail, totalPassed, totalFailed

def flatten_json(y):
    out = {}
    def flatten(x, name=''):
        if type(x) is dict:
            for a in x:
                flatten(x[a], name + a + '_')
        elif type(x) is list:
            i = 0
            for a in x:
                flatten(a, name + str(i) + '_')
                i += 1
        else:
            out[name[:-1]] = x
    flatten(y)
    return out


def get_ids(responseBody):
    body = json.loads(responseBody)
    transactions = body["transactions"]
    ids = []
    for tran in transactions:
        ids.append(tran["id"])
    return ids

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

def get_param_from_xlsx(filePath, index):
    workbook = xlrd.open_workbook(filePath)

    worksheet = workbook.sheet_by_name(index)
    
    listInput = []
    listOutput = []

    listParams = worksheet.merged_cells
    for param in listParams:
        rlo, rhi, clo, chi = param
        dictParamInput = {}
        dictParamOutput = {}
        print(param)
        listConditions = []
        if clo != 0:
            continue
        for i in range(rlo, rhi):
            fieldInput = worksheet.cell_value(i, chi)
            valueInput = worksheet.cell_value(i, chi + 1)
            print(fieldInput)
            print(valueInput)
            
            if fieldInput != '':
                dictParamInput[fieldInput] = valueInput
            
            field = worksheet.cell_value(i, chi+ 4)
            value = worksheet.cell_value(i, chi + 5)
            condition = worksheet.cell_value(i, chi + 6)
            
            if field != '':
                dictParamOutput['field'] = field
                dictParamOutput['value'] = value
                dictParamOutput['condition'] = condition
                listConditions.append(dictParamOutput)
                print(listConditions)
            
        if dictParamInput:   # not empty
            listInput.append(dictParamInput)
        if listConditions:   # not empty
            listOutput.append(listConditions)
            
    return listInput, listOutput

def make_result_expect(file):
    result = open(file, 'r')
    reader = csv.DictReader(result)
    myList = []
    for dictionary in reader:
        myList.append(dictionary)
    return myList

def make_csv_file():
 
    # field names
    fields = ['Name', 'Branch', 'Year', 'CGPA']
    
    # data rows of csv file
    rows = [ ['Nikhil', 'COE', '2', '9.0'],
            ['Sanchit', 'COE', '2', '9.1'],
            ['Aditya', 'IT', '2', '9.3'],
            ['Sagar', 'SE', '1', '9.5'],
            ['Prateek', 'MCE', '3', '7.8'],
            ['Sahil', 'EP', '2', '9.1']]
    
    # name of csv file
    filename = "university_records.csv"
    
    # writing to csv file
    with open(filename, 'w') as csvfile:
        # creating a csv writer object
        csvwriter = csv.writer(csvfile)
        
        # writing the fields
        csvwriter.writerow(fields)
        
        # writing the data rows
        csvwriter.writerows(rows)

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
