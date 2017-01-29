from elasticsearch import Elasticsearch
import requests

def test_hello():
    es = Elasticsearch(['http://localhost:9200'])
    print(es)

def test_hello_req():
    res = requests.get('http://localhost:9200', json={})
    print(res.json())
