#!/bin/bash
sudo snap switch --channel=candidate amazon-ssm-agent
sudo snap install amazon-ssm-agent --classic
sudo snap list amazon-ssm-agent
sudo snap start amazon-ssm-agent
sudo snap services amazon-ssm-agent