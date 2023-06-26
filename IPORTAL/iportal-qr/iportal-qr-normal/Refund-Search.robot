*** Settings ***
Library  RequestsLibrary
Library  json
Library  String
Library  py/ResultHandle.py
Library    Collections
Resource  ../../common/Common.robot

*** Keywords ***

Pre_request - Request - body
        [Arguments]     
        ...     ${fromDate}=01/11/2022 12:00 AM
        ...     ${toDate}=30/11/2022 11:59 PM
        ...     ${merchantId}=
        ...     ${merchantName}=
        ...     ${transactionId}=
        ...     ${orderInfo}=
        ...     ${merchantTransactionRef}=
        ...     ${masking}=
        ...     ${cardType}=
        ...     ${appName}=
        ...     ${acqCode}=
        ...     ${platform}=
        ...     ${tid}=
        ...     ${mid}=
        ...     ${status}=
        ...     ${channel}=
        ...     ${qrType}=
        ...     ${merchantChannel}=
        ...     ${page}=0
        ...     ${pageSize}=100
        ${schema}     catenate    SEPARATOR=
            ...     {
            ...         "fromDate":"${fromDate}",
            ...         "toDate":"${toDate}",
            ...         "merchantId":"${merchantId}",
            ...         "merchantName":"${merchantName}",
            ...         "transactionId":"${transactionId}",
            ...         "orderInfo":"${orderInfo}",
            ...         "merchantTransactionRef":"${merchantTransactionRef}",
            ...         "masking":"${masking}",
            ...         "cardType":"${cardType}",
            ...         "appName":"${appName}",
            ...         "acqCode":"${acqCode}",
            ...         "platform":"${platform}",
            ...         "tid":"${tid}",
            ...         "mid":"${mid}",
            ...         "status":"${status}",
            ...         "channel":"${channel}",
            ...         "qrType":"${qrType}",
            ...         "merchantChannel":"${merchantChannel}",
            ...         "page":"${page}",
            ...         "pageSize":"${pageSize}"
            ...     }
        ${body}     loads   ${schema}
        [Return]    ${body}

*** Variables ***
${API_SEARCH_URL}    https://dev.onepay.vn/iportal/api/v1/qr/refund-search
${API_DETAIL_URL}    https://127.0.0.1/iportal/api/v1/qr/refund-search/
${COOKIE}            auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwic2lkIjoiNTFERDdDOUM3REE2QTI3ODhGNEFCNTNCNTZCRTY4MTEiLCJpYXQiOjE2ODYxMTMwNjUsImV4cCI6MTY4Njk3NzA2NSwic3ViIjoiNDAyNjUifQ.HqPrlhZSqltuM1THwroZRrE0Qlc0sVgEBO3nPkbwmSI; Max-Age=14400; Expires=Wed, 07 Jun 2023 08:44:25 GMT; Path=/iportal; HTTPOnly
*** Test Cases ***
TC01 - Transaction Search
    [documentation]     Transaction Search
    ${testcasePath}=    Set Variable    /csv/RefundSearchTC01.csv
    ${request}    ${resultExpect}=    ResultHandle.Make Param    ${CURDIR}${testcasePath}
    # ${COOKIE}=    Common.GET COOKIE
    # ${resultExpect}=    ResultHandle.Make Result Expect    /home/hungld/bigmerchant-integration/config/result-expect.csv
    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json
    ...                            X-Request-Id=A5CEED7D80F454B6FD5BE3AA2F912824
    ...                            X-USER-ID=51DD7C9C7DA6A2788F4AB53B56BE6811
    ...                            User-Agent=Robot-Auto-Test
    ...                            Connection=keep-alive
                
    ${fieldExpect}=    Create List
    # ...    merchantId
    # ...    transactionId
    # ...    orderInfo
    # ...    merchantTxnRef
    # ...    masking
    # ...    appName
    # ...    acqCode
    # ...    status
    # ...    channel

    ${valueExpect}     Create Dictionary    #trans_type=Refund Dispute   

    ${count}=    Set Variable    1
    ${finalResult}=    Set Variable    True

    Log To Console    ${resultExpect}

    FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect} 
        Log To Console    ********** REQUEST ***********${count}
        Log To Console    ${req}
        Log To Console    ********** RESULT EXPECT ***********
        Log To Console    ${ret}
        ${fromDate}=         Get From Dictionary   ${req}    fromDate
        ${toDate}=           Get From Dictionary   ${req}    toDate
        ${merchantId}=       Get From Dictionary   ${req}    merchantId
        ${merchantName}=       Get From Dictionary   ${req}    merchantName
        ${transactionId}=    Get From Dictionary   ${req}    transactionId
        ${orderInfo}=        Get From Dictionary   ${req}    orderInfo
        ${merchantTransactionRef}=    Get From Dictionary   ${req}    merchantTransactionRef
        ${masking}=    Get From Dictionary   ${req}    masking
        ${cardType}=    Get From Dictionary   ${req}    cardType
        ${appName}=    Get From Dictionary   ${req}    appName
        ${acqCode}=    Get From Dictionary   ${req}    acqCode
        ${platform}=    Get From Dictionary   ${req}    platform
        ${tid}=    Get From Dictionary   ${req}    tid
        ${mid}=    Get From Dictionary   ${req}    mid
        ${status}=    Get From Dictionary   ${req}    status
        ${channel}=    Get From Dictionary   ${req}    channel
        ${qrType}=    Get From Dictionary   ${req}    qrType
        ${merchantChannel}=    Get From Dictionary   ${req}    merchantChannel
        ${page}=                 Get From Dictionary   ${req}    page
        ${pageSize}=            Get From Dictionary   ${req}    pageSize
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL}?merchantId=${merchantId}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&merchantName=${merchantName}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&fromDate=${fromDate}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&toDate=${toDate}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&transactionId=${transactionId}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&orderInfo=${orderInfo}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&merchantTransactionRef=${merchantTransactionRef}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&masking=${masking}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&cardType=${cardType}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&appName=${appName}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&acqCode=${acqCode}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&platform=${platform}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&tid=${tid}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&mid=${mid}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&status=${status}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&channel=${channel}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&qrType=${qrType}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&merchantChannel=${merchantChannel}
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

