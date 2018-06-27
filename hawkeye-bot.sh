#!/bin/sh

PID="./hawkeye-bot-daemon.pid"
CMD="bundle exec ruby hawkeye-bot.rb"

start()
{
  if [ -e $PID ]; then
    echo "hawkeye-bot is already started"
    exit 1
  fi
  echo "start hawkeye-bot"
  $CMD
  # TODO: send message to slack
}

stop()
{
  if [ ! -e $PID ]; then
    echo "hawkeye-bot is not started"
    exit 1
  fi
  echo "stop hawkeye-bot"
  kill -INT `cat ${PID}`
  rm $PID
}

update()
{
  git checkout master
  git pull
  bundle install --path vendor/bundle
}

restart()
{
  stop
  sleep 2
  update
  sleep 2
  start
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    restart
    ;;
  update)
    update
    ;;
  *)
    echo "Usage: ./hawkeye-bot.sh [start|stop|restart|update]"
    ;;
esac