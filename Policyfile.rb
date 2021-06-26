# Policyfile.rb - Describe how you want Chef Infra Client to build your system.
#
# For more information on the Policyfile feature, visit
# https://docs.chef.io/policyfile.html

# A name that describes what the system you're building with Chef does.
name 'checkmk'

# Where to find external cookbooks:
default_source :supermarket

run_list 'checkmk::server'
named_run_list :cmk_server, 'checkmk::server'
named_run_list :cmk_srvagt, 'checkmk::server', 'checkmk::agent-cmk'
named_run_list :cmk_agent,  'checkmk::agent-cmk'

# Specify a custom source for a single cookbook:
cookbook 'checkmk', path: '.'
