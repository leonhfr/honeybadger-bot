# honeybadger-bot

Lichess bot running the Honey Badger chess engine on a Raspberry Pi

## Set up

1. [Install Ubuntu Server](ubuntu-server) on the Raspberry Pi.
2. Set up a [Github self-hosted runner](github-action-runner), using Linux/ARM64 for the Raspberry Pi 3. Skip the step to run it `./run.sh`.
3. Then:

```sh
# From HOME
cd ~
# Clone this repository
git clone https://github.com/leonhfr/honeybadger-bot.git
cd honeybadger-bot
# Running with sudo to install dependencies, the argument is the lichess token
sudo ./setup.sh lip_651p**************io
```

<!--
[ubuntu-server]: https://ubuntu.com/tutorials/how-to-install-ubuntu-on-your-raspberry-pi
[github-action-runner]: https://docs.github.com/en/actions/hosting-your-own-runners/adding-self-hosted-runners
-->
