export PS4='(${BASH_SOURCE}:${LINENO}): - [${SHLVL},${BASH_SUBSHELL},$?] $ '
set -ex

echo pi:#### | chpasswd

export LANG=en_US.UTF-8
export TIMEZONE=CST

######################

# set locale
LOCALE="$LANG"
LOCALE_LINE="$(grep "^$LOCALE " /usr/share/i18n/SUPPORTED)"
ENCODING="$(echo $LOCALE_LINE | cut -f2 -d " ")"
echo "$LOCALE $ENCODING" > /etc/locale.gen
sed -i "s/^\s*LANG=\S*/LANG=$LOCALE/" /etc/default/locale
dpkg-reconfigure -f noninteractive locales

# Set wifi country
wpa_cli -i wlan0 set country US
wpa_cli -i wlan0 save_config
rfkill unblock wifi

for f in /etc/wpa_supplicant/wpa_supplicant.conf \
         /etc/network/interfaces \
         /etc/wpa_supplicant/functions.sh \
         /etc/default/keyboard
do
    b=$(basename $f)
    echo "=== $b ==="
    if [ ! -e ${f}.bak ]
    then
        cp $f ${f}.bak
    fi
    cp $b $f
    echo
done

# Set timezone
rm /etc/localtime
echo "$TIMEZONE" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

# US keyboard
dpkg-reconfigure -f noninteractive keyboard-configuration
invoke-rc.d keyboard-setup start
setsid sh -c 'exec setupcon -k --force <> /dev/tty1 >&0 2>&1'
udevadm trigger --subsystem-match=input --action=change

# Get rid of dhcpcd
systemctl disable dhcpcd.service

# Make wifi work
ip link set wlan0 up
#wpa_action wlan0 CONNECTED
#systemctl restart ifup@wlan0
#systemctl restart networking.service
