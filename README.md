# Fedora Silverblue - my custom image

Playing with [Ostree Native Containers](https://fedoraproject.org/wiki/Changes/OstreeNativeContainerStable)

The image can be rebased to via:

```bash
rpm-ostree rebase --experimental ostree-unverified-registry:ghcr.io/queil/silverblue:40-stable
```

Then upgraded via:

```bash
rpm-ostree upgrade
```

## Resources

https://coreos.github.io/rpm-ostree/container/
