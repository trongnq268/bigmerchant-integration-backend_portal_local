import csv
import json


class CSVLibrary(object):
    def read_csv_file(self, filename):
        '''This creates a keyword named "Read CSV File"

        This keyword takes one argument, which is a path to a .csv file. It
        returns a list of rows, with each row being a list of the data in 
        each column.
        '''
        data = []
        with open(filename, 'r') as csvfile:
            reader = csv.reader(csvfile)
            for row in reader:
                data.append(row)
        return data
    
    def make_param(self, file):
        myFile = open(file, 'r')
        reader = csv.DictReader(myFile, delimiter=';')
        listInput = []
        listOutput = []
        for dictionary in reader:
            json_data_input = json.loads(dictionary['input'])
            keyInputs = json_data_input.keys()
            param = {}
            for key in keyInputs:
                param[key] = json_data_input[key]
            listInput.append(param)
            list_value = []
            list_value = dictionary['output']
            listOutput.append(list_value)
        return listInput, listOutput