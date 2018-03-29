#!/bin/bash

SWIFTLINT="$(PWD)/Pods/SwiftLint/swiftlint"
CONFIG="$(PWD)/.swiftlint.yml"

# possible paths
paths_sources="Sources"
paths_tests="Tests"

# load selected group
if [ $# -gt 0 ]; then
	key="$1"
else
	echo "error: need group to lint."
	exit 1
fi

selected_path=`eval echo '$'paths_$key`
if [ -z "$selected_path" ]; then
	echo "error: need a valid group to lint."
	exit 1
fi

"$SWIFTLINT" lint --strict --config "$CONFIG" --path "${PWD}/${selected_path}"
