*** Settings ***
Library  RequestsLibrary
Library  json
Library  String
Library  ../../config/ResultHandle.py
Library    Collections
Resource    ../common/Common.robot

*** Keywords ***

Pre_request - Request - body
        [Arguments]     ${merchant_id}=
        ...     ${from_date}=21/10/2022 12:00 AM
        ...     ${to_date}=21/10/2022 11:59 PM
        ...     ${transaction_id}=
        ...     ${order_info}=
        ...     ${merchant_transaction_ref}=
        ...     ${card_number}=
        ...     ${authorisation_code}= 
        ...     ${card_type}=
        ...     ${currency}= 
        ...     ${transaction_type}=
        ...     ${transaction_state}=
        ...     ${installment_bank}=
        ...     ${installment_status}=
        ...     ${risk_assessment}=
        ...     ${hidden_column}=
        ...     ${page}=0
        ...     ${page_size}=100
        ${schema}     catenate    SEPARATOR=
            ...     {
            ...         "from_date":"${from_date}",
                ...     "to_date":"${to_date}",
                ...     "transaction_id":"${transaction_id}",
                ...     "order_info":"${order_info}",
                ...     "merchant_transaction_ref":"${merchant_transaction_ref}",
                ...     "card_number":"${card_number}",
                ...     "authorisation_code":"${authorisation_code}",
                ...     "card_type":"${card_type}",
                ...     "currency":"${currency}",
                ...     "transaction_type":"${transaction_type}",
                ...     "transaction_state":"${transaction_state}",
                ...     "installment_bank":"${installment_bank}",
                ...     "installment_status":"${installment_status}",
                ...     "risk_assessment":"${risk_assessment}",
                ...     "hidden_column":"${hidden_column}",
                ...     "page":"${page}",
                ...     "page_size":"${page_size}"
            ...     }
        ${body}     loads   ${schema}
        [Return]    ${body}

*** Variables ***
${API_SEARCH_URL}     http://127.0.0.1/ma/api/v1/international/transaction
${API_DETAIL_URL}    http://127.0.0.1/ma/api/v1/international/transaction/
${API_DETAIL_REQ_REFUND_URL}    https://127.0.0.1/api/v1/international/transaction/
${API_DETAIL_VOID_REFUND_CAPTURE_URL}    https://127.0.0.1/api/v1/international/transaction/void/
*** Test Cases ***
TC01 - Transaction Search
    [Documentation]     Transaction Search
    ${testcasePath}=    Set Variable    /csv/TC01-Transaction-Search.csv
    ${request}    ${resultExpect}=    ResultHandle.Make Param    ${CURDIR}${testcasePath}
    ${COOKIE}=    Common.GET COOKIE
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

    Log To Console    ${COOKIE}

    FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect} 
        Log To Console    ********** REQUEST ***********${count}
        Log To Console    ${req}
        Log To Console    ********** RESULT EXPECT ***********
        Log To Console    ${ret}
        #================= START CALL API =====================#
        ${response}=  GET    ${API_SEARCH_URL}    params=${req}     headers=${header}
        # Log To Console    ${response.text}
        #==================***CHECK RESULT***==================#
        
        # Should Be Equal As Numbers    ${response.status_code}    200
        ${flgCheckContain}  ${listObjectFail}    ${totalPassed}    ${totalFailed}
        ...    ResultHandle.Check Response Content    ${response.text}    ${fieldExpect}    ${ret}
        
        Log To Console    Total Trans Pass: ${totalPassed}
        Log To Console    Total Trans Fail: ${totalFailed}
        Log To Console    List Object failed: ${listObjectFail}
        IF    ${flgCheckContain} == False
            ${finalResult}=    Set Variable    False
        END
        
        
        ${count}=    Evaluate    ${count} + 1
    END
    Should Be Equal As Strings    ${finalResult}    True

TC02 - Transaction Detail Compare
    [Documentation]     Transaction Search
    ${testcasePath}=    Set Variable    /csv/TC02-Transaction-Search-Detail-Comp.csv
    ${request}    ${resultExpect}=    ResultHandle.Make Param    ${CURDIR}${testcasePath}
    ${COOKIE}=    Common.GET COOKIE
    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json

    ${fieldExpect}     Create List    id   merchant_id    date

    Log To Console    ${request}
    ${count}=    Set Variable    1
    ${finalResult}=    Set Variable    True

        FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect}
            Log To Console    ${req}
            Log To Console    ${ret}
            Log To Console    ********** REQUEST TRANS ID *********** ${count}
            ${transID}    Get From Dictionary    ${req}    transaction_id
            Log To Console      Transaction ID: ${transID}
            ${transType}    Get From Dictionary    ${req}    transaction_type
            IF    "${transType}" == "Request Refund"
                ${responseDetail}=    GET    ${API_DETAIL_REQ_REFUND_URL}${transID}    headers=${header}    
            ELSE IF    "${transType}" == "Void Refund Capture" or "${transType}" == "Refund Capture" or "${transType}" == "Void Purchase" or "${transType}" == "Void Authorize" or "${transType}" == "Void Refund" or "${transType}" == "Void Capture" or "${transType}" == "Refund" or "${transType}" == "Refund" or "${transType}" == "Refund Dispute"
                ${responseDetail}=    GET    ${API_DETAIL_VOID_REFUND_CAPTURE_URL}${transID}    headers=${header}
            ELSE
                ${responseDetail}=    GET    ${API_DETAIL_URL}${transID}    headers=${header}
            END

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
    [Documentation]     Transaction Search
    ${testcasePath}=    Set Variable    /csv/TC03-History-Comp.csv
    ${request}    ${resultExpect}=    ResultHandle.Make Param    ${CURDIR}${testcasePath}
    ${COOKIE}=    Common.GET COOKIE
    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json

    ${fieldExpect}     Create List    id   merchant_id    date

    Log To Console    ${request}
    ${count}=    Set Variable    1

        FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect}
            Log To Console    ${req}
            Log To Console    ${ret}
            Log To Console    ********** REQUEST TRANS ID *********** ${count}
            ${transID}    Get From Dictionary    ${req}    transaction_id
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
        