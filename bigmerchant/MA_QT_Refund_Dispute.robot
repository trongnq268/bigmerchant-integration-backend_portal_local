*** Settings ***
Library  RequestsLibrary
Library  json
Library  String
Library  ../config/ResultHandle.py

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


*** Test Cases ***
TC01 - Transaction Search
    [documentation]     Get Transaction by filter
    ${request}    ${resultExpect}=    ResultHandle.Make Param    /root/projects/onepay/python/bigmerchant-integration/config/ma-qt-transaction-search-tc.csv
    # ${resultExpect}=    ResultHandle.Make Result Expect    /home/hungld/bigmerchant-integration/config/result-expect.csv
    &{header}=  Create Dictionary  Cookie=auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwiaWF0IjoxNjY2NjgzMDc1LCJleHAiOjE2NjY2OTAyNzUsInN1YiI6IjUxREQ3QzlDN0RBNkEyNzg4RjRBQjUzQjU2QkU2ODExIn0.gdJtATbUCdudy_myMawgJ3SLFLXbDF3aVbL3Yc_nl0A; Max-Age=7200; Expires=Tue, 25 Oct 2022 09:31:15 GMT; Path=/ma; HTTPOnly
    ...                            Content-Type=application/json


    ${fieldExpect}     Create List    id   merchant_id    date
    ${valueExpect}     Create Dictionary    trans_type=Refund Dispute   

    Log To Console    ${resultExpect}

    FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect} 
        Log To Console    ********** REQUEST ***********
        Log To Console    ${req}
        Log To Console    ********** RESULT EXPECT ***********
        Log To Console    ${ret}
        #================= START CALL API =====================#
        ${response}=  GET      https://dev.onepay.vn/ma/api/v1/transaction/financial        params=${req}     headers=${header} 
        
        #==================***CHECK RESULT***==================#
        
        Should Be Equal As Numbers    ${response.status_code}    200
        ${flgCheckContain}  ${listObjectFail}    ResultHandle.Check Response Content    ${response.text}    ${fieldExpect}    ${ret}
        Log To Console    ${listObjectFail}
        
        Should Be Equal As Strings    ${flgCheckContain}    True
    END