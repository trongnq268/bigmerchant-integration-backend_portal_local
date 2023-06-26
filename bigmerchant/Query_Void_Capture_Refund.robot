*** Settings ***
Library     ../config/createjson.py
Library     Collections
Library     RequestsLibrary
Library     String
Resource    ../bigmerchant/resource.robot

*** Variables ***
${Base_URL}     https://mtf.onepay.vn/paygate/api/v1/vpc/merchants/


*** Test Cases ***
Query Void Capture Refund
    
    ${result}    createjson.Get Json Data
    ...    27
    FOR    ${r}    IN    @{result}
        ${vpc_MerchTxnRef}=     resource.GET ORG MERCHANTXREF VOID CAPTURE
        ${map_param}    ${responsejson}=   resource.GET QUERY PARAM     ${r}    ${vpc_MerchTxnRef}
        ${vpc_Merchant}    Get From Dictionary    ${map_param}    vpc_Merchant
        ${vpc_MerchTxnRef}    Get From Dictionary    ${map_param}    vpc_MerchTxnRef
        Create Session    QUERY VOID CAPTURE REFUND   ${Base_URL}${vpc_Merchant}    verify=True
        ${response}    GET On Session
        ...    QUERY VOID CAPTURE REFUND
        ...    capture_refund_voids/${vpc_MerchTxnRef}
        ...    params=${map_param}
        
        Should Be Equal As Numbers  ${response.status_code}    ${responsejson["http_code"]}
        Should Contain    ${response.text}    ${responsejson["body"]}
    END



