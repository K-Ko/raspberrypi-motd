motd
====

#### Message of the Day for the Raspberry Pi ####

<img src="https://raw.githubusercontent.com/K-Ko/raspberrypi-motd/master/motd.png"/>

Written in pure Bash. No need to install any package.

#### Download and save the `motd.sh` bash script in the Raspberry Pi ####

```bash
$ sudo wget -qO /etc/profile.d/motd.sh https://raw.githubusercontent.com/K-Ko/raspberrypi-motd/master/motd.sh
```

#### Remove the default MOTD ####

```bash
$ sudo rm /etc/motd
```

Note: If you don't see the degree Celsius character correctly (`°`)
make sure you have enabled a UTF8 locale
([Arch Linux locales](https://wiki.archlinux.org/index.php/locale)).
