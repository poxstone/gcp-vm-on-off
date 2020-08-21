# general
project_id="co-oortiz-internal"
account_key="account_key.json"
service_account_email="402543303294-compute@developer.gserviceaccount.com"  # default compute engine may be
region="us-east1"
zone="us-east1-b"

deploy_name_prefix="vms-onoff"
function_zip="../functions_start_stop.zip"
function_runtime="python37"
function_entry="vm_start_stop"
function_timeout=540

time_zone="America/Bogota"
schedule_chrone_on="57 22 * * *"
schedule_chrone_off="0 23 * * *"
message_instances="'gce':[ {'name':'*', 'zone':'us-east1-b'}], 'sql':[ {'name':'*'}], 'gke':[{'name':'*'}]"
