#!/bin/sh

DIR_HONEYBADGER="$HOME/honeybadger-bot"
DIR_BOT="$HOME/lichess-bot"
DIR_GH="$HOME/actions-runner"

source ./lib/utils.sh

cd $HOME

# lichess bot repository
p_header "- Cloning repository"
if [ -d $DIR_BOT ]; then
  p_log "- Lichess bot repository already cloned, skipping..."
else
  git clone https://github.com/ShailChoksi/lichess-bot.git $DIR_BOT
  p_success "Cloned repository."
fi

cd $DIR_BOT

# Python
p_header "- Installing Python 3"
apt install python3-pip --yes
p_success "Python installed."

# virtualenv
p_header "- Installing virtualenv"
pip install virtualenv
p_success "virtualenv installed."

# setup virtualenv
p_header "- Setting up virtualenv"
apt install python3-venv
p_success "virtualenv set up."
