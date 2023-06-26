*** Settings ***
Library     ../config/createjson.py
Library     Collections
Library     RequestsLibrary
Library     String
Resource    ../bigmerchant/resource.robot


*** Variables ***
${Base_URL}     https://mtf.onepay.vn/paygate/api/v1/vpc/merchants/


*** Test Cases ***
Void Authorization

    [Tags]    Void Authorization
    ${result}    createjson.Get Json Data
    ...    52
    FOR    ${r}    IN    @{result}
        ${org_merchantxnref} =    Set Variable    DummyMerchentRef

        ${map_param}    ${responsejson}=   resource.GET VOID PARAM     ${r}    ${org_merchantxnref}
        ${vpc_Merchant}    Get From Dictionary    ${map_param}    vpc_Merchant
        ${vpc_MerchTxnRef}    Get From Dictionary    ${map_param}    vpc_MerchTxnRef

        Create Session    Void Authorize    ${Base_URL}${vpc_Merchant}    verify=True
        ${headers}    Create Dictionary    Content-Type=application/w
        ${response}    Put On Session
        ...    Void Authorize
        ...    authorizations/${org_merchantxnref}/voids/${vpc_MerchTxnRef}
        ...    data=${map_param}
        ...    headers=${headers}
        
        Should Be Equal As Numbers  ${response.status_code}    ${responsejson["http_code"]}
        ${flgCheckContain}  ${listObjectFail}   createjson.Check Response Contains
        ...    ${response.text}
        ...    ${responsejson["body_value"]}
        ...    ${responsejson["body_regex"]}
        ...    ${responsejson["body_contain"]}
        ...    ${map_param}
        Log Many    ${listObjectFail}
    END
