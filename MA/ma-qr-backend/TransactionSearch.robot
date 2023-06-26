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
${API_SEARCH_URL}    https://dev.onepay.vn/ma/api/v1/qr/transaction
${API_DETAIL_URL}    https://dev.onepay.vn/ma/api/v1/qr/transaction/ 

${COOKIE}            auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwia2V5Y2xvYWtUb2tlbiI6ImV5SmhiR2NpT2lKU1V6STFOaUlzSW5SNWNDSWdPaUFpU2xkVUlpd2lhMmxrSWlBNklDSm1Xa0l6Y1V4dGNEbFlWMnRHVVZOdlUwVk9jbDlhVG1sNFZXaEdlRUU1WWtORFFuSnRRekpzVVhKTkluMC5leUpsZUhBaU9qRTJPRE01TkRReU9UTXNJbWxoZENJNk1UWTRNemswTXprNU15d2lZWFYwYUY5MGFXMWxJam94Tmpnek9UUXpPVGN4TENKcWRHa2lPaUkyT1dKaE1HSmlaUzFpTVRoaExUUXpaV0V0T1RBeE1DMDJabVF6WlRrM01UUXdaRFVpTENKcGMzTWlPaUpvZEhSd2N6b3ZMMlJsZGk1dmJtVndZWGt1ZG00dllYVjBhQzl5WldGc2JYTXZiMjVsY0dGNUlpd2lZWFZrSWpvaWJXRWlMQ0p6ZFdJaU9pSmhOV00wTkRoaE1DMDNZemhrTFRSbVlqWXRPVEEwWWkwNU0yTXpZbUl6TURjeVkyUWlMQ0owZVhBaU9pSkpSQ0lzSW1GNmNDSTZJbTFoSWl3aWMyVnpjMmx2Ymw5emRHRjBaU0k2SW1SbFl6VmtaRFppTFdJeFpHTXROR0kwWWkwNE5UY3dMV0l3TmpRMU5UWm1ZbVZpTlNJc0ltRjBYMmhoYzJnaU9pSjJlV1JJT0VabGVrc3lWMHRMVldvdGVrUllNMFJuSWl3aVlXTnlJam9pTVNJc0luTnBaQ0k2SW1SbFl6VmtaRFppTFdJeFpHTXROR0kwWWkwNE5UY3dMV0l3TmpRMU5UWm1ZbVZpTlNJc0ltVnRZV2xzWDNabGNtbG1hV1ZrSWpwbVlXeHpaU3dpYm1GdFpTSTZJbWdfSUhSb1AyNW5JRkYxUDI0Z2RISV9JSFpwNzctOWJpSXNJbkJ5WldabGNuSmxaRjkxYzJWeWJtRnRaU0k2SW1Ga2JXbHVRRzl1WlhCaGVTNTJiaUlzSW1kcGRtVnVYMjVoYldVaU9pSm9QeUIwYUQ5dVp5SXNJbVpoYldsc2VWOXVZVzFsSWpvaVVYVV9iaUIwY2o4Z2RtbnZ2NzF1SWl3aVpXMWhhV3dpT2lKaFpHMXBia0J2Ym1Wd1lYa3VkbTRpZlEuRDdmam5nLWJlek1OWTNvSmx1QlQ1Mm81Rk9VaTdnVE40bmdpVTJTRndDZWs3YVhBTTNubGRfVnRqVkd0aDZOLUk0NWt1eHBoZ2RqbzV5TnpXYmtlcGxRT1RGMFNxdDRqZFBvb1E1WUQ1dFlSS3dSWTJqTVBFSUtPRVgtX1psZlVFV1VnVzcxRFN2bjlOVTFTY2gxaVFmVzFrMEpsQnRwZmUtZko4Y2dDLVlaZ3ljdUYyRGN5NENWZWRSem5IYjR4UndnRnNGZVB1TnpKdHo5Q2VTUC03aE0xdFNHOEIyZDlIRWFLOGlhMXdZWlV2Y1BvcjBuUmJIa0E4S3VqZUxKZUJyeVBQbVB5V0IyWmRFdE5NUnViWmFwZDRlcFBZY0tERl8yUi1oRWN0VVd5cmJDZDB3dGVNcGFvbkY5TGNuWU40UlE1Rmw3bDlLZ2dSWmxWQkJiMDlBIiwiaWF0IjoxNjgzOTQ4OTIyLCJleHAiOjE2ODM5NTYxMjIsInN1YiI6IjUxREQ3QzlDN0RBNkEyNzg4RjRBQjUzQjU2QkU2ODExIn0.JRtEaUfEKx696I4io4ZfWKpDwZsf0sk7kp5eIfC42RU; Max-Age=7200; Expires=Sat, 13 May 2023 05:35:22 GMT; Path=/ma; HTTPOnly

