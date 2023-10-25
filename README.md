# Boing

This is the boing DevOps repository.
Use it on your own project (boing)

## Offical Boing DevOps

Add this project to your project with

```bash
git submodule init
```

```bash
git submodule add git@github.com:BatMaxou/boing.git
```

## Drupal

### Settings

set web/sites/default/settings.php

### Without docker

#### Database & dependencies

```
make install file=backups/*wanted_backup*
```

#### Run

```
make start
```

### With docker

#### Enable docker

add at the top of your Makefile the following line

```
DOCKER_ENABLED = 1
```

#### Env file

Complete the .env file with your database container informations

```
DB_HOST='name_of_the_container'
DB_PORT='port'
DB_USER='user'
DB_PASSWORD='password'
DB_NAME='name_of_the_database'
```

if you have problem with env variables, try the followings commands:

```
set -a
source .env
```

#### Ports

Override the docker-compose file to choose the port for the website

```
version: "3"

services:

  web:
    ports:
      - "8616:80"
```

#### Docker up

```
docker-compose up -d --build
```

#### Database & dependencies

If you already have a database dump, put it in the backups folder and run the following command

```
make install file=backups/*wanted_backup*
```

Otherwise, run the following command and go to your browser to set the database information

```
make install
```
