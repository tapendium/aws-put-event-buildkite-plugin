#!/bin/bash

put_events()
{
  aws events put-events "$1" "$2" --output json
}

is_valid_json() {
  jq -e . >/dev/null 2>&1 <<<"$1"
}

compose_variable() {
  local a="$1"
  local value=${!a}
  echo "$value"
}

