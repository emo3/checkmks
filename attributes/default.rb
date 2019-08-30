# Override values within called cookbook
default['chef-server']['accept_license'] = true
default['chef-server']['version'] = '12.19.31'
default['chef-server']['addons'] = {manage: nil, reporting: nil}
# set default varibles for user-create
default['chefsrv']['user_name']  = 'admin'
default['chefsrv']['first_name'] = 'Ed'
default['chefsrv']['last_name']  = 'Overton'
default['chefsrv']['email']      = 'bogus@email.com'
default['chefsrv']['password']   = 'insecurepassword'
# set default variables for org-create
default['chefsrv']['org']        = 'emo3'
default['chefsrv']['full_org']   = 'EMOverton3 Org'
