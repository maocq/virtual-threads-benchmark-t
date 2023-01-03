#######################################
# ARGUMENTS: (instance_ip, user, key)
# OUTPUTS:
# RETURN: 0, Non-zero on error.
#######################################
wait_initialized() {
  local instance_ip=$1
  local user=$2
  local key=$3

  while [[ $(execute_remote_command "echo 'OK'" "$instance_ip" "$user" "$key") != *"OK"* ]]; do
	  echo "... Waiting ssh $instance_ip" > /dev/tty
	done

  echo "Waiting for initialization $instance_id ..." > /dev/tty
  local cmd="until [ -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting...'; sleep 2; done"

  execute_remote_command "$cmd" "$instance_ip" "$user" "$key" > /dev/tty

  echo "Instance $instance_ip OK!" > /dev/tty
  return 0;
}

#######################################
# ARGUMENTS: (instance_ip, url_reposity, user, key)
# OUTPUTS:
# RETURN: 0, Non-zero on error.
#######################################
update_repository() {
  local instance_ip=$1
  local url_reposity=$2
  local user=$3
  local key=$4

  local cmd="cd app; git checkout . && git pull;"

  local out=$(execute_remote_command "$cmd" "$instance_ip" $user $key)
  return 0;
}

#######################################
# ARGUMENTS: (folder, url_reposity, instance_ip, user, key)
# OUTPUTS:
# RETURN: 0, Non-zero on error.
#######################################
start_docker_image() {
  local instance_ip=$1
  local url_reposity=$2
	local folder=$3
	local user=$4
	local key=$5

	execute_remote_command "bash app/sh/start_docker_image.sh $folder" "$instance_ip" "$user" "$key" > /dev/tty
	return 0;
}

#######################################
# ARGUMENTS: (command, instance_ip, user, key)
# OUTPUTS: command output
# RETURN: 0, Non-zero on error.
#######################################
execute_remote_command() {
  local command=$1
  local ip=$2
  local user=$3
  local key=$4

  echo "Executing command $command on $ip" > /dev/tty
  ssh -o "StrictHostKeyChecking no" -i "$key" "$user@$ip" "$command"

  return 0
}