#!bin/bash

sudo cat << EOF > ./config.json
  {
      "agent": {
          "metrics_collection_interval": 60,
          "run_as_user": "root"
      },
      "metrics": {
          "append_dimensions": {
              "ImageId": "${aws:ImageId}",
              "InstanceId": "${aws:InstanceId}",
              "InstanceType": "${aws:InstanceType}",
              "AutoScalingGroupName": "${aws:AutoScalingGroupName}"
          },
          "aggregation_dimensions": [
              ["AutoScalingGroupName"],
              ["InstanceId", "InstanceType"],
              ["InstanceId"]
          ],
          "metrics_collected": {
              "disk": {
                  "measurement": ["disk_used_percent", "disk_inodes_free"],
                  "metrics_collection_interval": 60,
                  "resources": ["/"]
              },
              "mem": {
                  "measurement": ["mem_used_percent"],
                  "metrics_collection_interval": 60
              }
          }
      }
  }
  EOF
sudo wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
sudo mv config.json /opt/aws/amazon-cloudwatch-agent/bin/config.json
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s
sudo /bin/systemctl restart amazon-cloudwatch-agent.service