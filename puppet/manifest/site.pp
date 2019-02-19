node default {

# test message

  notify {"This is the site.pp - you are on server ${hostname}.": }
  include nginx
}
