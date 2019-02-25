name 'monitor'
maintainer 'Philipp H'
maintainer_email 'phil@hellmi.de'
license 'Apache 2.0'
description 'A cookbook for monitoring services, using Sensu, a monitoring framework.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.0.16'

%w(
  ubuntu
  debian
  centos
  redhat
  fedora
).each do |os|
  supports os
end

depends 'apt', '~> 4.0.1'
depends 'sudo'
depends 'yum-epel'
depends 'build-essential', '~> 6.0.0'
depends 'sensu', '= 5.1.1'
depends 'uchiwa', '~> 2.1.0'
depends 'redisio', '= 2.7.1'
depends 'erlang', '~> 6.2.0'
