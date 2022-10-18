#!/bin/bash

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

put_events()
{
  aws events put-events "$1" "$2" --output json
}

is_valid_json() {
  json_pp >/dev/null 2>&1 <<<"$1"
}
