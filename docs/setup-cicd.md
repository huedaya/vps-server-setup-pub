## Setup CD
This is quick setup of Continous Delivery


### 1. Create new user
Login to server and run this
```
sudo adduser deploy
```
Then on local computer generate a key 
```
echo -e 'y\n' | ssh-keygen -m PEM -t rsa -b 4096 -C "for-gh-deploy" -f ~/.ssh/id_rsa_deploy -P ""

# copy the pub key
cat ~/.ssh/id_rsa_deploy.pub
```
And back to server, paste the pubkey to server to allow Github to access the server
```
nano ~/.ssh/authorized_keys
```
Then take a note the key and password

### 2. Put private key to GITHUB Secret 
Go to this menu https://github.com/<your_github_username>/<your_project_name>/settings/secrets/actions, and put this key:
- SSH_HOST : your server public ip 
- SSH_USERNAME: you server username (`deploy`)
- SSH_PRIVATE_KEY : your ssh private key on your server `cat ~/.ssh/id_rsa_deploy` (previously generated on local machine)
- SSH_APPS_PATH : `/home/server/apps`

### 3. Setup workflow
this is example for Laravel project.
create file in your project : `.github/workflows/deploy.yml`
```
name: Deploy

on:
  push:
    branches:
    - main

jobs:
  CD:
    name: Continuous Delivery
    runs-on: ubuntu-latest
    timeout-minutes: 5
    steps:
      - name: Get latest code 🚚
        uses: actions/checkout@v3
        with:
          fetch-depth: 0

      - name: Install dependencies 📡
        run: composer install --ansi --no-progress --no-interaction --prefer-dist

      - name: Remove dev file 🚮
        run: |
          cd $GITHUB_WORKSPACE/
          rm -f README.md
          rm -f .env.production
          rm -f .env.example
          rm -f .gitignore
          rm -f .gitattributes
          rm -f .styleci.yml
          rm -rf .git
          rm -rf .github
          rm -rf _.github
          rm -rf storage
          rm -rf tests
          rm -rf node_modules
          ls -al 

      - name: Ship codes 🚢
        uses: easingthemes/ssh-deploy@v4.1.8
        env:
          SSH_PRIVATE_KEY: ${{ secrets.SSH_PRIVATE_KEY }}
          REMOTE_HOST: ${{ secrets.SSH_HOST }}
          REMOTE_USER: ${{ secrets.SSH_USERNAME }}
          TARGET: ${{ secrets.SSH_APPS_PATH }}/${{ github.event.repository.name }}

      - name: Escalate .env to PRODUCTION 👑
        uses: appleboy/ssh-action@v0.1.6
        with:
          host: ${{ secrets.SSH_HOST }}
          username: ${{ secrets.SSH_USERNAME }}
          key: ${{ secrets.SSH_PRIVATE_KEY }}
          script: |
            cd ${{ secrets.SSH_APPS_PATH }}/${{ github.event.repository.name }}
            echo '${{ secrets.ENV_PROD }}' > .env

```


### Reference
- https://dev.to/s1hofmann/github-actions-ssh-deploy-setup-l7h
