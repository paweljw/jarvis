#!/bin/zsh
SUBCOMMAND=${1}

function shared_command_up() {
  docker-compose --file docker-compose.shared.yml --project-name shared up
}

function shared_command_build() {
  docker-compose --file docker-compose.shared.yml --project-name shared build
}

function shared_command_down() {
  docker-compose --file docker-compose.shared.yml --project-name shared down
}

function shared_command_logs() {
  docker-compose --file docker-compose.shared.yml --project-name shared logs -f
}

function shared_command_start() {
  sudo systemctl start shared;
}

function shared_command_stop() {
  sudo systemctl stop shared;
}

function shared_command_restart() {
  sudo systemctl restart shared;
}

function shared_command_help() {
  echo "
  $ jarvis shared help                                  - print this help message
  $ jarvis shared start                                 - start all shared stuff
  $ jarvis shared stop                                  - stop all shared stuff
  $ jarvis shared restart                               - restart all shared stuff
  "
}

function shared_validate_command() {
  if [ "$(whence -w shared_command_${SUBCOMMAND})" = "shared_command_${SUBCOMMAND}: function" ]; then
    return 0
  elif [ -z "$SUBCOMMAND" ]; then
    shared_command_help;
    return 1
  else
    echo "Unknown shared command: ${SUBCOMMAND}";
    return 1
  fi
}

function shared_execute_command() {
  if ! shared_validate_command; then
    return 1
  fi
  shared_command_${SUBCOMMAND} ${COMMAND_ARGS}
  return $?
}

if ! shared_execute_command; then
  return 1
fi
