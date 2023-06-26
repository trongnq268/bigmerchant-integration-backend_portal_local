*** Settings ***
Library     RequestsLibrary
Library     json
Library     String
Library     ../../../config/QrReportHandle.py
Library     Collections
Resource    ../../common/Common.robot

*** Variables ***
${API_SEARCH_URL}       http://127.0.0.1/iportal/api/v1/qr/report
${API_DETAIL_URL}       https://dev.onepay.vn/iportal/api/v1/international/transaction/


*** Test Cases ***
TC01 - Transaction Search
    [Documentation]    Transaction Search
    ${testcasePath}=    Set Variable    /csv/TC01-report.csv
    ${request}    ${resultExpect}=    QrReportHandle.Make Param    ${CURDIR}${testcasePath}
    #${COOKIE}=    Common.GET COOKIE
    &{header}=    Create Dictionary    Cookie=auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwic2lkIjoiNTFERDdDOUM3REE2QTI3ODhGNEFCNTNCNTZCRTY4MTEiLCJpYXQiOjE2Nzk1NjgzNDQsImV4cCI6MTY4MzE2ODM0NCwic3ViIjoiNDAyNjUifQ.z2I3RxhKiQiqb-3DWxCyFI-oUb861I7Xqbyigh775B4; Max-Age=60000; Expires=Fri, 24 Mar 2023 03:25:44 GMT; Path=/iportal; HTTPOnly

    # ...    Content-Type=application/json
    # ...    X-USER-ID=51DD7C9C7DA6A2788F4AB53B56BE6811

    ${fieldExpect}=    Create List    reportDate
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
        # ${response}=    GET    ${API_SEARCH_URL}    params=${req}    headers=${header}

        ${merchant_id}=       Get From Dictionary   ${req}    merchant_id
        ${from_date}=         Get From Dictionary   ${req}    from_date
        ${to_date}=           Get From Dictionary   ${req}    to_date
        ${interval}=    Get From Dictionary   ${req}    interval
        ${acqCode}=        Get From Dictionary   ${req}    acqCode
        ${card_type}=    Get From Dictionary   ${req}    card_type
        ${appName}=          Get From Dictionary   ${req}    appName
        ${tid}=   Get From Dictionary   ${req}    tid
        ${mid}=            Get From Dictionary   ${req}    mid
        ${channel}=             Get From Dictionary   ${req}    channel
        ${platform}=     Get From Dictionary   ${req}    platform
        ${masking}=    Get From Dictionary   ${req}    masking
        ${qrType}=    Get From Dictionary   ${req}    qrType
        ${merchantChannel}=    Get From Dictionary   ${req}    merchantChannel
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL}?merchant_id=${merchant_id}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&from_date=${from_date}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&to_date=${to_date}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&interval=${interval}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&acqCode=${acqCode}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&card_type=${card_type}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&appName=${appName}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&tid=${tid}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&mid=${mid}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&channel=${channel}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&platform=${platform}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&masking=${masking}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&qrType=${qrType}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&merchantChannel=${merchantChannel}

        ${response}=  GET    ${API_SEARCH_URL_ADD_PARAM}    headers=${header}

        #==================***CHECK RESULT***==================#

        Should Be Equal As Numbers    ${response.status_code}    200
        ${flgCheckContain}  ${listObjectFail}    ${totalPassed}    ${totalFailed}
        ...    QrReportHandle.Check Response Content    ${response.text}    ${fieldExpect}    ${ret}
        
        Log To Console    Total Trans Pass: ${totalPassed}
        Log To Console    Total Trans Fail: ${totalFailed}
        Log To Console    List Object failed: ${listObjectFail}

        Log To Console    TC01 List Object failed: ${listObjectFail}
        IF    ${flgCheckContain} == False
            ${finalResult}=    Set Variable    False
        END
        ${count}=    Evaluate    ${count} + 1
    END
    Log To Console    ********** RESPONSE SEARCH TC01 ***********
    Should Be Equal As Strings    ${finalResult}    True