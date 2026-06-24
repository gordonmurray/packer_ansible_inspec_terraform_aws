# Verify the example web server build.
title 'example.com web server'

describe package('nginx') do
  it { should be_installed }
end

describe service('nginx') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end

describe port(443) do
  it { should_not be_listening }
end

describe file('/var/www/html/index.nginx-debian.html') do
  it { should_not exist }
end

describe file('/var/www/html/index.php') do
  it { should exist }
end

# PHP should be 8.x, whatever minor the distro ships.
describe command('php -r "echo PHP_MAJOR_VERSION;"') do
  its('exit_status') { should eq 0 }
  its('stdout') { should cmp 8 }
end

# A PHP-FPM socket should exist, without hardcoding the version.
describe command('ls /run/php/php*-fpm.sock') do
  its('exit_status') { should eq 0 }
end
