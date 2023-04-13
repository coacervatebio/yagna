# Yagna Helm Chart

Fairly rigid working implementation as part of a larger project - may not work out of the box for a particular use-case. Feel free to submit a PR!

## Installation Instructions
- (Make sure Helm and Kubectl are installed before continuing)
- git clone https://github.com/coacervatebio/yagna.git
- cd chart
- helm install my-release . -f values.yaml

## Configuration

### Persistent Storage
- see `values.yaml` comments for options
- leaving as is will use your default StorageClass (if configured)
- can set pre-existing StorageClass to dynamically provision PV
- can add `local` path on node to create local PV manually