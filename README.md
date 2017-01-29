# es-guidebook

ElasticSearch Guidebook Exercise. The guidebook could be found at [official doc site](https://www.elastic.co/guide/en/elasticsearch/guide/current/index.html)

## Prerequisites

- docker >= 1.12.0
- docker-compose >= 1.9.0

## About Circle CI

Actually I've been testing for a whole afternoon to explore the reason why my Python testing keeps failed once giving a ping to `http://localhost:9200` (actually I've tried container name, gateway address, concrete IP address ... but eventually they were all failed, frustrated), and this [doc](https://circleci.com/docs/docker/) showed the usage how to use docker in Circle CI and consider some magic words like

```yml
test:
  override:
    ...;  sleep 10
    ... --retry 10 --retry-delay 5 ...
```

which made me puzzled.  [PR #11407](https://github.com/docker/docker/issues/11407) revealed some potential reasons about this issue, however I don't believe this has been fixed.

And it seems like Circle CI could not support latest elastic search well (at least 5.1.2) and a relevant issue raised [here](https://discuss.circleci.com/t/any-possibility-to-support-latest-elasticsearch-5-1-2-indeed/9951)

Now I have to disable it until it's fixed.


## Troubleshootings

### `fielddata` failure

If you encountered errors like this

```json
{
  "error" : {
    "root_cause" : [
      {
        "type" : "illegal_argument_exception",
        "reason" : "Fielddata is disabled on text fields by default. Set fielddata=true on [interests] in order to load fielddata in memory by uninverting the inverted index. Note that this can however use significant memory."
      }
    ],
    "type" : "search_phase_execution_exception",
    "reason" : "all shards failed",
    "phase" : "query",
    "grouped" : true,
    "failed_shards" : [
      {
        "shard" : 0,
        "index" : "megacorp",
        "node" : "pObCyooaSnikdSLIm2r5Yw",
        "reason" : {
          "type" : "illegal_argument_exception",
          "reason" : "Fielddata is disabled on text fields by default. Set fielddata=true on [interests] in order to load fielddata in memory by uninverting the inverted index. Note that this can however use significant memory."
        }
      }
    ],
    "caused_by" : {
      "type" : "illegal_argument_exception",
      "reason" : "Fielddata is disabled on text fields by default. Set fielddata=true on [interests] in order to load fielddata in memory by uninverting the inverted index. Note that this can however use significant memory."
    }
  },
  "status" : 400
}
```
That means you have not enabled `fielddata`. From [official reference doc](https://www.elastic.co/guide/en/elasticsearch/reference/current/fielddata.html#before-enabling-fielddata), you need to have a `text` field for full text search and an unanalyzed `keyword` field with `doc_values`, and enable `fielddata` for your field.

So firstly,
```
curl -XPUT http://localhost:9200/megacorp -H 'Content-Type: application/json' -d '
{
  "mappings": {
    "employee": {
      "properties": {
        "interests": {
          "type": "text",
          "fields": {
            "keyword": {
              "type": "keyword"
            }
          }
        }
      }
    }
  }
}
'
```
and then enable `fielddata`
```
curl -XPUT 'localhost:9200/megacorp/_mapping/employee?pretty' -H 'Content-Type: application/json' -d'
{
  "properties": {
    "interests": { 
      "type":     "text",
      "fielddata": true
    }
  }
}
'
```
