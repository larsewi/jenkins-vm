#!/bin/bash

IPADDR=192.168.56.20

if [ ! -f .venv/bin/activate ]
then
    echo "Creating Python virtual environment"
    python3 -m venv .venv

    echo "Installing/upgrading dependencies"
    source .venv/bin/activate
    pip install --upgrade -r requirements.txt
else
    source .venv/bin/activate
fi

cf-remote save --hosts root@$IPADDR --role hub --name jenkins

# echo "Installing CFEngine"
# cf-remote --version master install --bootstrap --hub jenkins

echo "Building masterfiles Policy Framework"
cfbs build

echo "Deploying Masterfiles Policy Framework"
cf-remote deploy --hub jenkins
