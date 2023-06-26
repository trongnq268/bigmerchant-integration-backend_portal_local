*** Settings ***
Library  RequestsLibrary
Library  json
Library  String
Library  py/ResultHandle.py
Library    Collections
Resource  ../common/Common.robot

*** Keywords ***

Pre_request - Request - body

*** Variables ***
${API_DETAIL_URL}    http://127.0.0.1/iportal/api/v1/ss-trans-management/purchase-qt/
${COOKIE}            auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwic2lkIjoiNTFERDdDOUM3REE2QTI3ODhGNEFCNTNCNTZCRTY4MTEiLCJpYXQiOjE2ODQxMjE4NDMsImV4cCI6MTY4NzcyMTg0Mywic3ViIjoiNDAyNjUifQ.CxVREQK2hRKQqMMAxvHF0uYnCRDei3oagbKJZuR_zlE; Max-Age=60000; Expires=Mon, 15 May 2023 20:17:23 GMT; Path=/iportal; HTTPOnly
*** Test Cases ***
TC01 - Transaction Detail Compare
    [documentation]     Transaction Search
    ${testcasePath}=    Set Variable    /csv/InternationalDetailTC01.csv
    ${request}    ${resultExpect}=    ResultHandle.Make Param    ${CURDIR}${testcasePath}
    # ${COOKIE}=    Common.GET COOKIE
    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json

    ${fieldExpect}=    Create List
    # ...    merchantId

    Log To Console    ${request}
    ${count}=    Set Variable    1
    ${finalResult}=    Set Variable    True

        FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect}
            Log To Console    ${req}
            Log To Console    ${ret}
            Log To Console    ********** REQUEST TRANS ID *********** ${count}
            ${transactionId}    Get From Dictionary    ${req}    transactionId
            Log To Console      Transaction ID: ${transactionId}
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