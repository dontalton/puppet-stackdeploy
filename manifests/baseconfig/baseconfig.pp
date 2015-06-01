class stackdeploy::baseconfig::baseconfig {

  # set selinux to permissive
 
  exec { 'disable selinux':
    command => '/usr/sbin/setenforce 0',
  }

  file { '/etc/selinux/config':
      content => template('stackdeploy/baseconfig/selinux'),
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
  }


  # setup Sec=sys for NFS connections

  file { '/etc/nfsmount.conf':
    content => template('stackdeploy/baseconfig/nfsmount.conf'),
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  # Install things that should have been installed by default

  package { ['vim-enhanced','git','screen']:
    ensure => installed,
  }

  service { 'puppet':
    ensure => running,
    enable => true,
  }

  file { '/etc/ntp.conf':
    ensure  => file,
    content => template('stackdeploy/baseconfig/ntp.conf'),
    owner   => root,
    group   => root,
    mode    => 0644,
  }

  service { 'ntpd':
    ensure    => running,
    enable    => true,
    subscribe => File['/etc/ntp.conf'],
  }


  # setup root's ssh key

  file { '/root/.ssh':
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => 0700,
    before => File['root privkey','root pubkey','root authkeys','root sshconf'],
  }

  file { 'root privkey':
    ensure  => file,
    path    => '/root/.ssh/id_rsa',
    content => template("stackdeploy/$site/ssh/root/id_rsa"),
    owner   => root,
    group   => root,
    mode    => 0600,
  }

  file { 'root pubkey':
    ensure  => file,
    path    => '/root/.ssh/id_rsa.pub',
    content => template("stackdeploy/$site/ssh/root/id_rsa.pub"),
    owner   => root,
    group   => root,
    mode    => 0644,
  }

  file { 'root authkeys':
    ensure  => file,
    path    => '/root/.ssh/authorized_keys',
    content => template("stackdeploy/$site/ssh/root/authorized_keys"),
    owner   => root,
    group   => root,
    mode    => 0644,
  }

  file { 'root sshconf':
    ensure  => file,
    path    => '/root/.ssh/config',
    content => template("stackdeploy/$site/ssh/ssh.config"),
    owner   => root,
    group   => root,
    mode    => 0644,
  }

}

