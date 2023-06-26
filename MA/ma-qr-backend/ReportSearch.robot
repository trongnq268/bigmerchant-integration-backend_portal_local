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
${API_SEARCH_URL}    https://dev.onepay.vn/ma/api/v1/qr/report
${API_SEARCH_MOCA_URL}    https://dev.onepay.vn/ma/api/v1/qr/moca/report

# ${COOKIE}            auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwiaWF0IjoxNjY2ODU0NjM2LCJleHAiOjE2NjY4NjE4MzYsInN1YiI6IjUxREQ3QzlDN0RBNkEyNzg4RjRBQjUzQjU2QkU2ODExIn0.tuirJC_pmuRBmyNDfyEAPhbVOsjcmAaK5Wpo4cLONgc; Max-Age=7200; Expires=Thu, 27 Oct 2022 09:10:36 GMT; Path=/ma; HTTPOnly

*** Test Cases ***
TC01 - Reprot Search
    [documentation]     Report Search TC Fillter report list
    # ${COOKIE}    Common.GET COOKIE
    ${COOKIE}=    Set Variable    auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwia2V5Y2xvYWtUb2tlbiI6ImV5SmhiR2NpT2lKU1V6STFOaUlzSW5SNWNDSWdPaUFpU2xkVUlpd2lhMmxrSWlBNklDSm1Xa0l6Y1V4dGNEbFlWMnRHVVZOdlUwVk9jbDlhVG1sNFZXaEdlRUU1WWtORFFuSnRRekpzVVhKTkluMC5leUpsZUhBaU9qRTJOemMwTmpNM05ERXNJbWxoZENJNk1UWTNOelEyTXpRME1Td2lZWFYwYUY5MGFXMWxJam94TmpjM05EWXpORFF4TENKcWRHa2lPaUprTURBeFptVmtOeTFoWTJNeUxUUmpZVGd0T0RobE9TMHdNREV3WXpJMk5EWTBNamNpTENKcGMzTWlPaUpvZEhSd2N6b3ZMMlJsZGk1dmJtVndZWGt1ZG00dllYVjBhQzl5WldGc2JYTXZiMjVsY0dGNUlpd2lZWFZrSWpvaWJXRWlMQ0p6ZFdJaU9pSmhOV00wTkRoaE1DMDNZemhrTFRSbVlqWXRPVEEwWWkwNU0yTXpZbUl6TURjeVkyUWlMQ0owZVhBaU9pSkpSQ0lzSW1GNmNDSTZJbTFoSWl3aWMyVnpjMmx2Ymw5emRHRjBaU0k2SWpBeFlqSXlNVEJtTFdJMk5UVXROREl5T0MxaE5tSmpMV1ZrTVRFd1ptUTRZV1UyTUNJc0ltRjBYMmhoYzJnaU9pSkRTRFpMZVhJM1MyUXlSVFJYY2tOWVJXbDZkbEZuSWl3aVlXTnlJam9pTVNJc0luTnBaQ0k2SWpBeFlqSXlNVEJtTFdJMk5UVXROREl5T0MxaE5tSmpMV1ZrTVRFd1ptUTRZV1UyTUNJc0ltVnRZV2xzWDNabGNtbG1hV1ZrSWpwbVlXeHpaU3dpYm1GdFpTSTZJbWdfSUhSb1AyNW5JRkYxUDI0Z2RISV9JSFpwNzctOWJpSXNJbkJ5WldabGNuSmxaRjkxYzJWeWJtRnRaU0k2SW1Ga2JXbHVRRzl1WlhCaGVTNTJiaUlzSW1kcGRtVnVYMjVoYldVaU9pSm9QeUIwYUQ5dVp5SXNJbVpoYldsc2VWOXVZVzFsSWpvaVVYVV9iaUIwY2o4Z2RtbnZ2NzF1SWl3aVpXMWhhV3dpT2lKaFpHMXBia0J2Ym1Wd1lYa3VkbTRpZlEuS015dG1ZeVcyaWdndlZ5NERpa2Jsc3ZERW5yVlJXWWRPU0xHRnlvRWcxb0poeEU3ajZxWkdYMHFMa0dFVDBoSTI3ZWdZT0NHRFVIQUJ0QlBISXVKVHAta1V4ZjdaNlY2UlRldzlmUXJvM001REt6X2RoV1EtVWFMZ2pzbTdkVmQxdktqem1xQkdwNkFySy1IeWVCR2QxOGxBR0NvdGRJeC1fb0twYVdBN1QxWjc3VmJJUUpKal82LVhoU3l3WHY5ZGN0TGJRZEdhSFVlS053QU5GOEIybmlBQWxIcnRxOW9YSVhFbmRQekd0YTJGSTdqcmtpNHdfZnJfaF96RjBZRm5VUUNEWXpxWmJ0ZHVRdDVBYTV2TGcwcFZSX0ctZzByaXlnbmVZcEVfZUhWVnphbldsV0FhaXNKdzhBYkdoM2FQa3RORUNqaVo1T1M5QTBGUFg1bGxRIiwiaWF0IjoxNjc3NDY2ODc1LCJleHAiOjE2Nzc0NzQwNzUsInN1YiI6IjUxREQ3QzlDN0RBNkEyNzg4RjRBQjUzQjU2QkU2ODExIn0.4MrXjB0Z4OSjlDA08i2C0n0uQxjjD5YjDjerVzDwrz0; Max-Age=7200; Expires=Mon, 27 Feb 2023 05:01:15 GMT; Path=/ma; HTTPOnly
    ${testcasePath}=    Set Variable    /csv/TC-Report-1.csv
    ${testcases}=    Read CSV File   ${CURDIR}${testcasePath}
    FOR  ${testcase}   IN   @{testcases} 
    # Continue For Loop If   ' ${testcase}[0]' == 'descrition'
         Log To Console    ${testcase}[0]': '${testcase}[1]': '${testcase}[2]

    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json
    ...                            X-USER-ID=xxx
    ...                            User-Agent=Robot-Auto-Test
    ...                            Connection=keep-alive


    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL}?fromDate=09/12/2022&toDate=04/01/2023&interval=1&${testcase}[1]=${testcase}[2]&version=ma

    #================= START CALL API =====================#
    ${response}=  GET    ${API_SEARCH_URL_ADD_PARAM}    headers=${header}
    

    Should Be Equal As Numbers    ${response.status_code}    200

    ${responseJson}=  evaluate    json.loads('''${response.text}''')    json

    
    # Should Not Be Equal    ${responseJson['totalItems']}    0
    # Log To Console    ${responseJson['list'][0]}
    # ${responseJson}= createjson.Get Json Data
    # ${responseJsonArray} = ${responseJson} 
    # ${res} = ${responseJson['list'][0]['${testcase}[3]']}

    Should Be Equal As Strings   ${responseJson['reports'][0]['${testcase}[3]']}    ${testcase}[4]
    #==================***CHECK RESULT***==================#

    END


