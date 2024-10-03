# k8s_ubuntu_wsl
Steps and scripts for running a single node kubernetes cluster using microk8s on Ubuntu running on WSL2 in Windows.


Any and all of the tools, applications, and software installed by this process assume you have the rights and or license to them.
This walk through and accompanying scripts are provided as is without warranty or promise.

I may or may not update this walkthrough and scripts, but it likely won't be often.

Pay attention to the steps, some require you editing the files before running or applying them for your particular usecase.

If you have any issues running the scripts:
* make sure the line endings are lf and not crlf
* check the permissions and try to chmod them
* try running use `sh <cmd>`

Good Luck.

## Steps
1. Clone this project
1. Enable WSL
1. Install an Ubuntu image (tested with 18.04, 20.04, and 22.04, 24.04)
1. install helpful utilities (git, docker, jq, yq, ansible, etc...)
1. Configure WSL
1. install microk8s
1. configure minimum microk8s things
1. install kubectl and helm, best to do them after the cluster is up and running.
1. configure any needed objects (gateway, cert-manager, etc...)
1. install some other fun infrastructure pieces: elasticsearch, postgres, couchdb, (oracle), etc...
1. build and deploy your project(s)

## install/enable WSL2
1. Follow the manual installation steps: https://docs.microsoft.com/en-us/windows/wsl/install-win10#manual-installation-steps

