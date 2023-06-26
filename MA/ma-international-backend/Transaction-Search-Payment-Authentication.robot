*** Settings ***
Library  RequestsLibrary
Library  json
Library  String
Library  ../../config/ResultHandle.py
Library    Collections
Library    ../common/CSVLibrary.py


*** Variables ***
${API_SEARCH_URL}    https://dev.onepay.vn/ma/api/v1/payment-authentication
${API_DETAIL_URL}    https://dev.onepay.vn/ma/api/v1/payment-authentication/

${COOKIE}            auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwia2V5Y2xvYWtUb2tlbiI6ImV5SmhiR2NpT2lKU1V6STFOaUlzSW5SNWNDSWdPaUFpU2xkVUlpd2lhMmxrSWlBNklDSm1Xa0l6Y1V4dGNEbFlWMnRHVVZOdlUwVk9jbDlhVG1sNFZXaEdlRUU1WWtORFFuSnRRekpzVVhKTkluMC5leUpsZUhBaU9qRTJPRFF6TURneU5UQXNJbWxoZENJNk1UWTRORE13TnprMU1Dd2lZWFYwYUY5MGFXMWxJam94TmpnME16QTNPVFV3TENKcWRHa2lPaUk1WkRoa05qY3dZUzB3T1RFM0xUUm1NbVF0WWpOaVl5MDBZemsyWVRZeU1XRXdabVFpTENKcGMzTWlPaUpvZEhSd2N6b3ZMMlJsZGk1dmJtVndZWGt1ZG00dllYVjBhQzl5WldGc2JYTXZiMjVsY0dGNUlpd2lZWFZrSWpvaWJXRWlMQ0p6ZFdJaU9pSmhOV00wTkRoaE1DMDNZemhrTFRSbVlqWXRPVEEwWWkwNU0yTXpZbUl6TURjeVkyUWlMQ0owZVhBaU9pSkpSQ0lzSW1GNmNDSTZJbTFoSWl3aWMyVnpjMmx2Ymw5emRHRjBaU0k2SWpGak0yRm1ZakpqTFdWaFltUXRORFV3TXkxaE1HUmpMVFUzTjJSaU9ESmlObUUwTnlJc0ltRjBYMmhoYzJnaU9pSlpaekJWVm1sVVJVOXlTakpsU3pjNE5HVklaVEJCSWl3aVlXTnlJam9pTVNJc0luTnBaQ0k2SWpGak0yRm1ZakpqTFdWaFltUXRORFV3TXkxaE1HUmpMVFUzTjJSaU9ESmlObUUwTnlJc0ltVnRZV2xzWDNabGNtbG1hV1ZrSWpwbVlXeHpaU3dpYm1GdFpTSTZJbWdfSUhSb1AyNW5JRkYxUDI0Z2RISV9JSFpwNzctOWJpSXNJbkJ5WldabGNuSmxaRjkxYzJWeWJtRnRaU0k2SW1Ga2JXbHVRRzl1WlhCaGVTNTJiaUlzSW1kcGRtVnVYMjVoYldVaU9pSm9QeUIwYUQ5dVp5SXNJbVpoYldsc2VWOXVZVzFsSWpvaVVYVV9iaUIwY2o4Z2RtbnZ2NzF1SWl3aVpXMWhhV3dpT2lKaFpHMXBia0J2Ym1Wd1lYa3VkbTRpZlEuUXJxMk9xQVNuRmFNdmZMOVYwMTdxUVVZODRkMllkY2p3OFFjTUpuaWVyU2ZrdGs1TVFZQUxIREpSdDdFRV9CclhYRjhRY1dtREZQbmZ1WTl2cjRkN25wZ3IzalpiYWZLRDF5OHNCT0NicnBaR0ZUdzNKTG1yZEJsc3RhcEx3Qnp2VXZFZ3M3SzBrdGR2eTJRUVNMUkpVLWtxNlhhZDd4RS1kLTZfbTZ5MkVGVk5QcVlvNUtlbXY5NHVvY0ptQ0Z2SmhOZnhNS0NZS0xJdVVIWk1lZC1nRHk3My1JMVAtM1pfNEo5MmpSakhHRHBudkdJTUU0WE5WME1IcTRCd1R6bzVfZndRdm5jY1hEdHdSN0VNQ21nOXFQdkVwajVES3hUc0ItVEdITW50NHZWYmYySlVNZVN1QmRPUjdCb3ZxY1o3TmZyMjlpNUNXSWpsRVRQZzRzVEFnIiwiaWF0IjoxNjg0MzA5MTg5LCJleHAiOjE2ODQzMTYzODksInN1YiI6IjUxREQ3QzlDN0RBNkEyNzg4RjRBQjUzQjU2QkU2ODExIn0.6nmqVHedwY-cSKYWlwJ0rRd3W-abxGJ2dXOdEjipJ4w; Max-Age=7200; Expires=Wed, 17 May 2023 09:39:49 GMT; Path=/ma; HTTPOnly

