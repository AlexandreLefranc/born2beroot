# Born2BeRoot

Encryption pw : test

root pw : toortoor

It might be necessary to add French locale in addition of system locale to avoid warning messages using `ssh`

```
sudo dpkg-reconfigure locales

[x] fr_FR.UTF-8
```

# Abstract

Remove AppArmor profiles

```
rm /etc/apparmor.d/lsb_release /etc/apparmor.d/nvidia_modprobe
aa-remove-unknown
```

Enable static IP

```
nano /etc/network/interfaces
	iface enp0s3 inet static
		address 192.168.1.142
		netmask 255.255.255.0
		gateway 192.168.1.254

reboot
```

Set up SSH port 4242 and UFW

```
apt install ssh ufw

ufw enable
ufw allow 4242

nano /etc/ssh/sshd_config
	Port 4242
	PermitRootLogin no
systemctl force-reload sshd
```

Update hostname

```
hostnamectl set-hostname alefranc42
nano /etc/hosts
	127.0.1.1	alefranc42
```

Strong sudo policy

```
apt install sudo
mkdir -p /var/log/sudo
touch /var/log/sudo/sudo.log

visudo /etc/sudoers.d/sudoers_conf
	Defaults	passwd_tries=3
	Defaults	badpass_message="Bad luck dude !"
	Defaults	logfile="/var/log/sudo/sudo.log"
	Defaults	log_input,log_output
	Defaults	requiretty

chmod 440 /etc/sudoers.d/sudoers_conf

service sudo reload

addgroup alefranc sudo
```

Strong user password policy

```
nano /etc/login.defs
	PASS_MAX_DAYS	30
	PASS_MIN_DAYS	2
	PASS_WARN_AGE	7

apt install libpam-pwquality

nano /etc/pam.d/common-password
	password    requisite      pam_pwquality.so retry=3 minlen=10 maxrepeat=3 ucredit=-1 dcredit=-1 difok=7 reject_username enforce_for_root

/opt/
```

Create groups and user + assign users to groups + delete user

```
addgroup user42
adduser bob42
addgroup bob42 user42
addgroup bob42 sudo
deluser --remove-home bob42
```

Monitoring and cron

```
crontab -e
	*/10 * * * * wall `/opt/monitoring.sh`
```

## Some help

https://github.com/caroldaniel/42sp-cursus-born2beroot

## Create 2 encrypted partitions using LVM

Done automatically in the Debian guided installer

```
lsblk
```

## Differences Aptitude and Apt

- 

## Difference SELinux and AppArmor + Clean AppArmor

To remove unwanted profile in AppArmor :

- `cd /etc/apparmor.d/`
- `rm lsb_release nvidia_modprobe`
- `aa-remove-unknown`

## Open 4242 port for ssh but not for root

https://linuxhint.com/ssh_virtualbox_guest/
https://www.golinuxcloud.com/ssh-command-in-linux/
https://www.golinuxcloud.com/ssh-into-virtualbox-vm/
https://askubuntu.com/questions/958440/can-not-change-ssh-port-server-16-04

