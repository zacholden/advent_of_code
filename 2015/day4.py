import hashlib

secret_key = 'ckczppom'
value = ''
five_zeros = '00000'
i = 1

while True:
    value = secret_key + str(i)
    result = hashlib.md5(value.encode()).hexdigest()
    if result[:5] == five_zeros:
        break

    i += 1

print(i)


secret_key = 'ckczppom'
value = ''
six_zeros = '000000'
i = 1

while True:
    value = secret_key + str(i)
    result = hashlib.md5(value.encode()).hexdigest()
    if result[:6] == six_zeros:
        break

    i += 1

print(i)
