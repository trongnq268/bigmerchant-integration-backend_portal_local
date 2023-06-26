*** Settings ***
Library  RequestsLibrary
Library  json
Library  String
Library  py/ResultHandle.py
Library    Collections
Resource  ../common/Common.robot
Library    ../common/CSVLibrary.py

*** Keywords ***

Pre_request - Request - body
       

*** Variables ***
# ${API_SEARCH_URL}    https://dev.onepay.vn/ma/api/v1/qr/transaction
${API_DETAIL_PURCHASE_URL}    https://dev.onepay.vn/ma/api/v1//qr/transaction/
${API_DETAIL_SAMSUNG_PURCHASE_URL}    https://dev.onepay.vn/ma/api/v1/qr/samsung/transaction/
${API_DETAIL_MOCA_PURCHASE_URL}    https://dev.onepay.vn/ma/api/v1/qr/moca/transaction/

# ${COOKIE}            auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwiaWF0IjoxNjY2ODU0NjM2LCJleHAiOjE2NjY4NjE4MzYsInN1YiI6IjUxREQ3QzlDN0RBNkEyNzg4RjRBQjUzQjU2QkU2ODExIn0.tuirJC_pmuRBmyNDfyEAPhbVOsjcmAaK5Wpo4cLONgc; Max-Age=7200; Expires=Thu, 27 Oct 2022 09:10:36 GMT; Path=/ma; HTTPOnly

*** Test Cases ***
TC-Detail-01 - Transaction Detail
    [documentation]     Transaction Detail
    ${COOKIE}    Common.GET COOKIE
    ${testcasePath}=    Set Variable    /csv/TC-Detail-01.csv
    ${testcases}=    Read CSV File   ${CURDIR}${testcasePath}
    FOR  ${testcase}   IN   @{testcases} 
    # Continue For Loop If   ' ${testcase}[0]' == 'descrition'
         Log To Console    ${testcase}[0]': '${testcase}[1]': '${testcase}[2]

    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json
    ...                            X-USER-ID=xxx
    ...                            User-Agent=Robot-Auto-Test
    ...                            Connection=keep-alive


    # ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL}?fromDate=01/11/2022 12:00 AM&toDate=30/12/2022 11:59 PM&${testcase}[1]=${testcase}[2]
    ${API_DETAIL_URL_ADD_PARAM}=    Set Variable    ${API_DETAIL_PURCHASE_URL}${testcase}[2]

    #================= START CALL API =====================#
    # ${response}=  GET    ${API_SEARCH_URL_ADD_PARAM}    headers=${header}
    ${responseDetail}=  GET    ${API_DETAIL_URL_ADD_PARAM}    headers=${header}
    

    # Should Be Equal As Numbers    ${response.status_code}    200
    Should Be Equal As Numbers    ${responseDetail.status_code}    200


    # ${responseJson}=  evaluate    json.loads('''${response.text}''')    json
    ${responseJson}=  evaluate    json.loads('''${responseDetail.text}''')    json
    # Log To Console    HieuAhihi${responseJson}
    # Log To Console    HieuAhihiCompare${testcase}[4]

    
    # Should Not Be Equal    ${responseJson['totalItems']}    0
    # Log To Console    ${responseJson['list'][0]}
    # ${responseJson}= createjson.Get Json Data
    # ${responseJsonArray} = ${responseJson} 
    # ${res} = ${responseJson['list'][0]['${testcase}[3]']}

    # Should Be Equal As Strings   ${responseJson['list'][0]['${testcase}[3]']}    ${testcase}[4]

    Should Be Equal As Strings    ${responseDetail.text}     ${testcase}[4]
    #==================***CHECK RESULT***==================#

    END

