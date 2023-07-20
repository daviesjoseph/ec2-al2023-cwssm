#!/bin/bash

sudo yum install -y amazon-cloudwatch-agent

sudo cat >> /opt/aws/amazon-cloudwatch-agent/bin/config_temp.json <<EOF
{
    "agent": {
    }
            "metrics_collection_interval": 60,
            "run_as_user": "root",
            "region": "ap-southeast-2",
            "logfile": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log"
    },
    "metrics": {
            "metrics_collected": {
                    "disk": {
                            "measurement": [
                                    "used_percent"
                            ],
                            "metrics_collection_interval": 60,
                            "resources": [
                                    "*"
                            ]
                    },
                    "mem": {
                            "measurement": [
                                    "mem_used_percent"
                            ],
                            "metrics_collection_interval": 60
                    }
            }
    }
}
EOF

sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
