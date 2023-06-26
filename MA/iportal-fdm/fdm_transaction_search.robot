*** Settings ***
Library    RequestsLibrary
Library  json
Library  String
Library    Collections
Library    BuiltIn

*** Variables ***
${API_URL}    https://dev.onepay.vn/iportal/api/v2/fdm/domestic/transactionSearch
${X_User_Id}    51DD7C9C7DA6A2788F4AB53B56BE6811
${fromDate}     01/03/2023 00:00:00
${pageSize}  10
${toDate}     01/03/2024 00:00:00

*** Keywords ***
Should Contain Keys
    [Arguments]    ${dictionary}    @{keys}
    FOR    ${key}    IN    @{keys}
        Run Keyword If    '${key}' not in ${dictionary}    Fail    Dictionary does not contain key '${key}'
    END

*** Test Cases ***
Test API Transaction Search
    Create Session    onepay    https://dev.onepay.vn
    ${headers}    Create Dictionary    Content-Type=application/json    X-USER-ID=${X_User_Id}
    ${params}    Create Dictionary    fromDate=${fromDate}    pageSize=${pageSize}    toDate=${toDate}
#    ${response}    Get Request    onepay    /iportal/api/v2/fdm/domestic/transactionSearch    headers=${headers}    params=${params}
#    Should Be Equal As Strings    ${response.status_code}    200
#    ${json_data}    Set Variable    ${response.json()}
#    Log    ${json_data}    # In ra kết quả trả về từ API
#
    # Test case 1: Kiểm tra status code trả về
#    ${response}    Get Request    onepay    /iportal/api/v2/fdm/domestic/transactionSearch    headers=${headers}    params=${params}
    ${response}    Get    ${API_URL}   headers=${headers}    params=${params}
    Should Be Equal As Strings    ${response.status_code}    200

#    # Test case 2: Kiểm tra response có thuộc tính 'issuer'
    ${json_data}    Set Variable    ${response.json()}
    Should Contain Keys   ${json_data}    issuer    amount
#
#    # Test case 3: Kiểm tra response có thuộc tính 'amount' và 'cardNumber'
#    Should Contain Key    ${json_data}    amount
#    Should Contain Key    ${json_data['data']}    cardNumber
#
#    # Test case 4: Kiểm tra giá trị của thuộc tính 'count'
#    Should Be Equal As Integers    ${json_data['data']['count']}    10
#
#    # Test case 5: Kiểm tra response có dữ liệu trả về không rỗng
#    Should Not Be Empty    ${json_data['data']['transactions']}
#
#    # Test case 6: Kiểm tra response có chứa các thuộc tính cần thiết
#    ${expected_keys}    Create List    transactionId    amount    status
#    ${transactions}    Set Variable    ${json_data['data']['transactions']}
#    FOR    ${transaction}    IN    @{transactions}
#        Should Contain Key    ${transaction}    @{expected_keys}
#    END
#
#    # Test case 7: Kiểm tra response có chứa thông tin đúng của giao dịch cần tìm
#    ${expected_transaction_id}    Set Variable    "ABC123"
#    ${expected_amount}    Set Variable    100.00
#    ${expected_status}    Set Variable    "completed"
#    ${transaction_found}    Set Variable    ${FALSE}
#    FOR    ${transaction}    IN    @{transactions}
#        Run Keyword If    '${transaction['transactionId']}' == '${expected_transaction_id}' and '${transaction['amount']}' == '${expected_amount}' and '${transaction['status']}' == '${expected_status}'
#            Set Variable    ${TRUE}
#            Exit For Loop
#    END
#    Should Be True    ${transaction_found}
