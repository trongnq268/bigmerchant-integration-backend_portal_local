*** Settings ***
Library    RequestsLibrary
Library    json
Library    String
Library    ../../util.py
Library    Collections
Library    ../../../../config/FDMRuleHandler.py

*** Variables ***
${BASE_API_URL}     https://dev.onepay.vn/iportal/api/v2/fdm/domestic/transactionSearch
${LIST_CONFIG_NOT_FOUND}      /json/list_not_found.json
${LIST_CONFIG_FAILED}   /json/list_failed.json
${LIST_CONFIG}      /json/list_transaction.json

*** Test Cases ***
TC01 - FDM - SEARCH TRANSACTION NOT FOUND
    [Documentation]    URL SEARCH TRANSACTION NOT FOUND
    @{array}    util.make param json    ${CURDIR}${LIST_CONFIG_NOT_FOUND}

    FOR     ${testCase}     IN    @{array}

        ${input}=   get from dictionary    ${testcase}  input
        ${userId}=    Get From Dictionary    ${input}    X-USER-ID
        ${inputParams}=     get from dictionary    ${input}     params

        ${output}=  get from dictionary    ${testcase}  output
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
        IF     """${response.text}""" != "" or """${output}""" != ""
            ${actualBody}=    json.loads    ${response.text}
            @{expectedMessage}=	Split String	${expectedBody['message']}	\n
            @{actualMessage}=	Split String	${actualBody['message']}	\n
            Lists Should Be Equal    ${expectedMessage}    ${actualMessage}	ignore_order=True

        END
    END

TC02 - FDM - TRANSACTION SEARCH FAILED
    [Documentation]    URL SEARCH TRANSACTION FAILED
    @{array}    util.make param json    ${CURDIR}${LIST_CONFIG_FAILED}

    FOR     ${testCase}     IN    @{array}

        ${input}=   get from dictionary    ${testcase}  input
        ${userId}=    Get From Dictionary    ${input}    X-USER-ID
        ${inputParams}=     get from dictionary    ${input}     params

        ${output}=  get from dictionary    ${testcase}  output
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
        IF     """${response.text}""" != "" or """${output}""" != ""
            ${actualBody}=    json.loads    ${response.text}
            @{expectedMessage}=	Split String	${expectedBody['message']}	\n
            @{actualMessage}=	Split String	${actualBody['message']}	\n
            Lists Should Be Equal    ${expectedMessage}    ${actualMessage}	ignore_order=True
        END
    END

TC03 - TRANSACTION SREACH
    [Documentation]    URL SEARCH TRANSACTION
    @{array}    util.make param json    ${CURDIR}${LIST_CONFIG}

    FOR     ${testCase}     IN    @{array}

        ${input}=   get from dictionary    ${testcase}  input
        ${userId}=    Get From Dictionary    ${input}    X-USER-ID
        ${inputParams}=     get from dictionary    ${input}     params

        ${output}=  get from dictionary    ${testcase}  output
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
            ${actualBody}=      json.Loads    ${response.text}
#            Should Be Equal    ${expectedBody['code']}    ${actualBody['code']}

            @{expectedMessage}=	Split String	${expectedBody['message']}	\n
            @{actualMessage}=	Split String	${actualBody['message']}	\n
            Lists Should Be Equal    ${expectedMessage}    ${actualMessage}	ignore_order=True

            # @{expectedData}=    Set Variable    ${expectedBody['data']}
            @{actualData}=    Set Variable    ${actualBody['data']}
