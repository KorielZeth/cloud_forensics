#!/bin/bash

cd /tmp/ && curl -LO https://rules.emergingthreats.net/open/suricata-6.0.8/emerging.rules.tar.gz
tar -xvzf emerging.rules.tar.gz && mv rules/*.rules /etc/suricata/rules/
chmod 640 /etc/suricata/rules/*.rules