TC02 - Reprot Search
    [documentation]     Report Search TC Fillter report total summery
    # ${COOKIE}    Common.GET COOKIE
    ${COOKIE}=    Set Variable    auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwia2V5Y2xvYWtUb2tlbiI6ImV5SmhiR2NpT2lKU1V6STFOaUlzSW5SNWNDSWdPaUFpU2xkVUlpd2lhMmxrSWlBNklDSm1Xa0l6Y1V4dGNEbFlWMnRHVVZOdlUwVk9jbDlhVG1sNFZXaEdlRUU1WWtORFFuSnRRekpzVVhKTkluMC5leUpsZUhBaU9qRTJOemMwTmpNM05ERXNJbWxoZENJNk1UWTNOelEyTXpRME1Td2lZWFYwYUY5MGFXMWxJam94TmpjM05EWXpORFF4TENKcWRHa2lPaUprTURBeFptVmtOeTFoWTJNeUxUUmpZVGd0T0RobE9TMHdNREV3WXpJMk5EWTBNamNpTENKcGMzTWlPaUpvZEhSd2N6b3ZMMlJsZGk1dmJtVndZWGt1ZG00dllYVjBhQzl5WldGc2JYTXZiMjVsY0dGNUlpd2lZWFZrSWpvaWJXRWlMQ0p6ZFdJaU9pSmhOV00wTkRoaE1DMDNZemhrTFRSbVlqWXRPVEEwWWkwNU0yTXpZbUl6TURjeVkyUWlMQ0owZVhBaU9pSkpSQ0lzSW1GNmNDSTZJbTFoSWl3aWMyVnpjMmx2Ymw5emRHRjBaU0k2SWpBeFlqSXlNVEJtTFdJMk5UVXROREl5T0MxaE5tSmpMV1ZrTVRFd1ptUTRZV1UyTUNJc0ltRjBYMmhoYzJnaU9pSkRTRFpMZVhJM1MyUXlSVFJYY2tOWVJXbDZkbEZuSWl3aVlXTnlJam9pTVNJc0luTnBaQ0k2SWpBeFlqSXlNVEJtTFdJMk5UVXROREl5T0MxaE5tSmpMV1ZrTVRFd1ptUTRZV1UyTUNJc0ltVnRZV2xzWDNabGNtbG1hV1ZrSWpwbVlXeHpaU3dpYm1GdFpTSTZJbWdfSUhSb1AyNW5JRkYxUDI0Z2RISV9JSFpwNzctOWJpSXNJbkJ5WldabGNuSmxaRjkxYzJWeWJtRnRaU0k2SW1Ga2JXbHVRRzl1WlhCaGVTNTJiaUlzSW1kcGRtVnVYMjVoYldVaU9pSm9QeUIwYUQ5dVp5SXNJbVpoYldsc2VWOXVZVzFsSWpvaVVYVV9iaUIwY2o4Z2RtbnZ2NzF1SWl3aVpXMWhhV3dpT2lKaFpHMXBia0J2Ym1Wd1lYa3VkbTRpZlEuS015dG1ZeVcyaWdndlZ5NERpa2Jsc3ZERW5yVlJXWWRPU0xHRnlvRWcxb0poeEU3ajZxWkdYMHFMa0dFVDBoSTI3ZWdZT0NHRFVIQUJ0QlBISXVKVHAta1V4ZjdaNlY2UlRldzlmUXJvM001REt6X2RoV1EtVWFMZ2pzbTdkVmQxdktqem1xQkdwNkFySy1IeWVCR2QxOGxBR0NvdGRJeC1fb0twYVdBN1QxWjc3VmJJUUpKal82LVhoU3l3WHY5ZGN0TGJRZEdhSFVlS053QU5GOEIybmlBQWxIcnRxOW9YSVhFbmRQekd0YTJGSTdqcmtpNHdfZnJfaF96RjBZRm5VUUNEWXpxWmJ0ZHVRdDVBYTV2TGcwcFZSX0ctZzByaXlnbmVZcEVfZUhWVnphbldsV0FhaXNKdzhBYkdoM2FQa3RORUNqaVo1T1M5QTBGUFg1bGxRIiwiaWF0IjoxNjc3NDY2ODc1LCJleHAiOjE2Nzc0NzQwNzUsInN1YiI6IjUxREQ3QzlDN0RBNkEyNzg4RjRBQjUzQjU2QkU2ODExIn0.4MrXjB0Z4OSjlDA08i2C0n0uQxjjD5YjDjerVzDwrz0; Max-Age=7200; Expires=Mon, 27 Feb 2023 05:01:15 GMT; Path=/ma; HTTPOnly
    ${testcasePath}=    Set Variable    /csv/TC-Report-2.csv
    ${testcases}=    Read CSV File   ${CURDIR}${testcasePath}
    FOR  ${testcase}   IN   @{testcases} 
    # Continue For Loop If   ' ${testcase}[0]' == 'descrition'
         Log To Console    ${testcase}[0]': '${testcase}[1]': '${testcase}[2]

    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json
    ...                            X-USER-ID=xxx
    ...                            User-Agent=Robot-Auto-Test
    ...                            Connection=keep-alive


    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL}?fromDate=02/02/2023&toDate=08/02/2023&interval=1&${testcase}[1]=${testcase}[2]&version=ma

    #================= START CALL API =====================#
    ${response}=  GET    ${API_SEARCH_URL_ADD_PARAM}    headers=${header}
    

    Should Be Equal As Numbers    ${response.status_code}    200

    ${responseJson}=  evaluate    json.loads('''${response.text}''')    json

    
    # Should Not Be Equal    ${responseJson['totalItems']}    0
    # Log To Console    ${responseJson['list'][0]}
    # ${responseJson}= createjson.Get Json Data
    # ${responseJsonArray} = ${responseJson} 
    # ${res} = ${responseJson['list'][0]['${testcase}[3]']}

    Should Be Equal As Strings   ${responseJson['${testcase}[3]']}    ${testcase}[4]
    #==================***CHECK RESULT***==================#
    END
