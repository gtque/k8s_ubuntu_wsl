# Infrastructure

This requires/expects a local nfs directory named the same as `app.nfs.path` from the config yml file.
You can run `/usr/local/bin/k8s_ubuntu_wsl/ubuntu/nfs/setup.sh <app.nfs.path>` to create the necessary nfs directory.

Example: `/usr/local/bin/k8s_ubuntu_wsl/ubuntu/nfs/setup.sh examples`

## Defines some basic infrastructure pieces:
* `00_namespace` defines the namespace. The examples are all defined to end up in this namespace
  * `app.infrastructure.name` a name for the "app", used for the namespace and to modify the name of other objects.
* `01_rbac_nfs` defines the rbac needed for using nfs in the cluster.
  * `app.infrastructure.name` used to define the namespace for the rbac objects
* `02_deployment_nfs` defines the deployment for the nfs provisioner.
  * `app.infrastructure.name` used to define the namespace for the provisioner
  * `app.nfs.name` is used to give the provisioner a name
  * `app.nfs.path` the path the root nfs directory
* `02_gateway_http` defines an initial gateway with support for http routing.
  * `app.infrastructure.name` defines the name of the gateway object and the namespace
  * assumes a gateway provisioner is deployed
  * assumes the gateway provisioner deployed is contour
* `03_storageclass_root`
  * `app.infrastructure.name` used to uniquify the name of the storage class and identify the provisioner.
    * the provisioner value needs to match the value of `PROVISIONER_NAME` from the provisioner deployment you expect to use.
* `03_storageclass_specific`
  * `app.infrastructure.name` used to uniquify the name of the storage class and identify the provisioner.
    * the provisioner value needs to match the value of `PROVISIONER_NAME` from the provisioner deployment you expect to use.
  * the specific path is controlled by using values from the PVC object
    * `.PVC.namespace` is the namespace for the PVC
    * `.PVC.label.examples.io/nfs` is a custom label "examples.io/nfs" that is expected to be on the PVC
  
## Deploying the infrastructure pieces
* make sure the expected nfs exists
  * run `/usr/local/bin/k8s_ubuntu_wsl/ubuntu/nfs/setup.sh <app.nfs.path>`
    * example `/usr/local/bin/k8s_ubuntu_wsl/ubuntu/nfs/setup.sh examples`
* run `./deploy/setup.sh`
  * `modules/infrastructure` is the default `module`
  * `config-examples.yml` is the default `config`
  * you can override the module and config if you have defined them.
    * `./deploy/setup.sh --module someothermodule --config local-dev/config-someotherconfig.yml`
* run `kubectl -n examples get gateway` to get the ip address for the gateway.
* run `netsh interface portproxy add v4tov4 listenport=80 listenaddress=0.0.0.0 connectport=80 connectaddress=ip.add.re.ss`, replacing ip.add.re.ss with the ip address of the gateway
* if you need to change the portforwarding for a particular port and have already set it before, you will want to delete the rule(s) for the port first.
  * `netsh interface portproxy delete v4tov4 listenport=80 listenaddress=0.0.0.0` 
  
