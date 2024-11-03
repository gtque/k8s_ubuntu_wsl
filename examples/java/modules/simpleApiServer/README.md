# Simple Api Server

This is a simple api server built using Java, Spring Boot, and Gradle and is targeted to Java 17.

The server is "protected" using basic auth. The default username and password are `test` and `password`

## The deployment
* `00_namespace`
* `01_clusterrole`
* `01_clusterrolebinding`
* `01_serviceaccount`
* `04_httproute`
* `08_service`
* `09_configmap`
* `10_deployment`

## Building
You can import the k8s_ubuntu_wsl project into an ide, such as Intellij Idea and build from there.

Or you can build directly from the command line in your wsl instance. Which is recommended, since that is kind of the point of this example.
* cd to the `examples` directory
  * if you followed the steps in this guide, you can do: `cd /usr/local/bin/k8s_ubuntu_wsl/examples`
* run `./build.sh simpleApiServer`
  * this will publish an image to `localhost:32000` if you have another accessible repo you wish to deploy to, please update the simpleAPiServer/build.sh script to the appropriate repo
    
## Deploying
* cd to the `examples` directory
  * if you followed the steps in this guide, you can do: `cd /usr/local/bin/k8s_ubuntu_wsl/examples`
* run `./deploy/setup.sh --module simpleApiServer`
  * `config-examples.yml` is the default `config`
  * you can override the config if you have defined them.
    * `./deploy/setup.sh --module simpleApiServer --config local-dev/config-someotherconfig.yml`
  
## Accessing
1. open the `C:\Windows\System32\drivers\etc\hosts` file for editing
   1. open it in your editor of choice, but you will need to edit it as an administrator
1. add line to provide a route to `simpleapiserver.local`
   1. If you want to test "lan access" i suggest just setting the IP address to your host Windows OS ip address for which ever network is active, usually the wifi adapter.
   1. If you don't care to test lan access, just set it to the loopback address `127.0.0.1`
   1. If you didn't already do it, please see the README.md in the `examples` directory under `You should start by deploying the infrastructure templates.`
1. open a browser and navigate to one of the following:
   1. to the hello/world endpoint: http://simpleapiserver.local/hello/world
   1. to the swagger page: http://simpleapiserver.local/swagger-ui/index.html#/
      1. this is the rendered swagger/openapi doc and is a convenient place to see and try all available apis on the server.
1. the username/password is: `test/password`
   1. the server uses basic auth.