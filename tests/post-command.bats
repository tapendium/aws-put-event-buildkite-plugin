#!/usr/bin/env bats

setup() {
	load "$BATS_PLUGIN_PATH/load.bash"
}

post_command_hook="$PWD/hooks/post-command"
prefix="BUILDKITE_PLUGIN_AWS_PUT_EVENT"
prefix_entries="${prefix}_ENTRIES"
export MOCK_PARSE_JSON=true

function buildkite-agent() {
	echo "value"
}

function aws() {
	echo "Runs mock aws cli"
}

export MOCK_DETAIL_OUTPUT=$(jq -R . ./tests/mock_detail.json)
function mock_parse_json() {
	echo "${MOCK_DETAIL_OUTPUT}"
}

@test "Runs and failed when entry not defined" {
	export -f aws
	run "$post_command_hook"
	assert_failure
	assert_output --partial "[WARNING] At least one entry needs to be defined"
}

@test "Runs and failed when detail not defined" {
	export ${prefix_entries}_0_SOURCE="sourcevalue"
	export -f aws
	run "$post_command_hook"
	assert_failure
	assert_output --partial "Entry[0]: detail or detail-env not defined."
}

@test "Runs and failed when detail-type not defined" {
	export ${prefix_entries}_0_DETAIL_ENV='HELLO'
	export ${prefix_entries}_0_SOURCE="sourcevalue"
	export -f aws
	run "$post_command_hook"
	assert_failure
	assert_output --partial "Entry[0]: detail-type not defined."
}

@test "Runs and failed when event-bus-name not defined" {
	export ${prefix_entries}_0_DETAIL='{"detail":"value with space"}'
	export ${prefix_entries}_0_SOURCE="sourcevalue"
	export ${prefix_entries}_0_DETAIL_TYPE="detailname"
	export -f aws
	export -f mock_parse_json
	run "$post_command_hook"
	assert_failure
	assert_output --partial "Entry[0]: event-bus-name not defined."
}

@test "Runs and failed when event-bus-name-env not defined" {
	export ${prefix_entries}_0_DETAIL='{"detail":"value with space"}'
	export ${prefix_entries}_0_SOURCE="sourcevalue"
	export ${prefix_entries}_0_DETAIL_TYPE="detailname"
	export ${prefix_entries}_0_EVENT_BUS_NAME_ENV="EVENT_BUS_URL"
	export -f aws
	export -f mock_parse_json
	run "$post_command_hook"
	assert_failure
	assert_output --partial "Entry[0]: event-bus-name not defined."
}

@test "Runs with no errors with single entry" {
	export ${prefix_entries}_0_DETAIL='{"detail":"value with space"}'
	export ${prefix_entries}_0_SOURCE="sourcevalue"
	export ${prefix_entries}_0_DETAIL_TYPE="detailname"
	export EVENT_BUS_URL="arn://testtesttest"
	export ${prefix_entries}_0_EVENT_BUS_NAME_ENV="EVENT_BUS_URL"
	export -f aws
	export -f mock_parse_json
	export -f buildkite-agent
	run "$post_command_hook"
	assert_success
	assert_output --partial "RNNNING COMMAND"
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
	export -f mock_parse_json
	run "$post_command_hook"
	assert_failure
	assert_output --partial "[INFO] ENTRIES_SIZE 2"
	assert_output --partial "Entry[1]: detail or detail-env not defined."
}

@test "Runs with no errors with multiple entries" {
	export ${prefix_entries}_0_DETAIL='{"detail":"value with space"}'
	export ${prefix_entries}_0_SOURCE="sourcevalue"
	export ${prefix_entries}_0_DETAIL_TYPE="detailname"
	export ${prefix_entries}_0_EVENT_BUS_NAME="detailname"
	export ${prefix_entries}_1_DETAIL='{"detail":"value with space"}'
	export ${prefix_entries}_1_SOURCE="sourcevalue"
	export ${prefix_entries}_1_DETAIL_TYPE="detailname"
	export ${prefix_entries}_1_EVENT_BUS_NAME="detailname"
	export -f aws
	export -f mock_parse_json
	run "$post_command_hook"
	assert_success
	assert_output --partial "[INFO] ENTRIES_SIZE 2"
	assert_output --partial "[RNNNING COMMAND]"
	assert_output --partial "aws events put-events --entries"
}

@test "Runs with no errors with multiple entries with exact value" {
	export ${prefix_entries}_0_DETAIL='{"detail":"value with space"}'
	export ${prefix_entries}_0_SOURCE="sourcevalue"
	export ${prefix_entries}_0_DETAIL_TYPE="detailname"
	export ${prefix_entries}_0_EVENT_BUS_NAME="detailname"
	export ${prefix_entries}_1_DETAIL='{"detail":"value with space"}'
	export ${prefix_entries}_1_SOURCE="sourcevalue"
	export ${prefix_entries}_1_DETAIL_TYPE="detailname"
	export ${prefix_entries}_1_EVENT_BUS_NAME="detailname"
	export -f aws
	export -f mock_parse_json
	run "$post_command_hook"
	assert_success
	assert_output --partial "[INFO] ENTRIES_SIZE 2"
	assert_output --partial "[RNNNING COMMAND]"
	expected_output="aws events put-events --entries ' Detail=${MOCK_DETAIL_OUTPUT},Source=sourcevalue,DetailType=detailname,EventBusName=detailname Detail=${MOCK_DETAIL_OUTPUT},Source=sourcevalue,DetailType=detailname,EventBusName=detailname' --output json"
	assert_output --partial "${expected_output}"
}
