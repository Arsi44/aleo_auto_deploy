#!/bin/bash

# если количетво аргументов не равно 5
if [ $# -ne 2 ]; then
    echo "Usage: $0 <NAME> <PK>"
    exit 1
fi

NAME="$1"
PK="$2"

snarkos developer execute "$NAME".aleo hello  $(echo $((1 + $RANDOM % 10)))u32 $(echo $((1 + $RANDOM % 10)))u32 --private-key $PK --query "https://vm.aleo.org/api" --broadcast "https://vm.aleo.org/api/testnet3/transaction/broadcast"
