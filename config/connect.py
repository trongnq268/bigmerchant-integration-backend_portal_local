#!/usr/bin/python
from ctypes import sizeof
from operator import index, le
from re import T
from numpy import size
import psycopg2
from Util import create_vpc_param
from config import config
import pandas as pd
import json


def connect():
    """ Connect to the PostgreSQL database server """
    conn = None
    try:
        # read connection parameters
        params = config()
        # connect to the PostgreSQL server
        conn = psycopg2.connect(**params)
        return conn
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)

if __name__ == '__main__':
    connect()
