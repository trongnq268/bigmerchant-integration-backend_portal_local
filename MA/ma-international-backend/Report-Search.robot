*** Settings ***
Library  RequestsLibrary
Library  json
Library  String
Library  ../../config/ResultHandle.py
Library    Collections

*** Keywords ***

Pre_request - Request - body
        [Arguments]     ${merchant_id}=
        ...     ${from_date}=21/10/2022 12:00 AM
        ...     ${to_date}=21/10/2022 11:59 PM
        ...     ${transaction_id}=
        ...     ${order_info}=
        ...     ${merchant_transaction_ref}=
        ...     ${card_number}=
        ...     ${authorisation_code}= 
        ...     ${card_type}=
        ...     ${currency}= 
        ...     ${transaction_type}=
        ...     ${transaction_state}=
        ...     ${installment_bank}=
        ...     ${installment_status}=
        ...     ${risk_assessment}=
        ...     ${hidden_column}=
        ...     ${page}=0
        ...     ${page_size}=100
        ${schema}     catenate    SEPARATOR=
            ...     {
            ...         "from_date":"${from_date}",
                ...     "to_date":"${to_date}",
                ...     "transaction_id":"${transaction_id}",
                ...     "order_info":"${order_info}",
                ...     "merchant_transaction_ref":"${merchant_transaction_ref}",
                ...     "card_number":"${card_number}",
                ...     "authorisation_code":"${authorisation_code}",
                ...     "card_type":"${card_type}",
                ...     "currency":"${currency}",
                ...     "transaction_type":"${transaction_type}",
                ...     "transaction_state":"${transaction_state}",
                ...     "installment_bank":"${installment_bank}",
                ...     "installment_status":"${installment_status}",
                ...     "risk_assessment":"${risk_assessment}",
                ...     "hidden_column":"${hidden_column}",
                ...     "page":"${page}",
                ...     "page_size":"${page_size}"
            ...     }
        ${body}     loads   ${schema}
        [Return]    ${body}

*** Variables ***
${API_SEARCH_URL}    http://127.0.0.1/ma/api/v1/international/report
${COOKIE}            auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwiaWF0IjoxNjc2MjU3NDM2LCJleHAiOjE2NzYyNjQ2MzYsInN1YiI6IjUxREQ3QzlDN0RBNkEyNzg4RjRBQjUzQjU2QkU2ODExIn0.4Qt6-ODE0U0O85MMMZ6G85WP4zYrv0SiLqqEAMYMnXo
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
    ...    type

    ${valueExpect}     Create Dictionary    #trans_type=Refund Dispute   

    ${count}=    Set Variable    1
    ${finalResult}=    Set Variable    True

    Log To Console    ${resultExpect}

    FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect} 
        Log To Console    ********** REQUEST ***********${count}
        Log To Console    ${req}
        Log To Console    ********** RESULT EXPECT ***********
        Log To Console    ${ret}
        ${merchant_id}=       Get From Dictionary   ${req}    merchant_id
        ${from_date}=         Get From Dictionary   ${req}    from_date
        ${to_date}=           Get From Dictionary   ${req}    to_date
        ${interval}=       Get From Dictionary   ${req}    interval
        ${currency}=    Get From Dictionary   ${req}    currency
        ${version}=        Get From Dictionary   ${req}    version
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL}?merchant_id=${merchant_id}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&from_date=${from_date}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&to_date=${to_date}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&interval=${interval}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&currency=${currency}
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
