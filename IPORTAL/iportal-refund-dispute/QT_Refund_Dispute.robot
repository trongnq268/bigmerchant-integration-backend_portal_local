*** Settings ***
Library     RequestsLibrary
Library     json
Library     String
Library     ../../config/Iportal_refund_dispute_Handle.py
Library     Collections

*** Variables ***
${API_SEARCH_URL}       https://dev.onepay.vn/iportal/api/v1/international/transaction
${API_DETAIL_URL}       https://dev.onepay.vn/iportal/api/v1/international/transaction/
${COOKIE}
...                     auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwic2lkIjoiNTFERDdDOUM3REE2QTI3ODhGNEFCNTNCNTZCRTY4MTEiLCJpYXQiOjE2NjcxODYxMDEsImV4cCI6MTY2ODA1MDEwMSwic3ViIjoiNDAyNjUifQ.3tksFGr-wFEIkltArASRoWbCC_NES9OxGzxLDzYDQ5E; Max-Age=14400; Expires=Mon, 31 Oct 2022 07:15:01 GMT; Path=/iportal; HTTPOnly


*** Test Cases ***
TC01 - Transaction Search
    [Documentation]    Transaction Search
    ${testcasePath}=    Set Variable    /csv/TC01-transaction-search.csv
    ${request}    ${resultExpect}=    Iportal_refund_dispute_Handle.Make Param    ${CURDIR}${testcasePath}
    &{header}=    Create Dictionary    Cookie=${COOKIE}
    ...    Content-Type=application/json

    ${fieldExpect}=    Create List    id    merchant_id    date
    ${valueExpect}=    Create Dictionary    trans_type=Refund Dispute

    ${count}=    Set Variable    1

    Log To Console    ${resultExpect}
    ${finalResult}=    Set Variable    True

    FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect}
        Log To Console    ********** REQUEST ***********${count}
        Log To Console    ${req}
        Log To Console    ********** RESULT EXPECT ***********
        Log To Console    ${ret}
        #================= START CALL API =====================#
        ${response}=    GET    ${API_SEARCH_URL}    params=${req}    headers=${header}

        #==================***CHECK RESULT***==================#

        Should Be Equal As Numbers    ${response.status_code}    200
        ${flgCheckContain}    ${listObjectFail}=    Iportal_refund_dispute_Handle.Check Response Content
        ...    ${response.text}
        ...    ${fieldExpect}
        ...    ${ret}

        Log To Console    TC01 List Object failed: ${listObjectFail}
        IF    ${flgCheckContain} == False
            ${finalResult}=    Set Variable    False
        END
        ${count}=    Evaluate    ${count} + 1
    END
    Log To Console    ********** RESPONSE SEARCH TC01 ***********
    Should Be Equal As Strings    ${finalResult}    True

TC02 - Transaction Detail
    [Documentation]    Transaction Search
    ${testcasePath}=    Set Variable    /csv/TC02-transaction-search-detail.csv
    ${request}    ${resultExpect}=    Iportal_refund_dispute_Handle.Make Param    ${CURDIR}${testcasePath}
    &{header}=    Create Dictionary    Cookie=${COOKIE}
    ...    Content-Type=application/json

    Log To Console    ${request}
    ${finalResult}=    Set Variable    True

    FOR    ${req}    IN    @{request}
        Log To Console    ********** REQUEST TRANS SEARCH ***********
        Log To Console    ${req}

        ${responseDetail}=    GET    ${API_DETAIL_URL}${req["transaction_id"]}    headers=${header}

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

TC03 - Transaction Detail History
    [Documentation]    Transaction Search
    ${testcasePath}=    Set Variable    /csv/TC03-transaction-hisory.csv
    ${request}    ${resultExpect}=    Iportal_refund_dispute_Handle.Make Param    ${CURDIR}${testcasePath}
    &{header}=    Create Dictionary    Cookie=${COOKIE}
    ...    Content-Type=application/json

    Log To Console    ${request}
    ${finalResult}=    Set Variable    True

    FOR    ${req}    IN    @{request}
        Log To Console    ********** REQUEST TRANS SEARCH HISTORY ***********
        Log To Console    ${req}

        ${responseDetail}=    GET    ${API_DETAIL_URL}${req["transaction_id"]}/history    headers=${header}

        Should Be Equal As Numbers    ${responseDetail.status_code}    200
        Log To Console    ${responseDetail.text}

        #==================***CHECK RESULT***==================#
        ${flgCheckContain}    ${listObjectFail}=    Iportal_refund_dispute_Handle.Compare Array Json
        ...    ${responseDetail.text}
        ...    ${resultExpect}

        Log To Console    TC03 List Object failed: ${listObjectFail}
        IF    ${flgCheckContain} == False
            ${finalResult}=    Set Variable    False
        END

        
    END
    Log To Console    ********** RESPONSE TRANSACTION DETAIL HISTORY TC03 ***********
    Should Be Equal As Strings    ${finalResult}    True
