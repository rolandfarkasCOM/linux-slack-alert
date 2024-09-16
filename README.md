# Linux Slack Alert
A simple slack notification for SSH logins

The notify.sh file includes a simple notification for slack which can be customised with a special name (eg.: if you have host names and IP's) and a group name in case you want to group your servers.

The advanced.sh file is a copy of the notify.sh but it includes IP API location details eg: Country, City, Proxy info, Latitude, Longtitude and so on. (More info on: https://freeipapi.com/)


Create the scripts folder
```bash
mkdir /etc/ssh/scripts/
```

Add the notify.sh file to the scripts folder
```bash
touch /etc/ssh/scripts/notify.sh
```

Edit the notify.sh file and copy either the notify.sh contents or the advanced.sh contents and update the required parameters
```bash
nano /etc/ssh/scripts/notify.sh
```

Set the required permissions for the notify.sh file
```bash
sudo chmod +x /etc/ssh/scripts/notify.sh
```

Add the notify.sh file to the sshd service
```bash
sudo echo "session optional pam_exec.so seteuid /etc/ssh/scripts/notify.sh" >> /etc/pam.d/sshd
```

** Only required for advanced script so you can parse the IPAPI json response
```bash
sudo apt-get install jq
```