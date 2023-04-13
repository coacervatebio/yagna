# Yagna Helm Chart

Fairly rigid working implementation as part of a larger project - may not work out of the box for a particular use-case. Feel free to submit a PR!

## Installation Instructions
- (Make sure Helm and Kubectl are installed before continuing)
- git clone https://github.com/coacervatebio/yagna.git
- cd yagna/chart
- helm install my-release . -f values.yaml

## Configuration

### Persistent Storage
- see `values.yaml` comments for options
- leaving as is will use your default StorageClass (if configured)
- can set pre-existing StorageClass to dynamically provision PV
- can add `local` path on node to create local PV manually

### Yagna Appkey
- coacervate/yagna [image](images/daemon/) automatically creates and funds an appkey on startup in persistent storage
- bringing your own appkey is planned but not currently supported out-the-box

### Accessing Daemon
- see test pod [definition](chart/templates/tests/test_pod.yaml) and [image](images/test_requestor/) to understand how you can build and deploy your own requestor that connects to the daemon