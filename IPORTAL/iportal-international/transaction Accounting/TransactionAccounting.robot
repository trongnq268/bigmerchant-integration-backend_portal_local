*** Settings ***
Library  RequestsLibrary
Library  json
Library  String
Library    Collections
Resource  ../../common/Common.robot
Library    ../../common/CSVLibrary.py

*** Keywords ***

# Pre_request - Request - body 

*** Variables ***
${API_SEARCH_URL}    https://dev.onepay.vn/iportal/api/v1/payment2-transaction-accounting
# ${API_SEARCH_URL}    http://127.0.0.1/iportal/api/v1/payment2-transaction-accounting
${COOKIE}            auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwic2lkIjoiNTFERDdDOUM3REE2QTI3ODhGNEFCNTNCNTZCRTY4MTEiLCJpYXQiOjE2ODYxMTMyMzksImV4cCI6MTY4Njk3NzIzOSwic3ViIjoiNDAyNjUifQ.HKMOi0f-eoUkKYFAgeUR21V-fOtKj45ao6zlNfkHbZk; Max-Age=14400; Expires=Wed, 07 Jun 2023 08:47:19 GMT; Path=/iportal; HTTPOnly

*** Test Cases ***
TC01 - Transaction Accounting
    [documentation]     Transaction Accounting
    # ${COOKIE}    Common.GET COOKIE
    ${testcasePath}=    Set Variable    /csv/TC01.csv
    ${testcases}=    Read CSV File   ${CURDIR}${testcasePath}
    FOR  ${testcase}   IN   @{testcases} 
    # Continue For Loop If   ' ${testcase}[0]' == 'descrition'
         Log To Console    ${testcase}[0]': '${testcase}[1]': '${testcase}[2]

    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json
    ...                            X-USER-ID=xxx
    ...                            User-Agent=Robot-Auto-Test
    ...                            Connection=keep-alive


    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL}?from_date=01/06/2023 12:00 AM&to_date=07/06/2023 11:59 PM&${testcase}[1]=${testcase}[2]&page=0&pageSize=20

    #================= START CALL API =====================#
    ${response}=  GET    ${API_SEARCH_URL_ADD_PARAM}    headers=${header}
    
    Log To Console    ${response}

    Should Be Equal As Numbers    ${response.status_code}    200

    ${responseJson}=  evaluate    json.loads('''${response.text}''')    json

    
    Should Not Be Equal    ${responseJson['total']}    0
    # Log To Console    ${responseJson['list'][0]}
    # ${responseJson}= createjson.Get Json Data
    # ${responseJsonArray} = ${responseJson} 
    # ${res} = ${responseJson['list'][0]['${testcase}[3]']}

    Should Be Equal As Strings   ${responseJson['data'][0]['${testcase}[3]']}    ${testcase}[4]
    #==================***CHECK RESULT***==================#

    END