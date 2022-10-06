#!/bin/bash

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

put_events()
{
  echo "--- [RNNNING COMMAND]"
  echo "aws events put-events"
  echo $1
  echo $2
  aws events put-events "$1" "$2" --output json
}

