#!/bin/bash
source ./sh/functions.sh

case=$1
#case="java-native-ms"

StackName=$(jq -r ".StackName" "config.json")-$case
User=$(jq -r ".User" "config.json")
Key=$(jq -r ".Key" "config.json")

outputs=$(aws cloudformation describe-stacks --stack-name $StackName | jq '{Outputs: .Stacks[].Outputs}')
app_ip=$(echo $outputs | jq -r '.Outputs[] | select(.OutputKey == "PublicIPApp") | .OutputValue')
app_private_ip=$(echo $outputs | jq -r '.Outputs[] | select(.OutputKey == "PrivateIPApp") | .OutputValue')
tests_ip=$(echo $outputs | jq -r '.Outputs[] | select(.OutputKey == "PublicIPTest") | .OutputValue')



scenarios=(
    "hello"
    "case-one"
    "case-one?latency=10"
    "case-two?latency=10"
    "case-two?latency=100"
    "case-three"
)


for scenario in "${scenarios[@]}"; do
    command="docker restart \$(docker ps -a -q)"
    execute_remote_command "$command" "$app_ip" "$User" "$Key" > /dev/tty

    wait_http "http://$app_ip:8080/api/$scenario"

    cp "test/performance-analyzer/performance.exs" "sh/.tmp/performance-$case.exs"
    sed -i -e "s/_IP_/$app_private_ip/g" -e "s/_SCENARIO_/$scenario/g" "sh/.tmp/performance-$case.exs"
    upload_file $tests_ip "sh/.tmp/performance-$case.exs" "performance.exs" $User $Key

    rm -f "sh/.tmp/$scenario-$case.csv"
    out=$(execute_remote_command "rm -f result.csv" "$tests_ip" "$User" "$Key")


    execute_remote_command "docker run --rm -v \$(pwd):/app/config bancolombia/distributed-performance-analyzer:0.3.0" "$tests_ip" "$User" "$Key" > /dev/tty

    download_file $tests_ip "result.csv" "sh/.tmp/$scenario|$case.csv" $User $Key
    echo "$case $scenario" > /dev/tty
    echo "http://$app_ip:8080/api/$scenario" > /dev/tty
    cat ".tmp/$scenario|$case.csv" > /dev/tty
done

echo "#################"
echo "$case"
echo "#################"

