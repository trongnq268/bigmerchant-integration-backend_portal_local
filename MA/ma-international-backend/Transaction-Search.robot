*** Settings ***
Library  RequestsLibrary
Library  json
Library  String
Library  ../../config/ResultHandle.py
Library    Collections
Library    ../common/CSVLibrary.py


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
${API_SEARCH_URL}    https://dev.onepay.vn/ma/api/v1/international/transaction
${API_DETAIL_URL}    127.0.0.1/ma-service/international/transaction
${API_DETAIL_PURCHASE_URL}    https://dev.onepay.vn/ma/api/v1/international/transaction/
${COOKIE}            auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwia2V5Y2xvYWtUb2tlbiI6ImV5SmhiR2NpT2lKU1V6STFOaUlzSW5SNWNDSWdPaUFpU2xkVUlpd2lhMmxrSWlBNklDSm1Xa0l6Y1V4dGNEbFlWMnRHVVZOdlUwVk9jbDlhVG1sNFZXaEdlRUU1WWtORFFuSnRRekpzVVhKTkluMC5leUpsZUhBaU9qRTJPRE01TkRReU9UTXNJbWxoZENJNk1UWTRNemswTXprNU15d2lZWFYwYUY5MGFXMWxJam94Tmpnek9UUXpPVGN4TENKcWRHa2lPaUkyT1dKaE1HSmlaUzFpTVRoaExUUXpaV0V0T1RBeE1DMDJabVF6WlRrM01UUXdaRFVpTENKcGMzTWlPaUpvZEhSd2N6b3ZMMlJsZGk1dmJtVndZWGt1ZG00dllYVjBhQzl5WldGc2JYTXZiMjVsY0dGNUlpd2lZWFZrSWpvaWJXRWlMQ0p6ZFdJaU9pSmhOV00wTkRoaE1DMDNZemhrTFRSbVlqWXRPVEEwWWkwNU0yTXpZbUl6TURjeVkyUWlMQ0owZVhBaU9pSkpSQ0lzSW1GNmNDSTZJbTFoSWl3aWMyVnpjMmx2Ymw5emRHRjBaU0k2SW1SbFl6VmtaRFppTFdJeFpHTXROR0kwWWkwNE5UY3dMV0l3TmpRMU5UWm1ZbVZpTlNJc0ltRjBYMmhoYzJnaU9pSjJlV1JJT0VabGVrc3lWMHRMVldvdGVrUllNMFJuSWl3aVlXTnlJam9pTVNJc0luTnBaQ0k2SW1SbFl6VmtaRFppTFdJeFpHTXROR0kwWWkwNE5UY3dMV0l3TmpRMU5UWm1ZbVZpTlNJc0ltVnRZV2xzWDNabGNtbG1hV1ZrSWpwbVlXeHpaU3dpYm1GdFpTSTZJbWdfSUhSb1AyNW5JRkYxUDI0Z2RISV9JSFpwNzctOWJpSXNJbkJ5WldabGNuSmxaRjkxYzJWeWJtRnRaU0k2SW1Ga2JXbHVRRzl1WlhCaGVTNTJiaUlzSW1kcGRtVnVYMjVoYldVaU9pSm9QeUIwYUQ5dVp5SXNJbVpoYldsc2VWOXVZVzFsSWpvaVVYVV9iaUIwY2o4Z2RtbnZ2NzF1SWl3aVpXMWhhV3dpT2lKaFpHMXBia0J2Ym1Wd1lYa3VkbTRpZlEuRDdmam5nLWJlek1OWTNvSmx1QlQ1Mm81Rk9VaTdnVE40bmdpVTJTRndDZWs3YVhBTTNubGRfVnRqVkd0aDZOLUk0NWt1eHBoZ2RqbzV5TnpXYmtlcGxRT1RGMFNxdDRqZFBvb1E1WUQ1dFlSS3dSWTJqTVBFSUtPRVgtX1psZlVFV1VnVzcxRFN2bjlOVTFTY2gxaVFmVzFrMEpsQnRwZmUtZko4Y2dDLVlaZ3ljdUYyRGN5NENWZWRSem5IYjR4UndnRnNGZVB1TnpKdHo5Q2VTUC03aE0xdFNHOEIyZDlIRWFLOGlhMXdZWlV2Y1BvcjBuUmJIa0E4S3VqZUxKZUJyeVBQbVB5V0IyWmRFdE5NUnViWmFwZDRlcFBZY0tERl8yUi1oRWN0VVd5cmJDZDB3dGVNcGFvbkY5TGNuWU40UlE1Rmw3bDlLZ2dSWmxWQkJiMDlBIiwiaWF0IjoxNjgzOTQ0OTE4LCJleHAiOjE2ODM5NTIxMTgsInN1YiI6IjUxREQ3QzlDN0RBNkEyNzg4RjRBQjUzQjU2QkU2ODExIn0.4uiU28r-uwyWf0MWADrfWJaaNFqqYTFo7QlRS1-kiN0; Max-Age=7200; Expires=Sat, 13 May 2023 04:28:38 GMT; Path=/ma; HTTPOnly
*** Test Cases ***
TC01 - Transaction Search
    [documentation]     Transaction Search
    ${testcasePath}=    Set Variable    /csv/TC01.csv
    ${request}    ${resultExpect}=    ResultHandle.Make Param    ${CURDIR}${testcasePath}
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
        Log To Console    ${response.text}
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

