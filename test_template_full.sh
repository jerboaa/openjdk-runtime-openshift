#!/bin/bash
#
# Build an OpenJDK runtime container from an s2i-built image
#
set -e

project="$PROJECT"
s2i_name="$S2I_NAME"
runtime_app_name="$RUNTIME_APP"
version=${VERSION:-11}
pkg=${PKG:-java-11-openjdk}

usage() {
  echo "usage: PROJECT=foo S2I_NAME=openjdk11-s2i RUNTIME_APP=openjdk11-run-app ./$0"
  exit 1
}

if [ -z $project ] || [ -z $s2i_name ] || [ -z $runtime_app_name ] || [ -z $version ] || [ -z $pkg ]; then
 usage
fi

oc new-project $project
oc process -p S2I_APP=$s2i_name -p NAMESPACE=$project -p APP_NAME=$runtime_app_name -p OPENJDK_VERSION=$version -p OPENJDK_PKG_NAME=$pkg -f openjdk_runtime_app_template_full.yaml | oc create -f -
url="$(echo http://$(oc get route $runtime_app_name --template '{{.spec.host}}'))"
output="$(curl -s $url)"
expected="Hello World"
maxtries=240
echo -n "Waiting for runtime app: $runtime_app_name to become available: "
while test "${output}_" != "Hello World_" && test $maxtries -gt 0; do
  echo -n "."
  sleep 1	
  output="$(curl -s $url)"
  maxtries=$(( $maxtries - 1 ))
done
echo -e '\n'
if [ $maxtries -eq 0 ]; then
  echo "Deploying $runtime_app_name timed out."
  exit 1
else
  echo "$runtime_app_name deployed at: $url"
fi
