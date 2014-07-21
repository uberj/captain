Exec {
  logoutput => true,
  timeout => 0
}

node /captain*/ {
  class {'captainshove::captain':
    install_root          => '/vagrant',
    captain_rabbit_vhost  => 'captain',
    captain_apache_vhost  => 'localhost',
    screen_startup        => true,
    screen_startup_user   => 'vagrant',
    web_port              => '80',
    rabbit_host           => 'captain',
    rabbit_user           => 'shove',
    rabbit_pass           => 'rabbitpass',
    debug                 => true,
    pip_cache             => '/vagrant/.pip_cache'
  }
}

node /shove*/ {
  class {'captainshove::shove':
    install_root          => '/vagrant',
    rabbit_user           => 'shove',
    rabbit_host           => '192.168.238.77',
    rabbit_pass           => 'rabbitpass',
    screen_startup        => true,
    screen_startup_user   => 'vagrant',
  }
}