*** Test Cases ***
TC-Detail-Samusung-01 - Transaction Detail
    [documentation]     Transaction Detail
    ${COOKIE}    Common.GET COOKIE
    ${testcasePath}=    Set Variable    /csv/TC-Detail-01.csv
    ${testcases}=    Read CSV File   ${CURDIR}${testcasePath}
    FOR  ${testcase}   IN   @{testcases} 
    # Continue For Loop If   ' ${testcase}[0]' == 'descrition'
         Log To Console    ${testcase}[0]': '${testcase}[1]': '${testcase}[2]

    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json
    ...                            X-USER-ID=xxx
    ...                            User-Agent=Robot-Auto-Test
    ...                            Connection=keep-alive

    # ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL}?fromDate=01/11/2022 12:00 AM&toDate=30/12/2022 11:59 PM&${testcase}[1]=${testcase}[2]
    ${API_DETAIL_URL_ADD_PARAM}=    Set Variable    ${API_DETAIL_SAMSUNG_PURCHASE_URL}${testcase}[2]

    #================= START CALL API =====================#
    # ${response}=  GET    ${API_SEARCH_URL_ADD_PARAM}    headers=${header}
    ${responseDetail}=  GET    ${API_DETAIL_URL_ADD_PARAM}    headers=${header}
    

    # Should Be Equal As Numbers    ${response.status_code}    200
    Should Be Equal As Numbers    ${responseDetail.status_code}    200


    # ${responseJson}=  evaluate    json.loads('''${response.text}''')    json
    ${responseJson}=  evaluate    json.loads('''${responseDetail.text}''')    json

    
    # Should Not Be Equal    ${responseJson['totalItems']}    0
    # Log To Console    ${responseJson['list'][0]}
    # ${responseJson}= createjson.Get Json Data
    # ${responseJsonArray} = ${responseJson} 
    # ${res} = ${responseJson['list'][0]['${testcase}[3]']}

    # Should Be Equal As Strings   ${responseJson['list'][0]['${testcase}[3]']}    ${testcase}[4]

    Should Be Equal As Strings    ${responseDetail.text}     ${testcase}[4]
    #==================***CHECK RESULT***==================#

    END

TC-Detail-Moca-01 - Transaction Detail
    [documentation]     Transaction Detail
    ${COOKIE}    Common.GET COOKIE
    ${testcasePath}=    Set Variable    /csv/TC-Detail-01.csv
    ${testcases}=    Read CSV File   ${CURDIR}${testcasePath}
    FOR  ${testcase}   IN   @{testcases} 
    # Continue For Loop If   ' ${testcase}[0]' == 'descrition'
         Log To Console    ${testcase}[0]': '${testcase}[1]': '${testcase}[2]

    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json
    ...                            X-USER-ID=xxx
    ...                            User-Agent=Robot-Auto-Test
    ...                            Connection=keep-alive

    Log To Console    HieuAhihi${testcase}[2]
    # ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL}?fromDate=01/11/2022 12:00 AM&toDate=30/12/2022 11:59 PM&${testcase}[1]=${testcase}[2]
    ${API_DETAIL_URL_ADD_PARAM}=    Set Variable    ${API_DETAIL_MOCA_PURCHASE_URL}${testcase}[2]

    #================= START CALL API =====================#
    # ${response}=  GET    ${API_SEARCH_URL_ADD_PARAM}    headers=${header}
    ${responseDetail}=  GET    ${API_DETAIL_URL_ADD_PARAM}    headers=${header}
    

    # Should Be Equal As Numbers    ${response.status_code}    200
    Should Be Equal As Numbers    ${responseDetail.status_code}    200


    # ${responseJson}=  evaluate    json.loads('''${response.text}''')    json
    ${responseJson}=  evaluate    json.loads('''${responseDetail.text}''')    json

    # Should Not Be Equal    ${responseJson['totalItems']}    0
    # Log To Console    ${responseJson['list'][0]}
    # ${responseJson}= createjson.Get Json Data
    # ${responseJsonArray} = ${responseJson} 
    # ${res} = ${responseJson['list'][0]['${testcase}[3]']}

    # Should Be Equal As Strings   ${responseJson['list'][0]['${testcase}[3]']}    ${testcase}[4]

    Should Be Equal As Strings    ${responseDetail.text}     ${testcase}[4]
    #==================***CHECK RESULT***==================#

    END
# *** Keywords ***