About NAT and bridge adapter
[one](https://linuxhint.com/use-virtualbox-bridged-adapter/)
[two](https://www.malekal.com/vmware-differences-nat-vs-bridged-vs-host-only/)
[three](https://www.virtualbox.org/manual/ch06.html)

```
apt install ssh
```

In `/etc/ssh/sshd_config` :

- modify `# Port 22` to `Port 4242`
- Modify `PermitRootLogin` to `no`

Reload the sshd service `systemctl force-reload sshd`
[1](https://askubuntu.com/questions/105200/what-is-the-difference-between-service-restart-and-service-reload)

Set the VirtualBox adapter to "Bridge" and connect using 192.168.x.x ip address.

NB :

- Check listening port using `ss -tulnp`
- Get my IP using `hostname -I` or `ip a`


Mise en place d'un nouveau compte ?

## Set static IP

https://www.tecmint.com/set-add-static-ip-address-in-linux/
https://linuxconfig.org/how-to-setup-a-static-ip-address-on-debian-linux

Run `ip a` to get dhcp ip and mask

Example `192.168.1.2/24` means :

- IP is `192.168.1.2`
- Mask is `255.255.255.0` (24 first bits are 1)

Run `ip route | grep default` to get gateway (`192.168.1.254` for me)

`ss -tulnp` shows DHCP is active

Usually, DHCP ranges from 1 to 100. So let create a static IP out of this range : `192.168.1.142`

Open file `/etc/network/interfaces` with `nano`

Replace the `dhcp` term by `static` and add address, mask and gateway of new static IP as follow :

```
iface enp0s3 inet static
	address 192.168.1.142
	netmask 255.255.255.0
	gateway 192.168.1.254
```

Reboot to apply changes

Check if internet still works : `ping 42l.fr`

## Installer UFW

```
apt install ufw
ufw enable
ufw allow 4242
ufw status
```

## Modifier hostname

```
hostnamectl set-hostname {{newhostname}}
```

Update the name in `/etc/hosts`

## Mise en place d'une politique de mdp fort

[Link](https://www.lifewire.com/create-users-useradd-command-3572157)
[Link](https://ostechnix.com/how-to-set-password-policies-in-linux/)
[Link](https://computingforgeeks.com/enforce-strong-user-password-policy-ubuntu-debian/)

/etc/login.defs

/etc/default/useradd

Settings about

- expiration to 30 days
- set minimum time before new change to 2
- warning before expiration date to 7

are in `/etc/login.defs`

```
# Password aging controls:
#       PASS_MAX_DAYS   Maximum number of days a password may be used.
#       PASS_MIN_DAYS   Minimum number of days allowed between password changes.
#       PASS_WARN_AGE   Number of days warning given before a password expires.
#
PASS_MAX_DAYS   30
PASS_MIN_DAYS   2
PASS_WARN_AGE   7

```

For more password policy, we have to install `pam_pwquality`

```
apt install libpam-pwquality
```

Then open `/etc/pam.d/common-password` and add to this line 

```
password   requisite   pam_pwquality.so retry=3
```

This fields

```
password    requisite      pam_pwquality.so retry=3 minlen=10 maxrepeat=3 ucredit=-1 dcredit=-1 difok=7 reject_username enforce_for_root
```


This doesn't apply to already existing users. To enforce it, we should to it manually : run script `/opt/chage_update_user user`

Or manually

```
chage -M 30 user
chage -m 2 user
chage -W 7 user
```


## Installer et configurer sudo selon une pratique stricte

https://www.tecmint.com/sudoers-configurations-for-setting-sudo-in-linux/

```
apt install sudo
usermod -aG sudo alefranc
```

Add in `/etc/sudoers` using `visudo` command :

- `Defaults	passwd_tries=3`
- `Defaults	badpass_message="Bad luck dude !"`
- `Defaults	logfile="/var/log/sudo/sudo.log"`
- `Defaults	log_input,log_output`
- `Defaults	requiretty`
- `Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"`

Remember to `mkdir -p /var/log/sudo/` and `touch /var/log/sudo/sudo.log`

## Creer un utilisateur alefranc appartenant aux groupes user42 et sudo

https://www.techrepublic.com/article/how-to-create-users-and-groups-in-linux-from-the-command-line/
https://unix.stackexchange.com/questions/55564/addgroup-vs-groupadd

Create a new user `useradd --create-home alefranc --password PASSWORD`.

User can change the password typing `passwd`.

Create group `groupadd mygroup`.

Add user to supplementary groups `usermod -a -G {{group1,group2}} {{user}}`

Create a new user and assign to a group `useradd --create-home alefranc --password PASSWORD --groups sudo,user42`

```
useradd -m alefranc
passwd alefranc
groupadd user42
usermod -a -G user42,sudo alefranc
```

Simplier method :

```
adduser alefranc
addgroup user42
addgroup alefranc user42
addgroup alefranc sudo
```

NB :

- --create-home => -m
- --password    => -p
- --groups      => -g
- list of users `cat /etc/passwd`
- list of groups `cat /etc/group`
- remove user (-r for removing home dir) `userdel -r user` or `deluser --remove-home user`

To know which group a user is in `groups user` or `id user` or `getent group | grep user`

To list all users `cat /etc/passwd` or `getent passwd`

To list all real users `getent passwd {1000..3000}` ([source](https://phoenixnap.com/kb/how-to-list-users-linux))

To list all groups `cat /etc/group` or `getent group`

## Mise en place du monitoring

https://blog.cenmax.in/general/cpu-vs-vcpu-whats-the-difference/
https://www.daniloaz.com/en/differences-between-physical-cpu-vs-logical-cpu-vs-core-vs-thread-vs-socket/

Using printf should work fine.

- Architecture : `uname -a`
- CPU core(s) : `cat /proc/cpuinfo | grep cpu\ cores | uniq | cut -d' ' -f3`
- vCPU(s) : `cat /proc/cpuinfo | grep processor | wc -l`
- Mem Usage :
- Disk Usage :
- CPU load : `cat /proc/loadavg | awk '{print $1, $2, $3}'`
- Last boot : `who --boot | awk '{print $3, $4}'` or `uptime --since`
- LVM use : `lvm lvs | wc -l | awk '{if ($0 > 0) {print "yes"} else {print "no"}}'`
- Connexions TCP :
- User log : `who | wc -l`
- Network : `hostname -I | awk '{print $1}'` + `ip a | awk '/ether/{print $2}'`
- Sudo :

Save in /opt/monitoring.sh

To set up cron

[link](https://phoenixnap.com/kb/set-up-cron-job-linux)

Run `sudo crontab -e` and add this line

```
*/10 * * * * wall `/opt/monitoring.sh`
```

Synthax :

```
 # Example of job definition:
 # .---------------- minute (0 - 59)
 # |  .------------- hour (0 - 23)
 # |  |  .---------- day of month (1 - 31)
 # |  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...
 # |  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7)
 # |  |  |  |  |
 # *  *  *  *  *   command to be executed
```

We can list all cron job using `crontab -l`

Note that you can run crontab as simple user. To edit crontab of specific user, run `crontab -u user -e`

Cron jobs don't need any reload / restart / reboot to apply. 


# BONUS

## Partitioning

- Manual
- Select drive
- Create 2 partitions
	- 500 MB primary ext2 mounted at /boot
	- All free space in logical partition with no fs
- Configure encrypted partition and select the logical partition
- Select the encrypted partition and set the fs to "Physical Volume for LVM"
- Configure the LVM
	- Create volume group "LVMGroup" on sda5_crypt
	- Create as many logical volume as necessary
- Select each LV and choose ext4 and mount point (except for SWAP)











