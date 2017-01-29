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
