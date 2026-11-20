#!/usr/bin/bash

#pod_name: str 
function validate_arg() {
	if [[ -z "$1" ]]; then
		return 1
	fi
	return 0
}

#pod_name: str
function main() {
	if ! validate_arg $1; then
		echo "Missing argument 'pod'"
		exit 1
	fi
	
	kubectl_output=$(kubectl get pod -A | awk -v pattern="$1" '$2 ~ pattern {print $2}')
	echo "$kubectl_output"	
}

main $1
