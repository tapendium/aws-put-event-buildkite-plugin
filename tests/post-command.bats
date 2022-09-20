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
	assert_output --partial "At least one entry needs to be defined"
}

@test "Runs and failed when detail not defined" {
  export ${prefix_entries}_0_SOURCE="sourcevalue"
  export -f aws
	run "$post_command_hook"
	assert_failure
	assert_output --partial "entries > detail not defined. Exiting"
}

@test "Runs and failed when detail-type not defined" {
  export ${prefix_entries}_0_DETAIL='{"detail":"value with space"}'
  export ${prefix_entries}_0_SOURCE="sourcevalue"
  export -f aws
	run "$post_command_hook"
	assert_failure
	assert_output --partial "entries > detail-type not defined. Exiting"
}

@test "Runs and failed when event-bus-name not defined" {
  export ${prefix_entries}_0_DETAIL='{"detail":"value with space"}'
  export ${prefix_entries}_0_SOURCE="sourcevalue"
  export ${prefix_entries}_0_DETAIL_TYPE="detailname"
  export -f aws
	run "$post_command_hook"
	assert_failure
	assert_output --partial "entries > event-bus-name not defined. Exiting"
}

@test "Runs with no errors with single entry" {
  export ${prefix_entries}_0_DETAIL='{"detail":"value with space"}'
  export ${prefix_entries}_0_SOURCE="sourcevalue"
  export ${prefix_entries}_0_DETAIL_TYPE="detailname"
  export ${prefix_entries}_0_EVENT_BUS_NAME="detailname"
  export -f aws
	run "$post_command_hook"
	assert_success
}

@test "Runs and fails with single entry with no detail on multiple" {
  export ${prefix_entries}_0_DETAIL='{"detail":"value with space"}'
  export ${prefix_entries}_0_SOURCE="sourcevalue"
  export ${prefix_entries}_0_DETAIL_TYPE="detailname"
  export ${prefix_entries}_0_EVENT_BUS_NAME="detailname"
  export ${prefix_entries}_1_WRONG_DEFINED_DETAIL='"{"detail":"value with space"}"'
  export ${prefix_entries}_1_SOURCE="sourcevalue"
  export ${prefix_entries}_1_DETAIL_TYPE="detailname"
  export ${prefix_entries}_1_EVENT_BUS_NAME="detailname"
  export -f aws
	run "$post_command_hook"
	assert_failure
	assert_output --partial "entries > detail not defined. Exiting"
}

@test "Runs with no errors with multiple entries" {
  export ${prefix_entries}_0_DETAIL='"{"detail":"value with space"}"'
  export ${prefix_entries}_0_SOURCE="sourcevalue"
  export ${prefix_entries}_0_DETAIL_TYPE="detailname"
  export ${prefix_entries}_0_EVENT_BUS_NAME="detailname"
  export ${prefix_entries}_1_DETAIL='"{"detail":"value with space"}"'
  export ${prefix_entries}_1_SOURCE="sourcevalue"
  export ${prefix_entries}_1_DETAIL_TYPE="detailname"
  export ${prefix_entries}_1_EVENT_BUS_NAME="detailname"
  export -f aws
	run "$post_command_hook"
	assert_success
}

