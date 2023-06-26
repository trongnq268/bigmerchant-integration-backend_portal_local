import ResultHandle
import json
list1, list2 = ResultHandle.make_param("/root/projects/bigmerchant-integration/ma-international/csv/TC01.csv")

# print(list1)
# print(list2)

for val in list2:
    print(val)
    print("***")
    list3 = list(eval(val))
    for val2 in list3:
        print(val2)
        print("*** inner ***")
        print(val2["field"])
        print(val2["value"])
        print(val2["condition"])
    # json_value = json.loads(val)
    # if json_value["field"] != "" and json_value["field"] is not None:
    #     print(json_value["value"])