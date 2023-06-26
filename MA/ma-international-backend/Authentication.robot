*** Settings ***
Library  RequestsLibrary
Library  json
Library  String
Library  py/AuthenticationHandle.py
Library  Collections

*** Keywords ***

*** Variables ***
${API_SEARCH_URL}    http://127.0.0.1/ma/api/v1/international/authentication
${API_DETAIL_URL}    http://127.0.0.1/ma/api/v1/international/authentication/
${COOKIE}            auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwia2V5Y2xvYWtUb2tlbiI6bnVsbCwiaWF0IjoxNjc1OTUwODEzLCJleHAiOjE2NzU5NTgwMTMsInN1YiI6IjUxREQ3QzlDN0RBNkEyNzg4RjRBQjUzQjU2QkU2ODExIn0.SYv1wiVeSdGmo6HKHwcVOO3jq6eqUVtfJ4pBOoEXpc8
*** Test Cases ***
Authentication Search
    [documentation]     Transaction Search
    ${testcasePath}=    Set Variable    /csv/TC01.csv
    ${request}    ${resultExpect}=    AuthenticationHandle.Get Param From Xlsx    ${CURDIR}/xlsx/Authentication.xlsx    Search
    # ${resultExpect}=    ResultHandle.Make Result Expect    /home/hungld/bigmerchant-integration/config/result-expect.csv
    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json
    ...                            X-USER-ID=xxx
    ...                            User-Agent=Robot-Auto-Test
    ...                            Connection=keep-alive
                
    ${fieldExpect}     Create List    id   merchant_id    date
    ${valueExpect}     Create Dictionary    trans_type=Refund Dispute   

    ${count}=    Set Variable    1
    ${finalResult}=    Set Variable    True

    Log To Console    ${resultExpect}

    FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect} 
        Log To Console    ********** REQUEST ***********${count}
        Log To Console    ${req}
        Log To Console    ********** RESULT EXPECT ***********
        Log To Console    ${ret}
        #================= START CALL API =====================#
        ${response}=  GET    ${API_SEARCH_URL}    params=${req}     headers=${header}
        # Log To Console    ${response.text}
        #==================***CHECK RESULT***==================#
        ${flgCheckContain}  ${listObjectFail}    ${totalPassed}    ${totalFailed}
        ...    AuthenticationHandle.Check Response Content    ${response.status_code}    ${response.text}    ${ret}
        
        Log To Console    TotalPass: ${totalPassed}
        Log To Console    TotalFail: ${totalFailed}
        Log To Console    List Object failed: ${listObjectFail}
        IF    ${flgCheckContain} == False
            ${finalResult}=    Set Variable    False
        END
        
        
        ${count}=    Evaluate    ${count} + 1
    END
    Should Be Equal As Strings    ${finalResult}    True

TC02 - Transaction Search And Detail Compare
    [documentation]     Authentication Detail
    ${request}    ${resultExpect}=    AuthenticationHandle.Get Param From Xlsx    ${CURDIR}/xlsx/Authentication.xlsx    Detail
    # ${resultExpect}=    ResultHandle.Make Result Expect    /home/hungld/bigmerchant-integration/config/result-expect.csv
    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json
    ...                            X-USER-ID=xxx
    ...                            User-Agent=Robot-Auto-Test
    ...                            Connection=keep-alive
                
    ${fieldExpect}     Create List    id   merchant_id    date
    ${valueExpect}     Create Dictionary    trans_type=Refund Dispute   

    ${count}=    Set Variable    1
    ${finalResult}=    Set Variable    True

    Log To Console    ${resultExpect}

    FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect} 
        Log To Console    ********** REQUEST ***********${count}
        Log To Console    ${req}
        Log To Console    ********** RESULT EXPECT ***********
        Log To Console    ${ret}
        #================= START CALL API =====================#
        ${id}=  Get From Dictionary        ${req}       transaction_id
        # ${id}=    math.ceil(${id})
        ${id} =  Convert To Integer  ${id}
        ${response}=  GET    ${API_SEARCH_URL}/${id}     headers=${header}
        # Log To Console    ${response.text}
        #==================***CHECK RESULT***==================#
        ${flgCheckContain}  ${listObjectFail}    ${totalPassed}    ${totalFailed}
        ...    AuthenticationHandle.Check Response Detail    ${response.status_code}    ${response.text}    ${ret}
        
        Log To Console    TotalPass: ${totalPassed}
        Log To Console    TotalFail: ${totalFailed}
        Log To Console    List Object failed: ${listObjectFail}
        IF    ${flgCheckContain} == False
            ${finalResult}=    Set Variable    False
        END
        
        
        ${count}=    Evaluate    ${count} + 1
    END
    Should Be Equal As Strings    ${finalResult}    True