#            FOR    ${item1}    IN    @{expectedData}
#                List Should Contain Value  ${actualData}  ${item1}
#            END
        #==================***Filter Issuer***==================#
            IF     """${inputParams['issuer']}"""!= ""
                FOR    ${item1}    IN    @{actualData}
                    Should Be Equal    ${item1['issuer']}    ${inputParams['issuer']}
                END
            END
        #==================***Filter AccNumber***==================#
            # IF     """${inputParams['accNumber']}"""!= ""
            #     FOR    ${item1}    IN    @{actualData}
            #         Should Be Equal    ${item1['accNumber']}    ${inputParams['accNumber']}
            #     END
            # END
        #==================***Filter amount***==================#
            IF     """${inputParams['amount']}"""!= ""
                FOR    ${item1}    IN    @{actualData}
                    Should Be True    ${item1['amount']} >= ${inputParams['amount']}
                END
            END
        #==================***Filter cardNumber***==================#
            IF     """${inputParams['cardNumber']}"""!= ""
                FOR    ${item1}    IN    @{actualData}
                    Should Be Equal    ${item1['cardNumber']}    ${inputParams['cardNumber']}
                END
            END
        #==================***Filter card Type***==================#
            # IF     """${inputParams['cardType']}"""!= ""
            #     FOR    ${item1}    IN    @{actualData}
            #         Should Be Equal    ${item1['cardType']}    ${inputParams['cardType']}
            #     END
            # END
        #==================***Filter customer name***==================#
            IF     """${inputParams['customerName']}"""!= ""
                FOR    ${item1}    IN    @{actualData}
                    Should Be Equal    ${item1['customerName']}    ${inputParams['customerName']}
                END
            END
        #==================***Filter email***==================#
            IF     """${inputParams['email']}"""!= ""
                FOR    ${item1}    IN    @{actualData}
                    Should Be Equal    ${item1['email']}    ${inputParams['email']}
                END
            END
        #==================***Filter epp***==================#
            # IF     """${inputParams['epp']}"""!= ""
            #     FOR    ${item1}    IN    @{actualData}
            #         Should Be Equal    ${item1['epp']}    ${inputParams['epp']}
            #     END
            # END
        #==================***Filter fraud Status***==================#
            IF     """${inputParams['fraudStatus']}"""!= ""
                FOR    ${item1}    IN    @{actualData}
                    Should Be Equal    ${item1['fraudStatus']}    ${inputParams['fraudStatus']}
                END
            END
        #==================***Filter ip***==================#
            # IF     """${inputParams['ip']}"""!= ""
            #     FOR    ${item1}    IN    @{actualData}
            #         Should Be Equal    ${item1['ip']}    ${inputParams['ip']}
            #     END
            # END
        #==================***Filter markFraud***==================#
            IF     """${inputParams['markFraud']}"""!= ""
                FOR    ${item1}    IN    @{actualData}
                    Should Be Equal    ${item1['markFraud']}    ${inputParams['markFraud']}
                END
            END
        #==================***Filter merchant ID***==================#
            IF     """${inputParams['merchantId']}"""!= ""
                FOR    ${item1}    IN    @{actualData}
                    Should Be Equal    ${item1['merchantId']}    ${inputParams['merchantId']}
                END
            END
        #==================***Filter merchant Txn ref***==================#
            IF     """${inputParams['merchantTxnRef']}"""!= ""
                FOR    ${item1}    IN    @{actualData}
                    Should Be Equal    ${item1['merchantTxnRef']}    ${inputParams['merchantTxnRef']}
                END
            END 
        #==================***Filter order ref***==================#
            IF     """${inputParams['orderRef']}"""!= ""
                FOR    ${item1}    IN    @{actualData}
                    Should Be Equal    ${item1['orderRef']}    ${inputParams['orderRef']}
                END
            END
        #==================***Filter phone***==================#
            IF     """${inputParams['phone']}"""!= ""
                FOR    ${item1}    IN    @{actualData}
                    Should Be Equal    ${item1['phone']}    ${inputParams['phone']}
                END
            END
        #==================***Filter pic***==================#
            IF     """${inputParams['pic']}"""!= ""
                FOR    ${item1}    IN    @{actualData}
                    Should Be Equal    ${item1['pic']}    ${inputParams['pic']}
                END
            END
        #==================***Filter QR channel***==================#
            IF     """${inputParams['qrChannel']}"""!= ""
                FOR    ${item1}    IN    @{actualData}
                    Should Be Equal    ${item1['qrChannel']}    ${inputParams['qrChannel']}
                END
            END
        #==================***Filter QR ID***==================#
            IF     """${inputParams['qrId']}"""!= ""
                FOR    ${item1}    IN    @{actualData}
                    Should Be Equal    ${item1['qrId']}    ${inputParams['qrId']}
                END
            END
        #==================***Filter Response Code***==================#
            IF     """${inputParams['responseCode']}"""!= ""
                FOR    ${item1}    IN    @{actualData}
                    Should Be Equal    ${item1['responseCode']}    ${inputParams['responseCode']}
                END
            END
        #==================***Filter Trans ID***==================# 
            IF     """${inputParams['transId']}"""!= ""
                FOR    ${item1}    IN    @{actualData}
                    Should Be Equal    ${item1['transId']}    ${inputParams['transId']}
                END
            END
        #==================***Filter Card list***==================# 
            IF     """${inputParams['cardList']}"""!= ""
                FOR    ${item1}    IN    @{actualData}
                    Should Be Equal    ${item1['cardList']}    ${inputParams['cardList']}
                END
            END
        #==================***Filter Trans Type***==================#
            IF     """${inputParams['transType']}"""!= ""
                FOR    ${item1}    IN    @{actualData}
                    Should Be Equal    ${item1['transType']}    ${inputParams['transType']}
                END
            END
        #==================***Filter Trans State***==================#   
            IF     """${inputParams['transState']}"""!= ""
                FOR    ${item1}    IN    @{actualData}
                    Should Be Equal    ${item1['transState']}    ${inputParams['transState']}
                END
            END      
        END
    END