# ----------------------------------------------------------------------------------------------------------------------------------
#     MOCA REPORT
TC01 - MOCA Reprot Search
    [documentation]     Report Search TC Fillter report moca list
    # ${COOKIE}    Common.GET COOKIE
    ${COOKIE}=    Set Variable    auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwia2V5Y2xvYWtUb2tlbiI6ImV5SmhiR2NpT2lKU1V6STFOaUlzSW5SNWNDSWdPaUFpU2xkVUlpd2lhMmxrSWlBNklDSm1Xa0l6Y1V4dGNEbFlWMnRHVVZOdlUwVk9jbDlhVG1sNFZXaEdlRUU1WWtORFFuSnRRekpzVVhKTkluMC5leUpsZUhBaU9qRTJOemMwTmpNM05ERXNJbWxoZENJNk1UWTNOelEyTXpRME1Td2lZWFYwYUY5MGFXMWxJam94TmpjM05EWXpORFF4TENKcWRHa2lPaUprTURBeFptVmtOeTFoWTJNeUxUUmpZVGd0T0RobE9TMHdNREV3WXpJMk5EWTBNamNpTENKcGMzTWlPaUpvZEhSd2N6b3ZMMlJsZGk1dmJtVndZWGt1ZG00dllYVjBhQzl5WldGc2JYTXZiMjVsY0dGNUlpd2lZWFZrSWpvaWJXRWlMQ0p6ZFdJaU9pSmhOV00wTkRoaE1DMDNZemhrTFRSbVlqWXRPVEEwWWkwNU0yTXpZbUl6TURjeVkyUWlMQ0owZVhBaU9pSkpSQ0lzSW1GNmNDSTZJbTFoSWl3aWMyVnpjMmx2Ymw5emRHRjBaU0k2SWpBeFlqSXlNVEJtTFdJMk5UVXROREl5T0MxaE5tSmpMV1ZrTVRFd1ptUTRZV1UyTUNJc0ltRjBYMmhoYzJnaU9pSkRTRFpMZVhJM1MyUXlSVFJYY2tOWVJXbDZkbEZuSWl3aVlXTnlJam9pTVNJc0luTnBaQ0k2SWpBeFlqSXlNVEJtTFdJMk5UVXROREl5T0MxaE5tSmpMV1ZrTVRFd1ptUTRZV1UyTUNJc0ltVnRZV2xzWDNabGNtbG1hV1ZrSWpwbVlXeHpaU3dpYm1GdFpTSTZJbWdfSUhSb1AyNW5JRkYxUDI0Z2RISV9JSFpwNzctOWJpSXNJbkJ5WldabGNuSmxaRjkxYzJWeWJtRnRaU0k2SW1Ga2JXbHVRRzl1WlhCaGVTNTJiaUlzSW1kcGRtVnVYMjVoYldVaU9pSm9QeUIwYUQ5dVp5SXNJbVpoYldsc2VWOXVZVzFsSWpvaVVYVV9iaUIwY2o4Z2RtbnZ2NzF1SWl3aVpXMWhhV3dpT2lKaFpHMXBia0J2Ym1Wd1lYa3VkbTRpZlEuS015dG1ZeVcyaWdndlZ5NERpa2Jsc3ZERW5yVlJXWWRPU0xHRnlvRWcxb0poeEU3ajZxWkdYMHFMa0dFVDBoSTI3ZWdZT0NHRFVIQUJ0QlBISXVKVHAta1V4ZjdaNlY2UlRldzlmUXJvM001REt6X2RoV1EtVWFMZ2pzbTdkVmQxdktqem1xQkdwNkFySy1IeWVCR2QxOGxBR0NvdGRJeC1fb0twYVdBN1QxWjc3VmJJUUpKal82LVhoU3l3WHY5ZGN0TGJRZEdhSFVlS053QU5GOEIybmlBQWxIcnRxOW9YSVhFbmRQekd0YTJGSTdqcmtpNHdfZnJfaF96RjBZRm5VUUNEWXpxWmJ0ZHVRdDVBYTV2TGcwcFZSX0ctZzByaXlnbmVZcEVfZUhWVnphbldsV0FhaXNKdzhBYkdoM2FQa3RORUNqaVo1T1M5QTBGUFg1bGxRIiwiaWF0IjoxNjc3NDY2ODc1LCJleHAiOjE2Nzc0NzQwNzUsInN1YiI6IjUxREQ3QzlDN0RBNkEyNzg4RjRBQjUzQjU2QkU2ODExIn0.4MrXjB0Z4OSjlDA08i2C0n0uQxjjD5YjDjerVzDwrz0; Max-Age=7200; Expires=Mon, 27 Feb 2023 05:01:15 GMT; Path=/ma; HTTPOnly
    ${testcasePath}=    Set Variable    /csv/TC-Moca-Report-1.csv
    ${testcases}=    Read CSV File   ${CURDIR}${testcasePath}
    FOR  ${testcase}   IN   @{testcases} 
    # Continue For Loop If   ' ${testcase}[0]' == 'descrition'
         Log To Console    ${testcase}[0]': '${testcase}[1]': '${testcase}[2]

    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json
    ...                            X-USER-ID=xxx
    ...                            User-Agent=Robot-Auto-Test
    ...                            Connection=keep-alive


    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_MOCA_URL}?fromDate=09/12/2022&toDate=04/01/2023&interval=1&${testcase}[1]=${testcase}[2]&version=ma

    #================= START CALL API =====================#
    ${response}=  GET    ${API_SEARCH_URL_ADD_PARAM}    headers=${header}
    

    Should Be Equal As Numbers    ${response.status_code}    200

    ${responseJson}=  evaluate    json.loads('''${response.text}''')    json

    
    # Should Not Be Equal    ${responseJson['totalItems']}    0
    # Log To Console    ${responseJson['list'][0]}
    # ${responseJson}= createjson.Get Json Data
    # ${responseJsonArray} = ${responseJson} 
    # ${res} = ${responseJson['list'][0]['${testcase}[3]']}
