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
${API_SEARCH_URL}    http://127.0.0.1/iportal/api/v1/bnpl/transaction
${API_DETAIL_URL}    http://127.0.0.1/iportal/api/v1/bnpl/transaction/
${API_HISTORY_URL}    http://127.0.0.1/iportal/api/v1/bnpl/refund/history/
${COOKIE}            columnList=bm8sZ2F0ZSxtZXJjaGFudElkLHRyYW5zSWQsb3JkZXJSZWYsbWVyY2hhbnRUcmFuc1JlZixjYXJkVHlwZSxjYXJkTnVtYmVyLHByb21vdGlvblBhcnRuZXIsdHJhbnNBbW91bnQsdHJhbnNEYXRlLHRyYW5zVHlwZSxyZXNwb25zZUNvZGUsaW52b2ljZVN0YXRlLHRyYW5zU3RhdGUsdGhlbWU%3D; columnList=MCwxLDIsMyw0LDUsNiw3LDgsOSwxMCwxMSwxMiwxMywxNCwxNSwxNiwxNywxOCwxOSwyMCwyMSwyMiwyMywyNCwyNSwyNiwyNywyOCwyOSwzMCwzMSwzMiwzNg%3D%3D; auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwic2lkIjoiNTFERDdDOUM3REE2QTI3ODhGNEFCNTNCNTZCRTY4MTEiLCJpYXQiOjE2NzQwMDg2ODMsImV4cCI6MTY3NzYwODY4Mywic3ViIjoiNDAyNjUifQ.ITazjrtm-pFigmaBmii6h-MfofLcIDrkHH0vlqdYp4g
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
        ${from_date}=         Get From Dictionary   ${req}    from_date
        ${to_date}=           Get From Dictionary   ${req}    to_date
        ${merchant_id}=       Get From Dictionary   ${req}    merchant_id
        ${merchant_name}=       Get From Dictionary   ${req}    merchant_name
        ${partner}=    Get From Dictionary   ${req}    partner
        ${time_search}=        Get From Dictionary   ${req}    time_search
        ${original_trans_id}=    Get From Dictionary   ${req}    original_trans_id
        ${refund_id}=    Get From Dictionary   ${req}    refund_id
        ${order_info}=    Get From Dictionary   ${req}    order_info
        ${merchant_transaction_ref}=    Get From Dictionary   ${req}    merchant_transaction_ref
        ${provider_ref}=    Get From Dictionary   ${req}    provider_ref
        ${settlement_ref}=    Get From Dictionary   ${req}    settlement_ref
        ${provider}=    Get From Dictionary   ${req}    provider
        ${model}=    Get From Dictionary   ${req}    model
        ${cus_mobile_num}=    Get From Dictionary   ${req}    cus_mobile_num
        ${transaction_type}=    Get From Dictionary   ${req}    transaction_type
        ${status}=    Get From Dictionary   ${req}    status
        ${refund_type}=    Get From Dictionary   ${req}    refund_type
        ${ext_search}=    Get From Dictionary   ${req}    ext_search
        ${from_value}=    Get From Dictionary   ${req}    from_value
        ${to_value}=    Get From Dictionary   ${req}    to_value
        ${type_search}=    Get From Dictionary   ${req}    type_search
        ${page}=                 Get From Dictionary   ${req}    page
        ${page_size}=            Get From Dictionary   ${req}    page_size
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL}?type_search=${type_search}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&from_date=${from_date}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&to_date=${to_date}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&merchant_id=${merchant_id}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&merchant_name=${merchant_name}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&partner=${partner}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&time_search=${time_search}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&original_trans_id=${original_trans_id}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&refund_id=${refund_id}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&order_info=${order_info}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&merchant_transaction_ref=${merchant_transaction_ref}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&provider_ref=${provider_ref}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&settlement_ref=${settlement_ref}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&provider=${provider}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&model=${model}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&cus_mobile_numd=${cus_mobile_num}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&transaction_type=${transaction_type}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&status=${status}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&refund_type=${refund_type}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&ext_search=${ext_search}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&from_value=${from_value}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&to_value=${to_value}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&page=${page}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&page_size=${page_size}

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
    ${testcasePath}=    Set Variable    /csv/TransactionSearchTC02.csv
    ${request}    ${resultExpect}=    ResultHandle.Make Param    ${CURDIR}${testcasePath}
    # ${COOKIE}=    Common.GET COOKIE
    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json

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

    Log To Console    ${request}
    ${count}=    Set Variable    1
    ${finalResult}=    Set Variable    True

        FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect}
            Log To Console    ${req}
            Log To Console    ${ret}
            Log To Console    ********** REQUEST TRANS ID *********** ${count}
            ${transactionId}    Get From Dictionary    ${req}    transactionId
            Log To Console      Transaction ID: ${transactionId}
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
    ${testcasePath}=    Set Variable    /csv/TransactionSearchTC03.csv
    ${request}    ${resultExpect}=    ResultHandle.Make Param    ${CURDIR}${testcasePath}
    # ${COOKIE}=    Common.GET COOKIE
    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json

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

    Log To Console    ${request}
    ${count}=    Set Variable    1

        FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect}
            Log To Console    ${req}
            Log To Console    ${ret}
            Log To Console    ********** REQUEST TRANS ID *********** ${count}
            ${transactionId}    Get From Dictionary    ${req}    transactionId
            Log To Console      Transaction ID: ${transactionId}
            
            ${responseDetail}=    GET    ${API_HISTORY_URL}${transactionId}    headers=${header}

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