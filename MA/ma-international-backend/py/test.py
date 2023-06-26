import AuthenticationHandle
import json






listInput, listOutput = AuthenticationHandle.get_param_from_xlsx("../xlsx/Authentication.xlsx", 0)

print('Input : ')
print(listInput)
print('Output : ')
print(listOutput)
listDict = list((listOutput))
print(listDict[0])
