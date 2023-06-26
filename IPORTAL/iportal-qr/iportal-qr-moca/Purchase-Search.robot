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
${API_SEARCH_URL}    http://127.0.0.1/iportal/api/v1/qr/purchase-search
${API_DETAIL_URL}    http://127.0.0.1/iportal/api/v1/qr/purchase-search/
${COOKIE}            columnList=MCwxLDIsMyw0LDUsNiw3LDgsOSwxMCwxMSwxMiwxMywxNCwxNSwxNywxOCwxOSwyMCwyMSwyMiwyMywyNCwyNiwyNywyOCwyOSwzMCwzMSwzMiwzMywzNA%3D%3D; auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwic2lkIjoiNTFERDdDOUM3REE2QTI3ODhGNEFCNTNCNTZCRTY4MTEiLCJrZXlDbG9ha1Rva2VuIjoiZXlKaGJHY2lPaUpTVXpJMU5pSXNJblI1Y0NJZ09pQWlTbGRVSWl3aWEybGtJaUE2SUNKbVdrSXpjVXh0Y0RsWVYydEdVVk52VTBWT2NsOWFUbWw0VldoR2VFRTVZa05EUW5KdFF6SnNVWEpOSW4wLmV5SmxlSEFpT2pFMk5qazNOelV4TlRnc0ltbGhkQ0k2TVRZMk9UYzNORGcxT0N3aVlYVjBhRjkwYVcxbElqb3hOalk1TnpjME9EVTNMQ0pxZEdraU9pSmxOREk0TkRZNU9DMHpPRGxpTFRRMFpXRXRPV1V4WXkxaE1XTmpZekU1WlRJeE56QWlMQ0pwYzNNaU9pSm9kSFJ3Y3pvdkwyUmxkaTV2Ym1Wd1lYa3VkbTR2WVhWMGFDOXlaV0ZzYlhNdmIyNWxjR0Y1SWl3aVlYVmtJam9pYVhCdmNuUmhiQ0lzSW5OMVlpSTZJamt5WlRReU9XVTNMVGc0WVRVdE5ESmpaaTFoT1RWaExXVTJNV0pqTWpZME1EVmtZaUlzSW5SNWNDSTZJa2xFSWl3aVlYcHdJam9pYVhCdmNuUmhiQ0lzSW5ObGMzTnBiMjVmYzNSaGRHVWlPaUl3TVRZNU1qQmtaaTAwWWpFd0xUUTJZall0WVdZMk1TMWlZemcwT0RZeFlUSTVPVGNpTENKaGRGOW9ZWE5vSWpvaVVtZHJORmN4Y3psbVIzWnhiR0ZUZW10cVFuVllaeUlzSW1GamNpSTZJakVpTENKemFXUWlPaUl3TVRZNU1qQmtaaTAwWWpFd0xUUTJZall0WVdZMk1TMWlZemcwT0RZeFlUSTVPVGNpTENKbGJXRnBiRjkyWlhKcFptbGxaQ0k2Wm1Gc2MyVXNJbTVoYldVaU9pSjFjMlZ5SUdGa2JXbHVJSFZ6WlhJaUxDSndjbVZtWlhKeVpXUmZkWE5sY201aGJXVWlPaUpoWkcxcGJrQnZibVZ3WVhrdWRtNGlMQ0puYVhabGJsOXVZVzFsSWpvaWRYTmxjaUlzSW1aaGJXbHNlVjl1WVcxbElqb2lZV1J0YVc0Z2RYTmxjaUlzSW1WdFlXbHNJam9pWVdSdGFXNUFiMjVsY0dGNUxuWnVJbjAuRnFRSWtrMWxSZ1lOdzRKYWtsbDdNRUg1OHg0VndIRzZKSkxkN1c0dWFqU3YyaEFyUWttY0FLcEdJM25Jb1paYTN0QTF0eS0wRDZqRUJSaTZSZ3dnMi1NVklIMlNGVDJja1FWTGhqOHdFU0Z3OUFCcWVpRDlfTzI4Q2JEN3pmVUNHX3JZY2pwMnQ5Y2FsZ1dwVGg1RXJCbW9JVzZoN0hMd2M0RjRKdXJEMUstam9MZGMtTGdPQ2VOMlltVTJIVXBHNkJsdERCemFzRy1pa0VIZHdYVVlHbzZlQVhXaWZ3VFpvM2pENE4zM1hGTHdaN1VLbzl4eUNnR255dG1OZTdBMjNrU3ZMVi1xVjBZRmRjMTBDQjNscF94TlV0ZGM4SDZTc0NqQ19sRXprOHY5Vzg4dHRoWjFKdWMzUXRmNDNaclYySUdrZ2k3YmhiSXFRZ2ZZNnllYS1BIiwiaWF0IjoxNjY5NzgyNzg3LCJleHAiOjE2NzA2NDY3ODcsInN1YiI6IjQwMjY1In0.rDXs7TUqrcSoHn8vtUXXcXnGB2T-dwve7pG1nZOdL30; _ga=GA1.2.1910318981.1667011125
*** Test Cases ***
TC01 - Transaction Search
    [documentation]     Transaction Search
    ${testcasePath}=    Set Variable    /csv/PurchaseSearchTC01.csv
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
    ...    transactionId
    ...    orderInfo
    ...    merchantTxnRef
    ...    masking
    ...    appName
    ...    acqCode
    ...    status
    ...    channel

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
        ${customerTransId}=    Get From Dictionary   ${req}    customerTransId
        ${merchantTransId}=    Get From Dictionary   ${req}    merchantTransId
        ${masking}=    Get From Dictionary   ${req}    masking
        ${cardType}=    Get From Dictionary   ${req}    cardType
        ${appName}=    Get From Dictionary   ${req}    appName
        ${acqCode}=    Get From Dictionary   ${req}    acqCode
        ${cardNumber}=    Get From Dictionary   ${req}    cardNumber
        ${platform}=    Get From Dictionary   ${req}    platform
        ${tid}=    Get From Dictionary   ${req}    tid
        ${mid}=    Get From Dictionary   ${req}    mid
        ${status}=    Get From Dictionary   ${req}    status
        ${channel}=    Get From Dictionary   ${req}    channel
        ${page}=                 Get From Dictionary   ${req}    page
        ${pageSize}=            Get From Dictionary   ${req}    pageSize
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL}?merchantId=${merchantId}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&fromDate=${fromDate}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&toDate=${toDate}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&transactionId=${transactionId}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&orderInfo=${orderInfo}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&merchantTransactionRef=${merchantTransactionRef}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&customerTransId=${customerTransId}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&merchantTransId=${merchantTransId}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&masking=${masking}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&cardType=${cardType}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&appName=${appName}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&acqCode=${acqCode}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&cardNumber=${cardNumber}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&platform=${platform}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&tid=${tid}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&mid=${mid}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&status=${status}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&channel=${channel}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&page=${page}
        ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&pageSize=${pageSize}

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
    ${testcasePath}=    Set Variable    /csv/PurchaseSearchTC02.csv
    ${request}    ${resultExpect}=    ResultHandle.Make Param    ${CURDIR}${testcasePath}
    # ${COOKIE}=    Common.GET COOKIE
    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json

    ${fieldExpect}=    Create List
    ...    merchantId
    ...    transactionId
    ...    orderInfo
    ...    merchantTxnRef
    ...    masking
    ...    appName
    ...    acqCode
    ...    status
    ...    channel

    Log To Console    ${request}
    ${count}=    Set Variable    1
    ${finalResult}=    Set Variable    True

        FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect}
            Log To Console    ${req}
            Log To Console    ${ret}
            Log To Console    ********** REQUEST TRANS ID *********** ${count}
            ${transactionId}    Get From Dictionary    ${req}    transactionId
            Log To Console      Transaction ID: ${transactionId}
            ${transactionType}    Get From Dictionary    ${req}    transactionType
            Log To Console      Transaction Type: ${transactionType}
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
    ${testcasePath}=    Set Variable    /csv/PurchaseSearchTC03.csv
    ${request}    ${resultExpect}=    ResultHandle.Make Param    ${CURDIR}${testcasePath}
    # ${COOKIE}=    Common.GET COOKIE
    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json

    ${fieldExpect}=    Create List
    ...    merchantId
    ...    transactionId
    ...    orderInfo
    ...    merchantTxnRef
    ...    masking
    ...    appName
    ...    acqCode
    ...    status
    ...    channel

    Log To Console    ${request}
    ${count}=    Set Variable    1

        FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect}
            Log To Console    ${req}
            Log To Console    ${ret}
            Log To Console    ********** REQUEST TRANS ID *********** ${count}
            ${transID}    Get From Dictionary    ${req}    transactionId
            Log To Console      Transaction ID: ${transID}
            
            ${responseDetail}=    GET    ${API_DETAIL_URL}${transID}/history    headers=${header}

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