*** Test Cases ***
TC01 - Transaction Search test Apple pay 
    [documentation]     Transaction Search
    # ${COOKIE}    Common.GET COOKIE
    ${testcasePath}=    Set Variable    /csv/TC01-payment-auth-APPLE PAY.csv
    ${testcases}=    Read CSV File   ${CURDIR}${testcasePath}
    FOR  ${testcase}   IN   @{testcases} 
    # Continue For Loop If   ' ${testcase}[0]' == 'descrition'
         Log To Console    ${testcase}[0]': '${testcase}[1]': '${testcase}[2]

    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json
    ...                            X-USER-ID=xxx
    ...                            User-Agent=Robot-Auto-Test
    ...                            Connection=keep-alive


    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL}?from_date=11/05/2023 12:00 AM&to_date=11/05/2023 11:59 PM&${testcase}[1]=${testcase}[2]

    #================= START CALL API =====================#
    ${response}=  GET    ${API_SEARCH_URL_ADD_PARAM}    headers=${header}
    

    Should Be Equal As Numbers    ${response.status_code}    200

    ${responseJson}=  evaluate    json.loads('''${response.text}''')    json

    
    Should Not Be Equal    ${responseJson['total_items']}    0
    # Log To Console    ${responseJson['list'][0]}
    # ${responseJson}= createjson.Get Json Data
    # ${responseJsonArray} = ${responseJson} 
    # ${res} = ${responseJson['list'][0]['${testcase}[3]']}

    Should Be Equal As Strings   ${responseJson['transactions'][0]['${testcase}[3]']}    ${testcase}[4]
    #==================***CHECK RESULT***==================#

    END

TC02 - Transaction Detail test Apple pay 
    [documentation]     Transaction Detail
    # ${COOKIE}    Common.GET COOKIE
    ${testcasePath}=    Set Variable    /csv/TC02-payment-auth-APPLE PAY.csv
    ${testcases}=    Read CSV File   ${CURDIR}${testcasePath}
    FOR  ${testcase}   IN   @{testcases} 
    # Continue For Loop If   ' ${testcase}[0]' == 'descrition'
         Log To Console    ${testcase}[0]': '${testcase}[1]': '${testcase}[2]

    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json
    ...                            X-USER-ID=xxx
    ...                            User-Agent=Robot-Auto-Test
    ...                            Connection=keep-alive


    # ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL}?fromDate=01/11/2022 12:00 AM&toDate=30/12/2022 11:59 PM&${testcase}[1]=${testcase}[2]
    ${API_DETAIL_URL_ADD_PARAM}=    Set Variable    ${API_DETAIL_URL}${testcase}[2]

    #================= START CALL API =====================#
    # ${response}=  GET    ${API_SEARCH_URL_ADD_PARAM}    headers=${header}
    ${responseDetail}=  GET    ${API_DETAIL_URL_ADD_PARAM}    headers=${header}
    

    # Should Be Equal As Numbers    ${response.status_code}    200
    Should Be Equal As Numbers    ${responseDetail.status_code}    200


    # ${responseJson}=  evaluate    json.loads('''${response.text}''')    json
    ${responseJson}=  evaluate    json.loads('''${responseDetail.text}''')    json

    # ${res} = ${responseJson['list'][0]['${testcase}[3]']}

    # Should Be Equal As Strings   ${responseJson['list'][0]['${testcase}[3]']}    ${testcase}[4]

    Should Be Equal As Strings    ${responseDetail.text}     ${testcase}[4]
    #==================***CHECK RESULT***==================#

    END