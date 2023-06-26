*** Settings ***
Library     RequestsLibrary
Library     json
Library     String
Library     ../../util.py
Library     Collections
Library     ../../../../config/FDMRuleHandler.py
# Resource    ../common/Common.robot


*** Variables ***
${BASE_API}                     http://localhost/iportal/api/v2/fdm/domestic/config-approval

${DETAIL}                /json/detail-multiple-merchant.json

*** Test Cases ***
FDM - DETAIL RULE APPROVAL
    [Documentation]    Detail rule approval
    @{array}=    util.Make Param Json    ${CURDIR}${DETAIL}

    FOR    ${testCase}    IN    @{array}
        ${input}=    Get From Dictionary    ${testCase}    input
        ${userId}=    Get From Dictionary    ${input}    X-USER-ID
        ${id}=    Get From Dictionary    ${input}    id

        ${output}=    Get From Dictionary    ${testCase}    output
        ${status}=    Get From Dictionary    ${output}    status
        ${statusString}=    Convert To String    ${status}
        ${expectedBody}=    Get From Dictionary    ${output}    body
        &{header}=    Create Dictionary
        ...    Content-Type=application/json
        ...    X-USER-ID=${userId}
        ...    User-Agent=Robot-Auto-Test
        ...    Connection=keep-alive
        # ================= START CALL API =====================#
        ${response}=    GET
        ...    ${BASE_API}/${id}
        ...    headers=${header}
        ...    expected_status=${statusString}

        # ==================***CHECK RESULT***==================#
        ${actualBody}=    json.Loads    ${response.text}
        IF    $status == 200
            Log To Console    ${actualBody}
            Dictionary Should Contain Key    ${actualBody}    data
            ${actualData}=    Set Variable    ${actualBody['data']}
            # Dictionary Should Contain Key    ${actualData}    merchantConfigSelected
            # Dictionary Should Contain Key    ${actualData}    merchantConfig
            Dictionary Should Contain Key    ${actualData}    userNote
            Dictionary Should Contain Key    ${actualData}    ruleId
        ELSE
            Should Be Equal    ${expectedBody['code']}    ${actualBody['code']}

            @{expectedMessage}=    Split String    ${expectedBody['message']}    \n
            @{actualMessage}=    Split String    ${actualBody['message']}    \n
            Lists Should Be Equal    ${expectedMessage}    ${actualMessage}    ignore_order=True

            @{expectedDetails}=    Set Variable    ${expectedBody['details']}
            @{actualDetails}=    Set Variable    ${actualBody['details']}
            FOR    ${item1}    IN    @{expectedDetails}
                List Should Contain Value    ${actualDetails}    ${item1}
            END
            FOR    ${item1}    IN    @{actualDetails}
                List Should Contain Value    ${expectedDetails}    ${item1}
            END
        END
    END
