#!/bin/bash
sudo apt update
sudo apt install -y mongodb python3-venv
python3 -m venv env
./env/bin/pip install pymongo
./env/bin/pip install -U pip
