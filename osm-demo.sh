#!/bin/bash

wait_for_continue() {
    read -n 1 -s -r -p "Press any key to continue... "
    echo
}

demo_access_policy () {
    clear
    echo "*** Access policy demo ***"
    echo
    echo "  1. Forward ports - open new terminal and run:"
    echo "    $ cd ~/dev/osm && ./scripts/port-forward-all.sh"
    echo
    echo "  2. Run bookwatcher - open new terminal and run:"
    echo "    $ cd ~/dev/osm && make build-bookwatcher && ./demo/bin/bookwatcher/bookwatcher"
    echo
    echo "  3. View the TrafficTarget defining the access policy:"
    echo "    $ kubectl get traffictarget -n bookstore bookbuyer-access-bookstore-v1 -o yaml | vim -"
    echo
    echo "  4. Observe the following:"
    echo "    - bookthief fails to access any bookstore services"
    echo "    - bookbuyer succeeds to buy books"
    echo

    wait_for_continue

    echo
    echo "  5. Modify the bookstore TrafficTarget to allow bookthief:"
    echo "    $ kubectl edit tt -n bookstore bookbuyer-access-bookstore-v1"
    echo "    Add:"
    echo "      - kind: ServiceAccount"
    echo "        name: bookthief"
    echo "        namespace: bookthief"
    echo
    echo "  6. Observe the following:"
    echo "    - bookthief can now access the bookstore and steal books"
    echo
    echo "  7. Remove the bookthief from the TrafficTarget and observe"
    echo
}

demo_traffic_shifting () {
    clear
    echo "*** Traffic shifting demo ***"
    echo
    echo "  1. Forward ports - open new terminal and run:"
    echo "    $ cd ~/dev/osm && ./scripts/port-forward-all.sh"
    echo
    echo "  2. Run bookwatcher - open new terminal and run:"
    echo "    $ cd ~/dev/osm && make build-bookwatcher && ./demo/bin/bookwatcher/bookwatcher"
    echo
    echo "  3. View the current TrafficSplit:"
    echo "    $ kubectl get ts -n bookstore bookstore-split -o yaml | vim -"
    echo
    echo "  4. Observe the following:"
    echo "    - The 50/50 traffic split between bookstore V1 and V2"
    echo

    wait_for_continue

    echo "  5. Modify the TrafficSplit to make it all for V2"
    echo "    $ kubectl edit ts -n bookstore bookstore-split"
    echo
    echo "  6. Observe the following:"
    echo "    - All traffic is now going to V2"
    echo

    wait_for_continue
}

echo "Starting OSM demo"

if [[ ! -d ~/dev/osm ]]; then
    echo "No OSM repo found at ~/dev/osm"
    exit 1
fi

# Initialization
CWD=$(pwd)
cd ~/dev/osm || exit 1

if [[ -z "$DEMO_KEEP_CLUSTER" ]]; then
    CURRENT_CLUSTER=$(kind get clusters)
    if [[ -n "$CURRENT_CLUSTER" ]]; then
        kind delete cluster --name "$CURRENT_CLUSTER"
    fi
    CI=true make kind-demo
fi

wait_for_continue

demo_access_policy
wait_for_continue

demo_traffic_shifting

cd "$CWD" || exit 1
echo "Completed OSM demo"
