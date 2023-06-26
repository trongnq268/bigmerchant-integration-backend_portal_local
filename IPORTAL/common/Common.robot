*** Settings ***
Library     Collections
Library    String
Library     RequestsLibrary

*** Variables ***
${Auth_URL}         https://dev.onepay.vn/accounts/ma/api/v1/oauth2/auth
${Authorize_URL}    https://dev.onepay.vn/accounts/ma/api/v1/oauth2/authorize
${Login_URL}        https://dev.onepay.vn/ma/login
${Global_Cookie}    

*** Keywords ***
GET AUTH
    [Arguments]    ${usr}    ${pwd}

    ${param}=    Create Dictionary    continue=http%3A%2F%2Foneam.onepay.vn%2F%3FresponseType%3Dcode%26scope%3Dprofile%26redirectUri%3Dhttps%3A%2F%2Fdev.onepay.vn%2Fma%2Flogin%26clientId%3DONEMADM%26authLevel%3D1
    # ${strParam}=    json.dumps${param}
    &{header}=  Create Dictionary  Accept=application/json
    ...                            Accept-Encoding=gzip, deflate, br
    ...                            Accept-Language=en-US,en;q=0.9
    ...                            Connection=keep-alive
    ...                            Content-Length=180
    ...                            Content-Type=application/json
    ...                            Host=dev.onepay.vn
    ...                            Origin=https://dev.onepay.vn
    ...                            Referer=https://dev.onepay.vn/accounts/ma/
    ...                            User-Agent=Robot-Auto-Test
    ...                            X-Username=admin@onepay.vn
    ...                            X-Password=EE2D4CE1C169625576A76052ED5B5544C8C7EC1F7863A95D9B2F7FDEC6320773
    ...                            X-Requested-With=XMLHttpRequest
    

    ${authResponse}=  POST       ${Auth_URL}    headers=${header}    json=${param}

    RETURN    ${authResponse}

GET AUTHORIZE
    [Arguments]    ${cookieAuth}    ${clientReqId}

    ${param}=    Create Dictionary    confirm=true
    # ${strParam}=    json.dumps${param}
    &{header}=  Create Dictionary  Accept=application/json
    ...                            Accept-Encoding=gzip, deflate, br
    ...                            Accept-Language=en-US,en;q=0.9
    ...                            Connection=keep-alive
    ...                            Content-Type=application/json
    ...                            Host=dev.onepay.vn
    ...                            Referer=https://dev.onepay.vn/accounts/ma/
    ...                            User-Agent=Robot-Auto-Test
    ...                            X-Requested-With=XMLHttpRequest
    ...                            X-Client-Request-Id=${clientReqId}
    ...                            Cookie=${cookieAuth}

    ${authResponse}=  GET       ${Authorize_URL}    headers=${header}    params=${param}

    RETURN    ${authResponse}
LOG IN
    [Arguments]    ${login_url}

    ${param}=    Create Dictionary    confirm=true
    # ${strParam}=    json.dumps${param}
    &{header}=  Create Dictionary  Accept=text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9
    ...                            Accept-Encoding=gzip, deflate, br
    ...                            Accept-Language=en-US,en;q=0.9
    ...                            Connection=keep-alive
    ...                            Host=dev.onepay.vn
    ...                            Referer=https://dev.onepay.vn/accounts/ma/
    ...                            User-Agent=Robot-Auto-Test
    ...                            Upgrade-Insecure-Requests=1

    ${loginResponse}=  GET       ${login_url}    headers=${header}
    
    ${Cookie}=    Get From Dictionary    ${loginResponse.headers}    Set-Cookie

    RETURN    ${Cookie}

GET COOKIE
    ${authResponse}=  GET AUTH    abc    xyz

    ${jsonAuthRes}=    evaluate    json.loads('''${authResponse.text}''')    json
    ${clientReqId}=        Get From Dictionary    ${jsonAuthRes}    clientRequestId
    ${strClientReqId}=    Convert To String    ${clientReqId}
    ${OneAM-Cookie}=    Get From Dictionary    ${authResponse.headers}    Set-Cookie
    ${words} =  Split String    ${OneAM-Cookie}       ;
    ${OneAM-Id}=    Get From List    ${words}    0

    ${authorizeRespone}=    GET AUTHORIZE    ${OneAM-Id}    ${strClientReqId}

    ${jsonAuthorizeRes}=    evaluate    json.loads('''${authorizeRespone.text}''')    json
    ${redirectUrl}=        Get From Dictionary    ${jsonAuthorizeRes}    redirect

    ${Cookie}=    LOG IN    ${redirectUrl}
    Log To Console    ${Cookie}
    RETURN    ${Cookie}
