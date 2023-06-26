import csv
import json
from operator import getitem

# Get input from csv
def make_param(file):
    myFile = open(file, 'r')
    reader = csv.DictReader(myFile, delimiter=';')
    listInput = []
    listOutput = []
    for dictionary in reader:
        json_data_input = json.loads(dictionary['input'])
        keyInputs = json_data_input.keys()
        # json_data_output = json.loads(dictionary['output'])
        # keyOutputs = json_data_output.keys()
        param = {}
        for key in keyInputs:
            param[key] = json_data_input[key]
        listInput.append(param)
        list_value = []
        list_value = dictionary['output']
        # retExpect = json_data_output
        # for output in json_data_output:
            # retExpect[key] = json_data_output[key]
            # list_value.append(output)
        listOutput.append(list_value)
    return listInput, listOutput

def check_list_response(responseBody, responseFieldExpect, valueExpect):
    flgCheck = True
    listObjectFail = []
    totalPassed = 0
    totalFailed = 0
    body = json.loads(responseBody)
    transactions = body["list"]
    
    # ================ Check Response Valid ==================#
    if("totalItems" not in body):
        flgCheck = False

    # ================ Check Response Fields Valid ==================#
    # keyExpects = responseFieldExpect.keys()
    for key in responseFieldExpect:
        for indx, tran in enumerate(transactions):
            if(key not in tran):
                flgCheck = False
                listObjectFail.append(indx + " - "+ key + " not exits")
                
    # ================ Check Response Values Valid ==================#
    listCheck = list(eval(valueExpect))
    for val in listCheck:
        field = val["field"]
        if field != "" and field is not None:
            path = field.split(".")
            for indx, tran in enumerate(transactions):
                v = get_time_line(tran, path)
                if val["condition"] == "equal" and val["value"] != v:
                    flgCheck = False
                    listObjectFail.append(indx + " - " + field + " - " + str(v))
                    totalFailed += 1
                else:
                    totalPassed +=1

    return flgCheck, listObjectFail, totalPassed, totalFailed

def check_detail_response(responseBody, responseFieldExpect, valueExpect):
    flgCheck = True
    listObjectFail = []
    totalPassed = 0
    totalFailed = 0
    tran = json.loads(responseBody)
    # ================ Check Response Fields Valid ==================#
    # keyExpects = responseFieldExpect.keys()
    for key in responseFieldExpect:
        if(key not in tran):
            flgCheck = False
            listObjectFail.append(key + " not exits")
                
    # ================ Check Response Values Valid ==================#
    listCheck = list(eval(valueExpect))
    for val in listCheck:
        field = val["field"]
        if field != "" and field is not None:
            path = field.split(".")
            v = get_time_line(tran, path)
            if val["condition"] == "equal" and val["value"] != v:
                flgCheck = False
                listObjectFail.append(str(field) + " - " + str(v))
                totalFailed += 1
            else:
                totalPassed +=1

    return flgCheck, listObjectFail, totalPassed, totalFailed

def get_time_line(timelines:dict, path):
    data = timelines
    for path_element in path:
        data = data.get(path_element, {})
    return data