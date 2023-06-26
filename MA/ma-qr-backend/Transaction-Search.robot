*** Settings ***
Library  RequestsLibrary
Library  json
Library  String
Library  py/ResultHandle.py
Library    Collections
Resource  ../common/Common.robot

*** Keywords ***

Pre_request - Request - body
        [Arguments]     ${merchantId}=
        ...     ${fromDate}=01/11/2022 12:00 AM
        ...     ${toDate}=07/11/2022 11:59 PM
        ...     ${transactionId}=
        ...     ${orderInfo}=
        ...     ${merchantTransactionRef}=
        ...     ${qrId}=
        ...     ${cardNumber}=
        ...     ${appName}=
        ...     ${transactionType}=
        ...     ${transactionState}=
        ...     ${page}=0
        ...     ${pageSize}=100
        ${schema}     catenate    SEPARATOR=
            ...     {
            ...         "merchantId":"${merchantId}",
            ...         "fromDate":"${fromDate}",
            ...         "toDate":"${toDate}",
            ...         "transactionId":"${transactionId}",
            ...         "orderInfo":"${orderInfo}",
            ...         "merchantTransactionRef":"${merchantTransactionRef}",
            ...         "qrId":"${qrId}",
            ...         "cardNumber":"${cardNumber}",
            ...         "appName":"${appName}",
            ...         "transactionType":"${transactionType}",
            ...         "transactionState":"${transactionState}",
            ...         "page":"${page}",
            ...         "pageSize":"${pageSize}"
            ...     }
        ${body}     loads   ${schema}
        [Return]    ${body}

*** Variables ***
${API_SEARCH_URL}    http://127.0.0.1/ma/api/v1/qr/transaction
${API_DETAIL_URL}    http://127.0.0.1/ma/api/v1/qr/transaction/
${COOKIE}            auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwiaWF0IjoxNjY2ODU0NjM2LCJleHAiOjE2NjY4NjE4MzYsInN1YiI6IjUxREQ3QzlDN0RBNkEyNzg4RjRBQjUzQjU2QkU2ODExIn0.tuirJC_pmuRBmyNDfyEAPhbVOsjcmAaK5Wpo4cLONgc; Max-Age=7200; Expires=Thu, 27 Oct 2022 09:10:36 GMT; Path=/ma; HTTPOnly
*** Test Cases ***
TC01 - Transaction Search
    [documentation]     Transaction Search
    ${testcasePath}=    Set Variable    /csv/TC01.csv
    ${request}    ${resultExpect}=    ResultHandle.Make Param    ${CURDIR}${testcasePath}
    ${COOKIE}=    Common.GET COOKIE
    # ${resultExpect}=    ResultHandle.Make Result Expect    /home/hungld/bigmerchant-integration/config/result-expect.csv
    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json
    ...                            X-USER-ID=xxx
    ...                            User-Agent=Robot-Auto-Test
    ...                            Connection=keep-alive
                
    ${fieldExpect}=    Create List
    ...    merchantId
    ...    transactionId
    ...    orderReference
    ...    merchantTransRef
    ...    qrId
    # ...    cardNumber
    ...    appName
    ...    transactionType
    ...    status
    
    ${valueExpect}     Create Dictionary    #trans_type=Refund Dispute   

    ${count}=    Set Variable    1
    ${finalResult}=    Set Variable    True

    Log To Console    ${resultExpect}

    FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect} 
        Log To Console    ********** REQUEST ***********${count}
        Log To Console    ${req}
        Log To Console    ********** RESULT EXPECT ***********
        Log To Console    ${ret}
        ${merchantId}=       Get From Dictionary   ${req}    merchantId
        ${fromDate}=         Get From Dictionary   ${req}    fromDate
        ${toDate}=           Get From Dictionary   ${req}    toDate
        ${transactionId}=    Get From Dictionary   ${req}    transactionId
        ${orderInfo}=        Get From Dictionary   ${req}    orderInfo
        ${merchantTransactionRef}=    Get From Dictionary   ${req}    merchantTransactionRef
        ${qrId}=    Get From Dictionary   ${req}    qrId
        ${cardNumber}=    Get From Dictionary   ${req}    cardNumber
        ${appName}=    Get From Dictionary   ${req}    appName
        ${transactionType}=    Get From Dictionary   ${req}    transactionType
        ${transactionState}=    Get From Dictionary   ${req}    transactionState
        ${page}=                 Get From Dictionary   ${req}    page
        ${pageSize}=            Get From Dictionary   ${req}    pageSize
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL}?merchantId=${merchantId}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&fromDate=${fromDate}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&toDate=${toDate}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&transactionId=${transactionId}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&orderInfo=${orderInfo}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&merchantTransactionRef=${merchantTransactionRef}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&qrId=${qrId}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&cardNumber=${cardNumber}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&appName=${appName}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&transactionType=${transactionType}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&status=${transactionState}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&page=${page}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&pageSize=${pageSize}

        #================= START CALL API =====================#
        ${response}=  GET    ${API_SEARCH_URL_ADD_PARAM}    headers=${header}
        # Log To Console    ${response.text}
        #==================***CHECK RESULT***==================#
        
        # Should Be Equal As Numbers    ${response.status_code}    200
        ${flgCheckContain}  ${listObjectFail}    ${totalPassed}    ${totalFailed}
        ...    ResultHandle.Check Response Content    ${response.text}    ${fieldExpect}    ${ret}
        
        Log To Console    TotalPass: ${totalPassed}
        Log To Console    TotalFail: ${totalFailed}
        Log To Console    List Object failed: ${listObjectFail}
        IF    ${flgCheckContain} == False
            ${finalResult}=    Set Variable    False
        END
        
        ${count}=    Evaluate    ${count} + 1
    END
    Should Be Equal As Strings    ${finalResult}    True

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