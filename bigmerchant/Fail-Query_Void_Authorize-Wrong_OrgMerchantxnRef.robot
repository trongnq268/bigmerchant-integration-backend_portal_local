*** Settings ***
Library     ../config/createjson.py
Library     Collections
Library     RequestsLibrary
Library     String
Resource    ../bigmerchant/resource.robot

*** Variables ***
${Base_URL}     https://mtf.onepay.vn/paygate/api/v1/vpc/merchants/


*** Test Cases ***
Query Void Authorize
    [Tags]    Query Void Authorize
    ${result}    createjson.Get Json Data
    ...    66
    FOR    ${r}    IN    @{result}
        ${vpc_MerchTxnRef}=     Set Variable    DummyMerchentRef
        ${map_param}    ${responsejson}=   resource.GET QUERY PARAM     ${r}    ${vpc_MerchTxnRef}
        ${vpc_Merchant}    Get From Dictionary    ${map_param}    vpc_Merchant
        Create Session    Query Void Authorize    ${Base_URL}${vpc_Merchant}    verify=True
        ${response}    GET On Session
        ...    Query Void Authorize
        ...    authorize_voids/${vpc_MerchTxnRef}
        ...    params=${map_param}
        Should Be Equal As Numbers  ${response.status_code}    ${responsejson["http_code"]}
        ${flgCheckContain}  ${listObjectFail}   createjson.Check Response Contains
        ...    ${response.text}
        ...    ${responsejson["body_value"]}
        ...    ${responsejson["body_regex"]}
        ...    ${responsejson["body_contain"]}
        ...    ${map_param}
        Log Many    ${listObjectFail}
    END