*** Test Cases ***
TC01 - Transaction Search
    [documentation]     Transaction Search
    # ${COOKIE}    Common.GET COOKIE
    ${testcasePath}=    Set Variable    /csv/TC01-Normal.csv
    ${testcases}=    Read CSV File   ${CURDIR}${testcasePath}
    FOR  ${testcase}   IN   @{testcases} 
    # Continue For Loop If   ' ${testcase}[0]' == 'descrition'
         Log To Console    ${testcase}[0]': '${testcase}[1]': '${testcase}[2]

    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json
    ...                            X-USER-ID=xxx
    ...                            User-Agent=Robot-Auto-Test
    ...                            Connection=keep-alive


    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL}?fromDate=01/11/2022 12:00 AM&toDate=30/12/2022 11:59 PM&${testcase}[1]=${testcase}[2]

    #================= START CALL API =====================#
    ${response}=  GET    ${API_SEARCH_URL_ADD_PARAM}    headers=${header}
    

    Should Be Equal As Numbers    ${response.status_code}    200

    ${responseJson}=  evaluate    json.loads('''${response.text}''')    json

    
    Should Not Be Equal    ${responseJson['totalItems']}    0
    # Log To Console    ${responseJson['list'][0]}
    # ${responseJson}= createjson.Get Json Data
    # ${responseJsonArray} = ${responseJson} 
    # ${res} = ${responseJson['list'][0]['${testcase}[3]']}

    Should Be Equal As Strings   ${responseJson['list'][0]['${testcase}[3]']}    ${testcase}[4]
    #==================***CHECK RESULT***==================#

    END


*** Variables ***
${SAMSUNG_API_SEARCH_URL}    https://dev.onepay.vn/ma/api/v1/qr/samsung/transaction
${API_DETAIL_URL}    https://dev.onepay.vn/ma/api/v1/qr/transaction/   

*** Test Cases ***
TC02 - Samsung Transaction Search
    [documentation]    Samsung Transaction Search
    ${COOKIE}=    Common.GET COOKIE
    ${testcasePath}=    Set Variable    /csv/TC02-Samsung.csv
    ${testcases}=    Read CSV File   ${CURDIR}${testcasePath}
    FOR  ${testcase}   IN   @{testcases} 
    # Continue For Loop If   ' ${testcase}[0]' == 'descrition'
         Log To Console    ${testcase}[0]': '${testcase}[1]': '${testcase}[2]

    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json
    ...                            X-USER-ID=xxx
    ...                            User-Agent=Robot-Auto-Test
    ...                            Connection=keep-alive


    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${SAMSUNG_API_SEARCH_URL}?fromDate=01/11/2022 12:00 AM&toDate=30/12/2022 11:59 PM&${testcase}[1]=${testcase}[2]

    #================= START CALL API =====================#
    ${response}=  GET    ${API_SEARCH_URL_ADD_PARAM}    headers=${header}
    

    Should Be Equal As Numbers    ${response.status_code}    200

    ${responseJson}=  evaluate    json.loads('''${response.text}''')    json

    
    Should Not Be Equal    ${responseJson['totalItems']}    0
    # Log To Console    ${responseJson['list'][0]}
    # ${responseJson}= createjson.Get Json Data
    # ${responseJsonArray} = ${responseJson} 
    # ${res} = ${responseJson['list'][0]['${testcase}[3]']}

    Should Be Equal As Strings   ${responseJson['list'][0]['${testcase}[3]']}    ${testcase}[4]
    #==================***CHECK RESULT***==================#

    END    
    
