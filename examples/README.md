# Examples

* The examples assume a local repository is available at localhost:32000
  * If you are using the microk8s setup defined in this project, you are good to go, otherwise, you will want to make sure you have a local image repo running and accessible at localhost:32000, or you can manually edit the build.sh scripts to use the expected name.
* The deployment process leverages ansible to render templates before applying them.
* The values for the templates are provided by a yaml file defined in the local-dev folder.
* `deploy` contains the scripts for rendering and deploying the templates
* `docker` contains the Dockerfile(s) used by the example projects that provide the content to demonstrate something running in kubernetes
* `gradle` contains the gradle wrapper information
* `local-dev` contains the configuration yaml files used to render the templates
* `modules` contain the example deployments including: infrastructure templates and sample projects that can be deployed to kubernetes.
  * each deployable module has a `k8s/templates` directory which contains the necessary scripts and template files for deploying that module.
  * when deployed, the templates will be rendered using ansible into the `k8s/rendered` directory.
* `render` contains the ansible confugration and k8s scripts that render and apply the templates. 
* All the scripts, setup, deploy, build, teardown, etc..., should be run from this `examples` directory.  
* **You should start by deploying the infrastructure templates.**
  * `./deploy/setup.sh`
    * for more information on additional parameters for setup, please run: `./deploy/setup.sh ?`
    * after running, if you want to access anything from your LAN, ie outside of the host Windows OS, you will need to configure the port forwarding.
    * the infrastructure gateway, currently, exposes port 80 to be used by httproutes.
    * run `kubectl -n examples get gateway` to get the ip address for the gateway.
    * from a power shell terminal running as administrator on the host Windows OS, run `netsh interface portproxy add v4tov4 listenport=80 listenaddress=0.0.0.0 connectport=80 connectaddress=ip.add.re.ss`, replacing ip.add.re.ss with the ip address of the gateway
    * if you need to change the portforwarding for a particular port and have already set it before, you will want to delete the rule(s) for the port first.
      * `netsh interface portproxy delete v4tov4 listenport=80 listenaddress=0.0.0.0` 
  * see the readme in `modules/infrastructure` for more information.
* a build.sh script is provided for building the specific example projects and publishing an image, which is required for running them in kubernetes.
  * each module that compiles and/or packages source code into an image will have its own build.sh file as well.
  * please take a look at those scripts if you are more curious about how they are actually built, but not much explaination will be given since those are not the point of this project.
  * modules with only kubernetes templates will not have a build.sh script.
  * to build a specific module, from the `examples` directory, run `./build.sh <module-name>`
    * example: `./build.sh simpleApiServer`
* The kubernetes templates are defined in the modules `k8s/templates` folder.
* The rendered templates are created in the modules `k8s/rendered` folder.
* debug is enabled by default, so you can take a look at the rendered templates in the `rendered` folder(s)