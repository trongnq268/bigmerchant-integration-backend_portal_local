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

${LIST_RULE_APPROVAL}                /json/list_rule_approval.json
${LIST_RULE}                    /json/list_rule.json

*** Test Cases ***
FDM - LIST RULE_APPROVAL
    [Documentation]    List merchant with paging
    @{array}=    util.Make Param Json    ${CURDIR}${LIST_RULE_APPROVAL}

    FOR    ${testCase}    IN    @{array}
        ${input}=    Get From Dictionary    ${testCase}    input
        ${userId}=    Get From Dictionary    ${input}    X-USER-ID
        ${inputParams}=    Get From Dictionary    ${input}    params

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
        ...    ${BASE_API}
        ...    params=${inputParams}
        ...    headers=${header}
        ...    expected_status=${statusString}

        # ==================***CHECK RESULT***==================#
        ${actualBody}=    json.Loads    ${response.text}
        IF    $status == 200
            Dictionary Should Contain Key    ${actualBody}    totalRecords
            Dictionary Should Contain Key    ${actualBody}    value
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

FDM - LIST RULE
    [Documentation]    List rule
    @{array}=    util.Make Param Json    ${CURDIR}${LIST_RULE}

    FOR    ${testCase}    IN    @{array}
        ${input}=    Get From Dictionary    ${testCase}    input
        ${userId}=    Get From Dictionary    ${input}    X-USER-ID
        ${inputParams}=    Get From Dictionary    ${input}    params

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
        ...    ${BASE_API}/rules
        ...    params=${inputParams}
        ...    headers=${header}
        ...    expected_status=${statusString}

        # ==================***CHECK RESULT***==================#
        ${actualBody}=    json.Loads    ${response.text}
        IF    $status == 200
            ${sample}=    Set Variable    ${actualBody[0]}
            Dictionary Should Contain Key    ${sample}    id
            Dictionary Should Contain Key    ${sample}    name
            Dictionary Should Contain Key    ${sample}    desc
            Dictionary Should Contain Key    ${sample}    typeName
            Dictionary Should Contain Key    ${sample}    typeId
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
