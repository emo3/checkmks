# checkmks

Here is an example of where to get the free version:<br />
This for RHEL/CentOS only<br />
```
osv=8 # Version of RHEL/CentOS
#cmkv='2.0.0p8' # 2.0 Version of checkmk server
## 2.0.0
wget -q https://download.checkmk.com/checkmk/${cmkv}/check-mk-free-${cmkv}-el${osv}-38.x86_64.rpm
```
My local server to get pre-packaged agent
```
wget http://checkmks/cmk/check_mk/agents/check-mk-agent-${cmkv}-1.noarch.rpm
curl "http://checkmks/cmk/check_mk/webapi.py?action=get_all_hosts&_username=automation&_secret=$akey"
```

The following will list the CheckMK token, if on server
```
sudo cat /opt/omd/sites/cmk/var/check_mk/web/automation/automation.secret
```

The following will list the CheckMK token, from host
```
knife ssh -m checkmks -x vagrant -P vagrant 'sudo cat /opt/omd/sites/cmk/var/check_mk/web/automation/automation.secret'
```
