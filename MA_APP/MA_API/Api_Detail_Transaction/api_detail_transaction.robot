*** Settings ***
Library    RequestsLibrary
Library    json
Library    String
Library    ../../util.py
# Library    ../../config/Iportal_refund_dispute_Handle.py
Library    Collections
Library    DateTime

*** Variables ***
${SERVICE}    domestic
${ID}    3322792        
${URL_DETAIL_TRANSACTION}    https://dev.onepay.vn/ma/api/v1/ma-app/transaction   
${API_TRANSACTION_DETAIL}    /json/TC_TRANSACTION_DETAIL.json

*** Test Cases ***
TRANSACTION DETAIL
    [Documentation]    Transaction detail 
    
    @{array}    util.Make Param Json    ${CURDIR}${API_TRANSACTION_DETAIL}

    FOR    ${testcase}    IN    @{array}
        ${input}=    Get From Dictionary    ${testcase}    input

        ${COOKIE}=    Get From Dictionary    ${input}    COOKIE 
        
        ${output}=    Get From Dictionary    ${testcase}    output
        ${status}=    Get From Dictionary    ${output}    status
        ${statusString}=    Convert To String    ${status}
        #=================START CALL API========================#
        
        ${header}=    Create Dictionary
        ...    Content-Type=application/json
        ...    Cookie=${COOKIE}
        ...    User-Agent=Robot-Auto-Test
        ...    Connection=keep-alive
        

        ${response}=    GET
        ...    ${URL_DETAIL_TRANSACTION}/${SERVICE}/${ID}
        ...    headers=${header}
        ...    expected_status=${statusString}    
        
        IF    """${response.text}""" != "" 
            ${actualBody}=    json.Loads    ${response.text}

            Should Be Equal    ${actualBody['id']}    ${ID}
            Should Be Equal    ${actualBody['service']}    ${SERVICE}

            Dictionary Should Contain Key    ${actualBody}    transactionType
            Dictionary Should Contain Key    ${actualBody}    originalId
            Dictionary Should Contain Key    ${actualBody}    merchantId
            Dictionary Should Contain Key    ${actualBody}    merchantTxnRef
            Dictionary Should Contain Key    ${actualBody}    canRefund

            ${actualHeader}=    Set Variable    ${actualBody['header']}
            Log To Console    message ${actualHeader}
            Dictionary Should Contain Key    ${actualHeader}    orderInfo
            Dictionary Should Contain Key    ${actualHeader}    icon
            Dictionary Should Contain Key    ${actualHeader}    amount
            Dictionary Should Contain Key    ${actualHeader}    currency
            Dictionary Should Contain Key    ${actualHeader}    transactionDate
            Dictionary Should Contain Key    ${actualHeader}    transactionAdvanceStatus
            Dictionary Should Contain Key    ${actualHeader}    transactionStatusColor
            Dictionary Should Contain Key    ${actualHeader}    responseCode
            
            @{body}=    Set Variable    ${actualBody['body']}
            FOR    ${bodyContent}    IN    @{body}
                @{content}    Set Variable    ${bodyContent['content']}
                Log To Console    content ${content}
                FOR    ${item}    IN    @{content}
                    ${label}=    Set Variable    ${item['label']}
                    Log To Console    label ${label}
                    
                    IF    '${label}' == 'Mã đơn vị'
                        Should Be True    ${item['required']}
                    END
                    IF    '${label}' == 'Số thẻ'
                        Should Be True    ${item['required']}
                    END
                    IF    '${label}' == 'Mã giao dịch'
                        Should Be True    ${item['required']}
                    END
                    IF    '${label}' == 'Mã tham chiếu'
                        Should Be True    ${item['required']}
                    END
                    IF    '${label}' == 'Tên chủ thẻ/tài khoản'
                        ${required}    Set Variable    ${item['required']}
                        Should Not Be Equal    ${required}    False    
                    END
                END
            END  
        END
        
    END
       


    