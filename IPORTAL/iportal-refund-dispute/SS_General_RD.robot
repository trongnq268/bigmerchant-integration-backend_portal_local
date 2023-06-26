*** Settings ***
Library     RequestsLibrary
Library     json
Library     String
Library     ../../config/Iportal_refund_dispute_Handle.py
Library     Collections


*** Variables ***
${API_SEARCH_URL}       https://dev.onepay.vn/iportal/api/v1
${API_DETAIL_URL}       https://dev.onepay.vn/iportal/api/v1/ss-trans-management/refund-qt/
${API_HISTORY_URL}      https://dev.onepay.vn/iportal/api/v1/ss-trans-management/qt/
${COOKIE}
...                     auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwic2lkIjoiNTFERDdDOUM3REE2QTI3ODhGNEFCNTNCNTZCRTY4MTEiLCJpYXQiOjE2NjcxODYxMDEsImV4cCI6MTY2ODA1MDEwMSwic3ViIjoiNDAyNjUifQ.3tksFGr-wFEIkltArASRoWbCC_NES9OxGzxLDzYDQ5E; Max-Age=14400; Expires=Mon, 31 Oct 2022 07:15:01 GMT; Path=/iportal; HTTPOnly


*** Test Cases ***
TC01 - SS Transaction Search
    [Documentation]    Transaction Search
    ${testcasePath}=    Set Variable    /csv/SS-TC01-transaction-search.csv
    ${request}    ${resultExpect}=    Iportal_refund_dispute_Handle.Make Param    ${CURDIR}${testcasePath}
    &{header}=    Create Dictionary    Cookie=${COOKIE}
    ...    Content-Type=application/json

    ${fieldExpect}=    Create List    id    merchant_id    date
    ${valueExpect}=    Create Dictionary    trans_type=Refund Dispute

    Log To Console    ${resultExpect}
    Create Session    success    ${API_SEARCH_URL}
    ${finalResult}=    Set Variable    True

    FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect}
        Log To Console    ${req}
        Log To Console    ********** RESULT EXPECT ***********
        Log To Console    ${ret}
        #================= START CALL API =====================#
        # ${response}=    POST    ${API_SEARCH_URL}    params=${req}    headers=${header}
        ${dataSearch}=    Iportal_refund_dispute_Handle.String To Json    ${req}
        ${response}=    POST On Session    success    /ss-trans-management    data=${dataSearch}    headers=${header}

        #==================***CHECK RESULT***==================#

        Should Be Equal As Numbers    ${response.status_code}    200
        ${flgCheckContain}    ${listObjectFail}=    Iportal_refund_dispute_Handle.Check Response Content ss
        ...    ${response.text}
        ...    ${fieldExpect}
        ...    ${ret}
        Log To Console    TC01 List Object failed: ${listObjectFail}
        IF    ${flgCheckContain} == False
            ${finalResult}=    Set Variable    False
        END
        
    END
    Log To Console    ********** RESPONSE SEARCH TC01 ***********
    Should Be Equal As Strings    ${finalResult}    True

TC02 - SS Transaction Detail
    [Documentation]    Transaction Search
    ${testcasePath}=    Set Variable    /csv/SS-TC02-transaction-search-detail.csv
    ${request}    ${resultExpect}=    Iportal_refund_dispute_Handle.Make Param    ${CURDIR}${testcasePath}
    &{header}=    Create Dictionary    Cookie=${COOKIE}
    ...    Content-Type=application/json

    Log To Console    ${request}

    ${finalResult}=    Set Variable    True

    FOR    ${req}    IN    @{request}
        Log To Console    ********** REQUEST TRANS SEARCH ***********
        Log To Console    ${req}

        ${responseDetail}=    GET    ${API_DETAIL_URL}${req["s_key"]}    headers=${header}

        Should Be Equal As Numbers    ${responseDetail.status_code}    200
        Log To Console    ${responseDetail.text}

        #==================***CHECK RESULT***==================#
        ${flgCheckContain}    ${listObjectFail}=    Iportal_refund_dispute_Handle.Compare Obj Json
        ...    ${responseDetail.text}
        ...    ${resultExpect}

        Log To Console    TC02 List Object failed: ${listObjectFail}
        IF    ${flgCheckContain} == False
            ${finalResult}=    Set Variable    False
        END

    END
    Log To Console    ********** RESPONSE TRANSACTION DETAIL TC02 ***********
    Should Be Equal As Strings    ${finalResult}    True
    
TC03 - SS Transaction Detail History
    [Documentation]    Transaction Search
    ${testcasePath}=    Set Variable    /csv/SS-TC03-transaction-detail-history.csv
    ${request}    ${resultExpect}=    Iportal_refund_dispute_Handle.Make Param ss   ${CURDIR}${testcasePath}
    &{header}=    Create Dictionary    Cookie=${COOKIE}
    ...    Content-Type=application/json

    Log To Console    ${request}
    ${finalResult}=    Set Variable    True

    FOR    ${req}    IN    @{request}
        Log To Console    ********** REQUEST TRANS SEARCH HISTORY ***********
        Log To Console    ${req}

        ${responseDetail}=    GET    ${API_HISTORY_URL}${req["s_key"]}/history    headers=${header}

        Should Be Equal As Numbers    ${responseDetail.status_code}    200
        Log To Console    ${responseDetail.text}

        #==================***CHECK RESULT***==================#
        ${flgCheckContain}    ${listObjectFail}=    Iportal_refund_dispute_Handle.Compare Array Json ss
        ...    ${responseDetail.text}
        ...    ${resultExpect}

        Log To Console    TC03 List Object failed: ${listObjectFail}
        IF    ${flgCheckContain} == False
            ${finalResult}=    Set Variable    False
        END

    END
    Log To Console    ********** RESPONSE TRANSACTION DETAIL HISTORY TC03 ***********
    Should Be Equal As Strings    ${finalResult}    True