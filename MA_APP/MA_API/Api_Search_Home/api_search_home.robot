*** Settings ***
Library    RequestsLibrary
Library    json
Library    String
Library    ../../util.py
# Library    ../../config/Iportal_refund_dispute_Handle.py
Library    Collections
Library    DateTime
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
       
        ${output}=  get from dictionary    ${testCase}  output
        ${status}=    Get From Dictionary    ${output}    status
        ${statusString}=    Convert To String    ${status}
        ${expectedBody}=    Get From Dictionary    ${output}    body
        ${expectTotalItem}=    Get From Dictionary    ${expectedBody}    totalItems
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
        
        Log To Console    message ${response}
        #==================***CHECK RESULT***=============================#
        IF     """${response.text}""" != "" or """${output}""" != ""
            ${actualBody}=    json.loads    ${response.text}
            
        #==================***CHECK TOTAL ITEMS***========================#
            ${actialTotalItem}=    Set Variable    ${actualBody['totalItems']}
            Should Be Equal    ${actialTotalItem}    ${expectTotalItem}       

        #==================***GET FROM DATE / TO DATE***==================#
            ${expectFromDate}=    Split String    ${inputParams['fromDate']}    ${SPACE}
            ${fromDate}=    Set Variable    ${expectFromDate[0]}    date_format=%d/%m/%Y        
           
            ${expectToDate}=    Split String    ${inputParams['toDate']}    ${SPACE}
            ${toDate}=    Set Variable    ${expectToDate[0]}    date_format=%d/%m/%Y 

            @{actualTransaction}=    Set Variable    ${actualBody['transactions']}
            @{expectedTransaction}=     Set Variable    ${expectedBody['transactions']}
           
            FOR    ${item1}    IN    @{actualTransaction}               
                ${actualDate}    Set Variable   ${item1['date']}    date_format=%d/%m/%Y    
                Should Be True    ${actualDate} >= ${fromDate}
                Should Be True    ${actualDate} <= ${toDate}
                
                @{actualItem}    Set Variable   ${item1['items']}
                FOR    ${element}    IN    @{actualItem}
                    Dictionary Should Contain Key    ${element}    id
                    Dictionary Should Contain Key    ${element}    orderInfo
                    Dictionary Should Contain Key    ${element}    cardNumber
                    Dictionary Should Contain Key    ${element}    cardType
                    Dictionary Should Contain Key    ${element}    icon
                    Dictionary Should Contain Key    ${element}    amount
                    Dictionary Should Contain Key    ${element}    currency
                    Dictionary Should Contain Key    ${element}    transactionType
                    Dictionary Should Contain Key    ${element}    transactionAdvanceStatus
                    Dictionary Should Contain Key    ${element}    transactionStatusColor
                    Dictionary Should Contain Key    ${element}    service
                    Dictionary Should Contain Key    ${element}    transactionDate
                END
            END
        END
    END 