TC02 - Transaction Detail Compare
    [documentation]     Transaction Search
    ${testcasePath}=    Set Variable    /csv/RefundSearchTC02.csv
    ${request}    ${resultExpect}=    ResultHandle.Make Param    ${CURDIR}${testcasePath}
    # ${COOKIE}=    Common.GET COOKIE
    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json

    ${fieldExpect}=    Create List
    ...    merchantId
    ...    transactionId
    ...    orderInfo
    ...    merchantTxnRef
    ...    masking
    ...    appName
    ...    acqCode
    ...    status
    ...    channel

    Log To Console    ${request}
    ${count}=    Set Variable    1
    ${finalResult}=    Set Variable    True

        FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect}
            Log To Console    ${req}
            Log To Console    ${ret}
            Log To Console    ********** REQUEST TRANS ID *********** ${count}
            ${transactionId}    Get From Dictionary    ${req}    transactionId
            Log To Console      Transaction ID: ${transactionId}
            ${transactionType}    Get From Dictionary    ${req}    transactionType
            Log To Console      Transaction Type: ${transactionType}
            ${responseDetail}=    GET    ${API_DETAIL_URL}${transactionId}    headers=${header}
            Log To Console      Transaction Detail: ${responseDetail}

            Log To Console    ${responseDetail.text}

            Should Be Equal As Numbers    ${responseDetail.status_code}    200
            # Log To Console    ${responseDetail.text}  
            
            #==================***CHECK RESULT***==================#
            ${flgCheckContain}  ${listObjectFail}    ${totalPassed}    ${totalFailed}    
            ...        ResultHandle.Check Response Detail    ${responseDetail.text}    ${fieldExpect}    ${ret}
            
            # Log To Console    ${responseDetail.text}
            Log To Console    Total Trans Pass: ${totalPassed}
            Log To Console    Total Trans Fail: ${totalFailed}
            Log To Console    List Object failed: ${listObjectFail}
            IF    ${flgCheckContain} == False
                ${finalResult}=    Set Variable    False
            END
            
            ${count}=    Evaluate    ${count} + 1
            
        END
        Should Be Equal As Strings    ${finalResult}    True

TC03 - History Compare
    [documentation]     Transaction Search
    ${testcasePath}=    Set Variable    /csv/RefundSearchTC03.csv
    ${request}    ${resultExpect}=    ResultHandle.Make Param    ${CURDIR}${testcasePath}
    # ${COOKIE}=    Common.GET COOKIE
    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json

    ${fieldExpect}=    Create List
    ...    merchantId
    ...    transactionId
    ...    orderInfo
    ...    merchantTxnRef
    ...    masking
    ...    appName
    ...    acqCode
    ...    status
    ...    channel

    Log To Console    ${request}
    ${count}=    Set Variable    1

        FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect}
            Log To Console    ${req}
            Log To Console    ${ret}
            Log To Console    ********** REQUEST TRANS ID *********** ${count}
            ${transID}    Get From Dictionary    ${req}    transactionId
            Log To Console      Transaction ID: ${transID}
            
            ${responseDetail}=    GET    ${API_DETAIL_URL}${transID}/history    headers=${header}

            Should Be Equal As Numbers    ${responseDetail.status_code}    200
            # Log To Console    ${responseDetail.text}  
            
            #==================***CHECK RESULT***==================#
            ${flgCheckContain}  ${listObjectFail}    ${totalPassed}    ${totalFailed}    
            ...        ResultHandle.Check Response Detail    ${responseDetail.text}    ${fieldExpect}    ${ret}
            
            Log To Console    Total Trans Pass: ${totalPassed}
            Log To Console    Total Trans Fail: ${totalFailed}
            Log To Console    List Object failed: ${listObjectFail}
            IF    ${flgCheckContain} == False
                ${finalResult}=    Set Variable    False
            END
            
            ${count}=    Evaluate    ${count} + 1
            
        END
        Should Be Equal As Strings    ${flgCheckContain}    True