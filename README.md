# checkmk

Here are two examples of where to get the free version:<br>
https://mathias-kettner.de/support/1.5.0p12/check-mk-raw-1.5.0p12-el7-38.x86_64.rpm
https://checkmk.com/support/1.6.0p6/check-mk-raw-1.6.0p6-el7-38.x86_64.rpm
My local server to get pre-packaged agent<br>
http://checkmks/cmk/check_mk/agents/check-mk-agent-1.6.0p6-1.noarch.rpm
curl "http://checkmks/cmk/check_mk/webapi.py?action=get_all_hosts&_username=automation&_secret=$akey"
Creating a host:<br>
curl "http://checkmks/cmk/check_mk/webapi.py?action=add_host&_username=automation&_secret=$akey" -d 'request={"hostname":"checkmks","folder":"","attributes":{"ipaddress":"10.1.1.20","site":"cmk","tag_agent":"cmk-agent"}}'
Executing a Service Discovery<br>
curl "http://checkmks/cmk/check_mk/webapi.py?action=discover_services&_username=automation&_secret=$akey" -d 'request={"hostname":"checkmks"}'
Activating changes
curl "http://checkmks/cmk/check_mk/webapi.py?_secret=$akey&_username=automation&action=activate_changes" -d 'request={"sites":["cmk"]}'
