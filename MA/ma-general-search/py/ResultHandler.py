import json


def check_response_content(responseBody, responseFieldExpect, valueExpect):
    flgCheck = True
    listObjectFail = []
    totalPassed = 0
    totalFailed = 0
    body = json.loads(responseBody)
    transactions = body["list"]
    
    # ================ Check Response Valid ==================#
    if("total_items" not in body):
        flgCheck = False

    # ================ Check Response Fields Valid ==================#
    # keyExpects = responseFieldExpect.keys()
    for key in responseFieldExpect:
        for tran in transactions:
            if(key not in tran):
                flgCheck = False
                listObjectFail.append(tran["id"] + "-"+ key + "not exits")
                
    # ================ Check Response Values Valid ==================#
    listCheck = list(eval(valueExpect))
    for val in listCheck:
        if val["field"] != "" and val["field"] is not None:
            for tran in transactions:
                if val["condition"] == "equal" and val["value"] != tran[val["field"]]:
                    flgCheck = False
                    listObjectFail.append(tran["id"] + "-"+ val["field"] + "-" + tran[val["field"]])
                    totalFailed += 1
                elif val["condition"] == "contain" and val["value"] not in tran[val["field"]]:
                    flgCheck = False
                    listObjectFail.append(tran["id"] + " - " + val["field"] + " - " + tran[val["field"]])
                    totalFailed += 1
                elif val["condition"] == "in" and tran[val["field"]] not in  val["value"]:
                    flgCheck = False
                    listObjectFail.append(tran["id"] + " - " + val["field"] + " - " + tran[val["field"]])
                    totalFailed += 1
                else:
                    totalPassed +=1

    return flgCheck, listObjectFail, totalPassed, totalFailed