# Generate a runtime image from an s2i build

## Usage OpenJDK 11

```
oc new-project <project-name>
oc process -p S2I_APP=openjdk-11-s2i-app \
           -p NAMESPACE=<project-name> \
           -p APP_NAME=openjdk-11-runtime-app \
           -f openjdk_runtime_app_template_full.yaml | oc create -f -
```

Then wait until `bc/openjdk-11-runtime-app` builds and deploys.

Check with:

```
$ url="$(echo http://$(oc get route openjdk-11-runtime-app --template '{{.spec.host}}'))"
$ curl $url
Hello World
```

## Usage OpenJDK 8

```
oc new-project <project-name>
oc process -p S2I_APP=openjdk-8-s2i-app \
           -p NAMESPACE=<project-name> \
           -p APP_NAME=openjdk-8-runtime-app \
           -p OPENJDK_VERSION=8 \
           -p OPENJDK_PKG_NAME=java-1.8.0-openjdk \
           -f openjdk_runtime_app_template_full.yaml | oc create -f -
```

Then wait until `bc/openjdk-8-runtime-app` builds and deploys.

Check with:

```
$ url="$(echo http://$(oc get route openjdk-8-runtime-app --template '{{.spec.host}}'))"
$ curl $url
Hello World
```
