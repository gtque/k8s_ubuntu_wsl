# Examples

* The examples assume a local repository is available at localhost:32000
  * If you are using the microk8s setup defined in this project, you are good to go, otherwise, you will want to make sure you have a local image repo running and accessible at localhost:32000, or you can manually edit the build.sh scripts to use the expected name.
* The deployment process leverages ansible to render templates before applying them.
* The values for the templates are provided by a yaml file defined in the local-dev folder.
* `config/local-dev` contains the configuration yaml files used to render the templates
* `deploy` contains the scripts for rendering and deploying the templates
  * `render` contains the ansible configuration and k8s scripts that render and apply the templates.
* the rest of the folders are language "types", such as java, k8s, go (not yet implemented), etc...
  * under each language there should be a folder called `modules`. This contains the actual example code and files.
  * each deployable module under `modules` has a `k8s/templates` directory which contains the necessary scripts and template files for deploying that module.
  * when deployed, the templates will be rendered using ansible into the `k8s/rendered` directory.
* `java` contains java based application examples
  * `docker` contains the Dockerfile(s) used by the example projects that provide the content to demonstrate something running in kubernetes
  * `gradle` contains the gradle wrapper information
  * `modules` contain the example deployments including: infrastructure templates and sample projects that can be deployed to kubernetes.
* `k8s`
  * `modules` contains kubernetes only templates that do not require any source code to be built and can be deployed directly.
* All the scripts, setup, deploy, build, teardown, etc..., should be run from this `examples` directory.
  * `./build.sh` is a highlevel build script wrapper that invokes the example language's build script. For more information on a language's build process, please look for a README file in that language's directory.
    * to build an example module other than the default simpleApiServer, you should specify `--language [language]` and `--module [name]`
    * for additional options/parameters run: `./build.sh ?`
  * `./setup.sh` deploys the specified example language module.
    * to setup, aka deploy, an example module other than the default infrastructure you should specify `--language [language]` and `--module [name]`
    * example: `./setup.sh --language java --module simpleApiServer`
    * for additional options/parameters run: `./setup.sh ?`
  * `./teardown.sh` tears down, aka undeploys, the specified example language module.
    * to tear down an example module other than the default infrastructure you should specify `--language [language]` and `--module [name]`
    * example: `./teardown.sh --language java --module simpleApiServer`
    * for additional options/parameters run: `./teardown.sh ?`
* **You should start by deploying the infrastructure templates.**
  * `./setup.sh`
    * for more information on additional parameters for setup, please run: `./deploy/setup.sh ?`
    * after running, if you want to access anything from your LAN, ie outside of the host Windows OS, you will need to configure the port forwarding.
    * the infrastructure gateway, currently, exposes port 80 to be used by httproutes.
    * run `kubectl -n examples get gateway` to get the ip address for the gateway.
    * from a power shell terminal running as administrator on the host Windows OS, run `netsh interface portproxy add v4tov4 listenport=80 listenaddress=0.0.0.0 connectport=80 connectaddress=ip.add.re.ss`, replacing ip.add.re.ss with the ip address of the gateway
    * if you need to change the portforwarding for a particular port and have already set it before, you will want to delete the rule(s) for the port first.
      * `netsh interface portproxy delete v4tov4 listenport=80 listenaddress=0.0.0.0` 
  * see the readme in `modules/infrastructure` for more information.
* **REMINDER: _The kubernetes templates are defined in the module's `k8s/templates` folder._**
* **REMINDER: _The rendered templates are created in the module's `k8s/rendered` folder._**
* **debug is enabled by default, so you can take a look at the rendered templates in the `rendered` folder(s)**