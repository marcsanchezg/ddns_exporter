import os, sys
import time
from prometheus_client.core import GaugeMetricFamily, REGISTRY, CounterMetricFamily
from prometheus_client import start_http_server
import requests
import json

if len(sys.argv) != 1:
    script_dir=str(sys.argv[1])
else:
    script_dir=str("/usr/bin/dhcp_lease_to_json.sh")
print(script_dir)

class CustomCollector(object):
    def __init__(self):
        pass

    def collect(self):
        leases_json = json.loads(str(os.popen("bash " + script_dir).read()))
        for key in leases_json:
           g = GaugeMetricFamily("ddns_server_leases", "metric ", labels=['nameserver','mac','address'])
           g.add_metric([key['nameserver'], key['mac'],key['address']], 1)
           yield g

if __name__ == '__main__':
    start_http_server(9180)
    REGISTRY.register(CustomCollector())
    while True:
        time.sleep(1)
