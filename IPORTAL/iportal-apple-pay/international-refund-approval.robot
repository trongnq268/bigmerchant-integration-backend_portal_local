*** Settings ***
Library  RequestsLibrary
Library  json
Library  String
Library  py/ResultHandle.py
Library    Collections
Resource  ../common/Common.robot

*** Keywords ***

Pre_request - Request - body

*** Variables ***
${API_SEARCH_URL}    http://127.0.0.1/iportal/api/v1/international/refund-approval
${COOKIE}            auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwic2lkIjoiNTFERDdDOUM3REE2QTI3ODhGNEFCNTNCNTZCRTY4MTEiLCJpYXQiOjE2ODQxMjY5ODIsImV4cCI6MTY4NzcyNjk4Miwic3ViIjoiNDAyNjUifQ.qqcXwZB7YsIY0Ahid3zt865QjOGQDs-W508JKNqq31c; Max-Age=60000; Expires=Mon, 15 May 2023 21:43:02 GMT; Path=/iportal; HTTPOnly
*** Test Cases ***
TC01 - Transaction Search
    [documentation]     Transaction Search
    ${testcasePath}=    Set Variable    /csv/InternationalRefundApprovalTC01.csv
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
        ${merchantId}=       Get From Dictionary   ${req}    merchantId
        ${fromDate}=         Get From Dictionary   ${req}    fromDate
        ${toDate}=           Get From Dictionary   ${req}    toDate
        ${transactionId}=       Get From Dictionary   ${req}    transactionId
        ${networkTransactionId}=    Get From Dictionary   ${req}    networkTransactionId
        ${orderInfo}=        Get From Dictionary   ${req}    orderInfo
        ${acquirerId}=    Get From Dictionary   ${req}    acquirerId
        ${cardNumber}=    Get From Dictionary   ${req}    cardNumber
        ${source}=    Get From Dictionary   ${req}    source
        ${tokenNumber}=    Get From Dictionary   ${req}    tokenNumber
        ${currency}=    Get From Dictionary   ${req}    currency
        ${gate}=    Get From Dictionary   ${req}    gate
        ${status}=    Get From Dictionary   ${req}    status
        ${page}=    Get From Dictionary   ${req}    page
        ${authCode}=    Get From Dictionary   ${req}    authCode
        ${refundApproveType}=    Get From Dictionary   ${req}    refundApproveType
        ${confirmable}=    Get From Dictionary   ${req}    confirmable
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL}?merchantId=${merchantId}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&fromDate=${fromDate}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&toDate=${toDate}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&transactionId=${transactionId}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&networkTransactionId=${networkTransactionId}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&orderInfo=${orderInfo}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&acquirerId=${acquirerId}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&cardNumber=${cardNumber}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&source=${source}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&tokenNumber=${tokenNumber}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&currency=${currency}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&gate=${gate}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&status=${status}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&page=${page}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&authCode=${authCode}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&refundApproveType=${refundApproveType}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&confirmable=${confirmable}

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