*** Variables ***
${PROMOTION_API_SEARCH_URL}   https://dev.onepay.vn/ma/api/v1/qr/moca/transaction
# ${API_DETAIL_URL}    https://dev.onepay.vn/ma/api/v1/qr/transaction/
*** Test Cases ***
TC03 - Promotion Transaction Search
    [documentation]   Promotion Transaction Search
    ${COOKIE}=    Common.GET COOKIE
    ${testcasePath}=    Set Variable    /csv/TC03-Promotion.csv
    ${testcases}=    Read CSV File   ${CURDIR}${testcasePath}
    FOR  ${testcase}   IN   @{testcases} 
    # Continue For Loop If   ' ${testcase}[0]' == 'descrition'
         Log To Console    ${testcase}[0]': '${testcase}[1]': '${testcase}[2]

    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json
    ...                            X-USER-ID=xxx
    ...                            User-Agent=Robot-Auto-Test
    ...                            Connection=keep-alive


    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${PROMOTION_API_SEARCH_URL}?fromDate=01/11/2022 12:00 AM&toDate=30/12/2022 11:59 PM&${testcase}[1]=${testcase}[2]

    #================= START CALL API =====================#
    ${response}=  GET    ${API_SEARCH_URL_ADD_PARAM}    headers=${header}
    

    Should Be Equal As Numbers    ${response.status_code}    200

    ${responseJson}=  evaluate    json.loads('''${response.text}''')    json

    
    Should Not Be Equal    ${responseJson['totalItems']}    0
    # Log To Console    ${responseJson['list'][0]}
    # ${responseJson}= createjson.Get Json Data
    # ${responseJsonArray} = ${responseJson} 
    # ${res} = ${responseJson['list'][0]['${testcase}[3]']}

    Should Be Equal As Strings   ${responseJson['list'][0]['${testcase}[3]']}    ${testcase}[4]
    #==================***CHECK RESULT***==================#

    END    
    # ${valueExpect}     Create Dictionary    #trans_type=Refund Dispute   

    # ${count}=    Set Variable    1
    # ${finalResult}=    Set Variable    True

    # Log To Console    ${resultExpect}

    # FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect} 
    #     Log To Console    ********** REQUEST ***********${count}
    #     Log To Console    ${req}
    #     Log To Console    ********** RESULT EXPECT ***********
    #     Log To Console    ${ret}
    #     ${merchantId}=       Get From Dictionary   ${req}    merchantId
    #     ${fromDate}=         Get From Dictionary   ${req}    fromDate
    #     ${toDate}=           Get From Dictionary   ${req}    toDate
    #     ${transactionId}=    Get From Dictionary   ${req}    transactionId
    #     ${orderInfo}=        Get From Dictionary   ${req}    orderInfo
    #     ${merchantTransactionRef}=    Get From Dictionary   ${req}    merchantTransactionRef
    #     ${qrId}=    Get From Dictionary   ${req}    qrId
    #     ${cardNumber}=    Get From Dictionary   ${req}    cardNumber
    #     ${appName}=    Get From Dictionary   ${req}    appName
    #     ${transactionType}=    Get From Dictionary   ${req}    transactionType
    #     ${transactionState}=    Get From Dictionary   ${req}    transactionState
    #     ${page}=                 Get From Dictionary   ${req}    page
    #     ${pageSize}=            Get From Dictionary   ${req}    pageSize
    #     ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL}?merchantId=${merchantId}
    #     ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&fromDate=${fromDate}
    #     ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&toDate=${toDate}
    #     ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&transactionId=${transactionId}
    #     ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&orderInfo=${orderInfo}
    #     ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&merchantTransactionRef=${merchantTransactionRef}
    #     ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&qrId=${qrId}
    #     ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&cardNumber=${cardNumber}
    #     ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&appName=${appName}
    #     ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&transactionType=${transactionType}
    #     ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&status=${transactionState}
    #     ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&page=${page}
    #     ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&pageSize=${pageSize}

    #     #================= START CALL API =====================#
    #     ${response}=  GET    ${API_SEARCH_URL_ADD_PARAM}    headers=${header}
    #     # Log To Console    ${response.text}
    #     #==================***CHECK RESULT***==================#
        
    #     # Should Be Equal As Numbers    ${response.status_code}    200
    #     ${flgCheckContain}  ${listObjectFail}    ${totalPassed}    ${totalFailed}
    #     ...    ResultHandle.Check Response Content    ${response.text}    ${fieldExpect}    ${ret}
        
    #     Log To Console    TotalPass: ${totalPassed}
    #     Log To Console    TotalFail: ${totalFailed}
    #     Log To Console    List Object failed: ${listObjectFail}
    #     IF    ${flgCheckContain} == False
    #         ${finalResult}=    Set Variable    False
    #     END
        
    #     ${count}=    Evaluate    ${count} + 1
    # END
    # Should Be Equal As Strings    ${finalResult}    True

