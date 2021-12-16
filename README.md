# Born2BeRoot

Encryption pw : test
root pw : toortoor

```
apt install vim
```

## Create 2 encrypted partitions using LVM

Done automatically in the Debian guided installer

```
lsblk
```

## Differences Aptitude and Apt

## Difference SELinux and AppArmor

## Open 4242 port for ssh but not for root

https://linuxhint.com/ssh_virtualbox_guest/
https://www.golinuxcloud.com/ssh-command-in-linux/
https://www.golinuxcloud.com/ssh-into-virtualbox-vm/
https://askubuntu.com/questions/958440/can-not-change-ssh-port-server-16-04

```
apt install ssh
```

In `/etc/ssh/sshd_config` :

- modify `# Port 22` to `Port 4242`
- Add `PermitRootLogin no`

Check listening port using `ss -tulnp`

Mise en place d'un nouveau compte ?

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

https://www.lifewire.com/create-users-useradd-command-3572157

/etc/login.defs
/etc/default/useradd

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
- remove user (-r for removing home dir) `userdel -r user`

## Mise en place du monitoring

https://blog.cenmax.in/general/cpu-vs-vcpu-whats-the-difference/
https://www.daniloaz.com/en/differences-between-physical-cpu-vs-logical-cpu-vs-core-vs-thread-vs-socket/

Using printf should work fine.

- Architecture : `uname -a`
- CPU core(s) : `cat /proc/cpuinfo | grep cpu\ cores | uniq | cut -d' ' -f3`
- vCPU(s) : `cat /proc/cpuinfo | grep processor | wc -l`
- Mem Usage :
- Disk Usage :
- CPU load : `cat /proc/loadavg | cut -d' ' -f1,2,3`
- Last boot : `who --boot | cut -d' ' -f13,14`
- LVM use :
- Connexions TCP :
- User log : `who | wc -l`
- Network :
- Sudo :

Save in /opt/monitoring.sh

cron it
