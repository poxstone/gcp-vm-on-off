import os
import ast
import base64
from pprint import pprint

from googleapiclient import discovery
from oauth2client.client import GoogleCredentials

PROJECT_ID = os.environ['GCP_PROJECT']

def vm_start_stop(event, context=None):
    credentials = GoogleCredentials.get_application_default()
    # default data
    data = {
        "on_off": "on", # set on or off
        "instances": [
            {"name":"my-vm", "zone":"us-east1-b"}
        ]}

    try:
        data_str = base64.b64decode(event['data']).decode('utf-8')
        data = ast.literal_eval(data_str)
        pprint(data)
    except Exception as e:
        pprint(str(e))
    
    service = discovery.build('compute', 'v1', credentials=credentials)
    for instance in data['instances']:
        try:
            if data['on_off'] == 'on':
                vm_request = service.instances().start(project=PROJECT_ID, zone=instance['zone'], instance=instance['name'])
            elif data['on_off'] == 'off':
                vm_request = service.instances().stop(project=PROJECT_ID, zone=instance['zone'], instance=instance['name'])
            pprint('status: {} = {}'.format(instance, data['on_off']))
            response = vm_request.execute()
        except Exception as e:
            pprint('error with: {} = {} - {}'.format(instance, data['on_off'], str(e)))

    return 'ok'
