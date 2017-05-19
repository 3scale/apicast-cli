# {{ path }}

Welcome to new project using [APIcast-cli](https://github.com/3scale/apicast-cli).

## Usage

You can start the server:

```shell
apicast-cli start -e development
```

## Deployment

Build process uses s2i to package docker image.

```shell
s2i build . {{ s2i.builder_image }}  {{path}}-app
```

You can deploy app to OpenShift by running:

```shell
oc new-app {{ s2i.builder_image }}~https://github.com/[yourname]/{{path}}.git
```
