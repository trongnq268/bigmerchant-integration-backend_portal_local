*** Settings ***
Library  RequestsLibrary
Library  json
Library  String
Library  py/ResultHandle.py
Library    Collections
Resource  ../common/Common.robot

*** Keywords ***

Pre_request - Request - body
        [Arguments]     
        ...     ${fromDate}=01/11/2022 12:00 AM
        ...     ${toDate}=30/11/2022 11:59 PM
        ...     ${merchantId}=
        ...     ${transactionId}=
        ...     ${orderInfo}=
        ...     ${merchantTransactionRef}=
        ...     ${customerTransId}=
        ...     ${merchantTransId}=
        ...     ${masking}=
        ...     ${cardType}=
        ...     ${appName}=
        ...     ${acqCode}=
        ...     ${cardNumber}=
        ...     ${platform}=
        ...     ${tid}=
        ...     ${mid}=
        ...     ${status}=
        ...     ${channel}=
        ...     ${page}=0
        ...     ${pageSize}=100
        ${schema}     catenate    SEPARATOR=
            ...     {
            ...         "fromDate":"${fromDate}",
            ...         "toDate":"${toDate}",
            ...         "merchantId":"${merchantId}",
            ...         "transactionId":"${transactionId}",
            ...         "orderInfo":"${orderInfo}",
            ...         "merchantTransactionRef":"${merchantTransactionRef}",
            ...         "customerTransId":"${customerTransId}",
            ...         "merchantTransId":"${merchantTransId}",
            ...         "masking":"${masking}",
            ...         "cardType":"${cardType}",
            ...         "appName":"${appName}",
            ...         "acqCode":"${acqCode}",
            ...         "cardNumber":"${cardNumber}",
            ...         "platform":"${platform}",
            ...         "tid":"${tid}",
            ...         "mid":"${mid}",
            ...         "status":"${status}",
            ...         "channel":"${channel}",
            ...         "page":"${page}",
            ...         "pageSize":"${pageSize}"
            ...     }
        ${body}     loads   ${schema}
        [Return]    ${body}

