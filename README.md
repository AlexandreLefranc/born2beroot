# Born2BeRoot

Encryption pw : test
root pw : toortoor

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

## Mise en place d'une politique de mdp fort

https://www.lifewire.com/create-users-useradd-command-3572157

/etc/login.defs
/etc/default/useradd

## Installer et configurer sudo selon une pratique stricte

## Creer un utilisateur alefranc appartenant aux groupes user42 et sudo

https://www.techrepublic.com/article/how-to-create-users-and-groups-in-linux-from-the-command-line/

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

NB : 

- --create-home => -m
- --password    => -p
- --groups      => -g
- list of users `cat /etc/passwd`
- list of groups `cat /etc/group`
- remove user (-r for removing home dir) `userdel -r user`

## Mise en place du monitoring
