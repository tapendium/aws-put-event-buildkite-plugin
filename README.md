# AWS Put Event Buildkite Plugin

A [Buildkite Plugin](https://buildkite.com/docs/agent/v3/plugins) to interact with AWS Event Bridge using aws CLI

## Example

```yml
steps:
  - command:
      - echo 'your commands'
      - export ENTRY_DETAIL='{"data":{"name":"authn", "path":"authn/prefix"}}' # required field
      - export ENTRY_DETAIL1='{"data":{"name":"authn", "path":"authn/prefix"}}' # required field
      - buildkite-agent meta-data set 'ENTRY_DETAIL' $$ENTRY_DETAIL
      - buildkite-agent meta-data set 'ENTRY_DETAIL1' $$ENTRY_DETAIL1
    env:
      ENTRY_DETAIL_KEY: ENTRY_DETAIL
      ENTRY_DETAIL1_KEY: ENTRY_DETAIL1
    plugins:
      - tapendium/aws-put-event#v1.0.4:
          entries:
            - source: 'authn'
              resources: 'resource1,resource2'
              detail-type: 'frontend-build-completed'
              event-bus-name: 'EventBusArn'
              detail-env: 'ENTRY_DETAIL_KEY'
            - source: 'authn'
              resources: 'resource1,resource2'
              detail-type: 'frontend-build-completed'
              event-bus-name: 'EventBusArn'
              detail-env: 'ENTRY_DETAIL1_KEY'
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

- matrix example

```yml
steps:
  - group: ':eventbridge: Publish Import url'
    depends_on: upload-frontend-group
    steps:
      - label: ':eventbridge: [{{matrix}}] Publish Import url'
        commands:
          - buildkite-agent meta-data set 'EVENT_BUS_{{matrix}}' $$SCALE_EVENT_BUS_PRIMARYEVENTBUSARN
        env:
          ROLE_ARN_FIELD: 'ARNs.{{matrix}}'
          DETAIL_METADATA_KEY: 'ENTRY_DETAIL_{{matrix}}'
          EVENT_BUS_METADATA_KEY: 'EVENT_BUS_{{matrix}}'
        plugins:
          - *secret-assume-role
          - cultureamp/aws-assume-role
          - envato/cloudformation-output#v2.1.0:
              output:
                - 'scale-event-bus:PrimaryEventBusArn:ap-southeast-2'
          - tapendium/aws-put-event#v1.0.4:
              debug: true
              entries:
                - source: 'authn'
                  detail-env: 'DETAIL_METADATA_KEY'
                  event-bus-name-env: 'EVENT_BUS_METADATA_KEY'
                  detail-type: 'frontend-build-completed'
        matrix: *matrix
```

## Developing

To run the tests:

```bash
docker-compose run --rm tests
```

## License

[MIT](https://opensource.org/licenses/MIT)
