# Schedule vm start off

1. Cloud pub*/sub
  - push
  - message (edit instances and on or off):
    ```json
    {
        "on_off": "off", 
        "instances": [
            {"name":"centos-7kvm", "zone":"us-east1-b"},
            {"name":"centos-7kvm-1", "zone":"us-east1-b"},
            {"name":"centos-7kvm-2", "zone":"us-east1-b"},
            {"name":"centos-7kvm-3", "zone":"us-east1-b"},
            {"name":"centos-7kvm-4", "zone":"us-east1-b"},
            {"name":"centos-7kvm-5", "zone":"us-east1-b"},
            {"name":"centos-7kvm-6", "zone":"us-east1-b"},
            {"name":"centos-7kvm-7", "zone":"us-east1-b"},
            {"name":"centos-7kvm-8", "zone":"us-east1-b"}
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
