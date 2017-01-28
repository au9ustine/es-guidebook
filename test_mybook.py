import requests

ES_LOCAL_ENDPOINT = 'localhost:9200'

def test_hello():
    res = requests.get('http://{0}/{1}'.format(ES_LOCAL_ENDPOINT, '?pretty'))
    assert res.status_code == 200
