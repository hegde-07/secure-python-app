#!/bin/bash
sudo apt update -y
sudo apt install -y python3-pip git

# Clone the app
cd /home/ubuntu
git clone https://github.com/hegde-07/secure-python-app.git
cd secure-python-app

pip3 install -r myapp/requirements.tx

python3 myapp/hello.py > /home/ubuntu/app_output.log