### install a (Ubuntu) linux image (if `wsl --install` didn't install one for you)
1. Install a linux image from the Windows Store, this assumes you are using ubuntu.
   1. actually open ubuntu once installed
   1. when prompted for username/password, use your username, you do not need to use the same host login password, this is not sync'ed to the host OS so set it to something easy for you remember
   1. **IF YOU WISH TO MOVE THE DISTRO TO A DIFFERENT DRIVE I SUGGEST YOU DO IT NOW**
       1. create a wsl\backups directory on the desired drive (it can be any name you want, but this is what I will use for the rest of the steps)
       1. open powershell
       1. stop wsl: `wsl --shutdown`
       1. list the distros: `wsl --list`
       1. export the distro you want to move, example: `wsl --export Ubuntu-24.04 D:\wsl\backups\ubuntu-24.04.tar`
       1. unregister the distro to delete it from the original location: `wsl --unregister Ubuntu-24.04`
       1. import it from the new location: `wsl --import Ubuntu-24.04 D:\wsl\distros\ubuntu-24.04 D:\wsl\backups\ubuntu-24.04.tar`
       1. reset default user if need be:   
          ```
          cd %userprofile%\AppData\Local\Microsoft\WindowsApps            **(this is not needed if in path)**
          ubuntu2404.exe config --default-user yourloginname`
          ```
      1. Launch/re-open the distro
3. Create a symbolic link to this project in the `/usr/local/bin` called k8s_ubuntu_wsl
   1. make sure to replace `[path/to/cloned]` with the path to where ever you cloned this project
   ```
   sudo ln -s /mnt/c/[path/to/cloned]/k8s_ubuntu_wsl /usr/local/bin/k8s_ubuntu_wsl
   ```
4. Edit the sudoers to remove the password request
    ```
   sudo visudo
   ```
   1. edit the sudo All line to look like the following:
       ```
        %sudo   ALL=(ALL:ALL) NOPASSWD: ALL
       ```
   1. press `ctrl+o` to save and then enter to actually save, then `ctrl+x` to exit, if prompted press `y` to save
5. To save some grief:
   1. create symbolic links to your maven, gradle, aws and any other local configurations in the home directory of the user in use in the linux image installed.
      ```
      sudo ln -s /mnt/c/Users/<username>/.m2 ~/.m2
      sudo ln -s /mnt/c/Users/<username>/.gradle ~/.gradle
      sudo ln -s /mnt/c/Users/<username>/.aws ~/.aws
      ```
6. I suggest creating a symbolic link in your `~` to your directory on your /mnt/c drive where you check out projects...
   1. sudo ln -s /mnt/c/<path-to-git-checkout-folder> ~/code
7. wsl hack for vpn client(s) 
   1. from power shell run: ipconfig /all 
   2. look for the entry for the VPN Client 
   3. copy the dns servers' ip addresses (may be 2)
   4. in your linux (aka ubuntu) instance in wsl edit /etc/resolv.conf  and add the dns server ip addresses to the top of the list.
      1. should be something like:
      ```
      nameserver XX.XXX.X.X
      nameserver XX.XXX.X.X
      ```
   5. edit /etc/wsl.conf and set `generateResolvConf = false`
      ```
      sudo vi /etc/wsl.conf
      press i
      edit the generateResolvConf line and set it to false
      press shift+:
      press wq
      press enter to save and close
      ```
8. close the terminal session and start a new one
## Setting up the required and helpful utilities
1. run `/usr/local/bin/k8s_ubuntu_wsl/tools/tool_config.sh`
   1. this installs: maven, net-tools, ansible, jq, yq, unzip, libjson-xs-perl, libxml-compile-perl, unzip, awscliv2
2. **Close the session and restart WSL.**
   1. close the terminal session
   2. run powershell as admin from host os
   3. run: `wsl --shutdown`
   4. open new Ubuntu/linux terminal
3. open a new terminal session to continue.
4. run docker install
   1. On ubuntu 18 or 20: `/usr/local/bin/k8s_ubuntu_wsl/tools/docker_install.sh`
   1. On ubuntu 22 or 24: `/usr/local/bin/k8s_ubuntu_wsl/tools/docker_install_jammy.sh`
   1. **Close the session and restart WSL.**
      1. close the terminal session
      2. run powershell as admin from host os
      3. run: `wsl --shutdown`
      4. open new Ubuntu/linux terminal
   1. this will also install: apt-transport-https, ca-certificates, curl, software-properties-common
   1. enable buildkit
      1. you may have to sudo mkdir /etc/docker 
      2. edit /etc/docker/daemon.json and add: { "features": { "buildkit": true } }
         1. sudo vi /etc/docker/daemon.json
      3. https://docs.docker.com/develop/develop-images/build_enhancements/
5. **Close the session and restart WSL.**
   1. close the terminal session
   2. run powershell as admin from host os
   3. run: `wsl --shutdown`
   4. open new Ubuntu/linux terminal
## DEPRECATED: daemonize setup
<details>

# DO NOT DO THE FOLLOWING STEPS
# THEY ARE NO LONGER NECESSARY 
# PLEASE PROCEED TO CONFIGURE wsl.conf
wsl2 now supports enabling systemd in the wsl.conf.

the scripts for manually setting up systemd have been moved tp microk8s/deprecated for historical purposes but should not be used.

The following information is from:
* https://wsl.dev/wsl2-microk8s/
* https://forum.snapcraft.io/t/running-snaps-on-wsl2-insiders-only-for-now/13033
1. Launch your WSL 2 instance (Tested with Ubuntu 20.04 LTS)
2. install daemonize
    ```  
    sudo apt-get install -y daemonize
    ```
3. run `/usr/local/bin/k8s_ubuntu_wsl/microk8s/systemd_config.sh`
4. **exit and restart system (close the terminal window, open powershell and run wsl --shutdown)**
5. run `/usr/local/bin/k8s_ubuntu_wsl/microk8s/systemd_resolved.sh`
6. You are now ready to start setting up microk8s

</details>

## Configuring wsl.conf
some default wsl configurations, includes enabling systemd. If you are on a vpn, after this is run, you will want to edit
the wsl.conf file and configure the nameservers as described above under `wsl hack for vpn client(s)`

for more information see:
* https://learn.microsoft.com/en-us/windows/wsl/wsl-config
* https://learn.microsoft.com/en-us/windows/wsl/systemd

**Note: the following is not needed if you are using latest wsl2, as systemd can be enabled by default, if not, please do follow the steps to enable it.**
1. add my default wsl.conf configuration by running: `usr/local/bin/k8s_ubuntu_wsl/wsl/wsl_config.sh`
2. **exit and restart system (close the terminal window, open powershell and run wsl --shutdown)**
## install microk8s
1. install microk8s by running: `/usr/local/bin/k8s_ubuntu_wsl/microk8s/microk8s_setup.sh`
2. **Close/exit this session and start a new one (close the window/terminal)**
3. Run the status command (you may have to wait and try a few times while microk8s starts up)
    ```
   microk8s status
   ```
   1. you should see something like:
        ```
        microk8s is running
        addons:
        cilium: disabled
        linkerd: disabled
        jaeger: disabled
        rbac: disabled
        prometheus: disabled
        dns: enabled
        fluentd: disabled
        storage: disabled
        gpu: disabled
        registry: disabled
        knative: disabled
        dashboard: disabled
        ingress: disabled
        metrics-server: disabled
        istio: disabled
        ```
4. Let's enable the DNS, storage, and registry
   ```
   microk8s enable dns storage registry
   ```
   1. You may choose to also add `ingress` to the list to enable microk8s' built ingress, but I strongly recommend using a gateway instead. 
   1. ingress used by microk8s is nginx, to use ha-proxy, please see steps below on deploying ha proxy to the cluster.
   1. gateway instructions are below under `Configure any needed objects`
5. adding a loadbalancer
    1. if on microk8s >= 1.17 you can also enable metallb, otherwise we have to manually install it.
        ```
        microk8s enable metallb
        ```
       1. use this an the ip address range based on your local eth range: 
          1. example on windows running wsl run powershell as admin and run: ipconfig /all
          2. look for the entry for WSL should look like:
          ```
          Ethernet adapter vEthernet (WSL):
          Connection-specific DNS Suffix  . :
          Description . . . . . . . . . . . : Hyper-V Virtual Ethernet Adapter
          Physical Address. . . . . . . . . : 00-15-5D-DD-1D-1B
          DHCP Enabled. . . . . . . . . . . : No
          Autoconfiguration Enabled . . . . : Yes
          Link-local IPv6 Address . . . . . : fe80::4046:191e:f5dd:39b9%48(Preferred)
          IPv4 Address. . . . . . . . . . . : 172.21.16.1(Preferred)
          Subnet Mask . . . . . . . . . . . : 255.255.240.0
          Default Gateway . . . . . . . . . :
          DHCPv6 IAID . . . . . . . . . . . : 805311837
          DHCPv6 Client DUID. . . . . . . . : 00-01-00-01-27-E7-35-51-18-CC-18-A5-3F-B6
          DNS Servers . . . . . . . . . . . : fec0:0:0:ffff::1%1
          fec0:0:0:ffff::2%1
          fec0:0:0:ffff::3%1
          NetBIOS over Tcpip. . . . . . . . : Enabled
          ```
          3. so set the range to something like: 172.21.16.175-172.21.16.225
6. microk8s is up, running, and configured.
7. Setup local kubeconfig: run `/usr/local/bin/k8s_ubuntu_wsl/microk8s/microk8s_kubeconfig.sh`
    1. this edits the ~/.bashrc file so that `microk8s config > ~/.kube/config` is run everytime to make sure it is up to date. 
8. **Close and restart the session**
9. Continue with installing `Kubectl and Helm`.
## Kubectl and Helm and nfs
1. for ubuntu 18, 20, and 22 run `/usr/local/bin/k8s_ubuntu_wsl/tools/kubectl_and_helm.sh`
2. for ubuntu 24 run `/usr/local/bin/k8s_ubuntu_wsl/tools/kubectl_and_helm_jammy.sh`
3. setup nfs run: `/usr/local/bin/k8s_ubuntu_wsl/ubuntu/nfs/setup.sh`
## configure any needed objects
A few extra services need to be running in the kubernetes cluster to be more useful: cert-manager, kubernetes-replicator, secrets, ingress if not using the one provided by microk8s
1. run `/usr/local/bin/k8s_ubuntu_wsl/infrastructure/setup.sh`
   1. this does not install ingress, see the ingress section below if you want to use ha proxy instead of the nginx ingress provided by microk8s
   2. You may want to double-check the version first and check for a newer version. Be careful though, and test it thoroughly before committing a change to the `k8s_setup.sh` updating the cert-manager version.
2. install contour gateway
   1. run `/usr/local/bin/k8s_ubuntu_wsl/infrastructure/optional/contour/setup.sh`
   2. This is under optional, because while I strongly encourage moving to using a gateway instead of ingress,
   it is up to you to decide which implementation you want to use, this is just what I have been using and is what the examples are using,
   but setup for nginx-gateway are also provided if you want to go down that path.
3. install ha-proxy if you must and if you aren't using the provide nginx ingress from microk8s, just know that it is strongly encouraged to use a gateway instead.
   <details>
   
   1. you are on your own, but I would suggest checking out their website and using helm if possible.
   2. coredns hosts override is recommended if using ha-proxy:
      2. kubectl -n kube-system edit cm coredns -o yaml
      3. inside:
       ```
      data:
        Corefile: |
          .:53 {
       ```
      add: (the ip should be changed to whatever the IP address of ha-proxy ends up being, hopefully this doesn't change when restarted, but on windows, wsl does not use static ips so...)
       ```
      hosts /etc/coredns/customdomains.db somehost.com {
      172.21.18.223 local.somehost.com
      172.21.18.223 another.somehost.com
      fallthrough
      }
       ```
      4. delete the coredns pod
         1. kubectl -n kube-system get pod
         2. kubectl -n kube-system delete pod <coredns-pod-name>
      5. you will also want to edit the hosts file on the host os (ubuntu if running on windows wls) to add the host list as well.
         1. sudo vi /etc/hosts
         2. add:
         ```
         172.21.18.223 local.somehost.com
         172.21.18.223 another.somehost.com
         ```
   </details>

#### Certificates
There are no certs installed by the preceding steps. 
There are several options for certs. 
The easiest to get started with will be the self signed certs.
but first:
1. run `/usr/local/bin/k8s_ubuntu_wsl/infrastructure/certs/setup.sh`
###### SelfSigned
The certs are defined for `*.local.dev` and `*.sso.local.dev`. Edit this if you want to use a different base url.
1. `/usr/local/bin/k8s_ubuntu_wsl/infrastructure/certs/selfsigned/setup.sh`
###### External
This installs external secret manager.
The `setup.sh` is templated for ca-certs in aws secrets, you will need to modify it to work with your secret(s)
1. `/usr/local/bin/k8s_ubuntu_wsl/infrastructure/certs/external/install.sh`
1. edit `setup.sh` for your ca-certs
1. `/usr/local/bin/k8s_ubuntu_wsl/infrastructure/certs/external/setup.sh`
###### LetsEncrypt
While it is possible to use the letsencrypt production server to generate actual valid certificates, there are rate limits for certificate requests.
They do provide an acme tool for testing and development that I am looking into to see if it can be used for this process.
In either case, use the following at your own risk and only if you own the domains you are generating certs for.
This is templated to use route53 to verify ownership of the domain.
1. edit `/usr/local/bin/k8s_ubuntu_wsl/infrastructure/certs/letsencrypt/k8s/00_cert_secret.yml`
  1. add your aws account access key
1. edit `/usr/local/bin/k8s_ubuntu_wsl/infrastructure/certs/letsencrypt/k8s/01_cert_issuer.yml`
  1. add your email
  1. set the access key
  1. set the zone id
  1. set the region
1. edit `/usr/local/bin/k8s_ubuntu_wsl/infrastructure/certs/letsencrypt/k8s/02_cert_manager.yml`
  1. set [your.domain] to a domain you control
1. `/usr/local/bin/k8s_ubuntu_wsl/infrastructure/certs/letsencrypt/setup.sh`

## Optional
Under `k8s_ubuntu_wsl/infrastructure` is a folder called `optional` this contains some third party services you may want running.
So far this includes: elasticsearch, oracle (not tested completely), and postgresql

##### microk8s information
1. To restart microk8s if your host system is stopped or wsl2 is restarted:
    ```
    microk8s start
    ```
1. To use locally built and published images:
    1. in the docker build command set tag like below: (where <service-name> is the service you are building)
        ```
        --tag localhost:32000/<imagename>:<tag>
        ```
    1. push the image to the local microk8s repository:
        ```
        docker push docker push localhost:32000/<imagename>:<tag>
        ```
1. to refresh (only do this if you are ready to upgrade your cluster)
   1. Refresh the Microk8s snap by selecting the channel "1.19/stable"
   ```
   sudo snap refresh microk8s --channel="1.19/stable"
   ```
1. If WSL is restarted (either windows was restarted or you used the wsl --shutdown command), 
   on the first launch you may notice an error about microk8s. 
   This is because microk8s hasn't started up quickly enough and setting up the kubeconfig failed.
   Just close the session and open a new one and you should be good to go.

###### for more information on microk8s:
* https://microk8s.io/docs/commands
* https://microk8s.io/docs/registry-built-in
* https://microk8s.io/docs/registry-private
