#!/bin/bash

# если количетво аргументов не равно 5
if [[ "$#" -ne 5 ]]; then
  echo "Неверное количество аргументов"
  exit 1
fi

PK="$1"
VK="$2"
ADDRESS="$3"
QUOTE_LINK="$4"
NAME="$5"

echo "Private Key: $PK"
echo "View Key: $VK"
echo "Address: $ADDRESS"
echo "Quote Link: $QUOTE_LINK"
echo "Contract Name: $NAME"

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

# ./aleo_deploy.sh APrivateKey1zkp3ckEYE8edcuGD917b8Dwv1LmdLjye3QtAmvJs5aaMwMT AViewKey1rnZzU1BaapGzu3rZSrUq6KHoefTZHKN1tQkaZtvvSJRN aleo1l3h53jde5uxy0v08w6zdwxsv754lmjcg3pwlnttd2smzwlf0syxs79rxe5 https://vm.aleo.org/api/testnet3/transaction/at1ll0njuj7nrr2uptjee0dedm62eufamwuqhqwp097ck5fsr3tkcgqa57quz… sobriquet213