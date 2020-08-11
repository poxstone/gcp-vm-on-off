# general
project_id="co-oortiz-internal"
account_key="account_key.json"
service_account_email=""  # default compute engine may be
region="us-east1"
zone="us-east1-b"

deploy_name_prefix="vms-onoff"
function_zip="../functions_start_stop.zip"
function_runtime="python37"
function_entry="vm_start_stop"
function_timeout=540

time_zone="America/Bogota"
schedule_chrone_on="*/5 * * * *"
schedule_chrone_off="*/1 * * * *"
message_instances="[ {'name':'centos-7kvm', 'zone':'us-east1-b'}, {'name':'centos-7kvm-1', 'zone':'us-east1-b'} ]"