#     Log To Console    ${responseJson['reports'][0]['${testcase}[3]']}    ${testcase}[4]
    Should Be Equal As Strings   ${responseJson['reports'][0]['${testcase}[3]']}    ${testcase}[4]
    #==================***CHECK RESULT***==================#

    END


TC02 - Reprot Search
    [documentation]     Report Search TC Fillter report total summery
    # ${COOKIE}    Common.GET COOKIE
    ${COOKIE}=    Set Variable    auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwia2V5Y2xvYWtUb2tlbiI6ImV5SmhiR2NpT2lKU1V6STFOaUlzSW5SNWNDSWdPaUFpU2xkVUlpd2lhMmxrSWlBNklDSm1Xa0l6Y1V4dGNEbFlWMnRHVVZOdlUwVk9jbDlhVG1sNFZXaEdlRUU1WWtORFFuSnRRekpzVVhKTkluMC5leUpsZUhBaU9qRTJOemMwTmpNM05ERXNJbWxoZENJNk1UWTNOelEyTXpRME1Td2lZWFYwYUY5MGFXMWxJam94TmpjM05EWXpORFF4TENKcWRHa2lPaUprTURBeFptVmtOeTFoWTJNeUxUUmpZVGd0T0RobE9TMHdNREV3WXpJMk5EWTBNamNpTENKcGMzTWlPaUpvZEhSd2N6b3ZMMlJsZGk1dmJtVndZWGt1ZG00dllYVjBhQzl5WldGc2JYTXZiMjVsY0dGNUlpd2lZWFZrSWpvaWJXRWlMQ0p6ZFdJaU9pSmhOV00wTkRoaE1DMDNZemhrTFRSbVlqWXRPVEEwWWkwNU0yTXpZbUl6TURjeVkyUWlMQ0owZVhBaU9pSkpSQ0lzSW1GNmNDSTZJbTFoSWl3aWMyVnpjMmx2Ymw5emRHRjBaU0k2SWpBeFlqSXlNVEJtTFdJMk5UVXROREl5T0MxaE5tSmpMV1ZrTVRFd1ptUTRZV1UyTUNJc0ltRjBYMmhoYzJnaU9pSkRTRFpMZVhJM1MyUXlSVFJYY2tOWVJXbDZkbEZuSWl3aVlXTnlJam9pTVNJc0luTnBaQ0k2SWpBeFlqSXlNVEJtTFdJMk5UVXROREl5T0MxaE5tSmpMV1ZrTVRFd1ptUTRZV1UyTUNJc0ltVnRZV2xzWDNabGNtbG1hV1ZrSWpwbVlXeHpaU3dpYm1GdFpTSTZJbWdfSUhSb1AyNW5JRkYxUDI0Z2RISV9JSFpwNzctOWJpSXNJbkJ5WldabGNuSmxaRjkxYzJWeWJtRnRaU0k2SW1Ga2JXbHVRRzl1WlhCaGVTNTJiaUlzSW1kcGRtVnVYMjVoYldVaU9pSm9QeUIwYUQ5dVp5SXNJbVpoYldsc2VWOXVZVzFsSWpvaVVYVV9iaUIwY2o4Z2RtbnZ2NzF1SWl3aVpXMWhhV3dpT2lKaFpHMXBia0J2Ym1Wd1lYa3VkbTRpZlEuS015dG1ZeVcyaWdndlZ5NERpa2Jsc3ZERW5yVlJXWWRPU0xHRnlvRWcxb0poeEU3ajZxWkdYMHFMa0dFVDBoSTI3ZWdZT0NHRFVIQUJ0QlBISXVKVHAta1V4ZjdaNlY2UlRldzlmUXJvM001REt6X2RoV1EtVWFMZ2pzbTdkVmQxdktqem1xQkdwNkFySy1IeWVCR2QxOGxBR0NvdGRJeC1fb0twYVdBN1QxWjc3VmJJUUpKal82LVhoU3l3WHY5ZGN0TGJRZEdhSFVlS053QU5GOEIybmlBQWxIcnRxOW9YSVhFbmRQekd0YTJGSTdqcmtpNHdfZnJfaF96RjBZRm5VUUNEWXpxWmJ0ZHVRdDVBYTV2TGcwcFZSX0ctZzByaXlnbmVZcEVfZUhWVnphbldsV0FhaXNKdzhBYkdoM2FQa3RORUNqaVo1T1M5QTBGUFg1bGxRIiwiaWF0IjoxNjc3NDY2ODc1LCJleHAiOjE2Nzc0NzQwNzUsInN1YiI6IjUxREQ3QzlDN0RBNkEyNzg4RjRBQjUzQjU2QkU2ODExIn0.4MrXjB0Z4OSjlDA08i2C0n0uQxjjD5YjDjerVzDwrz0; Max-Age=7200; Expires=Mon, 27 Feb 2023 05:01:15 GMT; Path=/ma; HTTPOnly
    ${testcasePath}=    Set Variable    /csv/TC-Moca-Report-2.csv
    ${testcases}=    Read CSV File   ${CURDIR}${testcasePath}
    FOR  ${testcase}   IN   @{testcases} 
    # Continue For Loop If   ' ${testcase}[0]' == 'descrition'
         Log To Console    ${testcase}[0]': '${testcase}[1]': '${testcase}[2]

    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json
    ...                            X-USER-ID=xxx
    ...                            User-Agent=Robot-Auto-Test
    ...                            Connection=keep-alive


    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_MOCA_URL}?fromDate=02/02/2023&toDate=08/02/2023&interval=1&${testcase}[1]=${testcase}[2]&version=ma

    #================= START CALL API =====================#
    ${response}=  GET    ${API_SEARCH_URL_ADD_PARAM}    headers=${header}
    

    Should Be Equal As Numbers    ${response.status_code}    200

    ${responseJson}=  evaluate    json.loads('''${response.text}''')    json

    
    # Should Not Be Equal    ${responseJson['totalItems']}    0
    # Log To Console    ${responseJson['list'][0]}
    # ${responseJson}= createjson.Get Json Data
    # ${responseJsonArray} = ${responseJson} 
    # ${res} = ${responseJson['list'][0]['${testcase}[3]']}
    Should Be Equal As Strings   ${responseJson['${testcase}[3]']}    ${testcase}[4]
    #==================***CHECK RESULT***==================#

    END