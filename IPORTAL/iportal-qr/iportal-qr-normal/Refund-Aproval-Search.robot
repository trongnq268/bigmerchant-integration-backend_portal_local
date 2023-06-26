*** Settings ***
Library  RequestsLibrary
Library  json
Library  String
Library  py/ResultHandle.py
Library    Collections
# Resource  ../common/Common.robot

*** Keywords ***

Pre_request - Request - body
        [Arguments]     
        ...     ${fromDate}=01/11/2022 12:00 AM
        ...     ${toDate}=30/11/2022 11:59 PM
        ...     ${merchantId}=
        ...     ${transactionId}=
        ...     ${merchantTransactionRef}=
        ...     ${orderInfo}=
        ...     ${masking}=
        ...     ${cardType}=
        ...     ${appName}=
        ...     ${acqCode}=
        ...     ${page}=0
        ...     ${pageSize}=100
        ...     ${refundId}=
        ...     ${clientId}=
        ...     ${confirmable}=0
        ...     ${qrType}=
        ...     ${merchantChannel}=
        ${schema}     catenate    SEPARATOR=
            ...     {
            ...         "fromDate":"${fromDate}",
            ...         "toDate":"${toDate}",
            ...         "merchantId":"${merchantId}",
            ...         "transactionId":"${transactionId}",
            ...         "orderInfo":"${orderInfo}",
            ...         "merchantTransactionRef":"${merchantTransactionRef}",
            ...         "masking":"${masking}",
            ...         "cardType":"${cardType}",
            ...         "appName":"${appName}",
            ...         "acqCode":"${acqCode}",
            ...         "page":"${page}",
            ...         "pageSize":"${pageSize}",
            ...         "id":"${refundId}",
            ...         "channel":"${clientId}",
            ...         "confirmable":"${confirmable}",
            ...         "qrType":"${qrType}",
            ...         "merchantChannel":"${merchantChannel}"
            ...     }
        ${body}     loads   ${schema}
        [Return]    ${body}

