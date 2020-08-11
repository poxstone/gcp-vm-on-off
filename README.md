# Schedule vm start off

General components description

1. Cloud pub*/sub
   - push
   - message (edit instances and on or off), exaple:
     ```json
     {
        "on_off": "off", 
        "instances": [
            {"name":"my-mv-1", "zone":"us-east1-b"},
            {"name":"my-mv-2", "zone":"us-east1-c"},
        ]
     }
    ```
1. Cloud Functions
   - pubsub
   - 128 MB
   - 540s
   - max retries: 2
   - service account: GCE default
   - python 3.7 (main.py requirements.py)
   - entrypoint: vm_start_stop
1. Cloud Schedule
   - pub/sub


## Deploy GCloud

Create only with gcloud command line
```bash
PROJECT_ID=`gcloud config get-value project`;
REGION="us-east1";
TOPIC_NAME="vm-schedule";
SERVICE_ACCOUNT_EMAIL=`gcloud iam service-accounts list --project "${PROJECT_ID}" --format="value(email)" --filter="email:compute@developer"`;
FUNCTION_NAME="vm_onoff";
SCHEDULE_NAME="vms";
SCHEDULE_TZONE="America/Bogota";
SCHEDULE_CHRONE_ON="1 * * * *";
SCHEDULE_CHRONE_OFF="1 * * * *";
MESSAGE_INSTANCES="[ {'name':'centos-7kvm', 'zone':'us-east1-b'}, {'name':'centos-7kvm-1', 'zone':'us-east1-b'} ]";
MESSAGE_ON="{ 'on_off': 'on', 'instances': ${MESSAGE_INSTANCES} }";
MESSAGE_OFF="{ 'on_off': 'off', 'instances': ${MESSAGE_INSTANCES} }";

# create topic
gcloud pubsub topics create "${TOPIC_NAME}" --project "${PROJECT_ID}";

# cloud functions  --runtime nodejs10 --trigger-topic
gcloud functions deploy "${FUNCTION_NAME}" --trigger-topic "${TOPIC_NAME}" --runtime "python37" --source="./" --entry-point "vm_start_stop" --service-account "${SERVICE_ACCOUNT_EMAIL}" --memory "128"  --region "${REGION}" --project "${PROJECT_ID}";

# schedule on
gcloud scheduler jobs create pubsub "projects/${PROJECT_ID}/locations/${REGION}/jobs/${SCHEDULE_NAME}-on" --schedule "${SCHEDULE_CHRONE_OFF}" --topic "${TOPIC_NAME}" --time-zone "${SCHEDULE_TZONE}" --message-body "${MESSAGE_ON}" --project "${PROJECT_ID}";
# schedule off
gcloud scheduler jobs create pubsub "projects/${PROJECT_ID}/locations/${REGION}/jobs/${SCHEDULE_NAME}-off" --schedule "${SCHEDULE_CHRONE_ON}" --topic "${TOPIC_NAME}" --time-zone "${SCHEDULE_TZONE}" --message-body "${MESSAGE_OFF}" --project "${PROJECT_ID}";

```

## Deploy terraform

Create with terraform

1. Create service account key add permissions "terraform/account_key.json"
1. Comppress (Zip) main.py and requirements.py "functions_start_stop.zip"
1. Edit someones variables "terraform/variables.auto.tfvars"
   - project_id
   - service_account_email
   - time_zone
   - schedule_chrone_on
   - schedule_chrone_off
   - message_instances
1. Run commands:
    ```bash
    cd terraform;
    
    # install provider
    terraform init;
    
    # validate script
    terraform validate;
    
    # Create execution plan to visualizate resourses
    terraform plan;
    
    # apply dev (vars-dev.auto.tfvars)
    terraform apply -auto-approve;
    ```
1. Go to cloud Schedule and deploy
