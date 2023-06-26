*** Settings ***
Library  RequestsLibrary
Library  json
Library  String
Library  ../config/ResultHandle.py

*** Keywords ***

# Pre_request - Request - body
#         [Arguments]     ${merchant_id}=
#         ...     ${from_date}=25/10/2022 12:00 AM
#         ...     ${to_date}=25/10/2022 11:59 PM
#         ...     ${transaction_id}=0
#         ...     ${merchant_transaction_ref}=
#         ...     ${order_info}=
#         ...     ${card_number}=
#         ...     ${acquirer_id}= 
#         ...     ${status}=
#         ...     ${transaction_type}=
#         ...     ${customer_email}=
#         ...     ${customer_mobile}=
#         ...     ${merchant_website}=
#         ...     ${fraud_check}=
#         ...     ${page}=0
#         ...     ${page_size}=100
#         ...     ${target}=v2
#         ${schema}     catenate    SEPARATOR=
#             ...     {
#             ...         "from_date":"${from_date}",
#                 ...     "to_date":"${to_date}",
#                 ...     "transaction_id":"${transaction_id}",
#                 ...     "merchant_transaction_ref":"${merchant_transaction_ref}",
#                 ...     "order_info":"${order_info}",
#                 ...     "card_number":"${card_number}",
#                 ...     "acquirer_id":"${acquirer_id}",
#                 ...     "status":"${status}",
#                 ...     "transaction_type":"${transaction_type}",
#                 ...     "customer_email":"${customer_email}",
#                 ...     "customer_mobile":"${customer_mobile}",
#                 ...     "merchant_website":"${merchant_website}",
#                 ...     "fraud_check":"${fraud_check}",
#                 ...     "page":"${page}",
#                 ...     "page_size":"${page_size}",
#                 ...     "target":"${target}",
#             ...     }
#         ${body}     loads   ${schema}
#         [Return]    ${body}

*** Variables ***
${Base_URL}     https://dev.onepay.vn/ma/api/v1/transaction/domestic
${data_search}  config/domestic/ma-dom-transaction-search.csv
${data_output}  config/ma-dom-transaction-search.csv

*** Test Cases ***
TC01 - Transaction Search
    [documentation]     Get Transaction by filter
    ${request}    ${resultExpect}=    ResultHandle.Make Param    ${data_search}
    # ${resultExpect}=    ResultHandle.Make Result Expect    /home/hungld/bigmerchant-integration/config/result-expect.csv
    &{header}=  Create Dictionary  Cookie=auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwiaWF0IjoxNjY2NzU1Mjc1LCJleHAiOjE2NjY3NjI0NzUsInN1YiI6IjUxREQ3QzlDN0RBNkEyNzg4RjRBQjUzQjU2QkU2ODExIn0.qkljYCuHXV-aRJzRDM-FCuwUpS8srPxUWhbxgSUcp3g; Max-Age=7200; Expires=Wed, 26 Oct 2022 05:34:35 GMT; Path=/ma; HTTPOnly
    ...                            Content-Type=application/json


    ${fieldExpect}     Create List    transaction_id   merchant_id  merchant_transaction_ref order_info transaction_time
    ${valueExpect}     Create Dictionary    #trans_type=Refund Dispute   

    Log To Console    ********** 1 ***********
    # Log To Console    ${request}
    Log To Console    ${resultExpect}

    FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect} 
        Log To Console    ********** REQUEST ***********
        # Log To Console    ${req}
        Log To Console    ********** RESULT EXPECT ***********
        # Log To Console    ${ret}
        #================= START CALL API =====================#
        ${response}=  GET   ${Base_URL}    params=${req}     headers=${header} 
        
        #==================***CHECK RESULT***==================#
        
        Should Be Equal As Numbers    ${response.status_code}    200
        ${flgCheckContain}  ${listObjectFail}    ResultHandle.Check Response Content    ${response.text}    ${fieldExpect}    ${ret}
        Log To Console    ${listObjectFail}
        Log To Console    ********** RESPONSE ***********
        Log To Console    ${response.text}
        Should Be Equal As Strings    ${flgCheckContain}    True
    END