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
${API_SEARCH_URL}    http://127.0.0.1/iportal/api/v1/bnpl/report
${COOKIE}            columnList=bm8sZ2F0ZSxtZXJjaGFudElkLHRyYW5zSWQsb3JkZXJSZWYsbWVyY2hhbnRUcmFuc1JlZixjYXJkVHlwZSxjYXJkTnVtYmVyLHByb21vdGlvblBhcnRuZXIsdHJhbnNBbW91bnQsdHJhbnNEYXRlLHRyYW5zVHlwZSxyZXNwb25zZUNvZGUsaW52b2ljZVN0YXRlLHRyYW5zU3RhdGUsdGhlbWU%3D; columnList=MCwxLDIsMyw0LDUsNiw3LDgsOSwxMCwxMSwxMiwxMywxNCwxNSwxNiwxNywxOCwxOSwyMCwyMSwyMiwyMywyNCwyNSwyNiwyNywyOCwyOSwzMCwzMSwzMiwzNg%3D%3D; auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwic2lkIjoiNTFERDdDOUM3REE2QTI3ODhGNEFCNTNCNTZCRTY4MTEiLCJpYXQiOjE2NzQwMDg2ODMsImV4cCI6MTY3NzYwODY4Mywic3ViIjoiNDAyNjUifQ.ITazjrtm-pFigmaBmii6h-MfofLcIDrkHH0vlqdYp4g
*** Test Cases ***
TC01 - Report Search
    [documentation]     Report Search
    ${testcasePath}=    Set Variable    /csv/ReportTC01.csv
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
    ...    transAmount

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
        ${interval}=        Get From Dictionary   ${req}    interval
        ${provider}=    Get From Dictionary   ${req}    provider
        ${status}=    Get From Dictionary   ${req}    status
        ${type_search}=    Get From Dictionary   ${req}    type_search
        ${other}=    Get From Dictionary   ${req}    other
        ${version}=    Get From Dictionary   ${req}    version
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL}?from_date=${from_date}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&to_date=${to_date}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&merchant_id=${merchant_id}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&merchant_name=${merchant_name}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&partner=${partner}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&interval=${interval}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&provider=${provider}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&status=${status}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&type_search=${type_search}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&other=${other}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&version=${version}

        #================= START CALL API =====================#
        ${response}=  GET    ${API_SEARCH_URL_ADD_PARAM}    headers=${header}
        # Log To Console    ${response.text}
        #==================***CHECK RESULT***==================#
        
        # Should Be Equal As Numbers    ${response.status_code}    200
        ${flgCheckContain}  ${listObjectFail}    ${totalPassed}    ${totalFailed}
        ...    ResultHandle.Check Response Report    ${response.text}    ${fieldExpect}    ${ret}
        
        Log To Console    TotalPass: ${totalPassed}
        Log To Console    TotalFail: ${totalFailed}
        Log To Console    List Object failed: ${listObjectFail}
        IF    ${flgCheckContain} == False
            ${finalResult}=    Set Variable    False
        END
        
        ${count}=    Evaluate    ${count} + 1
    END
    Should Be Equal As Strings    ${finalResult}    True