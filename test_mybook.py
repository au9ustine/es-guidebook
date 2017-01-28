import requests
from time import sleep

ES_LOCAL_ENDPOINT = 'es-guidebook:9200'

def test_hello():
    sleep(1)
    res = requests.get('http://{0}/{1}'.format(ES_LOCAL_ENDPOINT, ''))
    assert res.status_code == 200
