*** Settings ***
Library     RequestsLibrary
Library     json
Library     String
Library     ../../config/DomesticHandle.py
Resource    ../common/Common.robot

*** Variables ***
${API_SEARCH_URL}
...                         https://dev.onepay.vn/ma/api/v1/domestic/samsung/transaction
${API_DETAIL_URL}           https://dev.onepay.vn/ma/api/v1/domestic/samsung/transaction/
# ${COOKIE}
# ...                         auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiMDMga-G7uSB0aHXhuq10IiwiZW1haWwiOiJ1c2VyMDNAb25lcGF5LnZuIiwicGhvbmUiOiI4NDk4NzY1NDU1NSIsImFkZHJlc3MiOiJobiAiLCJpYXQiOjE2NjcxOTk1MjgsImV4cCI6MTY2NzIwNjcyOCwic3ViIjoiOEQzRTBCNzQ5MjYxQjc4NzBEQ0EzMDEwNUFBQUU0RUIifQ.k7mo3PAQUBNES-Q1pzTG6Tq7R2SxNbdpTshrpwEqiC4; Max-Age=7200; Expires=Mon, 31 Oct 2022 08:58:48 GMT; Path=/ma; HTTPOnly

${TC01_SEARCH}              /json/SS_TC01_SEARCH.json
${TC02_SEARCH_CARD_NUMBER}  /json/SS_TC02_SEARCH_CARD_NUMBER.json
${TC03_SEARCH_BANK_ID}      /json/SS_TC03_SEARCH_BANK_ID.json


*** Test Cases ***
TC01 - SS Transaction Search
    [Documentation]    Get Transaction by filter
    ${request}    ${resultExpect}=    DomesticHandle.Make Param Json    ${CURDIR}${TC01_SEARCH}
    ${COOKIE}=    Common.GET COOKIE
    &{header}=    Create Dictionary    Cookie=${COOKIE}
    ...    Content-Type=application/json
    ...    X-USER-ID=xxx
    ...    User-Agent=Robot-Auto-Test
    ...    Connection=keep-alive

    ${fieldExpect}=    Create List
    ...    transaction_id
    ...    merchant_id
    ...    merchant_transaction_ref order_info transaction_time
    ${valueExpect}=    Create Dictionary    #trans_type=Refund Dispute
    ${finalResult}=    Set Variable    True

    FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect}
        #================= START CALL API =====================#
        ${response}=    GET    ${API_SEARCH_URL}    params=${req}    headers=${header}

        #==================***CHECK RESULT***==================#

        Should Be Equal As Numbers    ${response.status_code}    200
        ${flgCheckContain}    ${listObjectFail}=    DomesticHandle.Check Response Content
        ...    ${response.text}
        ...    ${fieldExpect}
        ...    ${ret}
        Log To Console    ${listObjectFail}
        IF    ${flgCheckContain} == False
            ${finalResult}=    Set Variable    False
        END
    END
    Log To Console    ********** RESPONSE SEARCH TC01 ***********
    Should Be Equal As Strings    ${finalResult}    True

TC02 - Transaction Search_Card_number
    [Documentation]    Get Transaction by filter
    ${request}    ${resultExpect}=    DomesticHandle.Make Param Json    ${CURDIR}${TC02_SEARCH_CARD_NUMBER}
    ${COOKIE}=    Common.GET COOKIE
    &{header}=    Create Dictionary    Cookie=${COOKIE}
    ...    Content-Type=application/json
    ...    X-USER-ID=xxx
    ...    User-Agent=Robot-Auto-Test
    ...    Connection=keep-alive

    ${fieldExpect}=    Create List
    ...    transaction_id
    ...    merchant_id
    ...    merchant_transaction_ref order_info transaction_time

    ${finalResult}=    Set Variable    True

    FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect}
        #================= START CALL API =====================#
        ${response}=    GET    ${API_SEARCH_URL}    params=${req}    headers=${header}

        #==================***CHECK RESULT***==================#

        Should Be Equal As Numbers    ${response.status_code}    200
        ${flgCheckContain}    ${listObjectFail}=    DomesticHandle.checkResponseCardNumber
        ...    ${response.text}
        ...    ${ret}
        Log To Console    ${listObjectFail}
        IF    ${flgCheckContain} == False
            ${finalResult}=    Set Variable    False
        END
    END
    Log To Console    ********** RESPONSE SEARCH CARD NUMBER TC02 ***********
    # Log To Console    ${response.text}
    Should Be Equal As Strings    ${finalResult}    True

