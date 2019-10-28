#!/bin/zsh
SUBCOMMAND=${1}

function ha_command_up() {
  docker-compose --file docker-compose.ha.yml --project-name ha up
}

function ha_command_build() {
  docker-compose --file docker-compose.ha.yml --project-name ha build
}

function ha_command_down() {
  docker-compose --file docker-compose.ha.yml --project-name ha down
}

function ha_command_logs() {
  docker-compose --file docker-compose.ha.yml --project-name ha logs -f
}

function ha_command_start() {
  sudo systemctl start ha;
}

function ha_command_stop() {
  sudo systemctl stop ha;
}

function ha_command_restart() {
  sudo systemctl restart ha;
}

function ha_command_sh() {
  docker-compose --file docker-compose.ha.yml --project-name ha exec home-assistant sh
}


function ha_command_help() {
  echo "
  $ jarvis ha help                                  - print this help message
  $ jarvis ha start                                 - start all ha stuff
  $ jarvis ha stop                                  - stop all ha stuff
  $ jarvis ha restart                               - restart all ha stuff
  "
}

function ha_validate_command() {
  if [ "$(whence -w ha_command_${SUBCOMMAND})" = "ha_command_${SUBCOMMAND}: function" ]; then
    return 0
  elif [ -z "$SUBCOMMAND" ]; then
    ha_command_help;
    return 1
  else
    echo "Unknown ha command: ${SUBCOMMAND}";
    return 1
  fi
}

function ha_execute_command() {
  if ! ha_validate_command; then
    return 1
  fi
  ha_command_${SUBCOMMAND} ${COMMAND_ARGS}
  return $?
}

if ! ha_execute_command; then
  return 1
fi
