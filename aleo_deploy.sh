#!/bin/bash

echo Enter your Private Key: && read PK && \
echo Enter your View Key: && read VK && \
echo Enter your Address: && read ADDRESS && \
echo Paste the link: && read QUOTE_LINK && \
echo Enter the Name of your contract "(any)": && read NAME


if [[ $1 == "true" ]]; then
  echo "Выполняем команду apt update"
  apt update && apt install make clang pkg-config libssl-dev build-essential gcc xz-utils git curl vim tmux ntp jq llvm ufw -y

  cd $HOME
  git clone https://github.com/AleoHQ/snarkOS.git --depth 1
  cd snarkOS
  bash ./build_ubuntu.sh
  source $HOME/.bashrc
  source $HOME/.cargo/env

  cd $HOME
  git clone https://github.com/AleoHQ/leo.git
  cd leo
  cargo install --path .
else
  echo "Установка зависимосте не требуется"
fi

cd $HOME
rm -rf leo_deploy


cd $HOME && mkdir leo_deploy && cd leo_deploy
leo new $NAME

CIPHERTEXT=$(curl -s $QUOTE_LINK | jq -r '.execution.transitions[0].outputs[0].value')
RECORD=$(snarkos developer decrypt --ciphertext $CIPHERTEXT --view-key $VK)

snarkos developer deploy "$NAME.aleo" \
--private-key "$PK" \
--query "https://vm.aleo.org/api" \
--path "$HOME/leo_deploy/$NAME/build/" \
--broadcast "https://vm.aleo.org/api/testnet3/transaction/broadcast" \
--fee 600000 \
--record "$RECORD"