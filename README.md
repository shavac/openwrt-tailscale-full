# Tailscale
This readme help you with tailscale client and daemon setup on OpenWrt.

modified from official feed by Jan Pavlinec <jan.pavlinec1@gmail.com>

## Compile
---

1. Use the latest [OpenWrt SDK](https://downloads.openwrt.org/snapshots/)

2. Enter root directory of SDK, run the following:

```sh
echo "src-git tailscale https://github.com/shavac/openwrt-tailscale-full.git" >> feeds.conf

./scripts/feeds update tailscale

./scripts/feeds install tailscale

make menuconfig
```
Network ---> VPN ---> <*> tailscale-full

```sh
make package/tailscale-full/{clean,compile} V=s
```
> [!NOTE]
> make sure uncheck tailscale and tailscaled.

package should be bin/packages/<TARGET>/tailscale-full-*.ipk


## Install
To install, run
```
opkg install tailscale-full-*.ipk
```
> [!NOTE]
> By default this package will use nftables. If you wish to use iptables, the config file `/etc/config/tailscale` can be modfied, changing the line `fw_mode 'nftables'` to `fw_mode 'iptables'`. You can then run `/etc/init.d/tailscale restart` to restart tailscale using your chosen method

## First setup

First, enable and run daemon

```
/etc/init.d/tailscale enable
/etc/init.d/tailscale start
```

Then you should use tailscale utility to get a login link for your device.

Run command and finish device registration with the given URL.
```
tailscale up
```

See the [OpenWrt wiki](https://openwrt.org/docs/guide-user/services/vpn/tailscale/start) for more detailed setup instructions
