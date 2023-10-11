#!/bin/bash

# Installing SSH key
sudo mkdir -p /home/ubuntu/.ssh
sudo chmod 700 /home/ubuntu/.ssh
sudo cp /tmp/key.pub /home/ubuntu/.ssh/authorized_keys
sudo chmod 600 /home/ubuntu/.ssh/authorized_keys
sudo chown -R ubuntu /home/terraform/.ssh
sudo usermod --shell /bin/bash ubuntu
