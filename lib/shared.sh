#!/bin/bash

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

put_events()
{
  aws events put-events "$1" "$2" --output json
}

