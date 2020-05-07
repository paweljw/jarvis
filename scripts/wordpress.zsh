#!/bin/zsh
SUBCOMMAND=${1}

function wordpress_command_up() {
  docker-compose --file docker-compose.wordpress.yml --project-name wordpress up
}

function wordpress_command_build() {
  docker-compose --file docker-compose.wordpress.yml --project-name wordpress build
}

function wordpress_command_down() {
  docker-compose --file docker-compose.wordpress.yml --project-name wordpress down
}

function wordpress_command_logs() {
  docker-compose --file docker-compose.wordpress.yml --project-name wordpress logs -f
}

function wordpress_command_ps() {
  docker-compose --file docker-compose.wordpress.yml --project-name wordpress ps
}

function wordpress_command_start() {
  sudo systemctl start wordpress;
}

function wordpress_command_stop() {
  sudo systemctl stop wordpress;
}

function wordpress_command_restart() {
  sudo systemctl restart wordpress;
}

function wordpress_command_help() {
  echo "
  $ jarvis wordpress help                                  - print this help message
  $ jarvis wordpress start                                 - start all wordpress stuff
  $ jarvis wordpress stop                                  - stop all wordpress stuff
  $ jarvis wordpress restart                               - restart all wordpress stuff
  "
}

function wordpress_validate_command() {
  if [ "$(whence -w wordpress_command_${SUBCOMMAND})" = "wordpress_command_${SUBCOMMAND}: function" ]; then
    return 0
  elif [ -z "$SUBCOMMAND" ]; then
    wordpress_command_help;
    return 1
  else
    echo "Unknown wordpress command: ${SUBCOMMAND}";
    return 1
  fi
}

function wordpress_execute_command() {
  if ! wordpress_validate_command; then
    return 1
  fi
  wordpress_command_${SUBCOMMAND} ${COMMAND_ARGS}
  return $?
}

if ! wordpress_execute_command; then
  return 1
fi
