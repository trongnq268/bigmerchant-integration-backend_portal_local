*** Settings ***
Library  RequestsLibrary
Library  ../../common/common.py
Library    Collections
Suite Setup    FROM CSV

*** Variables ***
${API_SEARCH_URL}     https://dev.onepay.vn/iportal/api/v1/domestic/report
${COOKIE}            auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwic2lkIjoiNTFERDdDOUM3REE2QTI3ODhGNEFCNTNCNTZCRTY4MTEiLCJpYXQiOjE2ODM4ODI2MzUsImV4cCI6MTY4NDc0NjYzNSwic3ViIjoiNDAyNjUifQ.PPiajl18j3Wvyf66MHn2jvT4Azw10Yvdwg64e9rPzlU; Max-Age=14400; Expires=Fri, 12 May 2030 13:10:35 GMT; Path=/iportal; HTTPOnly

*** Keywords ***
FROM CSV
    ${testcasePath}=    Set Variable    /csv/CheckPaymentAmountTC01.csv
    ${input01}    ${expect01}=    common.Make Param    ${CURDIR}${testcasePath}
    Set Suite Variable    ${input01}
    Set Suite Variable    ${expect01}

Check Original Amount And Payment Amount
    [Arguments]    ${req}    ${ret}
    Log To Console    ********** REQUEST ***********
    Log To Console    ${req}
    Log To Console    ********** RESULT EXPECT ***********
    Log To Console    ${ret}
    ${fieldExpect}=    Create List
    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json
    ...                            X-Request-Id=4AE9E2BB2ABA0719DF6C8B87D6035F3A
    ...                            X-USER-ID=51DD7C9C7DA6A2788F4AB53B56BE6811
    ...                            User-Agent=Robot-Auto-Test
    ...                            Connection=keep-alive    
    ${fromDate}=         Get From Dictionary   ${req}    fromDate
    ${toDate}=           Get From Dictionary   ${req}    toDate
    ${merchantId}=       Get From Dictionary   ${req}    merchantId
    ${interval}=         Get From Dictionary   ${req}    interval
    ${version}=          Get From Dictionary   ${req}    version
    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL}?merchant_id=${merchantId}
    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&from_date=${fromDate}
    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&to_date=${toDate}
    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&interval=${interval}
    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&version=${version}

    ${response}=  GET    ${API_SEARCH_URL_ADD_PARAM}    headers=${header}

    ${flgCheckContain}  ${listObjectFail}    ${totalPassed}    ${totalFailed}
    ...    common.Check Detail Response    ${response.text}    ${fieldExpect}    ${ret}
    
    Log To Console    TotalPass: ${totalPassed}
    Log To Console    TotalFail: ${totalFailed}
    Log To Console    List Object failed: ${listObjectFail}
    IF    ${flgCheckContain} == False
        ${finalResult}=    Set Variable    False
    END
    Should Be Equal As Integers    ${totalFailed}    0


*** Test Cases ***
TC01 - Check original amount and payment amount in domestic report
    [Template]    Check Original Amount And Payment Amount
    FOR    ${req}    ${ret}    IN ZIP    ${input01}    ${expect01}
        ${req}    ${ret}
    END