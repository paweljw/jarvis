#!/bin/zsh
SUBCOMMAND=${1}

function graylog_command_up() {
  docker-compose --file docker-compose.graylog.yml --project-name graylog up
}

function graylog_command_build() {
  docker-compose --file docker-compose.graylog.yml --project-name graylog build
}

function graylog_command_down() {
  docker-compose --file docker-compose.graylog.yml --project-name graylog down
}

function graylog_command_logs() {
  docker-compose --file docker-compose.graylog.yml --project-name graylog logs -f
}

function graylog_command_start() {
  sudo systemctl start graylog;
}

function graylog_command_stop() {
  sudo systemctl stop graylog;
}

function graylog_command_restart() {
  sudo systemctl restart graylog;
}

function graylog_command_help() {
  echo "
  $ jarvis graylog help                                  - print this help message
  $ jarvis graylog start                                 - start all graylog stuff
  $ jarvis graylog stop                                  - stop all graylog stuff
  $ jarvis graylog restart                               - restart all graylog stuff
  "
}

function graylog_validate_command() {
  if [ "$(whence -w graylog_command_${SUBCOMMAND})" = "graylog_command_${SUBCOMMAND}: function" ]; then
    return 0
  elif [ -z "$SUBCOMMAND" ]; then
    graylog_command_help;
    return 1
  else
    echo "Unknown graylog command: ${SUBCOMMAND}";
    return 1
  fi
}

function graylog_execute_command() {
  if ! graylog_validate_command; then
    return 1
  fi
  graylog_command_${SUBCOMMAND} ${COMMAND_ARGS}
  return $?
}

if ! graylog_execute_command; then
  return 1
fi
