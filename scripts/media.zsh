#!/bin/zsh
SUBCOMMAND=${1}

function media_command_up() {
  docker-compose --file docker-compose.media.yml --project-name media up
}

function media_command_build() {
  docker-compose --file docker-compose.media.yml --project-name media build
}

function media_command_down() {
  docker-compose --file docker-compose.media.yml --project-name media down
}

function media_command_logs() {
  docker-compose --file docker-compose.media.yml --project-name media logs -f
}

function media_command_ps() {
  docker-compose --file docker-compose.media.yml --project-name media ps
}

function media_command_start() {
  sudo systemctl start media;
}

function media_command_stop() {
  sudo systemctl stop media;
}

function media_command_restart() {
  sudo systemctl restart media;
}

function media_command_help() {
  echo "
  $ jarvis media help                                  - print this help message
  $ jarvis media start                                 - start all media stuff
  $ jarvis media stop                                  - stop all media stuff
  $ jarvis media restart                               - restart all media stuff
  "
}

function media_validate_command() {
  if [ "$(whence -w media_command_${SUBCOMMAND})" = "media_command_${SUBCOMMAND}: function" ]; then
    return 0
  elif [ -z "$SUBCOMMAND" ]; then
    media_command_help;
    return 1
  else
    echo "Unknown media command: ${SUBCOMMAND}";
    return 1
  fi
}

function media_execute_command() {
  if ! media_validate_command; then
    return 1
  fi
  media_command_${SUBCOMMAND} ${COMMAND_ARGS}
  return $?
}

if ! media_execute_command; then
  return 1
fi