*** Variables ***
${API_SEARCH_URL}    https://127.0.0.1/iportal/api/v1/ss-trans-management
${COOKIE}            columnItems=W3sibmFtZSI6Ik1lcmNoYW50IENoYW5uZWwiLCJjb2RlIjoibWVyY2hhbnRDaGFubmVsIiwib3JkZXIiOi0xLCJhY3RpdmUiOmZhbHNlfSx7Im5hbWUiOiJHYXRlIiwiY29kZSI6ImdhdGUiLCJvcmRlciI6MCwiYWN0aXZlIjpmYWxzZX0seyJuYW1lIjoiUGFydG5lciBOYW1lIiwiY29kZSI6InBhcnRuZXJOYW1lIiwib3JkZXIiOjEsImFjdGl2ZSI6ZmFsc2V9LHsibmFtZSI6IkFjcXVpcmVyIiwiY29kZSI6ImFjcXVpcmVyIiwib3JkZXIiOjIsImFjdGl2ZSI6ZmFsc2V9LHsibmFtZSI6Ik1lcmNoYW50IElEIiwiY29kZSI6Im1lcmNoYW50SWQiLCJvcmRlciI6MywiYWN0aXZlIjp0cnVlfSx7Im5hbWUiOiJJbnZvaWNlIElEIiwiY29kZSI6Imludm9pY2VJZCIsIm9yZGVyIjo0LCJhY3RpdmUiOmZhbHNlfSx7Im5hbWUiOiJUcmFucy4gSUQiLCJjb2RlIjoidHJhbnNJZCIsIm9yZGVyIjo1LCJhY3RpdmUiOnRydWV9LHsibmFtZSI6IlBheW1lbnQgSUQiLCJjb2RlIjoicGF5bWVudElkIiwib3JkZXIiOjYsImFjdGl2ZSI6ZmFsc2V9LHsibmFtZSI6Ik9yZGVyIFJlZi4iLCJjb2RlIjoib3JkZXJSZWYiLCJvcmRlciI6NywiYWN0aXZlIjp0cnVlfSx7Im5hbWUiOiJNZXJjaGFudCBUcmFucy4gUmVmIiwiY29kZSI6Im1lcmNoYW50VHJhbnNSZWYiLCJvcmRlciI6OCwiYWN0aXZlIjp0cnVlfSx7Im5hbWUiOiJRUiBJRCIsImNvZGUiOiJxcklkIiwib3JkZXIiOjksImFjdGl2ZSI6ZmFsc2V9LHsibmFtZSI6IkNoYW5uZWwiLCJjb2RlIjoicXJDaGFubmVsIiwib3JkZXIiOjEwLCJhY3RpdmUiOmZhbHNlfSx7Im5hbWUiOiJDYXJkIExpc3QiLCJjb2RlIjoiY2FyZFR5cGUiLCJvcmRlciI6MTEsImFjdGl2ZSI6dHJ1ZX0seyJuYW1lIjoiQ2FyZCBOdW1iZXIiLCJjb2RlIjoiY2FyZE51bWJlciIsIm9yZGVyIjoxMiwiYWN0aXZlIjp0cnVlfSx7Im5hbWUiOiJCSU4gQ291bnRyeSIsImNvZGUiOiJiaW5Db3VudHJ5Iiwib3JkZXIiOjEzLCJhY3RpdmUiOmZhbHNlfSx7Im5hbWUiOiJJc3N1ZXIiLCJjb2RlIjoiaXNzdWVyIiwib3JkZXIiOjE0LCJhY3RpdmUiOmZhbHNlfSx7Im5hbWUiOiJJbnN0YWxsbWVudCBCYW5rIiwiY29kZSI6Imluc3RhbGxtZW50QmFuayIsIm9yZGVyIjoxNSwiYWN0aXZlIjpmYWxzZX0seyJuYW1lIjoiSW5zdGFsbG1lbnQgUGVyaW9kIiwiY29kZSI6Imluc3RhbGxtZW50UGVyaW9kIiwib3JkZXIiOjE2LCJhY3RpdmUiOmZhbHNlfSx7Im5hbWUiOiJQcm9tb3Rpb24gQ29kZSIsImNvZGUiOiJwcm9tb3Rpb25Db2RlIiwib3JkZXIiOjE3LCJhY3RpdmUiOmZhbHNlfSx7Im5hbWUiOiJQcm9tb3Rpb24gTmFtZSIsImNvZGUiOiJwcm9tb3Rpb25OYW1lIiwib3JkZXIiOjE4LCJhY3RpdmUiOmZhbHNlfSx7Im5hbWUiOiJQcm9tb3Rpb24gUGFydG5lciIsImNvZGUiOiJwcm9tb3Rpb25QYXJ0bmVyIiwib3JkZXIiOjE5LCJhY3RpdmUiOmZhbHNlfSx7Im5hbWUiOiJPcmlnaW5hbCBBbW91bnQiLCJjb2RlIjoib3JpZ2luYWxBbW91bnQiLCJvcmRlciI6MjAsImFjdGl2ZSI6ZmFsc2V9LHsibmFtZSI6IlRyYW5zLiBBbW91bnQiLCJjb2RlIjoidHJhbnNBbW91bnQiLCJvcmRlciI6MjEsImFjdGl2ZSI6dHJ1ZX0seyJuYW1lIjoiT3JpZ2luYWwgRGF0ZSIsImNvZGUiOiJvcmlnaW5hbERhdGUiLCJvcmRlciI6MjIsImFjdGl2ZSI6ZmFsc2V9LHsibmFtZSI6IlRyYW5zLiBEYXRlIiwiY29kZSI6InRyYW5zRGF0ZSIsIm9yZGVyIjoyMywiYWN0aXZlIjp0cnVlfSx7Im5hbWUiOiJUcmFucy4gVHlwZSIsImNvZGUiOiJ0cmFuc1R5cGUiLCJvcmRlciI6MjQsImFjdGl2ZSI6dHJ1ZX0seyJuYW1lIjoiQXV0aGVudGljYXRpb24gU3RhdGUiLCJjb2RlIjoiYXV0aGVuU3RhdGUiLCJvcmRlciI6MjUsImFjdGl2ZSI6ZmFsc2V9LHsibmFtZSI6IlJlc3BvbnNlIENvZGUiLCJjb2RlIjoicmVzcG9uc2VDb2RlIiwib3JkZXIiOjI2LCJhY3RpdmUiOnRydWV9LHsibmFtZSI6Ikludm9pY2UgU3RhdGUiLCJjb2RlIjoiaW52b2ljZVN0YXRlIiwib3JkZXIiOjI3LCJhY3RpdmUiOnRydWV9LHsibmFtZSI6IlRyYW5zLiBTdGF0ZSIsImNvZGUiOiJ0cmFuc1N0YXRlIiwib3JkZXIiOjI4LCJhY3RpdmUiOnRydWV9LHsibmFtZSI6IkF1dGhvcml6YXRpb24gQ29kZSIsImNvZGUiOiJhdXRob0NvZGUiLCJvcmRlciI6MjksImFjdGl2ZSI6ZmFsc2V9LHsibmFtZSI6Ikluc3RhbGxtZW50IFN0YXR1cyIsImNvZGUiOiJpbnN0YWxsbWVudFN0YXR1cyIsIm9yZGVyIjozMCwiYWN0aXZlIjpmYWxzZX0seyJuYW1lIjoiSW50ZWdyYXRpb24gVHlwZSIsImNvZGUiOiJpbnRlVHlwZSIsIm9yZGVyIjozMSwiYWN0aXZlIjpmYWxzZX0seyJuYW1lIjoiVGhlbWUiLCJjb2RlIjoidGhlbWUiLCJvcmRlciI6MzIsImFjdGl2ZSI6ZmFsc2V9XQ%3D%3D; auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwic2lkIjoiNTFERDdDOUM3REE2QTI3ODhGNEFCNTNCNTZCRTY4MTEiLCJpYXQiOjE2ODU5MzE2ODQsImV4cCI6MTY4Njc5NTY4NCwic3ViIjoiNDAyNjUifQ.KSG3D4SC8dFM_LIouLptBRRypK3nenlinELNdRUxpkY
*** Test Cases ***
TC01 - Transaction Search
    [documentation]     Transaction Search
    ${testcasePath}=    Set Variable    /csv/TransactionSearchTC01.csv
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
    ...    merchantId
    ...    transactionId
    ...    orderInfo
    ...    merchantTxnRef
    ...    masking
    ...    appName
    ...    acqCode
    ...    status
    ...    channel

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
        ${transactionId}=    Get From Dictionary   ${req}    transactionId
        ${orderInfo}=        Get From Dictionary   ${req}    orderInfo
        ${merchantTransactionRef}=    Get From Dictionary   ${req}    merchantTransactionRef
        ${customerTransId}=    Get From Dictionary   ${req}    customerTransId
        ${merchantTransId}=    Get From Dictionary   ${req}    merchantTransId
        ${masking}=    Get From Dictionary   ${req}    masking
        ${cardType}=    Get From Dictionary   ${req}    cardType
        ${appName}=    Get From Dictionary   ${req}    appName
        ${acqCode}=    Get From Dictionary   ${req}    acqCode
        ${cardNumber}=    Get From Dictionary   ${req}    cardNumber
        ${platform}=    Get From Dictionary   ${req}    platform
        ${tid}=    Get From Dictionary   ${req}    tid
        ${mid}=    Get From Dictionary   ${req}    mid
        ${status}=    Get From Dictionary   ${req}    status
        ${channel}=    Get From Dictionary   ${req}    channel
        ${page}=                 Get From Dictionary   ${req}    page
        ${pageSize}=            Get From Dictionary   ${req}    pageSize
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL}?merchantId=${merchantId}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&fromDate=${fromDate}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&toDate=${toDate}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&transactionId=${transactionId}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&orderInfo=${orderInfo}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&merchantTransactionRef=${merchantTransactionRef}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&customerTransId=${customerTransId}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&merchantTransId=${merchantTransId}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&masking=${masking}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&cardType=${cardType}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&appName=${appName}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&acqCode=${acqCode}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&cardNumber=${cardNumber}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&platform=${platform}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&tid=${tid}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&mid=${mid}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&status=${status}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&channel=${channel}
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