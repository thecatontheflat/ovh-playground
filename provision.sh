cp /home/ubuntu/.ssh/authorized_keys /root/.ssh/

apt update
apt install pv atop  -y
apt install zfsutils-linux -y

zpool create dbdata raidz /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1 -f
zfs set redundant_metadata=most dbdata
zfs set xattr=sa dbdata
zfs set atime=off dbdata
zfs set compression=lz4 dbdata
zfs set recordsize=16k dbdata

sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
apt-get update
apt install postgresql-15 postgresql-server-dev-15 make gcc -y

chown postgres:postgres /dbdata
