import ReportHandle
import json






listInput, listOutput = ReportHandle.get_param_from_xlsx("../xlsx/Report.xlsx", "Search")

print('Input : ')
print(listInput)
print('Output : ')
print(listOutput)
listDict = list((listOutput))
print(listDict[0])
