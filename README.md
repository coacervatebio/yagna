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

### Wallets and Appkeys
- the container entrypoint [start script](images/daemon/start.sh) will set the appkey as follows:
    - if an appkey has already been created in persistent storage it will just use that
    - if a keystore is present *and unlocked* at the path specified in .Values.existingWallet.mountPath, it will import that key, set it as default, and create an appkey for it
    - if neither of the above conditions are met, the default/unconfigured behavior is to create an appkey and inialize it with test funds from the faucet
- once initialized i.e. `yagna app-key list` returns a non-empty list, that appkey will be used; any changes to this e.g. test -> mainnet must be carried out manually
- a clean way to switch between test and mainnet is to have different PVCs for each, as defined in .Values.yagna.pvcName

### Accessing Daemon
- see test pod [definition](chart/templates/tests/test_pod.yaml) and [image](images/test_requestor/) to understand how you can build and deploy your own requestor that connects to the daemon