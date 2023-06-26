*** Settings ***
Library  RequestsLibrary
Library  ../../common/common.py
Library    Collections
Suite Setup    FROM CSV

*** Variables ***
${API_SEARCH_URL}     https://dev.onepay.vn/iportal/api/v1/international/transaction
${COOKIE}            auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwic2lkIjoiNTFERDdDOUM3REE2QTI3ODhGNEFCNTNCNTZCRTY4MTEiLCJpYXQiOjE2ODM4NjcyNzksImV4cCI6MTY4NDczMTI3OSwic3ViIjoiNDAyNjUifQ.RbA3y7oyo6PqUuWeEfnuFD4UHG_j_cEj4otuu75trho; Max-Age=14400; Expires=Fri, 12 May 2023 08:54:39 GMT; Path=/iportal; HTTPOnly

*** Keywords ***
FROM CSV
    ${testcasePath}=    Set Variable    /csv/CheckPaymentAmountTC01.csv
    ${input01}    ${expect01}=    common.Make Param    ${CURDIR}${testcasePath}
    Set Suite Variable    ${input01}
    Set Suite Variable    ${expect01}

    ${tc02}=    Set Variable    /csv/CheckPaymentAmountTC02.csv
    ${input02}    ${expect02}=    common.Make Param    ${CURDIR}${tc02}
    Set Suite Variable    ${input02}
    Set Suite Variable    ${expect02}

*** Test Cases ***
TC01 - Check original amount and payment amount in international txt search
    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json
    ...                            X-Request-Id=4AE9E2BB2ABA0719DF6C8B87D6035F3A
    ...                            X-USER-ID=51DD7C9C7DA6A2788F4AB53B56BE6811
    ...                            User-Agent=Robot-Auto-Test
    ...                            Connection=keep-alive
    ${count}=    Set Variable    1
    ${finalResult}=    Set Variable    True
    ${fieldExpect}=    Create List
    FOR    ${req}    ${ret}    IN ZIP    ${input01}    ${expect01}
        Log To Console    ********** REQUEST ***********${count}
        Log To Console    ${req}
        Log To Console    ********** RESULT EXPECT ***********
        Log To Console    ${ret}
        ${fromDate}=         Get From Dictionary   ${req}    fromDate
        ${toDate}=           Get From Dictionary   ${req}    toDate
        ${merchantId}=       Get From Dictionary   ${req}    merchantId
        ${transactionId}=    Get From Dictionary   ${req}    transactionId
        ${transactionType}=    Get From Dictionary   ${req}    transaction_type
        ${page}=             Get From Dictionary   ${req}    page
        ${pageSize}=         Get From Dictionary   ${req}    pageSize
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL}?merchant_id=${merchantId}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&from_date=${fromDate}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&to_date=${toDate}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&transaction_id=${transactionId}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&transaction_type=${transactionType}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&sent_bank_date=null
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&page=${page}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&page_size=${pageSize}

        #================= START CALL API =====================#
        ${response}=  GET    ${API_SEARCH_URL_ADD_PARAM}    headers=${header}
        #==================***CHECK RESULT***==================#
        ${flgCheckContain}  ${listObjectFail}    ${totalPassed}    ${totalFailed}
        ...    common.Check List Response    ${response.text}    ${fieldExpect}    ${ret}
        
        Log To Console    TotalPass: ${totalPassed}
        Log To Console    TotalFail: ${totalFailed}
        Log To Console    List Object failed: ${listObjectFail}
        IF    ${flgCheckContain} == False
            ${finalResult}=    Set Variable    False
        END
        ${count}=    Evaluate    ${count} + 1
    END
    Should Be Equal As Strings    ${finalResult}    True

TC02 - Check original amount and payment amount in international transaction detail
    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json
    ...                            X-Request-Id=4AE9E2BB2ABA0719DF6C8B87D6035F3A
    ...                            X-USER-ID=51DD7C9C7DA6A2788F4AB53B56BE6811
    ...                            User-Agent=Robot-Auto-Test
    ...                            Connection=keep-alive
    ${count}=    Set Variable    1
    ${finalResult}=    Set Variable    True
    ${fieldExpect}=    Create List
    FOR    ${req}    ${ret}    IN ZIP    ${input02}    ${expect02}
        Log To Console    ********** REQUEST ***********${count}
        Log To Console    ${req}
        Log To Console    ********** RESULT EXPECT ***********
        Log To Console    ${ret}
        ${transactionId}=    Get From Dictionary   ${req}    transactionId
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL}/${transactionId}

        #================= START CALL API =====================#
        ${response}=  GET    ${API_SEARCH_URL_ADD_PARAM}    headers=${header}
        #==================***CHECK RESULT***==================#
        ${flgCheckContain}  ${listObjectFail}    ${totalPassed}    ${totalFailed}
        ...    common.Check Detail Response    ${response.text}    ${fieldExpect}    ${ret}
        
        Log To Console    TotalPass: ${totalPassed}
        Log To Console    TotalFail: ${totalFailed}
        Log To Console    List Object failed: ${listObjectFail}
        IF    ${flgCheckContain} == False
            ${finalResult}=    Set Variable    False
        END
        ${count}=    Evaluate    ${count} + 1
    END
    Should Be Equal As Strings    ${finalResult}    True