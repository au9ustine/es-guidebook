# es-guidebook

ElasticSearch Guidebook Exercise. The guidebook could be found at [official doc site](https://www.elastic.co/guide/en/elasticsearch/guide/current/index.html)

## Prerequisites

- docker >= 1.12.0
- docker-compose >= 1.9.0

## About retry in Circle CI

Actually I've been testing for a whole afternoon to explore the reason why my Python testing keeps failed once giving a ping to `http://localhost:9200` (actually I've tried container name, gateway address, concrete IP address ... but eventually they were all failed, frustrated), and this [doc](https://circleci.com/docs/docker/) showed the usage how to use docker in Circle CI and consider some magic words like

```yml
test:
  override:
    ...;  sleep 10
    ... --retry 10 --retry-delay 5 ...
```

which made me puzzled.  [PR #11407](https://github.com/docker/docker/issues/11407) revealed some potential reasons about this issue. So I don't believe this has been fixed, however this interim solution saved me after all.
