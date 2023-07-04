*** Settings ***
Library    RequestsLibrary
Library    json
Library    String
Library    ../../util.py
# Library     ../../config/Iportal_refund_dispute_Handle.py
Library     Collections

*** Variables ***
${API_SEARCH_URL}    https://dev.onepay.vn/ma/api/v1/ma-app/transaction
${TC_SEARCH_TRANS_STATUS}    /json/TC_SEARCH_TRANS_STATUS.json

*** Test Cases ***
SEARCH TRANSACTION STATUS 
    [Documentation]    SEARCH TRANSACTION STATUS 
    @{array}    util.Make Param Json     ${CURDIR}${TC_SEARCH_TRANS_STATUS}
    FOR    ${testcase}    IN    @{array}
        ${input}=    Get From Dictionary    ${testcase}    input 
        ${COOKIE}=    Get From Dictionary    ${input}    COOKIE

        ${inputParams}=     Get From Dictionary    ${input}     params
        
        ${output}=  get from dictionary    ${testCase}  output
        ${status}=    Get From Dictionary    ${output}    status
        ${statusString}=    Convert To String    ${status}
        ${expectedBody}=    Get From Dictionary    ${output}    body
        
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
                @{actualItems}    Set Variable   ${item1['items']}
               
                FOR    ${item2}    IN    @{actualItems}
                    Should Be Equal    ${item2['transactionAdvanceStatus']}    ${inputParams['transactionStatus']}
                END
            END
        END  
    END
