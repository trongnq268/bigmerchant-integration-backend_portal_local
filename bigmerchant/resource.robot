*** Settings ***
Library     ../config/createjson.py
Library     Collections
Library     RequestsLibrary
Resource    ../bigmerchant/resource.robot


*** Variables ***
${Base_URL}     https://mtf.onepay.vn/paygate/api/v1/vpc/merchants/


*** Keywords ***
GET MAP PARAM
    [Arguments]    ${input}
    ${data}    Get From Dictionary    ${input}    data
    ${c1}    Get From Dictionary    ${data}    c1
    ${request}    Get From Dictionary    ${c1}    request
    ${responsejson}    Get From Dictionary    ${c1}    response

    ${query_param}    Get From Dictionary    ${request}    query_param

    ${map_param}    createjson.Get Map Param
    ...    ${query_param}
    RETURN    ${map_param}    ${responsejson}

GET ORG MERCHANTXREF PURCHASE
    ${result}    createjson.Get Json Data
    ...    3
    ${map_param}    ${responsejson}    resource.GET MAP PARAM    ${result[0]}
    ${vpc_Merchant}    Get From Dictionary    ${map_param}    vpc_Merchant
    ${vpc_MerchTxnRef}    Get From Dictionary    ${map_param}    vpc_MerchTxnRef

    Create Session    Create 2d Inline    ${Base_URL}${vpc_Merchant}    verify=True
    ${headers}    Create Dictionary    Content-Type=application/w
    ${response}    Put On Session
    ...    Create 2d Inline
    ...    purchases/${vpc_MerchTxnRef}
    ...    data=${map_param}
    ...    headers=${headers}

    
    
    RETURN    ${vpc_MerchTxnRef}

GET ORG MERCHANTXREF AUTHORIZATION
    ${result}    createjson.Get Json Data
    ...    9
    ${map_param}    ${responsejson}    GET MAP PARAM    ${result[0]}

    ${vpc_Merchant}    Get From Dictionary    ${map_param}    vpc_Merchant
    ${vpc_MerchTxnRef}    Get From Dictionary    ${map_param}    vpc_MerchTxnRef

    Create Session    Create Authorization 2d Inline    ${Base_URL}${vpc_Merchant}    verify=True
    ${headers}    Create Dictionary    Content-Type=application/w
    ${response}    Put On Session
    ...    Create Authorization 2d Inline
    ...    authorizations/${vpc_MerchTxnRef}
    ...    data=${map_param}
    ...    headers=${headers}

    RETURN    ${vpc_MerchTxnRef}

GET ORG MERCHANTXREF CAPTURE
    ${result}    createjson.Get Json Data
    ...    12
    ${org_merchantxnref}    GET ORG MERCHANTXREF AUTHORIZATION
    ${map_param}    ${responsejson}    GET VOID PARAM    ${result[0]}    ${org_merchantxnref}
    ${vpc_Merchant}    Get From Dictionary    ${map_param}    vpc_Merchant
    ${vpc_MerchTxnRef}    Get From Dictionary    ${map_param}    vpc_MerchTxnRef
    Create Session    CAPTURE    ${Base_URL}${vpc_Merchant}    verify=True
    ${headers}    Create Dictionary    Content-Type=application/w
    ${response}    Put On Session
    ...    CAPTURE
    ...    authorizations/${org_merchantxnref}/captures/${vpc_MerchTxnRef}
    ...    data=${map_param}
    ...    headers=${headers}

    RETURN    ${vpc_MerchTxnRef}

GET ORG MERCHANTXREF REFUND PURCHASE
    ${result}    createjson.Get Json Data
    ...    15
    ${org_merchantxnref}    resource.GET ORG MERCHANTXREF PURCHASE
    ${map_param}    ${responsejson}    resource.GET VOID PARAM    ${result[0]}    ${org_merchantxnref}
    ${vpc_Merchant}    Get From Dictionary    ${map_param}    vpc_Merchant
    ${vpc_MerchTxnRef}    Get From Dictionary    ${map_param}    vpc_MerchTxnRef

    Create Session    Refund Purchase    ${Base_URL}${vpc_Merchant}    verify=True
    ${headers}    Create Dictionary    Content-Type=application/w
    ${response}    Put On Session
    ...    Refund Purchase
    ...    purchases/${org_merchantxnref}/refunds/${vpc_MerchTxnRef}
    ...    data=${map_param}
    ...    headers=${headers}
   
    RETURN    ${vpc_MerchTxnRef}

