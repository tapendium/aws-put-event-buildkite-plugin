# AWS Put Event Buildkite Plugin

A [Buildkite Plugin](https://buildkite.com/docs/agent/v3/plugins) to interact with AWS Event Bridge using aws CLI

## Example

```yml
steps:
  - command:
      - echo 'your commands'
      - export ENTRY_DETAIL='{"detail":"value"}' # required field
    plugins:
      - tapendium/aws-put-event:
          entries:
            source: 'source_name'
            resources: 'resource1,resource2'
            detail-type: 'DetailName'
            event-bus-name: 'EventBusArn'
```

## Developing

To run the tests:

```bash
docker-compose run --rm tests
```

## License

[MIT](https://opensource.org/licenses/MIT)
