sudo apt-get install -y python-software-properties

cd /tmp
wget http://apt.puppetlabs.com/puppetlabs-release-trusty.deb
sudo dpkg -i puppetlabs-release-trusty.deb

apt-get update
apt-get install -y puppet-common
