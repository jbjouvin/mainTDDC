[![Build Status](https://travis-ci.org/jbjouvin/mainTDDC.svg?branch=master)](https://travis-ci.org/jbjouvin/mainTDDC)

# HowTo

## **for docker-machine on aws**

> install aws cli
```
$ apt install awscli
$ aws configure
```

> Create the docker-machine on aws
```
$ docker-machine create --driver amazonec2 --amazonec2-region eu-west-2 aws
```

> Export variable before launch
```
$ eval $(docker-machine env aws) && 
export REACT_APP_USERS_SERVICE_URL=`echo $DOCKER_HOST | cut -c7- | cut -d: -f1` &&
export SECRET_KEY=`hexdump -n 16 -e '4/4 "%08X" 1 "\n"' /dev/random`
```

> Launch the beast
```sh
$ docker-compose -f docker-compose-prod.yml up -d --build
```
> Create db
```sh
$ docker-compose -f docker-compose-prod.yml run users-service python manage.py recreate_db
```
> seed db
```
$ docker-compose -f docker-compose-prod.yml run users-service python manage.py seed_db
```
> test application
```
$ docker-compose -f docker-compose-prod.yml run users-service python manage.py test
```