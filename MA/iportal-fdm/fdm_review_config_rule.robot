*** Settings ***
Library     RequestsLibrary
Library     json
Library     String
Library     ../../config/FDMRuleHandler.py
Resource    ../common/Common.robot

*** Variables ***
${API_SEARCH_URL}
...                         http://localhost/iportal/api/v2/fdm/fdm/nd/reviewRule
${API_DETAIL_URL}           http://localhost/iportal/api/v2/fdm/fdm/nd/reviewRule/
${API_UPDATE_URL}           http://localhost/iportal/api/v2/fdm/fdm/nd/reviewRule/update
${API_DELETE_URL}           http://localhost/iportal/api/v2/fdm/fdm/nd/reviewRule/delete/
${COOKIE}
...                         auth=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoiUXXhuqNuIHRy4buLIHZpw6puIGjhu4cgdGjhu5FuZyIsImVtYWlsIjoiYWRtaW5Ab25lcGF5LnZuIiwicGhvbmUiOiI4NDkzNDYyMTExMSIsImFkZHJlc3MiOiJ0cmFuIHF1YW5nIGtoYWkgIiwia2V5Y2xvYWtUb2tlbiI6ImV5SmhiR2NpT2lKU1V6STFOaUlzSW5SNWNDSWdPaUFpU2xkVUlpd2lhMmxrSWlBNklDSm1Xa0l6Y1V4dGNEbFlWMnRHVVZOdlUwVk9jbDlhVG1sNFZXaEdlRUU1WWtORFFuSnRRekpzVVhKTkluMC5leUpsZUhBaU9qRTJOemN3TkRNM01EQXNJbWxoZENJNk1UWTNOekEwTXpRd01Dd2lZWFYwYUY5MGFXMWxJam94TmpjM01EUXpNems1TENKcWRHa2lPaUpqTkdRd01HVTFOaTFqTkdSbUxUUXdNak10WW1Kak1TMDNORGxtT1dOak5UTmpOREVpTENKcGMzTWlPaUpvZEhSd2N6b3ZMMlJsZGk1dmJtVndZWGt1ZG00dllYVjBhQzl5WldGc2JYTXZiMjVsY0dGNUlpd2lZWFZrSWpvaWJXRWlMQ0p6ZFdJaU9pSmhOV00wTkRoaE1DMDNZemhrTFRSbVlqWXRPVEEwWWkwNU0yTXpZbUl6TURjeVkyUWlMQ0owZVhBaU9pSkpSQ0lzSW1GNmNDSTZJbTFoSWl3aWMyVnpjMmx2Ymw5emRHRjBaU0k2SW1SaVpHUmxNVEUyTFRSbFptRXRORGRpWkMwNE56UTRMV0kzT1RnMU5UUmxNVGd6TWlJc0ltRjBYMmhoYzJnaU9pSldPRlJxVVZGaFJWOHhSV0ZSWmxOTlVFdGZZa2xSSWl3aVlXTnlJam9pTVNJc0luTnBaQ0k2SW1SaVpHUmxNVEUyTFRSbFptRXRORGRpWkMwNE56UTRMV0kzT1RnMU5UUmxNVGd6TWlJc0ltVnRZV2xzWDNabGNtbG1hV1ZrSWpwbVlXeHpaU3dpYm1GdFpTSTZJbWdfSUhSb1AyNW5JRkYxUDI0Z2RISV9JSFpwNzctOWJpSXNJbkJ5WldabGNuSmxaRjkxYzJWeWJtRnRaU0k2SW1Ga2JXbHVRRzl1WlhCaGVTNTJiaUlzSW1kcGRtVnVYMjVoYldVaU9pSm9QeUIwYUQ5dVp5SXNJbVpoYldsc2VWOXVZVzFsSWpvaVVYVV9iaUIwY2o4Z2RtbnZ2NzF1SWl3aVpXMWhhV3dpT2lKaFpHMXBia0J2Ym1Wd1lYa3VkbTRpZlEuTnhkSy1hOE92a05qUHZFNTkwSk1hS2dpdVhaMnNOTHItQzJfMERnandKNFYzWU50WlB0LUpXOEtHcE91NWZpOVJmWnI1Vm9DYms1dktydU1Udkp2QTBQWWMtMlZ5VEo5R0gyaEJONVhLcm1zWFFkNUNBVlQ3TUdaSWpza3E2R2lGOFh0d0lGOTc4Nk1aM21NdExwZE02amkyQ19vR3ZzaEkzZnJCdGZIUkplUXlHb0t3dTdsOUdDb1lJZDJZVXdIWHRNUlpEU2VZU18teHQ0TEU3dThtelVEa2l3eHplcmtwQkg3TzhtX3lEWTljc295UmxhaWJ2MW9feHp5cjNabDFoZ0p1Zi1idFI1UjB5U284cDVseThNQXRmOUNVUUZWN1dTT2pzOGloVm15LVUxTERpa2hMcDdzbV9IUVFzR3pkaGNESHlmQ2tsUTFXUFhTSnFqaWx3IiwiaWF0IjoxNjc3MDQzNDMwLCJleHAiOjE2NzcwNTA2MzAsInN1YiI6IjUxREQ3QzlDN0RBNkEyNzg4RjRBQjUzQjU2QkU2ODExIn0.d6Pn9oqq0Q52lTq0gBNaifCR4nAM84FmUyOZe61G0bo; Max-Age=7200; Expires=Wed, 22 Feb 2023 07:23:50 GMT; Path=/ma; HTTPOnly