TC02 - Transaction Search And Detail Compare
    [documentation]     Transaction Search
    ${testcasePath}=    Set Variable    /csv/TC02.csv
    ${request}    ${resultExpect}=    ResultHandle.Make Param    ${CURDIR}${testcasePath}
    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json
    ...                            X-USER-ID=xxx
    ...                            User-Agent=Robot-Auto-Test
    ...                            Connection=keep-alive

    ${fieldExpect}     Create List    id   merchant_id    date

    Log To Console    ${request}
    ${count}=    Set Variable    1
    FOR    ${req}    IN    @{request}
        Log To Console    ********** REQUEST TRANS SEARCH ***********${count}
        Log To Console    ${req}
        #================= START CALL API SEARCH =====================#
        ${response_1}=  GET    ${API_SEARCH_URL}    params=${req}     headers=${header} 
        
        # Log To Console    ${response_1.text}
        ${listTransID}=    ResultHandle.Get Ids    ${response_1.text}
        Should Be Equal As Numbers    ${response_1.status_code}    200
        FOR    ${transID}    IN    @{listTransID}
            Log To Console    ********** REQUEST TRANS ID ***********${transID}
            ${responseDetail}=    GET    ${API_DETAIL_URL}${transID}    headers=${header}

            Should Be Equal As Numbers    ${response_1.status_code}    200
            Log To Console    ${responseDetail.text}  
            
            #==================***CHECK RESULT***==================#
            # ${flgCheckContain}  ${listObjectFail}    ResultHandle.Check Response Content    ${response1.text}    ${fieldExpect}    ${ret}
            # Log To Console    ${listObjectFail}
        
            # Should Be Equal As Strings    ${flgCheckContain}    True
        END
        
        ${count}=    Evaluate    ${count} + 1
    END
TC03 - Transaction Search ApplePay
    [documentation]     Transaction Search
    # ${COOKIE}    Common.GET COOKIE
    ${testcasePath}=    Set Variable    /csv/TC03.csv
    ${testcases}=    Read CSV File   ${CURDIR}${testcasePath}
    FOR  ${testcase}   IN   @{testcases} 
    # Continue For Loop If   ' ${testcase}[0]' == 'descrition'
         Log To Console    ${testcase}[0]': '${testcase}[1]': '${testcase}[2]

    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json
    ...                            X-USER-ID=xxx
    ...                            User-Agent=Robot-Auto-Test
    ...                            Connection=keep-alive


    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL}/?from_date=11/05/2023 12:00 AM&to_date=11/05/2023 11:59 PM&${testcase}[1]=${testcase}[2]

    #================= START CALL API =====================#
    ${response}=  GET    ${API_SEARCH_URL_ADD_PARAM}    headers=${header}
    

    Should Be Equal As Numbers    ${response.status_code}    200

    ${responseJson}=  evaluate    json.loads('''${response.text}''')    json

    
    Should Not Be Equal    ${responseJson['total_items']}    0
    # Log To Console    ${responseJson['list'][0]}
    # ${responseJson}= createjson.Get Json Data
    # ${responseJsonArray} = ${responseJson} 
    # ${res} = ${responseJson['list'][0]['${testcase}[3]']}

    Should Be Equal As Strings   ${responseJson['transactions'][0]['${testcase}[3]']}    ${testcase}[4]
    #==================***CHECK RESULT***==================#

    END

TC04 - Detail Compare Applepay
    [documentation]     Transaction Detail
    # ${COOKIE}    Common.GET COOKIE
    ${testcasePath}=    Set Variable    /csv/TC04.csv
    ${testcases}=    Read CSV File   ${CURDIR}${testcasePath}
    FOR  ${testcase}   IN   @{testcases} 
    # Continue For Loop If   ' ${testcase}[0]' == 'descrition'
    Log To Console    ${testcase}[0]': '${testcase}[1]': '${testcase}[2]

    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json
    ...                            X-USER-ID=xxx
    ...                            User-Agent=Robot-Auto-Test
    ...                            Connection=keep-alive


    # ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL}?fromDate=01/11/2022 12:00 AM&toDate=30/12/2022 11:59 PM&${testcase}[1]=${testcase}[2]
    ${API_DETAIL_URL_ADD_PARAM}=    Set Variable    ${API_DETAIL_PURCHASE_URL}${testcase}[2]

    #================= START CALL API =====================#
    # ${response}=  GET    ${API_SEARCH_URL_ADD_PARAM}    headers=${header}
    ${responseDetail}=  GET    ${API_DETAIL_URL_ADD_PARAM}    headers=${header}

    # Should Be Equal As Numbers    ${response.status_code}    200
    Should Be Equal As Numbers    ${responseDetail.status_code}    200

    # Log To Console    ${testcase}[0]': '${testcase}[1]': '${testcase}[2]
    # ${responseJson}=  evaluate    json.loads('''${response.text}''')    json
    ${responseJson}=  evaluate    json.loads('''${responseDetail.text}''')    json

    Should Be Equal As Strings    ${responseDetail.text}     ${testcase}[4]
    #==================***CHECK RESULT***==================#

    END