# AWS Put Event Buildkite Plugin

A [Buildkite Plugin](https://buildkite.com/docs/agent/v3/plugins) to interact with AWS Event Bridge using aws CLI

## Example

```yml
steps:
  - command:
      - echo 'your commands'
      - export ENTRY_DETAIL='{"detail":"value"}' # required field
      - export ENTRY_DETAIL1='{"detail":"value"}' # required field
    plugins:
      - tapendium/aws-put-event#v1.0.0:
          entries:
            - source: 'source_name'
              resources: 'resource1,resource2'
              detail-type: 'DetailName'
              event-bus-name: 'EventBusArn'
              detail-env: 'ENTRY_DETAIL'
            - source: 'source_name'
              resources: 'resource1,resource2'
              detail-type: 'DetailName'
              event-bus-name: 'EventBusArn'
              detail-env: 'ENTRY_DETAIL1'
```

- or use the plugin as

```yml
steps:
  - command:
      - echo 'your commands'
    env:
      - ENTRY_DETAIL: '{"detail":"value"}'
      - ENTRY_DETAIL1: '{"detail":"value"}'
    plugins:
      - tapendium/aws-put-event#v1.0.0:
          entries:
            - source: 'source_name'
              resources: 'resource1,resource2'
              detail-type: 'DetailName'
              event-bus-name: 'EventBusArn'
              detail-env: 'ENTRY_DETAIL'
            - source: 'source_name'
              resources: 'resource1,resource2'
              detail-type: 'DetailName'
              event-bus-name: 'EventBusArn'
              detail-env: 'ENTRY_DETAIL1'
```

- or 

```yml
steps:
  - command:
      - echo 'your commands'
    plugins:
      - tapendium/aws-put-event#v1.0.0:
          entries:
            - source: 'source_name'
              resources: 'resource1,resource2'
              detail-type: 'DetailName'
              event-bus-name: 'EventBusArn'
              detail: '"{"detail":"value"}"'
            - source: 'source_name'
              resources: 'resource1,resource2'
              detail-type: 'DetailName'
              event-bus-name: 'EventBusArn'
              detail: '"{"detail":"value"}"'
```

## Developing

To run the tests:

```bash
docker-compose run --rm tests
```

## License

[MIT](https://opensource.org/licenses/MIT)
