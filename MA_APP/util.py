#!/usr/bin/python
import pathlib
import json
from os.path import dirname, join

def make_param_json(filePath):
    # # Opening JSON file
    # pathlib.Path(__file__).parent.resolve()
    jsonExpect = open(join(dirname(pathlib.Path(__file__).absolute()), filePath), 'r', encoding='utf-8')
    dataExpect = json.load(jsonExpect)
    return dataExpect

def load_json(myjson):
  result = myjson
  try:
    result = json.loads(myjson)
  except:
    pass
  return result