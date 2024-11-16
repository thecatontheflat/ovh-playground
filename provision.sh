apt update
apt install pv atop  -y
apt install zfsutils-linux -y
apt install openvswitch-switch-dpdk -y

zpool create dbdata /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1 -f
#zpool create -o ashift=12 dbdata /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1 -f # use ashift when HDD


zfs set redundant_metadata=most dbdata
zfs set xattr=sa dbdata
zfs set atime=off dbdata
zfs set compression=lz4 dbdata
zfs set recordsize=16k dbdata
# zfs set ashift=12 # HDD

sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
apt-get update
apt install postgresql-16 postgresql-server-dev-16 make gcc -y

chown postgres:postgres /dbdata