# TC02 - Transaction Detail Compare
#     [documentation]     Transaction Search
#     ${testcasePath}=    Set Variable    /csv/TC02.csv
#     ${request}    ${resultExpect}=    ResultHandle.Make Param    ${CURDIR}${testcasePath}
#     ${COOKIE}=    Common.GET COOKIE
#     &{header}=  Create Dictionary  Cookie=${COOKIE}
#     ...                            Content-Type=application/json

#     ${fieldExpect}=    Create List
#     ...    merchantId
#     ...    transactionId
#     ...    orderReference
#     ...    merchantTransRef
#     ...    qrId
#     # ...    cardNumber
#     ...    appName
#     ...    transactionType
#     ...    status

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

# TC03 - History Compare
#     [documentation]     Transaction Search
#     ${testcasePath}=    Set Variable    /csv/TC03.csv
#     ${request}    ${resultExpect}=    ResultHandle.Make Param    ${CURDIR}${testcasePath}
#     ${COOKIE}=    Common.GET COOKIE
#     &{header}=  Create Dictionary  Cookie=${COOKIE}
#     ...                            Content-Type=application/json

#     ${fieldExpect}=    Create List
#     ...    merchantId
#     ...    transactionId
#     ...    orderReference
#     ...    merchantTransRef
#     ...    qrId
#     # ...    cardNumber
#     ...    appName
#     ...    transactionType
#     ...    status

#     Log To Console    ${request}
#     ${count}=    Set Variable    1

#         FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect}
#             Log To Console    ${req}
#             Log To Console    ${ret}
#             Log To Console    ********** REQUEST TRANS ID *********** ${count}
#             ${transID}    Get From Dictionary    ${req}    transactionId
#             Log To Console      Transaction ID: ${transID}
            
#             ${responseDetail}=    GET    ${API_DETAIL_URL}${transID}/history    headers=${header}

#             Should Be Equal As Numbers    ${responseDetail.status_code}    200
#             # Log To Console    ${responseDetail.text}  
            
#             #==================***CHECK RESULT***==================#
#             ${flgCheckContain}  ${listObjectFail}    ${totalPassed}    ${totalFailed}    
#             ...        ResultHandle.Check Response Detail    ${responseDetail.text}    ${fieldExpect}    ${ret}
            
#             Log To Console    Total Trans Pass: ${totalPassed}
#             Log To Console    Total Trans Fail: ${totalFailed}
#             Log To Console    List Object failed: ${listObjectFail}
#             IF    ${flgCheckContain} == False
#                 ${finalResult}=    Set Variable    False
#             END
            
#             ${count}=    Evaluate    ${count} + 1
            
#         END
#         Should Be Equal As Strings    ${flgCheckContain}    True