Common packaging and distribution
---------------------------------


Stand-alone
-----------

Just works as a standa-alone application.


Debian 7.0 Wheezy
------------------
```
su -
echo 'deb http://rep.logentries.com/ wheezy main' >/etc/apt/sources.list.d/logentries.list
gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys C43C79AD && gpg -a --export C43C79AD | apt-key add -
aptitude update
aptitude install logentries
le register
aptitude install logentries-daemon
exit
```


Debian 8.0 Jessie/SID
---------------------
```
su -
echo 'deb http://rep.logentries.com/ jessie main' >/etc/apt/sources.list.d/logentries.list
gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys C43C79AD && gpg -a --export C43C79AD | apt-key add -
aptitude update
aptitude install logentries
le register
aptitude install logentries-daemon
exit
```


Ubuntu 11.10 Oneiric Ocelot
-----------------------------
```
sudo -sH
echo 'deb http://rep.logentries.com/ oneiric main' >/etc/apt/sources.list.d/logentries.list
gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys C43C79AD && gpg -a --export C43C79AD | apt-key add -
apt-get update
apt-get install logentries
le register
apt-get install logentries-daemon
exit
```


Ubuntu 13.04 Raring Ringtail
-----------------------------
```
sudo -sH
echo 'deb http://rep.logentries.com/ raring main' >/etc/apt/sources.list.d/logentries.list
gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys C43C79AD && gpg -a --export C43C79AD | apt-key add -
apt-get update
apt-get install logentries
le register
apt-get install logentries-daemon
exit
```


Ubuntu 13.10 Saucy Salamander
-----------------------------
```
sudo -sH
echo 'deb http://rep.logentries.com/ saucy main' >/etc/apt/sources.list.d/logentries.list
gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys C43C79AD && gpg -a --export C43C79AD | apt-key add -
aptitude update
aptitude install logentries
le register
aptitude install logentries-daemon
exit
```


Ubuntu 14.04 Trusty Tahr
------------------------
```
sudo -sH
echo 'deb http://rep.logentries.com/ trusty main' >/etc/apt/sources.list.d/logentries.list
gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys C43C79AD && gpg -a --export C43C79AD | apt-key add -
apt-get update
apt-get install logentries
le register
apt-get install logentries-daemon
exit
```


Ubuntu 15.04 Vivid Vervet
-------------------------
```
sudo -sH
echo 'deb http://rep.logentries.com/ vivid main' >/etc/apt/sources.list.d/logentries.list
gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys C43C79AD && gpg -a --export C43C79AD | apt-key add -
apt-get update
apt-get install logentries
le register
apt-get install logentries-daemon
exit
```


Fedora 14-19
------------
```
su -
tee /etc/yum.repos.d/logentries.repo <<EOF
[logentries]
name=Logentries repo
enabled=1
metadata_expire=1d
baseurl=http://rep.logentries.com/fedora\$releasever/\$basearch
gpgkey=http://rep.logentries.com/RPM-GPG-KEY-logentries
EOF
yum update
yum install logentries
le register
yum install logentries-daemon
exit
```


Fedora 20
---------
```
su -
yum-config-manager --add-repo http://rep.logentries.com/helpers/fedora20/logentries.repo
yum update
yum install logentries
le register
yum install logentries-daemon
exit
```


Amazon Linux AMI
-------------
```
su -
tee /etc/yum.repos.d/logentries.repo <<EOF
[logentries]
name=Logentries repo
enabled=1
metadata_expire=1d
baseurl=http://rep.logentries.com/amazon\$releasever/\$basearch
gpgkey=http://rep.logentries.com/RPM-GPG-KEY-logentries
EOF
yum update
yum install logentries
le register
yum install logentries-daemon
exit
```


CentOS 5
--------
```
su -
tee /etc/yum.repos.d/logentries.repo <<EOF
[logentries]
name=Logentries repo
enabled=1
metadata_expire=1d
gpgcheck=0
baseurl=http://rep.logentries.com/centos\$releasever/\$basearch
EOF
yum update
yum install logentries
le register
yum install logentries-daemon
exit
```


CentOS 6
--------
```
su -
tee /etc/yum.repos.d/logentries.repo <<EOF
[logentries]
name=Logentries repo
enabled=1
metadata_expire=1d
gpgcheck=0
baseurl=http://rep.logentries.com/centos\$releasever/\$basearch
EOF
yum update
yum install logentries
le register
yum install logentries-daemon
exit
```


### You will need to install python packages separately