*** Variables ***
${API_SEARCH_URL}     https://dev.onepay.vn/iportal/api/v1/qr/refund-approval
${COOKIE}            auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwic2lkIjoiNTFERDdDOUM3REE2QTI3ODhGNEFCNTNCNTZCRTY4MTEiLCJrZXlDbG9ha1Rva2VuIjoiZXlKaGJHY2lPaUpTVXpJMU5pSXNJblI1Y0NJZ09pQWlTbGRVSWl3aWEybGtJaUE2SUNKbVdrSXpjVXh0Y0RsWVYydEdVVk52VTBWT2NsOWFUbWw0VldoR2VFRTVZa05EUW5KdFF6SnNVWEpOSW4wLmV5SmxlSEFpT2pFMk56azFOVGMwTlRrc0ltbGhkQ0k2TVRZM09UVTFOekUxT1N3aVlYVjBhRjkwYVcxbElqb3hOamM1TlRVM01UVTVMQ0pxZEdraU9pSXpZV1E1T1dVNE1DMWxZakF5TFRRNFl6QXRPRE15TXkxalpERmpOVFJtTm1GallUVWlMQ0pwYzNNaU9pSm9kSFJ3Y3pvdkwyUmxkaTV2Ym1Wd1lYa3VkbTR2WVhWMGFDOXlaV0ZzYlhNdmIyNWxjR0Y1SWl3aVlYVmtJam9pYVhCdmNuUmhiQ0lzSW5OMVlpSTZJbUUxWXpRME9HRXdMVGRqT0dRdE5HWmlOaTA1TURSaUxUa3pZek5pWWpNd056SmpaQ0lzSW5SNWNDSTZJa2xFSWl3aVlYcHdJam9pYVhCdmNuUmhiQ0lzSW5ObGMzTnBiMjVmYzNSaGRHVWlPaUkzT0dKaFlqWXdPUzFrTUdWbExUUXhabUV0WVRJMU1DMWxaalV3WVRCbE1qVTFORGdpTENKaGRGOW9ZWE5vSWpvaVkzVnhSMXBvV1RKcVYyRmlhazFCU21veE0wcFBVU0lzSW1GamNpSTZJakVpTENKemFXUWlPaUkzT0dKaFlqWXdPUzFrTUdWbExUUXhabUV0WVRJMU1DMWxaalV3WVRCbE1qVTFORGdpTENKbGJXRnBiRjkyWlhKcFptbGxaQ0k2Wm1Gc2MyVXNJbTVoYldVaU9pSm9QeUIwYUQ5dVp5QlJkVDl1SUhSeVB5QjJhZS1fdlc0aUxDSndjbVZtWlhKeVpXUmZkWE5sY201aGJXVWlPaUpoWkcxcGJrQnZibVZ3WVhrdWRtNGlMQ0puYVhabGJsOXVZVzFsSWpvaWFEOGdkR2dfYm1jaUxDSm1ZVzFwYkhsZmJtRnRaU0k2SWxGMVAyNGdkSElfSUhacDc3LTliaUlzSW1WdFlXbHNJam9pWVdSdGFXNUFiMjVsY0dGNUxuWnVJbjAuZTJvYzdydVVqczhYaWY4TEVRZ2tLWlczaGd6aGNZMURSRWlTVFBjbzhCcjdOTG5WdXVwWVZob3pJcTZNWDVPSkY2VXg0ejVxU3B1TDJMcEU0dzhRTUp0M1lkbExRZDJ3SURUOHFKdDBuTUN5SlpPMUptWWVzb3ZBYXJOWVRCTWlqRmsyZXQtT0dXSnN3VDFYU04tYldaSVljcklNeE9fZ0EwXzhpTGVzOVV0dzRXQktoSWZmdnpuWFltQmpsZEZPTzdSX2lqTlhld1pSU3lEV1BBTk1GeVhxNmNBN00ybDNiZ1NsQzViTDRza29GSjhVZHZKQWVMS3NNN0FSQXA3Q3UyMVVid18yX1NQWlU4TEFGYVJRbE1qOVppRm9MejRsN1BPdzk2dmFTd0lKZzdRRjN6eFNMR2txblZCTVJJNFl1REY2MFNwbk9rZHItc2JhSmlDTld3IiwiaWF0IjoxNjc5NTY1NzUzLCJleHAiOjE2ODA0Mjk3NTMsInN1YiI6IjQwMjY1In0.hWbKKhmznpybD-lYEf1dCHZy96I84wO9-EuLMCfT050; Max-Age=14400; Expires=Thu, 23 Mar 2023 14:02:33 GMT; Path=/iportal; HTTPOnly
*** Test Cases ***
TC01 - Refund Aproval Transaction Search
    [documentation]     Refund Aproval Transaction Search
    ${testcasePath}=    Set Variable    /csv/RefundAprovalSearchTC01.csv
    ${request}    ${resultExpect}=    ResultHandle.Make Param    ${CURDIR}${testcasePath}
    # ${COOKIE}=    Common.GET COOKIE
    # ${resultExpect}=    ResultHandle.Make Result Expect    /home/hungld/bigmerchant-integration/config/result-expect.csv
    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json
    ...                            X-Request-Id=A5CEED7D80F454B6FD5BE3AA2F912824
    ...                            X-USER-ID=51DD7C9C7DA6A2788F4AB53B56BE6811
    ...                            User-Agent=Robot-Auto-Test
    ...                            Connection=keep-alive

    # ${fieldExpect} check trường bắt buộc trả ra
    ${fieldExpect}=    Create List
    ...    merchantId
    ...    transactionId
    # ...    refundId
    # ...    orderInfo
    # ...    merchantTxnRef
    # ...    acqCode
    # ...    cardType
    ...    appName
    # ...    masking
    # ...    clientId
    # ...    confirmable
    # ...    qrType
    # ...    merchantChannel

    ${valueExpect}     Create Dictionary    #trans_type=Refund Dispute   

    ${count}=    Set Variable    1
    ${finalResult}=    Set Variable    True

    Log To Console    ${resultExpect}

    FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect} 
        Log To Console    ********** REQUEST ***********${count}
        Log To Console    ${req}
        Log To Console    ********** RESULT EXPECT ***********
        Log To Console    ${ret}
        ${fromDate}=         Get From Dictionary   ${req}    fromDate
        ${toDate}=           Get From Dictionary   ${req}    toDate
        ${merchantId}=       Get From Dictionary   ${req}    merchantId
        ${transactionId}=    Get From Dictionary   ${req}    transactionId
        ${orderInfo}=        Get From Dictionary   ${req}    orderInfo
        ${merchantTransactionRef}=    Get From Dictionary   ${req}    merchantTransactionRef
        ${masking}=    Get From Dictionary   ${req}    masking
        ${cardType}=    Get From Dictionary   ${req}    cardType
        ${appName}=    Get From Dictionary   ${req}    appName
        ${acqCode}=    Get From Dictionary   ${req}    acqCode
        ${clientId}=    Get From Dictionary   ${req}    clientId
        ${page}=                 Get From Dictionary   ${req}    page
        ${pageSize}=            Get From Dictionary   ${req}    pageSize
        ${refundId}=    Get From Dictionary   ${req}    refundId
        ${confirmable}=    Get From Dictionary   ${req}    confirmable
        ${qrType}=    Get From Dictionary   ${req}    qrType
        ${merchantChannel}=    Get From Dictionary   ${req}    merchantChannel
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL}?merchantId=${merchantId}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&fromDate=${fromDate}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&toDate=${toDate}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&transactionId=${transactionId}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&orderInfo=${orderInfo}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&merchantTransactionRef=${merchantTransactionRef}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&masking=${masking}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&cardType=${cardType}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&appName=${appName}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&acqCode=${acqCode}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&page=${page}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&pageSize=${pageSize}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&refundId=${refundId}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&confirmable=${confirmable}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&clientId=${clientId}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&qrType=${qrType}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&merchantChannel=${merchantChannel}

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