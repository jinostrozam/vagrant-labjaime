#node default {
## test message
#  notify {"This is the site.pp - you are on server ${hostname}.": }
#  include nginx
#}

node 'lbalancer.example.local' {
# Test message
  notify { "Debug output on ${hostname} node.": }

  include webapp,load_balancer,sudoers
}

node 'web01.example.local', 'web02.example.local' {
# Test message
  notify { "Debug output on ${hostname} node.": }

  include webapp,sudoers
}
