import os

#iterate loop to read and print all environment variables
print("The keys and values of all env variables:")
for key in os.environ:
    print(key, '=>', os.environ[key])

#get TOMI_KEY
try:
    if os.environ['TOMI_KEY']:
        print('Tomi key is : {}'.format(os.environ['TOMI_KEY']))
except KeyError:
    print('environment variable TOMI_KEY is not set.')
