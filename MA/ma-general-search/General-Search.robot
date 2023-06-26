*** Settings ***
Library  RequestsLibrary
Library    ../common/CSVLibrary.py
Library    py/ResultHandler.py
Library    Collections
Suite Setup    FROM CSV

*** Variables ***
${API_SEARCH_URL}    https://dev.onepay.vn/ma/api/v1/report/general
${COOKIE}            auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwia2V5Y2xvYWtUb2tlbiI6ImV5SmhiR2NpT2lKU1V6STFOaUlzSW5SNWNDSWdPaUFpU2xkVUlpd2lhMmxrSWlBNklDSm1Xa0l6Y1V4dGNEbFlWMnRHVVZOdlUwVk9jbDlhVG1sNFZXaEdlRUU1WWtORFFuSnRRekpzVVhKTkluMC5leUpsZUhBaU9qRTJPRFF6T1RVNU1qUXNJbWxoZENJNk1UWTRORE01TlRZeU5Dd2lZWFYwYUY5MGFXMWxJam94TmpnME16azFOakkwTENKcWRHa2lPaUkwWkdRek5XRmxaUzB3T1RFNExUUmtabUl0T0RFek1pMDRPVE13T1RWbE56UTRaaklpTENKcGMzTWlPaUpvZEhSd2N6b3ZMMlJsZGk1dmJtVndZWGt1ZG00dllYVjBhQzl5WldGc2JYTXZiMjVsY0dGNUlpd2lZWFZrSWpvaWJXRWlMQ0p6ZFdJaU9pSmhOV00wTkRoaE1DMDNZemhrTFRSbVlqWXRPVEEwWWkwNU0yTXpZbUl6TURjeVkyUWlMQ0owZVhBaU9pSkpSQ0lzSW1GNmNDSTZJbTFoSWl3aWMyVnpjMmx2Ymw5emRHRjBaU0k2SW1aaU9ESTROVEJsTFRJNFpHUXRORFV5WVMwNE9XUTRMVEV4T1RJM1l6Y3pPREZpTXlJc0ltRjBYMmhoYzJnaU9pSjVUSEJ5YjFvNFUyOWpiMDA1YlU5M2VEVlpMV0puSWl3aVlXTnlJam9pTVNJc0luTnBaQ0k2SW1aaU9ESTROVEJsTFRJNFpHUXRORFV5WVMwNE9XUTRMVEV4T1RJM1l6Y3pPREZpTXlJc0ltVnRZV2xzWDNabGNtbG1hV1ZrSWpwbVlXeHpaU3dpYm1GdFpTSTZJbWdfSUhSb1AyNW5JRkYxUDI0Z2RISV9JSFpwNzctOWJpSXNJbkJ5WldabGNuSmxaRjkxYzJWeWJtRnRaU0k2SW1Ga2JXbHVRRzl1WlhCaGVTNTJiaUlzSW1kcGRtVnVYMjVoYldVaU9pSm9QeUIwYUQ5dVp5SXNJbVpoYldsc2VWOXVZVzFsSWpvaVVYVV9iaUIwY2o4Z2RtbnZ2NzF1SWl3aVpXMWhhV3dpT2lKaFpHMXBia0J2Ym1Wd1lYa3VkbTRpZlEudUxJY3JyNU1DdGRjTzNid0c1WjRSTTRaY05sTTk3VmowT1h6dHpwZTJKQkh2LURqMDFGSElBbXlxMEt2RFYtdlVGdEJ4dEhmUXZlbml6MGxqOTlzWTZOa0xRd0N2MEZIUjFfRjk4RG04eU0yNktBd05DZUwxdndMUGNPQ0t1a3RrOUFKOXBKLUVFMFF5N3BfQmVjd29vZU5CeEctQ1dneDJ2SENPTnBQQ2s1Wm1VN3hSM01heXNaMDYtTUNsc2gyajZsLVp4bkRPem1oeFQ0MEUyQVd1a25zcGdYMjJIUGtKV21XZmd5LXBZQUNERjdNYlp6dVZIV2dSbkRwaFE0R2ZBeEZFbUlWbTdhbGRGMTRLTlZYWkVhY2ZfWlJEZXEyZ3J6bFk3ZkZuWTFCSVhCVVpDY1VDWF9iekZobjZobUdYbWx5dG41c3VwS0hBUzJOWWVoU293IiwiaWF0IjoxNjg0NDAwOTE4LCJleHAiOjE2ODQ0MDgxMTgsInN1YiI6IjUxREQ3QzlDN0RBNkEyNzg4RjRBQjUzQjU2QkU2ODExIn0.r8MLglsoQuqtZSAFz2umsukmMrE-EPw5XqW9BWV9skY; Max-Age=7200; Expires=Thu, 18 May 2023 11:08:38 GMT; Path=/ma; HTTPOnly

