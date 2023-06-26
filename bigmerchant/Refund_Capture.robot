*** Settings ***
Library     ../config/createjson.py
Library     Collections
Library     RequestsLibrary
Library     String
Resource    ../bigmerchant/resource.robot

*** Variables ***
${Base_URL}     https://mtf.onepay.vn/paygate/api/v1/vpc/merchants/


*** Test Cases ***
Refund Capture
    [Tags]    Refund Capture
    ${result}    createjson.Get Json Data
    ...    14
    FOR    ${r}    IN    @{result}
        ${org_merchantxnref}=     resource.GET ORG MERCHANTXREF CAPTURE
        ${map_param}    ${responsejson}=   resource.GET VOID PARAM     ${r}    ${org_merchantxnref}
        ${vpc_Merchant}    Get From Dictionary    ${map_param}    vpc_Merchant
        ${vpc_MerchTxnRef}    Get From Dictionary    ${map_param}    vpc_MerchTxnRef
        Create Session    REFUND CAPTURE    ${Base_URL}${vpc_Merchant}    verify=True
        ${headers}    Create Dictionary    Content-Type=application/w
        ${response}    Put On Session
        ...    REFUND CAPTURE
        ...    captures/${org_merchantxnref}/refunds/${vpc_MerchTxnRef}
        ...    data=${map_param}
        ...    headers=${headers}
        
        Should Be Equal As Numbers  ${response.status_code}    ${responsejson["http_code"]}
        ${flgCheckContain}  ${listObjectFail}   createjson.Check Response Contains
        ...    ${response.text}
        ...    ${responsejson["body_value"]}
        ...    ${responsejson["body_regex"]}
        ...    ${responsejson["body_contain"]}
        ...    ${map_param}
        Log Many    ${response.text}
        Log Many    ${listObjectFail}
        Should Be True    ${flgCheckContain}
    END



