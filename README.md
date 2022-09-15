# AWS Put Event Buildkite Plugin

A [Buildkite Plugin](https://buildkite.com/docs/agent/v3/plugins) to interact with AWS Event Bridge using aws CLI

## Example

```yml
steps:
  - command: 'echo \$SECRET_A' 
    plugins:
      - tapendium/aws-put-event:
          region: ap-southeast-2
          entries:
            source: 'source_name'
            resources: 'resource1,resource2'
```

## Developing

To run the tests:

```bash
docker-compose run --rm tests
```

## License

[MIT](https://opensource.org/licenses/MIT)
