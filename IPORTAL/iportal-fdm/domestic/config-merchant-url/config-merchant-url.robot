*** Settings ***
Library     RequestsLibrary
Library     json
Library     String
Library     ../../util.py
Library     Collections
Library    ../../../../config/FDMRuleHandler.py
# Resource    ../common/Common.robot


*** Variables ***
${BASE_API_URL}    http://localhost/iportal/api/v2/fdm/domestic/merchant-administration/merchant-url

${CREATE_CONFIG}        /json/create.json
${LIST_CONFIG}          /json/list.json
${DELETE_CONFIG}        /json/delete.json


*** Test Cases ***
FDM - DELETE MERCHANT URL
    [Documentation]    URL Delete
    @{array}=    util.Make Param Json    ${CURDIR}${DELETE_CONFIG}

    ${valueExpect}=    Create Dictionary
    ${finalResult}=    Set Variable    True

    FOR    ${testCase}    IN    @{array}
        ${input}=    Get From Dictionary    ${testCase}    input
        ${userId}=    Get From Dictionary    ${input}    X-USER-ID
        ${userId}=    Get From Dictionary    ${input}    X-USER-ID
        ${id}=    Get From Dictionary    ${input}    id

        ${output}=    Get From Dictionary    ${testCase}    output
        ${status}=    Get From Dictionary    ${output}    status
        ${statusString}=    Convert To String    ${status}
        ${expectedBody}=    Get From Dictionary    ${output}    body
        &{header}=    Create Dictionary
        ...    Content-Type=application/json
        ...    X-USER-ID=${userId}
        ...    X-USER-ID=${userId}
        ...    User-Agent=Robot-Auto-Test
        ...    Connection=keep-alive
        #================= START CALL API =====================#
        ${response}=    DELETE
        ...    ${BASE_API_URL}/${id}
        ...    headers=${header}
        ...    expected_status=${statusString}

        #==================***CHECK RESULT***==================#
        ${json}=    util.Load Json    ${response.text}
        Should Be Equal    ${expectedBody}    ${json}
    END

FDM - LIST MERCHANT URL
    [Documentation]    URL List
    @{array}=    util.Make Param Json    ${CURDIR}${LIST_CONFIG}

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
        #================= START CALL API =====================#
        ${response}=    GET
        ...    ${BASE_API_URL}
        ...    params=${inputParams}
        ...    headers=${header}
        ...    expected_status=${statusString}

        #==================***CHECK RESULT***==================#
        IF    """${response.text}""" != "" or """${expectedBody}""" != ""
            ${actualBody}=    json.Loads    ${response.text}
            Should Be Equal    ${expectedBody['code']}    ${actualBody['code']}

            @{expectedMessage}=	Split String	${expectedBody['message']}	\n
            @{actualMessage}=	Split String	${actualBody['message']}	\n
            Lists Should Be Equal    ${expectedMessage}    ${actualMessage}	ignore_order=True

            @{expectedDetails}=    Set Variable    ${expectedBody['details']}
            @{actualDetails}=    Set Variable    ${actualBody['details']}
            FOR    ${item1}    IN    @{expectedDetails}
                List Should Contain Value  ${actualDetails}  ${item1}
            END
            FOR    ${item1}    IN    @{actualDetails}
                List Should Contain Value  ${expectedDetails}  ${item1}
            END
        END
    END

FDM - CREATE MERCHANT URL
    [Documentation]    URL Create
    @{array}=    util.Make Param Json    ${CURDIR}${CREATE_CONFIG}

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
        #================= START CALL API =====================#
        ${response}=    POST
        ...    ${BASE_API_URL}
        ...    json=${inputBody}
        ...    headers=${header}
        ...    expected_status=${statusString}

        #==================***CHECK RESULT***==================#
        IF    """${response.text}""" != "" or """${expectedBody}""" != ""
            ${actualBody}=    json.Loads    ${response.text}
            Should Be Equal    ${expectedBody['code']}    ${actualBody['code']}

            @{expectedMessage}=	Split String	${expectedBody['message']}	\n
            @{actualMessage}=	Split String	${actualBody['message']}	\n
            Lists Should Be Equal    ${expectedMessage}    ${actualMessage}	ignore_order=True

            @{expectedDetails}=    Set Variable    ${expectedBody['details']}
            @{actualDetails}=    Set Variable    ${actualBody['details']}
            FOR    ${item1}    IN    @{expectedDetails}
                List Should Contain Value  ${actualDetails}  ${item1}
            END
            FOR    ${item1}    IN    @{actualDetails}
                List Should Contain Value  ${expectedDetails}  ${item1}
            END
        END
    END
