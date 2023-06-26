*** Settings ***
Library     RequestsLibrary
Library     json
Library     String
Library     ../../util.py
Library     Collections
Library     ../../../../config/FDMRuleHandler.py
# Resource    ../common/Common.robot


*** Variables ***
${BASE_API}                     http://localhost/iportal/api/v2/fdm/domestic/rule-management/config-review-rule

${LIST_MERCHANT}                /json/list_merchant.json
${LIST_RULE}                    /json/list_rule.json
${LIST_RULE_ID_CONFIGURED}      /json/list_rule_id_configured.json
${CONFIG_MULTIPLE_RULE}    /json/config_multiple_rule.json


*** Test Cases ***
FDM - LIST MERCHANT
    [Documentation]    List merchant with paging
    @{array}=    util.Make Param Json    ${CURDIR}${LIST_MERCHANT}

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

FDM - LIST RULE ID CONFIGURED
    [Documentation]    List rule id configured by merchant id
    @{array}=    util.Make Param Json    ${CURDIR}${LIST_RULE_ID_CONFIGURED}

    FOR    ${testCase}    IN    @{array}
        ${input}=    Get From Dictionary    ${testCase}    input
        ${userId}=    Get From Dictionary    ${input}    X-USER-ID
        ${merchantId}=    Get From Dictionary    ${input}    merchantId

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
        ...    ${BASE_API}/rules/${merchantId}
        ...    headers=${header}
        ...    expected_status=${statusString}

        # ==================***CHECK RESULT***==================#
        ${actualBody}=    json.Loads    ${response.text}
        IF    $status == 200
            ${type}=    Evaluate    type($actualBody)
            ${type string}=    Convert To String    ${type}
            Should Be Equal    ${type string}    <class 'list'>
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

FDM - CONFIG MULTIPLE RULE ONE MERCHANT
    [Documentation]    URL Create
    @{array}=    util.Make Param Json    ${CURDIR}${CONFIG_MULTIPLE_RULE}

    FOR    ${testCase}    IN    @{array}
        ${input}=    Get From Dictionary    ${testCase}    input
        ${userId}=    Get From Dictionary    ${input}    X-USER-ID
        ${inputBody}=    Get From Dictionary    ${input}    body

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
        ${response}=    POST
        ...    ${BASE_API}/update
        ...    json=${inputBody}
        ...    headers=${header}
        ...    expected_status=${statusString}

        # ==================***CHECK RESULT***==================#
        IF    """${response.text}""" != "" or """${expectedBody}""" != ""
            ${actualBody}=    json.Loads    ${response.text}
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
