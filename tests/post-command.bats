#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

post_command_hook="$PWD/hooks/post-command"
prefix="BUILDKITE_PLUGIN_AWS_PUT_EVENT"
prefix_entries="BUILDKITE_PLUGIN_AWS_PUT_EVENT_ENTRIES"

function aws() {
	echo ${SECRET_VALUE:-secret}
}

@test "Runs and failed when entry not defined" {
  export -f aws
	run "$post_command_hook"
	assert_failure
	assert_output --partial "ENTRY_DETAIL environment not defined. Exiting"
}

@test "Runs and failed when detail-type not defined" {
  export ENTRY_DETAIL='{"somekey":"hello"}'
  export ${prefix_entries}_SOURCE="sourcevalue"
  export -f aws
	run "$post_command_hook"
	assert_failure
	assert_output --partial "entries > detail-type not defined. Exiting"
}

@test "Runs and failed when event-bus-name not defined" {
  export ENTRY_DETAIL='{"somekey":"hello"}'
  export ${prefix_entries}_SOURCE="sourcevalue"
  export ${prefix_entries}_DETAIL_TYPE="detailname"
  export -f aws
	run "$post_command_hook"
	assert_failure
	assert_output --partial "entries > event-bus-name not defined. Exiting"
}

@test "Runs with no errors" {
  export ENTRY_DETAIL='{"detail-type":"hello"}'
  export ${prefix_entries}_SOURCE="sourcevalue"
  export ${prefix_entries}_DETAIL_TYPE="detailname"
  export ${prefix_entries}_EVENT_BUS_NAME="detailname"
  export -f aws
	run "$post_command_hook"
	assert_success
}

