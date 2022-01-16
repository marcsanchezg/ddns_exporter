#!/bin/bash
python3.9 -m pip install -r requirements.txt

mkdir $HOME/bin
sudo cp ddns_exporter.py $HOME/bin/ddns_exporter.py
sudo cp dhcp_lease_to_json.sh /usr/bin/dhcp_lease_to_json.sh

echo "
[Unit]
Description=DDNS Exporter
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
ExecStart=/usr/bin/python3.9 $HOME/bin/ddns_exporter.py

[Install]
WantedBy=multi-user.target
" | sudo tee /etc/systemd/system/ddns_exporter.service

sudo systemctl enable ddns_exporter.service
sudo systemctl daemon-reload
sudo systemctl start ddns_exporter