# Pre_request - Request - body
#         [Arguments]     ${merchantId}=
#         ...     ${fromDate}=01/11/2022 12:00 AM
#         ...     ${toDate}=07/11/2022 11:59 PM
#         ...     ${transactionId}=
#         ...     ${orderInfo}=
#         ...     ${merchantTransactionRef}=
#         ...     ${qrId}=
#         ...     ${cardNumber}=
#         ...     ${appName}=
#         ...     ${transactionType}=
#         ...     ${transactionState}=
#         ...     ${page}=0
#         ...     ${pageSize}=100
#         ${schema}     catenate    SEPARATOR=
#             ...     {
#             ...         "merchantId":"${merchantId}",
#             ...         "fromDate":"${fromDate}",
#             ...         "toDate":"${toDate}",
#             ...         "transactionId":"${transactionId}",
#             ...         "orderInfo":"${orderInfo}",
#             ...         "merchantTransactionRef":"${merchantTransactionRef}",
#             ...         "qrId":"${qrId}",
#             ...         "cardNumber":"${cardNumber}",
#             ...         "appName":"${appName}",
#             ...         "transactionType":"${transactionType}",
#             ...         "transactionState":"${transactionState}",
#             ...         "page":"${page}",
#             ...         "pageSize":"${pageSize}"
#             ...     }
#         ${body}     loads   ${schema}
#         [Return]    ${body}

# *** Variables ***
# ${API_SEARCH_URL}    https://dev.onepay.vn/ma/api/v1/qr/transaction
# ${API_DETAIL_URL}    https://dev.onepay.vn/ma/api/v1/qr/transaction/
# ${COOKIE}            auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwiaWF0IjoxNjY2ODU0NjM2LCJleHAiOjE2NjY4NjE4MzYsInN1YiI6IjUxREQ3QzlDN0RBNkEyNzg4RjRBQjUzQjU2QkU2ODExIn0.tuirJC_pmuRBmyNDfyEAPhbVOsjcmAaK5Wpo4cLONgc; Max-Age=7200; Expires=Thu, 27 Oct 2022 09:10:36 GMT; Path=/ma; HTTPOnly
# *** Test Cases ***
# TestCase Detail - Transaction Detail Compare
#     [documentation]     Transaction Search
#     ${testcasePath}=    Set Variable    /csv/TestCaseDetail.csv
#     ${request}    ${resultExpect}=    ResultHandle.Make Param    ${CURDIR}${testcasePath}
#     ${COOKIE}=    Common.GET COOKIE
#     &{header}=  Create Dictionary  Cookie=${COOKIE}
#     ...                            Content-Type=application/json

#     ${fieldExpect}=    Create List
#     # ...    merchantId
#     ...    transactionId
#     # ...    merchantTransRef
#     # ...    advanceStatus
#     # ...    appName
#     ...    transactionType
#     # ...    status

#     Log To Console    ${request}
#     ${count}=    Set Variable    1
#     ${finalResult}=    Set Variable    True

#         FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect}
#             Log To Console    ${req}
#             Log To Console    ${ret}
#             Log To Console    ********** REQUEST TRANS ID *********** ${count}
#             ${transactionId}    Get From Dictionary    ${req}    transactionId
#             Log To Console      Transaction ID: ${transactionId}
#             ${transactionType}    Get From Dictionary    ${req}    transactionType
#             Log To Console      Transaction Type: ${transactionType}
#             ${responseDetail}=    GET    ${API_DETAIL_URL}${transactionId}    headers=${header}
#             Log To Console      Transaction Detail: ${responseDetail}

#             Log To Console    ${responseDetail.text}
#             Log To Console      HieuAhihi Detail Compare: ${ret}

#             Should Be Equal As Numbers    ${responseDetail.status_code}    200
#             # Log To Console    ${responseDetail.text}  
            
#             #==================***CHECK RESULT***==================#
#             ${flgCheckContain}  ${listObjectFail}    ${totalPassed}    ${totalFailed}    
#             ...        ResultHandle.Check Response Detail    ${responseDetail.text}    ${fieldExpect}    ${ret}
#             # Log To Console    ${responseDetail.text}
#             Log To Console    Total Trans Pass: ${totalPassed}
#             Log To Console    Total Trans Fail: ${totalFailed}
#             Log To Console    List Object failed: ${listObjectFail}
#             IF    ${flgCheckContain} == False
#                 ${finalResult}=    Set Variable    False
#             END
            
#             ${count}=    Evaluate    ${count} + 1
            
#         END
#         Should Be Equal As Strings    ${finalResult}    True