GET ORG MERCHANTXREF REFUND CAPTURE
    ${result}    createjson.Get Json Data
    ...    14

    ${org_merchantxnref}    resource.GET ORG MERCHANTXREF CAPTURE
    ${map_param}    ${responsejson}    resource.GET VOID PARAM    ${result[0]}    ${org_merchantxnref}
    ${vpc_Merchant}    Get From Dictionary    ${map_param}    vpc_Merchant
    ${vpc_MerchTxnRef}    Get From Dictionary    ${map_param}    vpc_MerchTxnRef
    Create Session    REFUND CAPTURE    ${Base_URL}${vpc_Merchant}    verify=True
    ${headers}    Create Dictionary    Content-Type=application/w
    ${response}    Put On Session
    ...    REFUND CAPTURE
    ...    captures/${org_merchantxnref}/refunds/${vpc_MerchTxnRef}
    ...    data=${map_param}
    ...    headers=${headers}

    
    
    RETURN    ${vpc_MerchTxnRef}

GET ORG MERCHANTXREF VOID PURCHASE
    ${result}    createjson.Get Json Data
    ...    10
    ${org_merchantxnref}    resource.GET ORG MERCHANTXREF PURCHASE

    ${map_param}    ${responsejson}    resource.GET VOID PARAM    ${result[0]}    ${org_merchantxnref}
    ${vpc_Merchant}    Get From Dictionary    ${map_param}    vpc_Merchant
    ${vpc_MerchTxnRef}    Get From Dictionary    ${map_param}    vpc_MerchTxnRef

    Create Session    Void Purchase    ${Base_URL}${vpc_Merchant}    verify=True
    ${headers}    Create Dictionary    Content-Type=application/w
    ${response}    Put On Session
    ...    Void Purchase
    ...    purchases/${org_merchantxnref}/voids/${vpc_MerchTxnRef}
    ...    data=${map_param}
    ...    headers=${headers}

    
    

    RETURN    ${vpc_MerchTxnRef}

GET ORG MERCHANTXREF VOID PURCHASE REFUND
    ${result}    createjson.Get Json Data
    ...    16
    ${org_merchantxnref}    resource.GET ORG MERCHANTXREF REFUND PURCHASE
    ${map_param}    ${responsejson}    resource.GET VOID PARAM    ${result[0]}    ${org_merchantxnref}
    ${vpc_Merchant}    Get From Dictionary    ${map_param}    vpc_Merchant
    ${vpc_MerchTxnRef}    Get From Dictionary    ${map_param}    vpc_MerchTxnRef
    Create Session    VOID PURCHASE REFUND    ${Base_URL}${vpc_Merchant}    verify=True
    ${headers}    Create Dictionary    Content-Type=application/w
    ${response}    Put On Session
    ...    VOID PURCHASE REFUND
    ...    refunds/${org_merchantxnref}/voids/${vpc_MerchTxnRef}
    ...    data=${map_param}
    ...    headers=${headers}

    
    

    RETURN    ${vpc_MerchTxnRef}

GET ORG MERCHANTXREF VOID AUTHORIZATION
    ${result}    createjson.Get Json Data
    ...    11
    ${org_merchantxnref}    resource.GET ORG MERCHANTXREF AUTHORIZATION

    ${map_param}    ${responsejson}    resource.GET VOID PARAM    ${result[0]}    ${org_merchantxnref}
    ${vpc_Merchant}    Get From Dictionary    ${map_param}    vpc_Merchant
    ${vpc_MerchTxnRef}    Get From Dictionary    ${map_param}    vpc_MerchTxnRef

    Create Session    Void Authorize    ${Base_URL}${vpc_Merchant}    verify=True
    ${headers}    Create Dictionary    Content-Type=application/w
    ${response}    Put On Session
    ...    Void Authorize
    ...    authorizations/${org_merchantxnref}/voids/${vpc_MerchTxnRef}
    ...    data=${map_param}
    ...    headers=${headers}

    
    

    RETURN    ${vpc_MerchTxnRef}

