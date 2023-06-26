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
# ${API_SEARCH_URL}    https://dev.onepay.vn/ma/api/v1/qr/static-transaction
${API_SEARCH_URL}    http://127.0.0.1/ma/api/v1/qr/static-transaction


${COOKIE}            auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwia2V5Y2xvYWtUb2tlbiI6bnVsbCwiaWF0IjoxNjc4NDQxOTQ5LCJleHAiOjE2Nzg0NDkxNDksInN1YiI6IjUxREQ3QzlDN0RBNkEyNzg4RjRBQjUzQjU2QkU2ODExIn0.pk2Rtoahf1bmdwaoecKWAqLev4y4uVrYROTQxfjzACs; Max-Age=7200; Expires=Fri, 10 Mar 2023 11:52:29 GMT; Path=/ma; HTTPOnly

*** Test Cases ***
TC01 - Transaction Static Search
    [documentation]     Transaction Search
    # ${COOKIE}    Common.GET COOKIE
    ${testcasePath}=    Set Variable    /csv/TC01-Static.csv
    ${testcases}=    Read CSV File   ${CURDIR}${testcasePath}
    FOR  ${testcase}   IN   @{testcases} 
    # Continue For Loop If   ' ${testcase}[0]' == 'descrition'
         Log To Console    ${testcase}[0]': '${testcase}[1]': '${testcase}[2]

    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json
    ...                            X-USER-ID=xxx
    ...                            User-Agent=Robot-Auto-Test
    ...                            Connection=keep-alive


    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL}?fromDate=01/03/2023 12:00 AM&toDate=10/03/2023 11:59 PM&${testcase}[1]=${testcase}[2]

    #================= START CALL API =====================#
    ${response}=  GET    ${API_SEARCH_URL_ADD_PARAM}    headers=${header}
    Log To Console    ${response}
    Log To Console    ${response.text}  

    Should Be Equal As Numbers    ${response.status_code}    200

    ${responseJson}=  evaluate    json.loads('''${response.text}''')    json

    
    Should Not Be Equal    ${responseJson['totalItems']}    0
    # Log To Console    ${responseJson['list'][0]}
    # ${responseJson}= createjson.Get Json Data
    # ${responseJsonArray} = ${responseJson} 
    # ${res} = ${responseJson['list'][0]['${testcase}[3]']}

    Should Be Equal As Strings   ${responseJson['list'][0]['${testcase}[3]']}    ${testcase}[4]
    #==================***CHECK RESULT***==================#

    END