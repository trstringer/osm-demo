#!/bin/bash

wait_for_continue() {
    read -n 1 -s -r -p "Press any key to continue... "
    echo
}

demo_mtls () {
    clear
    echo "*** mTLS Demo ***"
    echo
    echo "  1. Create the resources"
    echo "    $ cd ~/dev/osm-demo && kubectl apply -f ./mtls-demo-resources.yaml"
    echo
    echo "  2. Observe the plaintext traffic from the bad actor"
    echo "    $ kubectl logs server tcpdump"
    echo
    echo "  3. Delete the resources"
    echo "    $ kubectl delete -f ./mtls-demo-resources.yaml"
    echo
    echo "  4. Add the namespace to the mesh"
    echo "    $ osm namespace add default"
    echo
    echo "  5. Create the resources"
    echo "    $ cd ~/dev/osm-demo && kubectl apply -f ./mtls-demo-resources.yaml"
    echo
    echo "  6. Observe the encrypted traffic from the bad actor"
    echo "    $ kubectl logs server tcpdump"

    wait_for_continue
}

echo "Starting OSM mTLS demo"

if [[ ! -d ~/dev/osm ]]; then
    echo "No OSM repo found at ~/dev/osm"
    exit 1
fi

kind create cluster
echo "Kind cluster up and ready..."
echo "Installing OSM..."
osm install \
    --set OpenServiceMesh.enablePermissiveTrafficPolicy=true \
    --set OpenServiceMesh.enableEgress=true

echo "About to wait"
wait_for_continue

demo_mtls

kind delete cluster

echo "Completed OSM demo"