GET ORG MERCHANTXREF VOID CAPTURE
    ${result}    createjson.Get Json Data
    ...    13
    ${org_merchantxnref}    resource.GET ORG MERCHANTXREF CAPTURE
    ${map_param}    ${responsejson}    resource.GET VOID PARAM    ${result[0]}    ${org_merchantxnref}
    ${vpc_Merchant}    Get From Dictionary    ${map_param}    vpc_Merchant
    ${vpc_MerchTxnRef}    Get From Dictionary    ${map_param}    vpc_MerchTxnRef
    Create Session    VOID CAPTURE    ${Base_URL}${vpc_Merchant}    verify=True
    ${headers}    Create Dictionary    Content-Type=application/w
    ${response}    Put On Session
    ...    VOID CAPTURE
    ...    captures/${org_merchantxnref}/voids/${vpc_MerchTxnRef}
    ...    data=${map_param}
    ...    headers=${headers}

    
    

    RETURN    ${vpc_MerchTxnRef}

GET ORG MERCHANTXREF VOID CAPTURE REFUND
    ${result}    createjson.Get Json Data
    ...    17
    ${org_merchantxnref}    resource.GET ORG MERCHANTXREF REFUND CAPTURE
    ${map_param}    ${responsejson}    resource.GET VOID PARAM    ${result[0]}    ${org_merchantxnref}
    ${vpc_Merchant}    Get From Dictionary    ${map_param}    vpc_Merchant
    ${vpc_MerchTxnRef}    Get From Dictionary    ${map_param}    vpc_MerchTxnRef
    Create Session    VOID CAPTURE REFUND    ${Base_URL}${vpc_Merchant}    verify=True
    ${headers}    Create Dictionary    Content-Type=application/w
    ${response}    Put On Session
    ...    VOID CAPTURE REFUND
    ...    capture_refunds/${org_merchantxnref}/voids/${vpc_MerchTxnRef}
    ...    data=${map_param}
    ...    headers=${headers}

    
    

    RETURN    ${vpc_MerchTxnRef}

GET ORG MERCHANTXREF CREATE INVOICE
    ${result}    createjson.Get Json Data
    ...    1
    ${map_param}    ${responsejson}    resource.GET MAP PARAM    ${result[0]}

    ${vpc_Merchant}    Get From Dictionary    ${map_param}    vpc_Merchant
    ${vpc_MerchTxnRef}    Get From Dictionary    ${map_param}    vpc_MerchTxnRef

    Create Session    Create Invoice    ${Base_URL}${vpc_Merchant}    verify=True
    ${headers}    Create Dictionary    Content-Type=application/w
    ${response}    Put On Session
    ...    Create Invoice
    ...    purchases/${vpc_MerchTxnRef}
    ...    data=${map_param}
    ...    headers=${headers}

    
    
    ${location}    Get From Dictionary    ${response.headers}    location
    Should Match Regexp
    ...    ${location}
    ...    ${responsejson["redirect_url"]}
    RETURN    ${vpc_MerchTxnRef}

GET VOID PARAM
    [Arguments]    ${input}    ${org_merchantxnref}
    ${data}    Get From Dictionary    ${input}    data
    ${c1}    Get From Dictionary    ${data}    c1
    ${request}    Get From Dictionary    ${c1}    request
    ${responsejson}    Get From Dictionary    ${c1}    response

    ${query_param}    Get From Dictionary    ${request}    query_param

    Set To Dictionary    ${query_param}    vpc_OrgMerchTxnRef=${org_merchantxnref}
    ${map_param}    createjson.Get Map Param
    ...    ${query_param}
    RETURN    ${map_param}    ${responsejson}

GET QUERY PARAM
    [Arguments]    ${input}    ${vpc_MerchTxnRef}
    ${data}    Get From Dictionary    ${input}    data
    ${c1}    Get From Dictionary    ${data}    c1
    ${request}    Get From Dictionary    ${c1}    request
    ${responsejson}    Get From Dictionary    ${c1}    response

    ${query_param}    Get From Dictionary    ${request}    query_param

    Set To Dictionary    ${query_param}    vpc_MerchTxnRef=${vpc_MerchTxnRef}
    ${map_param}    createjson.Get Map Param
    ...    ${query_param}
    RETURN    ${map_param}    ${responsejson}
