*** Settings ***
Library  RequestsLibrary
Library  json
Library  String
Library  py/ResultHandle.py
Library    Collections
Resource  ../common/Common.robot
Library    ../common/CSVLibrary.py

*** Keywords ***

Pre_request - Request - body
       

*** Variables ***
${API_SEARCH_URL}    https://dev.onepay.vn/ma/api/v1/transaction/promotion

# ${COOKIE}            auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwiaWF0IjoxNjY2ODU0NjM2LCJleHAiOjE2NjY4NjE4MzYsInN1YiI6IjUxREQ3QzlDN0RBNkEyNzg4RjRBQjUzQjU2QkU2ODExIn0.tuirJC_pmuRBmyNDfyEAPhbVOsjcmAaK5Wpo4cLONgc; Max-Age=7200; Expires=Thu, 27 Oct 2022 09:10:36 GMT; Path=/ma; HTTPOnly

*** Test Cases ***
TC01 - Transaction Search
    [Documentation]     Transaction Search
    # ${COOKIE}    Common.GET COOKIE
    ${COOKIE}=    Set Variable    auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwia2V5Y2xvYWtUb2tlbiI6ImV5SmhiR2NpT2lKU1V6STFOaUlzSW5SNWNDSWdPaUFpU2xkVUlpd2lhMmxrSWlBNklDSm1Xa0l6Y1V4dGNEbFlWMnRHVVZOdlUwVk9jbDlhVG1sNFZXaEdlRUU1WWtORFFuSnRRekpzVVhKTkluMC5leUpsZUhBaU9qRTJOek0xT1RjM01URXNJbWxoZENJNk1UWTNNelU1TnpReE1Td2lZWFYwYUY5MGFXMWxJam94Tmpjek5UazNOREV4TENKcWRHa2lPaUprTlRVMFpHTmtOUzB5T0dOakxUUTRZemt0T0RNMU5DMWxaamRpTlRsbVl6QTVNR0lpTENKcGMzTWlPaUpvZEhSd2N6b3ZMMlJsZGk1dmJtVndZWGt1ZG00dllYVjBhQzl5WldGc2JYTXZiMjVsY0dGNUlpd2lZWFZrSWpvaWJXRWlMQ0p6ZFdJaU9pSmhOV00wTkRoaE1DMDNZemhrTFRSbVlqWXRPVEEwWWkwNU0yTXpZbUl6TURjeVkyUWlMQ0owZVhBaU9pSkpSQ0lzSW1GNmNDSTZJbTFoSWl3aWMyVnpjMmx2Ymw5emRHRjBaU0k2SWpkbE1XUTVOekJqTFdJeE5qa3RORGsyWWkwNU5UQTNMV0l5TmpoaVpXRXpOMkkzWWlJc0ltRjBYMmhoYzJnaU9pSkdPREIzVEhGNldFdE1VRWxFY1cxVE5VVm9aRVZuSWl3aVlXTnlJam9pTVNJc0luTnBaQ0k2SWpkbE1XUTVOekJqTFdJeE5qa3RORGsyWWkwNU5UQTNMV0l5TmpoaVpXRXpOMkkzWWlJc0ltVnRZV2xzWDNabGNtbG1hV1ZrSWpwbVlXeHpaU3dpYm1GdFpTSTZJbWdfSUhSb1AyNW5JRkYxUDI0Z2RISV9JSFpwNzctOWJpSXNJbkJ5WldabGNuSmxaRjkxYzJWeWJtRnRaU0k2SW1Ga2JXbHVRRzl1WlhCaGVTNTJiaUlzSW1kcGRtVnVYMjVoYldVaU9pSm9QeUIwYUQ5dVp5SXNJbVpoYldsc2VWOXVZVzFsSWpvaVVYVV9iaUIwY2o4Z2RtbnZ2NzF1SWl3aVpXMWhhV3dpT2lKaFpHMXBia0J2Ym1Wd1lYa3VkbTRpZlEudXRWUFJ5b2UtVUJfSkV3dXVYU0xLdkNoMUYyUmVFXzhfR3hpRXItLTBKeHc0YmFtVDZPNnBTcnBmVkJoME02VXpURkpoclIzeWlvWFRpcVhiWXlfWU1DT1lHcno2OGdodVUyUFdFS1dYSFN2UHpmQVB0QlV5VGlVNi01VmZHVVZHanpURzNoTUxiSjc0ei1YT0dEVUdQSkU2ZDdCZ2g0QW9zOHNTZEJjc3J1SXpvYmktTkpGcXFvRUtRZlBnNXNsRkRzRTU1WDlZMXJTM3FXTExIQkN1X3JtNTN0c09ZNXYwcUlmemM3ZmRYR19iQ2VTdFFIaVpvRzIyeVFNMjdEOG43UkFFVnZTS3l3SWVydm1TcVU1WGxDWmRKYjZGalVtandXVGVhRFJYX19xN01LYmZDY2VZSGw1YklFOVo2eHJIU29hcDFZN1gzRmRaTHY4WGxmbm9nIiwiaWF0IjoxNjczNjA3MTUxLCJleHAiOjE2NzM2MTQzNTEsInN1YiI6IjUxREQ3QzlDN0RBNkEyNzg4RjRBQjUzQjU2QkU2ODExIn0.zOxxslRZDcxuSCI6JgoW8MVroYQIm20dpLecbnWyThs; Max-Age=7200; Expires=Fri, 13 Jan 2023 12:52:31 GMT; Path=/ma; HTTPOnly
    ${testcasePath}=    Set Variable    /csv/TC01-Normal.csv
    ${testcases}=    Read CSV File   ${CURDIR}${testcasePath}
    FOR  ${testcase}   IN   @{testcases} 
    # Continue For Loop If   ' ${testcase}[0]' == 'descrition'
         Log To Console    ${testcase}[0]': '${testcase}[1]': '${testcase}[2]

    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json
    ...                            X-USER-ID=xxx
    ...                            User-Agent=Robot-Auto-Test
    ...                            Connection=keep-alive


    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL}?from_date=05/01/2023%2012:00%20AM&to_date=13/01/2023%2011:59%20PM&${testcase}[1]=${testcase}[2]&card_type=Visa,Mastercard,JCB,Amex,CUP

    #================= START CALL API =====================#
    ${response}=  GET    ${API_SEARCH_URL_ADD_PARAM}    headers=${header}
    

    Should Be Equal As Numbers    ${response.status_code}    200
    Log To Console    ${response.text}
     

    ${responseJson}=  evaluate    json.loads('''${response.text}''')    json

    
    Should Not Be Equal    ${responseJson['total_items']}    0
    # Log To Console    ${responseJson['list'][0]}
    # ${responseJson}= createjson.Get Json Data
    # ${responseJsonArray} = ${responseJson} 
    # ${res} = ${responseJson['list'][0]['${testcase}[3]']}

    Should Be Equal As Strings   ${responseJson['transactions'][0]['${testcase}[3]']}    ${testcase}[4]
    #==================***CHECK RESULT***==================#

    END