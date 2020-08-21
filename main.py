import os
import ast
import base64
from pprint import pprint

from googleapiclient import discovery
from oauth2client.client import GoogleCredentials


pprint('TOOL VERSION: 1.0')

ON_OFF = "on_off"
GCE = 'gce'
GKE = 'gke'
SQL = 'sql'
ON = 'on'
OFF = 'off'
ALL = '*'

PROJECT_ID = os.environ['GCP_PROJECT']


def gce_onoff(service, instance, on_off):
    try:
        if on_off == ON:
            vm_request = service.instances().start(project=PROJECT_ID,
                         zone=instance['zone'], instance=instance['name'])
        elif on_off == OFF:
            vm_request = service.instances().stop(project=PROJECT_ID,
                         zone=instance['zone'], instance=instance['name'])
        pprint('{} status: {} = {}'.format(GCE, instance, on_off))
        response = vm_request.execute()
    except Exception as e:
        pprint('{} error: {} = {} - {}'.format(GCE, instance, on_off, str(e)))


def sql_onoff(service, instance, on_off):
    if on_off == OFF:
        policy = 'NEVER'
    else:
        policy = 'ALWAYS'

    body = {"settings": {"activationPolicy": policy}}
    try:
        vm_request = service.instances().patch(project=PROJECT_ID,
                                               instance=instance['name'],
                                               body=body)
        pprint('{} status: {} = {}'.format(SQL, instance, on_off))
        response = vm_request.execute()
    except Exception as e:
        pprint('{} error: {} = {} - {}'.format(SQL, instance, on_off, str(e)))


def vm_start_stop(event, context=None):
    credentials = GoogleCredentials.get_application_default()
    # default data
    data = {
        ON_OFF: "on", # set on or off
        GCE: [
            #{"name":"my-vm", "zone":"us-east1-b"}
        ],
        SQL: [
            #{"name":"my-vm"}
        ],
        GKE: [
            #{"name":"my-vm", "zone":"us-east1-b"}
        ]}

    try:
        data_str = base64.b64decode(event['data']).decode('utf-8')
        data = ast.literal_eval(data_str)
        pprint(data)
    except Exception as e:
        pprint(str(e))
    
    on_off = data[ON_OFF].lower()
    
    # GCE instances
    if GCE in data and data[GCE]:
        pprint('init {}'.format(GCE))
        service = discovery.build('compute', 'v1', credentials=credentials)
        for instance in data[GCE]:
            # shutdown instance list
            if instance['name'] == ALL:
                instances_list = []
                try:
                    instances_list = service.instances().list(
                                    project=PROJECT_ID, zone=instance["zone"]
                                    ).execute()['items']
                except Exception as e:
                    pprint(e)
                    continue

                for instance_found in instances_list:
                    instance_status = instance_found['status']
                    if instance_status in ['TERMINATED', 'STOPPING',
                        'SUSPENDING'] and on_off == OFF:
                        continue
                    elif instance_status in ['RUNNING', 'STAGING'] and \
                        on_off == ON:
                        continue

                    instance_data = {"name": instance_found["name"],
                                    "zone": instance["zone"]}
                    gce_onoff(service=service, instance=instance_data,
                              on_off=on_off)

            else:
                gce_onoff(service=service, instance=instance, on_off=on_off)
    
    # Cloud SQL
    if SQL in data and data[SQL]:
        pprint('init {}'.format(SQL))
        service = discovery.build('sql', 'v1beta4', credentials=credentials)
        for instance in data[SQL]:
            if instance['name'] == ALL:
                instances_list = []
                try:
                    instances_list = service.instances().list(project=PROJECT_ID
                                            ).execute()['items']
                    
                except Exception as e:
                    pprint(e)
                    continue
                for instance_found in instances_list:
                    instance_status = instance_found['settings'][
                                                            'activationPolicy']
                    # status: STOPPED RUNNABLE PENDING PENDING_CREATE
                    if instance_status in ['NEVER'] and on_off == OFF:
                        continue
                    elif instance_status in ['ALWAYS'] and \
                        on_off == ON:
                        continue

                    instance_data = {"name": instance_found["name"]}
                    sql_onoff(service=service, instance=instance_data,
                              on_off=on_off)
            else:
                sql_onoff(service=service, instance=instance, on_off=on_off)
    
    # Cloud GKE
    if GKE in data and data[GKE]:
        pprint('init {}'.format(GKE))

    return 'ok'
