*** Settings ***
Library  RequestsLibrary
Library  json
Library  String
Library  py/ResultHandle.py
Library    Collections
Resource  ../../common/Common.robot
Library    ../../common/CSVLibrary.py

*** Keywords ***

# Pre_request - Request - body 

*** Variables ***
# ${API_SEARCH_URL}    https://dev.onepay.vn/iportal/api/v1/international/transaction
${API_SEARCH_URL}    http://127.0.0.1/iportal/api/v1/international/transaction
${API_DETAIL_PURCHASE_URL}    http://127.0.0.1/iportal/api/v1/international/purchase/
${COOKIE}            auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwic2lkIjoiNTFERDdDOUM3REE2QTI3ODhGNEFCNTNCNTZCRTY4MTEiLCJpYXQiOjE2ODQxMTczMDAsImV4cCI6MTY4NDk4MTMwMCwic3ViIjoiNDAyNjUifQ.JM82yJc_o-IH-Cigdq5BelWWyeS9pV5Ta6pA5CMEO90; Max-Age=14400; Expires=Mon, 15 May 2023 06:21:40 GMT; Path=/iportal; HTTPOnly

*** Test Cases ***
TC01 - Transaction Search Apple Pay
    [documentation]     Transaction Search
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


    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL}?from_date=11/05/2023 12:00 AM&to_date=11/05/2023 11:59 PM&${testcase}[1]=${testcase}[2]&page_size=100

    #================= START CALL API =====================#
    ${response}=  GET    ${API_SEARCH_URL_ADD_PARAM}    headers=${header}
    

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

TC02 - Detail Compare Applepay
    [documentation]     Transaction Detail
    # ${COOKIE}    Common.GET COOKIE
    ${testcasePath}=    Set Variable    /csv/TC02.csv
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
    ${API_DETAIL_URL_ADD_PARAM}=    Set Variable    ${API_DETAIL_PURCHASE_URL}${testcase}[2]

    #================= START CALL API =====================#
    # ${response}=  GET    ${API_SEARCH_URL_ADD_PARAM}    headers=${header}
    ${responseDetail}=  GET    ${API_DETAIL_URL_ADD_PARAM}    headers=${header}

    # Should Be Equal As Numbers    ${response.status_code}    200
    Should Be Equal As Numbers    ${responseDetail.status_code}    200

    # Log To Console    ${testcase}[0]': '${testcase}[1]': '${testcase}[2]
    # ${responseJson}=  evaluate    json.loads('''${response.text}''')    json
    ${responseJson}=  evaluate    json.loads('''${responseDetail.text}''')    json
    # Log To Console    HieuAhihi ${responseJson}

    Should Be Equal As Strings    ${responseJson}     ${testcase}[4]
    #==================***CHECK RESULT***==================#

    END