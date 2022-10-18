# AWS Put Event Buildkite Plugin

A [Buildkite Plugin](https://buildkite.com/docs/agent/v3/plugins) to interact with AWS Event Bridge using aws CLI

## Example

```yml
steps:
  - command:
      - echo 'your commands'
      - export ENTRY_DETAIL='{"data":{"name":"authn", "path":"authn/prefix"}}' # required field
      - buildkite-agent meta-data set 'ENTRY_DETAIL' $$ENTRY_DETAIL
      - export ENTRY_DETAIL1='{"data":{"name":"authn", "path":"authn/prefix"}}' # required field
      - buildkite-agent meta-data set 'ENTRY_DETAIL1' $$ENTRY_DETAIL1
    plugins:
      - tapendium/aws-put-event#v1.0.4:
          entries:
            - source: 'authn'
              resources: 'resource1,resource2'
              detail-type: 'frontend-build-completed'
              event-bus-name: 'EventBusArn'
              detail-env: 'ENTRY_DETAIL'
            - source: 'authn'
              resources: 'resource1,resource2'
              detail-type: 'frontend-build-completed'
              event-bus-name: 'EventBusArn'
              detail-env: 'ENTRY_DETAIL1'
```

- or use the plugin as

```yml
steps:
  - command:
      - echo 'your commands'
    env:
      - ENTRY_DETAIL: '{"data":{"name":"authn", "path":"authn/prefix"}}'
      - buildkite-agent meta-data set 'ENTRY_DETAIL' $$ENTRY_DETAIL
      - ENTRY_DETAIL1: '{"data":{"name":"authn", "path":"authn/prefix"}}'
      - buildkite-agent meta-data set 'ENTRY_DETAIL1' $$ENTRY_DETAIL1
    plugins:
      - tapendium/aws-put-event#v1.0.4:
          entries:
            - source: 'authn'
              resources: 'resource1,resource2'
              detail-type: 'frontend-build-completed'
              event-bus-name: 'EventBusArn'
              detail-env: 'ENTRY_DETAIL'
            - source: 'authn'
              resources: 'resource1,resource2'
              detail-type: 'frontend-build-completed'
              event-bus-name: 'EventBusArn'
              detail-env: 'ENTRY_DETAIL1'
```

- or 

```yml
steps:
  - command:
      - echo 'your commands'
    plugins:
      - tapendium/aws-put-event#v1.0.4:
          entries:
            - source: 'authn'
              resources: 'resource1,resource2'
              detail-type: 'frontend-build-completed'
              event-bus-name: 'EventBusArn'
              detail: '{"data":{"name":"authn", "path":"authn/prefix"}}'
            - source: 'authn'
              resources: 'resource1,resource2'
              detail-type: 'frontend-build-completed'
              event-bus-name: 'EventBusArn'
              detail: '{"data":{"name":"authn", "path":"authn/prefix"}}'
```

## Developing

To run the tests:

```bash
docker-compose run --rm tests
```

## License

[MIT](https://opensource.org/licenses/MIT)
