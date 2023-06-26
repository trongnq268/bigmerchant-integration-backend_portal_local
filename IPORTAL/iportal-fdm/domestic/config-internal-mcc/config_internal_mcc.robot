*** Settings ***
Library     RequestsLibrary
Library     json
Library     String
Library     ../../util.py
Library     Collections
# Resource    ../common/Common.robot


*** Variables ***
${API_CREATE_URL}       http://localhost:8482/iportal/api/v2/fdm/domestic/merchant-administration/config-internal-mcc
${API_LIST_URL}         http://localhost:8482/iportal/api/v2/fdm/domestic/merchant-administration/config-internal-mcc
${API_DELETE_URL}       http://localhost:8482/iportal/api/v2/fdm/domestic/merchant-administration/config-internal-mcc

${CREATE_CONFIG}        /json/create.json
${LIST_CONFIG}          /json/list.json
${DELETE_CONFIG}        /json/delete.json


*** Test Cases ***
FDM - DELETE CONFIG INTERNAL MCC
    [Documentation]    MCC Delete
    @{array}=    util.Make Param Json    ${CURDIR}${DELETE_CONFIG}

    ${valueExpect}=    Create Dictionary
    ${finalResult}=    Set Variable    True

    FOR    ${testCase}    IN    @{array}
        ${input}=    Get From Dictionary    ${testCase}    input
        ${userName}=    Get From Dictionary    ${input}    X-USER-NAME
        ${userId}=    Get From Dictionary    ${input}    X-USER-ID
        ${id}=    Get From Dictionary    ${input}    id

        ${output}=    Get From Dictionary    ${testCase}    output
        ${status}=    Get From Dictionary    ${output}    status
        ${statusString}=    Convert To String    ${status}
        ${expectedBody}=    Get From Dictionary    ${output}    body
        &{header}=    Create Dictionary
        ...    Content-Type=application/json
        ...    X-USER-NAME=${userName}
        ...    X-USER-ID=${userId}
        ...    User-Agent=Robot-Auto-Test
        ...    Connection=keep-alive
        #================= START CALL API =====================#
        ${response}=    DELETE
        ...    ${API_CREATE_URL}/${id}
        ...    headers=${header}
        ...    expected_status=${statusString}

        #==================***CHECK RESULT***==================#
        ${json}=    util.Load Json    ${response.text}
        Should Be Equal    ${expectedBody}    ${json}
    END

FDM - LIST CONFIG INTERNAL MCC
    [Documentation]    MCC List
    @{array}=    util.Make Param Json    ${CURDIR}${LIST_CONFIG}

    ${valueExpect}=    Create Dictionary
    ${finalResult}=    Set Variable    True

    FOR    ${testCase}    IN    @{array}
        ${input}=    Get From Dictionary    ${testCase}    input
        ${userId}=    Get From Dictionary    ${input}    X-USER-ID
        ${params}=    Get From Dictionary    ${input}    params

        ${output}=    Get From Dictionary    ${testCase}    output
        ${status}=    Get From Dictionary    ${output}    status
        ${statusString}=    Convert To String    ${status}
        &{header}=    Create Dictionary
        ...    Content-Type=application/json
        ...    X-USER-ID=${userId}
        ...    User-Agent=Robot-Auto-Test
        ...    Connection=keep-alive
        #================= START CALL API =====================#
        ${response}=    GET
        ...    ${API_LIST_URL}
        ...    params=${params}
        ...    headers=${header}
        ...    expected_status=${statusString}

        #==================***CHECK RESULT***==================#
        # ${json}=    util.Load Json    ${response.text}
        # IF    ${statusString} == 200
        #     Dictionary Should Contain Key    ${json}    totalRecords
        #     Dictionary Should Contain Key    ${json}    value
        # END
    END

FDM - CREATE CONFIG INTERNAL MCC
    [Documentation]    MCC Create
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
        ...    ${API_CREATE_URL}
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
