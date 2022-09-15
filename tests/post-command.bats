#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

post_command_hook="$PWD/hooks/post-command"

prefix="BUILDKITE_PLUGIN_AWS_PUT_EVENT"

function aws() {
	echo ${SECRET_VALUE:-secret}
}

@test "Runs with no errors" {
	run "$post_command_hook"

  export -f aws

	assert_success
}

