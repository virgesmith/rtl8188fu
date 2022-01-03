For Kernel 4.15.x ~ 5.15.x (Linux Mint, Ubuntu or Debian Derivatives)

------------------

## How to install (for arm devices)

`sudo ln -s /lib/modules/$(uname -r)/build/arch/arm /lib/modules/$(uname -r)/build/arch/armv7l`

`sudo apt-get install build-essential git dkms linux-headers-$(uname -r)`

`git clone -b arm https://github.com/kelebek333/rtl8188fu rtl8188fu-arm`

`sudo dkms add ./rtl8188fu-arm`

`sudo dkms build rtl8188fu/1.0`

`sudo dkms install rtl8188fu/1.0`

`sudo cp ./rtl8188fu-arm/firmware/rtl8188fufw.bin /lib/firmware/rtlwifi/`

### What I did, loosely based on the above

On a Raspberry Pi model A+ running Raspbian bullseye with `build-essential` (gcc 10.2.1) and `raspberrypi-kernel-headers` (kernel 5.10.63+ armv6l) installed. Note:

- `ARCH` needs to be overridden from `armv6l` (which is not recognised) to just `arm`
- `MODULE_NAME` needs to be explicitly set for some reason

```sh
git clone -b arm https://github.com/kelebek333/rtl8188fu rtl8188fu-arm
cd rtl8188fu-arm/
ARCH=arm make # override ARCH
sudo MODULE_NAME=rtl8188fu make install # manually set MODULE_NAME
cp firmware/rtl8188fufw.bin /lib/firmware/rtlwifi/
echo 'alias usb:v0BDApF179d*dc*dsc*dp*icFFiscFFipFFin* rtl8188fu' | sudo tee /etc/modprobe.d/r8188eu-blacklist.conf
sudo shutdown -h now
```

Inserted wifi dongle, booted... and it worked!

------------------

## Configuration

#### Disable Power Management

Run following commands for disable power management and plugging/replugging issues.

`sudo mkdir -p /etc/modprobe.d/`

`sudo touch /etc/modprobe.d/rtl8188fu.conf`

`echo "options rtl8188fu rtw_power_mgnt=0 rtw_enusbss=0" | sudo tee /etc/modprobe.d/rtl8188fu.conf`

#### Disable MAC Address Spoofing

Run following commands for disabling MAC Address Spoofing (Note: This is not needed on Ubuntu based distributions. MAC Address Spoofing is already disable on Ubuntu base).

`sudo mkdir -p /etc/NetworkManager/conf.d/`

`sudo touch /etc/NetworkManager/conf.d/disable-random-mac.conf`

`echo -e "[device]\nwifi.scan-rand-mac-address=no" | sudo tee /etc/NetworkManager/conf.d/disable-random-mac.conf`

#### Blacklist for kernel 5.15 and newer

If you are using kernel 5.15 and newer, you must create a configuration file with following commands for preventing to conflict rtl8188fu module with built-in r8188eu module.

`echo 'alias usb:v0BDApF179d*dc*dsc*dp*icFFiscFFipFFin* rtl8188fu' | sudo tee /etc/modprobe.d/r8188eu-blacklist.conf`

------------------

## How to uninstall

`sudo dkms remove rtl8188fu/1.0 --all`

`sudo rm -f /lib/firmware/rtlwifi/rtl8188fufw.bin`

`sudo rm -f /etc/modprobe.d/rtl8188fu.conf`


