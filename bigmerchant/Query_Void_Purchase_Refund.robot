*** Settings ***
Library     ../config/createjson.py
Library     Collections
Library     RequestsLibrary
Library     String
Resource    ../bigmerchant/resource.robot

*** Variables ***
${Base_URL}     https://mtf.onepay.vn/paygate/api/v1/vpc/merchants/


*** Test Cases ***
Query Void Purchase Refund
    
    ${result}    createjson.Get Json Data
    ...    24
    FOR    ${r}    IN    @{result}
        ${vpc_MerchTxnRef}=     resource.GET ORG MERCHANTXREF VOID PURCHASE REFUND
        ${map_param}    ${responsejson}=   resource.GET QUERY PARAM     ${r}    ${vpc_MerchTxnRef}
        ${vpc_Merchant}    Get From Dictionary    ${map_param}    vpc_Merchant
        ${vpc_MerchTxnRef}    Get From Dictionary    ${map_param}    vpc_MerchTxnRef
        Create Session    QUERY REFUND PURCHASE    ${Base_URL}${vpc_Merchant}    verify=True
        ${response}    GET On Session
        ...    QUERY REFUND PURCHASE
        ...    purchase_refund_voids/${vpc_MerchTxnRef}
        ...    params=${map_param}
        
        Should Be Equal As Numbers  ${response.status_code}    ${responsejson["http_code"]}
        Should Contain    ${response.text}    ${responsejson["body"]}
    END



