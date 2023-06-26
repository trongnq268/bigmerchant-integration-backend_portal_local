#!/usr/bin/python
from ctypes import sizeof
from operator import index, le
from pickle import TRUE
from re import T
import os
from os.path import dirname as up
from unicodedata import name
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
from csv import DictReader
import csv

def check_response_content(responseBody, valueExpect):
    flgCheck = True
    listObjectFail = []
    if is_json(responseBody) != True:
        flgCheck = False
        listObjectFail.append('Interver server error ')
        return flgCheck, listObjectFail
    body = json.loads(responseBody)

    # ================ Check Response Valid ==================#
    if ("total" not in body):
        flgCheck = False
        return flgCheck, listObjectFail
    if "data" in body:
        ruleReview = body["data"]

        # ================ Check Response Values Valid ==================#

        keyValueExpects = valueExpect.keys()
        # valDict = json.loads(valueExpect)
        for key in keyValueExpects:
            if key != "" and key is not None:
                x = 0
                for rule in ruleReview:
                    if valueExpect[key] not in rule[key]:
                        listObjectFail.append("value_error: " + rule[key])

        
    else:
        flgCheck = False
        listObjectFail.append("DATA NOT FOUND")
    return flgCheck, listObjectFail    

def compare_obj_json(responseSearch, responseCheck):
    flgCheck = True
    listObjectFail = []
    if is_json(responseSearch) != True:
        flgCheck = False
        listObjectFail.append('Interver server error ')
        return flgCheck, listObjectFail
    bodySearch = json.loads(responseSearch)
    bodySearch.pop('originalAmount', None)
    bodySearch.pop('originalDate', None)
    bodySearch.pop('response_code', None)
    bodySearch.pop('refund_status', None)
    
    bodyCheck = responseCheck[0]
    bodyCheck.pop('refund_status', None)
    # ================ Check Response Fields Valid ==================#
    if sorted(bodySearch.items()) != sorted(bodyCheck.items()):
        flgCheck = False
        listObjectFail.append("Data detail not match")

    return flgCheck, listObjectFail

def string_to_json(data):
    dataJson = json.dumps(data)
    print('data json '+dataJson)
    return dataJson

def compare_str_response_and_obj_json(responseSearch, responseCheck):
    flgCheck = True
    listObjectFail = []
    if is_json(responseSearch) != True:
        flgCheck = False
        listObjectFail.append('Interver server error ')
        return flgCheck, listObjectFail
    bodySearch = json.loads(responseSearch)

    # ================ Check Response Fields Valid ==================#
    if sorted(bodySearch.items()) != sorted(responseCheck.items()):
        flgCheck = False
        listObjectFail.append("Data detail not match")

    return flgCheck, listObjectFail


def compare_array_json(responseSearch, responseCheck):
    flgCheck = True
    listObjectFail = []
    if is_json(responseSearch) != True:
        flgCheck = False
        listObjectFail.append('Interver server error ')
        return flgCheck, listObjectFail
    bodySearch = json.loads(responseSearch)

    bodyCheck = responseCheck[0][0]["transactions"]
    # ================ Check Response Fields Valid ==================#
    for historyObj in bodySearch["transactions"]:
        if historyObj in bodyCheck:
            print("It exists in both arrays")
            flgCheck = True
        else:
            print("Device " + str(historyObj) + "is not in arrayTwo")
            listObjectFail.append(
                "Data detail history not match "+str(historyObj))
            flgCheck = False

    return flgCheck, listObjectFail


def is_json(myjson):
    try:
        json.loads(myjson)
    except ValueError as e:
        return False
    return True


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


def make_param(file):
    myFile = open(file, 'r')
    reader = csv.DictReader(myFile, delimiter=';')
    listInput = []
    listOutput = []
    for dictionary in reader:
        json_data_input = json.loads(dictionary['input'])
        keyInputs = json_data_input.keys()
        json_data_output = json.loads(dictionary['output'])
        # keyOutputs = json_data_output.keys()
        param = {}
        for key in keyInputs:
            param[key] = json_data_input[key]
        listInput.append(param)
        list_value = []
        list_value = json.loads(dictionary['output'])
        # retExpect = json_data_output
        # for output in json_data_output:
        # retExpect[key] = json_data_output[key]
        # list_value.append(output)
        listOutput.append(list_value)
    return listInput, listOutput

def make_param_str_json(data):
    reader = data.split(';')
    listInput = []
    listOutput = []
    # for dictionary in reader:
    json_data_input = json.loads(reader[0])
    keyInputs = json_data_input.keys()
    json_data_output = json.loads(reader[1])
    keyOutputs = json_data_output.keys()
    param = {}
    retExpect = {}
    for key in keyInputs:
        param[key] = json_data_input[key]
    listInput.append(param)
    for key in keyOutputs:
        retExpect[key] = json_data_output[key]
    listOutput.append(retExpect)
    return listInput, listOutput

def make_param_json(dataFile):
    listInput = []
    listOutput = []
    
    upperDir = up(up(__file__))
    config_file_path = os.path.join(upperDir, "MA/ma-domestic/json")
    config_file_path = os.path.join(config_file_path, dataFile)
    # # Opening JSON file
    jsonExpect = open(config_file_path, 'r')
    dataExpect = json.load(jsonExpect)
    for data in dataExpect["data"]:
        keyInputs = data["input"].keys()
        param = {}
        for key in keyInputs:
            param[key] = data["input"][key]
        listInput.append(param)
        listOutput.append(data["output"])
    return listInput, listOutput

def read_file_json(dataFile):
    listInput = []
    listOutput = []
    
    upperDir = up(up(__file__))
    config_file_path = os.path.join(upperDir, "MA/ma-domestic/json")
    config_file_path = os.path.join(config_file_path, dataFile)
    # # Opening JSON file
    jsonExpect = open(config_file_path, 'r')

    dataExpect = json.load(jsonExpect)
    
    for key in dataExpect["data"]:
        listInput.append(key["input"])
        listOutput.append(key["output"])
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
    rows = [['Nikhil', 'COE', '2', '9.0'],
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