*** Keywords ***
FROM CSV
    ${testcasePath}=    Set Variable    /csv/TC01.csv
    ${input01}    ${expect01}=    CSVLibrary.Make Param   ${CURDIR}${testcasePath}
    Set Suite Variable    ${input01}
    Set Suite Variable    ${expect01}

GENERAL SEARCH
    [Arguments]    ${req}    ${ret}
    Log To Console    ********** REQUEST ***********
    Log To Console    ${req}
    Log To Console    ********** RESULT EXPECT ***********
    Log To Console    ${ret}
    ${fieldExpect}=    Create List
    &{header}=  Create Dictionary  Cookie=${COOKIE}
    ...                            Content-Type=application/json
    ...                            X-Request-Id=4AE9E2BB2ABA0719DF6C8B87D6035F3A
    ...                            X-USER-ID=51DD7C9C7DA6A2788F4AB53B56BE6811
    ...                            User-Agent=Robot-Auto-Test
    ...                            Connection=keep-alive    
    
    ${fromDate}=         Get From Dictionary   ${req}    fromDate
    ${toDate}=           Get From Dictionary   ${req}    toDate
    ${merchantId}=       Get From Dictionary   ${req}    merchantIds
    ${transactionId}=    Get From Dictionary   ${req}    transactionId
    ${cardType}=         Get From Dictionary   ${req}    cardType
    ${orderInfo}=        Get From Dictionary   ${req}    orderInfo
    ${transaction_ref}=  Get From Dictionary   ${req}    transaction_ref
    ${card_number}=      Get From Dictionary   ${req}    card_number
    ${transaction_type}=     Get From Dictionary   ${req}    transaction_type
    ${transaction_state}=      Get From Dictionary   ${req}    transaction_state
    ${page}=             Get From Dictionary   ${req}    page

    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL}?fromDate=${fromDate}
    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&toDate=${toDate}
    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&merchant_ids=${merchantId}
    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&card_type=${cardType}
    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&transaction_id=${transactionId}
    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&order_info=${orderInfo}
    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&merchant_transaction_ref=${transaction_ref}
    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&card_number=${card_number}
    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&transaction_type=${transaction_type}
    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&transaction_state=${transaction_state}
    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&page=${page}
    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&version=ma
    ${API_SEARCH_URL_ADD_PARAM}=    Set Variable    ${API_SEARCH_URL_ADD_PARAM}&target=v2,admin-user-onepay

    ${response}=  GET    ${API_SEARCH_URL_ADD_PARAM}    headers=${header}

    ${flgCheckContain}  ${listObjectFail}    ${totalPassed}    ${totalFailed}    ResultHandler.Check Response Content    ${response.text}    ${fieldExpect}    ${ret}

    Log To Console    TotalPass: ${totalPassed}
    Log To Console    TotalFail: ${totalFailed}
    Log To Console    List Object failed: ${listObjectFail}
    IF    ${flgCheckContain} == False
        ${finalResult}=    Set Variable    False
    END

    Should Be Equal As Integers    ${totalFailed}    0


*** Test Cases ***
TC01 - General Search
    [Template]    GENERAL SEARCH
    FOR    ${req}    ${ret}    IN ZIP    ${input01}    ${expect01}
        ${req}    ${ret}
    END