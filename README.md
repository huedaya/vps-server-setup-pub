## Folder structure
- /home/server/apps/ (main application)
- /home/server/system/(where we clone this repo)

## Clone the repos
```
mkdir -p /home/server/system
cd /home/server/system
git clone git@github.com:huedaya/vps-server-setup-pub.git
cd vps-server-setup
cp .env.example .env
```

## Edit the `.env`
Just adjust the domain name

## Install Docker first
```
chmod +x setup-docker.sh
./setup-docker.sh
```

## Then run this script
make sure its cloned successfully
```
chmod +x setup.sh
./setup.sh
```
