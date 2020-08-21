export PROJECT_ID=`gcloud config get-value project`;
export REGION="us-east1";
export TOPIC_NAME="vms-onoff-schedule";
export SERVICE_ACCOUNT_EMAIL=`gcloud iam service-accounts list --project "${PROJECT_ID}" --format="value(email)" --filter="email:compute@developer"`;
export FUNCTION_NAME="vms-onoff-schedule";
export SCHEDULE_NAME="vms-onoff";
export SCHEDULE_TZONE="America/Bogota";
export SCHEDULE_CHRONE_ON="57 22 * * *";
export SCHEDULE_CHRONE_OFF="0 23 * * *";
export MESSAGE_INSTANCES="'gce':[ {'name':'*', 'zone':'us-east1-b'}], 'sql':[ {'name':'*'}], 'gke':[{'name':'*', 'zone': 'us-central1-c', 'nodeCount': 2}]";
export MESSAGE_ON="{ 'on_off': 'on', ${MESSAGE_INSTANCES} }";
export MESSAGE_OFF="{ 'on_off': 'off', ${MESSAGE_INSTANCES} }";