${FDM_CONFIG_RULE_SEARCH}              /json/FDM_CONFIG_RULE_SEARCH.json
${FDM_CONFIG_RULE_DETAIL}              /json/FDM_CONFIG_RULE_DETAIL.json
${FDM_CONFIG_RULE_UPDATE}              /json/FDM_CONFIG_RULE_UPDATE.json

*** Test Cases ***
FDM - Review Rule Search
    [Documentation]  Rule Search 
    ${request}    ${resultExpect}=    FDMRuleHandler.Make Param Json   ${CURDIR}${FDM_CONFIG_RULE_SEARCH}
    # ${COOKIE}=    Common.GET COOKIE
    &{header}=    Create Dictionary    Cookie=${COOKIE}
    ...    Content-Type=application/json
    ...    X-USER-ID=xxx
    ...    User-Agent=Robot-Auto-Test
    ...    Connection=keep-alive

    ${valueExpect}=    Create Dictionary 
    ${finalResult}=    Set Variable    True

    FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect}
        #================= START CALL API =====================#
        ${response}=    GET    ${API_SEARCH_URL}    params=${req}    headers=${header}

        #==================***CHECK RESULT***==================#

        Should Be Equal As Numbers    ${response.status_code}    200
        ${flgCheckContain}    ${listObjectFail}=    FDMRuleHandler.Check Response Content
        ...    ${response.text}
        ...    ${ret}
        Log To Console    Rule List Object failed: ${listObjectFail}
        IF    ${flgCheckContain} == False
            ${finalResult}=    Set Variable    False
        END
    END
    Log To Console    ********** RESPONSE SEARCH RULE ***********
    Should Be Equal As Strings    ${finalResult}    True

FDM - Review Rule Detail
    [Documentation]    Rule Detail
    ${request}    ${resultExpect}=    FDMRuleHandler.Make Param Json    ${CURDIR}${FDM_CONFIG_RULE_DETAIL}
    &{header}=    Create Dictionary    Cookie=${COOKIE}
    ...    Content-Type=application/json
    ...    X-USER-ID=xxx
    ...    User-Agent=Robot-Auto-Test
    ...    Connection=keep-alive

    ${valueExpect}=    Create Dictionary    #trans_type=Refund Dispute
    ${finalResult}=    Set Variable    True

    FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect}
        Log To Console    ********** REQUEST RULE DETAIL ***********
        Log To Console    ${req}

        ${responseDetail}=    GET    ${API_DETAIL_URL}${req["id"]}    headers=${header}

        Should Be Equal As Numbers    ${responseDetail.status_code}    200
        Log To Console    ${responseDetail.text}

        #==================***CHECK RESULT***==================#
        ${flgCheckContain}    ${listObjectFail}=    FDMRuleHandler.compare str response and obj json
        ...    ${responseDetail.text}
        ...    ${ret}

        Log To Console    ${listObjectFail}
        IF    ${flgCheckContain} == False
            ${finalResult}=    Set Variable    False
        END
    END
    Log To Console    ********** RESPONSE RULE DETAIL ***********
    # Log To Console    ${response.text}
    Should Be Equal As Strings    ${finalResult}    True

FDM - Review Rule Update
    [Documentation]    Rule Update
    ${request}    ${resultExpect}=    FDMRuleHandler.Make Param Json    ${CURDIR}${FDM_CONFIG_RULE_UPDATE}
    &{header}=    Create Dictionary    Cookie=${COOKIE}
    ...    Content-Type=application/json
    ...    X-USER-ID=xxx
    ...    User-Agent=Robot-Auto-Test
    ...    Connection=keep-alive

    ${valueExpect}=    Create Dictionary    
    ${finalResult}=    Set Variable    True

    FOR    ${req}    ${ret}    IN ZIP    ${request}    ${resultExpect}
        Log To Console    ********** REQUEST RULE DETAIL ***********
        Log To Console    ${req}

        ${dataUpdate}=    FDMRuleHandler.String To Json    ${req}
        ${response}=    POST On Session    success    /ss-trans-management    data=${dataUpdate}    headers=${header}

        
        Should Be Equal As Numbers    ${response.status_code}    200
        ${flgCheckContain}    ${listObjectFail}=    FDMRuleHandler.check_response_content
        ...    ${response.text}
        ...    ${ret}
        Log To Console    TC01 List Object failed: ${listObjectFail}
        IF    ${flgCheckContain} == False
            ${finalResult}=    Set Variable    False
        END
    END
    Log To Console    ********** RESPONSE UPDATE RULE***********
    Should Be Equal As Strings    ${finalResult}    True