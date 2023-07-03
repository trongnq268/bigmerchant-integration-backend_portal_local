*** Settings ***
Library    RequestsLibrary
Library    json
Library    String
Library    ../util.py
Library     ../../config/Iportal_refund_dispute_Handle.py
Library     Collections

*** Variables ***
${API_SEARCH_URL}    https://dev.onepay.vn/ma/api/v1/ma-app/transaction
${TC01_SEARCH}    /json/TC_01_SEARCH.json
*** Test Cases ***
SEARCH
    [Documentation]    URL SEARCH TRANSACTION HOME  
    @{array}    util.Make Param Json    ${CURDIR}${TC01_SEARCH}
    FOR    ${testCase}    IN    @{array}
        
        ${input}=    Get From Dictionary    ${testCase}    input 
        ${COOKIE}=    Get From Dictionary    ${input}    COOKIE
        ${inputParams}=     Get From Dictionary    ${input}     params
        Log To Console    message input ${inputParams['fromDate']}
        ${output}=  get from dictionary    ${testCase}  output
        ${status}=    Get From Dictionary    ${output}    status
        ${statusString}=    Convert To String    ${status}
        ${expectedBody}=    Get From Dictionary    ${output}    body
        @{expectTransactions}=    Get From Dictionary    ${expectedBody}    transactions

        &{header}=    Create Dictionary
        ...    Content-Type=application/json
        ...    COOKIE=${COOKIE}
        ...    User-Agent=Robot-Auto-Test
        ...    Connection=keep-alive
        
        #=================START CALL API========================#
        ${response}=    GET
        ...    ${API_SEARCH_URL}
        ...    params=${inputParams}
        ...    headers=${header}
        ...    expected_status=${statusString}
        #==================***CHECK RESULT***==================#
        IF     """${response.text}""" != "" or """${output}""" != ""
            ${actualBody}=    json.loads    ${response.text}

            @{actualTransaction}=    Set Variable    ${actualBody['transactions']}
            
            FOR    ${item1}    IN    @{actualTransaction}               
                ${actualDate}    Set Variable   ${item1['date']}    
                FOR    ${element}    IN    @{expectTransactions}
                    Log To Console    ${element['date']}
                    Should Be Equal    ${actualDate}    ${element['date']}
                END
            END
        END
    END 