TC03 - Transaction Search_Bank_ID
    [Documentation]    Get Transaction by filter
    ${request}    ${resultExpect}=    DomesticHandle.Make Param Json    ${CURDIR}${TC03_SEARCH_BANK_ID}
    ${COOKIE}=    Common.GET COOKIE
    &{header}=    Create Dictionary    Cookie=${COOKIE}
    ...    Content-Type=application/json
    ...    X-USER-ID=xxx
    ...    User-Agent=Robot-Auto-Test
    ...    Connection=keep-alive

    ${fieldExpect}=    Create List
    ...    transaction_id
    ...    merchant_id
    ...    merchant_transaction_ref order_info transaction_time

    ${finalResult}=    Set Variable    True

    FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect}
        #================= START CALL API =====================#
        ${response}=    GET    ${API_SEARCH_URL}    params=${req}    headers=${header}

        #==================***CHECK RESULT***==================#

        Should Be Equal As Numbers    ${response.status_code}    200
        ${flgCheckContain}    ${listObjectFail}=    DomesticHandle.checkResponseBankID
        ...    ${response.text}
        ...    ${ret}
        Log To Console    ${listObjectFail}
        IF    ${flgCheckContain} == False
            ${finalResult}=    Set Variable    False
        END
    END
    Log To Console    ********** RESPONSE SEARCH BANK ID TC03 ***********
    # Log To Console    ${response.text}
    Should Be Equal As Strings    ${finalResult}    True

TC04 - Transaction Detail
    [Documentation]    Transaction Search
    ${testcasePath}=    Set Variable    /json/SS_TC04_TRANSACTION_DETAIL.json
    ${request}    ${resultExpect}=    DomesticHandle.read file json    ${CURDIR}${testcasePath}
    ${COOKIE}=    Common.GET COOKIE
    &{header}=    Create Dictionary    Cookie=${COOKIE}
    ...    Content-Type=application/json

    Log To Console    ${request}
    ${finalResult}=    Set Variable    True

    FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect}
        Log To Console    ********** REQUEST TRANS SEARCH ***********
        Log To Console    ${req}

        ${responseDetail}=    GET    ${API_DETAIL_URL}${req["transaction_id"]}    headers=${header}

        Should Be Equal As Numbers    ${responseDetail.status_code}    200
        Log To Console    ${responseDetail.text}

        #==================***CHECK RESULT***==================#
        ${flgCheckContain}    ${listObjectFail}=    DomesticHandle.compare str response and obj json
        ...    ${responseDetail.text}
        ...    ${ret}

        Log To Console    ${listObjectFail}
        IF    ${flgCheckContain} == False
            ${finalResult}=    Set Variable    False
        END
    END
    Log To Console    ********** RESPONSE TRANSACTION DETAIL TC04 ***********
    # Log To Console    ${response.text}
    Should Be Equal As Strings    ${finalResult}    True

# TC05 - Transaction Detail History
#    [Documentation]    Transaction Search
#    ${testcasePath}=    Set Variable    /csv/TC05-TRANSACTION_HISTORY.csv
#    ${request}    ${resultExpect}=    DomesticHandle.Make Param    ${CURDIR}${testcasePath}
#    &{header}=    Create Dictionary    Cookie=${COOKIE}
#    ...    Content-Type=application/json

#    Log To Console    ${request}

#    FOR    ${req}    IN    @{request}
#    Log To Console    ********** REQUEST TRANS SEARCH HISTORY ***********
#    Log To Console    ${req}

#    ${responseDetail}=    GET    ${API_DETAIL_URL}${req["transaction_id"]}/history    headers=${header}

#    Should Be Equal As Numbers    ${responseDetail.status_code}    200
#    Log To Console    ${responseDetail.text}

#    #==================***CHECK RESULT***==================#
#    ${flgCheckContain}    ${listObjectFail}=    DomesticHandle.Compare Array Json
#    ...    ${responseDetail.text}
#    ...    ${resultExpect}

#    Log To Console    ${listObjectFail}

#    Should Be Equal As Strings    ${flgCheckContain}    True
#    END