# TC02 - Transaction Search And Detail Compare
#    [Documentation]    Transaction Search
#    ${testcasePath}=    Set Variable    /csv/TC02-Transaction-Search-Detail-Comp.csv
#    ${request}    ${resultExpect}=    Iportal_refund_dispute_Handle.Make Param    ${CURDIR}${testcasePath}
#    &{header}=    Create Dictionary    Cookie=${COOKIE}
#    ...    Content-Type=application/json

#    ${fieldExpect}=    Create List    id    merchant_id    date

#    Log To Console    ${request}
#    ${count}=    Set Variable    1
#    FOR    ${req}    ${ret}    IN    @{request} ${resultExpect}
#    Log To Console    ********** REQUEST TRANS SEARCH ***********${count}
#    Log To Console    ${req}
#    #================= START CALL API SEARCH =====================#
#    ${response_search}=    GET    ${API_SEARCH_URL}    params=${req}    headers=${header}

#    # Log To Console    ${response_1.text}
#    ${listTransID}=    Iportal_refund_dispute_Handle.Get Ids    ${response_search.text}
#    Should Be Equal As Numbers    ${response_search.status_code}    200
#    FOR    ${transID}    IN    @{listTransID}
#    Log To Console    ********** REQUEST TRANS ID ***********${transID}
#    ${responseDetail}=    GET    ${API_DETAIL_URL}${transID}    headers=${header}

#    Should Be Equal As Numbers    ${responseDetail.status_code}    200
#    Log To Console    ${responseDetail.text}

#    #==================***CHECK RESULT***==================#
#    ${flgCheckContain}    ${listObjectFail}=    Iportal_refund_dispute_Handle.Check Response Search And Detail
#    ...    ${response_search.text}
#    ...    ${responseDetail.text}

#    Log To Console    ${listObjectFail}

#    Should Be Equal As Strings    ${flgCheckContain}    True
#    END

#    ${count}=    Evaluate    ${count} + 1
#    END


*** Keywords ***
Pre_request - Request - body
    [Arguments]    ${merchant_id}=
    ...    ${from_date}=21/10/2022 12:00 AM
    ...    ${to_date}=21/10/2022 11:59 PM
    ...    ${transaction_id}=
    ...    ${order_info}=
    ...    ${merchant_transaction_ref}=
    ...    ${card_number}=
    ...    ${authorisation_code}=
    ...    ${card_type}=
    ...    ${currency}=
    ...    ${transaction_type}=
    ...    ${transaction_state}=
    ...    ${installment_bank}=
    ...    ${installment_status}=
    ...    ${risk_assessment}=
    ...    ${hidden_column}=
    ...    ${page}=0
    ...    ${page_size}=100
    ${schema}=    catenate    SEPARATOR=
    ...    {
    ...    "from_date":"${from_date}",
    ...    "to_date":"${to_date}",
    ...    "transaction_id":"${transaction_id}",
    ...    "order_info":"${order_info}",
    ...    "merchant_transaction_ref":"${merchant_transaction_ref}",
    ...    "card_number":"${card_number}",
    ...    "authorisation_code":"${authorisation_code}",
    ...    "card_type":"${card_type}",
    ...    "currency":"${currency}",
    ...    "transaction_type":"${transaction_type}",
    ...    "transaction_state":"${transaction_state}",
    ...    "installment_bank":"${installment_bank}",
    ...    "installment_status":"${installment_status}",
    ...    "risk_assessment":"${risk_assessment}",
    ...    "hidden_column":"${hidden_column}",
    ...    "page":"${page}",
    ...    "page_size":"${page_size}"
    ...    }
    ${body}=    loads    ${schema}
    RETURN    ${body}
