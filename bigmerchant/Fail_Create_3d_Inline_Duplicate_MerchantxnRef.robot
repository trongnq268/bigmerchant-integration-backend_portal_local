*** Settings ***
Library     ../config/createjson.py
Library     Collections
Library     RequestsLibrary
Library     String
Resource    ../bigmerchant/resource.robot


*** Variables ***
${Base_URL}     https://mtf.onepay.vn/paygate/api/v1/vpc/merchants/


*** Test Cases ***
Fail Create 3d Inline Duplicate MerchantxnRef
    [Tags]    Create Verification
    ${result}    createjson.Get Json Data
    ...    30
    FOR    ${r}    IN    @{result}
        ${vpc_MerchTxnRef}=     resource.GET ORG MERCHANTXREF PURCHASE
        ${map_param}    ${responsejson}=   resource.GET QUERY PARAM    ${r}    ${vpc_MerchTxnRef}
        ${vpc_Merchant}    Get From Dictionary    ${map_param}    vpc_Merchant
        ${vpc_MerchTxnRef}    Get From Dictionary    ${map_param}    vpc_MerchTxnRef

        Create Session    Create 3d Inline    ${Base_URL}${vpc_Merchant}    verify=True
        ${headers}    Create Dictionary    Content-Type=application/w
        ${response}    Put On Session
        ...    Create 3d Inline
        ...    purchases/${vpc_MerchTxnRef}
        ...    data=${map_param}
        ...    headers=${headers}
        
        Should Be Equal As Numbers  ${response.status_code}    ${responsejson["http_code"]}
        Log Many    ${response.text}
        ${flgCheckContain}  ${listObjectFail}   createjson.Check Response Contains
        ...    ${response.text}
        ...    ${responsejson["body_value"]}
        ...    ${responsejson["body_regex"]}
        ...    ${responsejson["body_contain"]}
        ...    ${map_param}
        Log Many    List Object Fail:${listObjectFail}
        Should Be True    ${flgCheckContain}
    END
