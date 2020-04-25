#!/bin/bash
wget -q -O - https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -
sudo sh -c 'echo "deb http://www.apache.org/dist/cassandra/debian 311x main" > /etc/apt/sources.list.d/cassandra.list'
sudo apt update
sudo apt install -y mongodb python3-venv openjdk-8-jdk apt-transport-https cassandra
python3 -m venv env
./env/bin/pip install pymongo
./env/bin/pip install -U pip
nodetool status
