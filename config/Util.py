
import json
import time
import re
import hashlib
import hmac
import base64
import binascii
import collections


class Value:
    HASH_CODE = '6D0870CDE5F24F34F3915FB0045120DB'

    vpcParam = '{"vpc_merchant":"TESTOP2D","vpc_version":"2","vpc_MerchTxnRef":"REF_1664962196742","vpc_Command":"queryCapture"}'

    hexCode = [char for char in "0123456789ABCDEF"]


def create_vpc_param(vpcParam):
    merchTxnRef = 'REF_' + str(round(time.time() * 1000))
    s1 = json.dumps(vpcParam)
    data = json.loads(s1)
    if("vpc_MerchTxnRef" not in data.keys()):
        data["vpc_MerchTxnRef"] = merchTxnRef
    # for key, value in data.items():
    #     print(key, value)
    secureHash = createVpcHash(data, Value.HASH_CODE)
    data["vpc_SecureHash"] = secureHash

    return data

def createVpcHash(hashFields, secretKey):
    dataparam = ''
    newhashfields= dict()
    for key, value in hashFields.items():
        if (key.find("vpc_") != -1 ):
            newhashfields[key] = value
    print (newhashfields)
    hashFields = dict(sorted(newhashfields.items()))
    # hashFields = sorted(hashFields.items(), key=lambda x: x[1], reverse=True)
    for key, value in hashFields.items():
        if re.match(("^(vpc_|user_).*$"), str(key)) and (not re.match(("^(vpc_SecureHashType|vpc_SecureHash)$"), str(key))):
            if ~checkNull(value) and len(value) > 0:
                if (len(dataparam) > 0):
                    dataparam = dataparam+"&"
                dataparam = dataparam+key+"="+value
    signature = vpc_auth(secretKey,dataparam)
    return signature

def vpc_auth(key ,msg):
    vpc_key = bytes.fromhex(key)
    vpc_hash = hmac_sha256(vpc_key, msg)
    return vpc_hash.hex().upper()

def hmac_sha256(key, msg):
    return hmac.new(key, msg.encode('utf-8'), hashlib.sha256).digest()

def checkNull(input):
    return input is None



if __name__ == '__main__':
    createVpcParam(Value.vpcParam)
