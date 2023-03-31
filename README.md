## Northplay Redis Config

### CLI

To install `northplay-redis-cli`:
```shell
sudo cp northplay-redis-cli /usr/local/bin/northplay-redis-cli
sudo chmod +x /usr/local/bin/northplay-redis-cli
sudo cp ./redis-users.acl /etc/redis-users.acl
sudo cp ./redis-base.conf /etc/redis-base.conf
```

The `redis-users.acl` contains the redis user and redis password.

### Prepare

#### sysctl

Sysctl config set values:

```shell
sudo echo vm.overcommit_memory = 1 | sudo tee -a /etc/sysctl.conf
sudo echo fs.inotify.max_user_watches = 524288 | sudo tee -a /etc/sysctl.conf
sudo echo net.ipv6.conf.all.disable_ipv6 = 1 | sudo tee -a /etc/sysctl.conf
sudo echo net.ipv6.conf.default.disable_ipv6 = 1 | sudo tee -a /etc/sysctl.conf
sudo echo fs.file-max = 1000000 | sudo tee -a /etc/sysctl.conf
```

Reload sysctl:
```shell
sudo sysctl -p
```

#### screen
Install screen so we can start multiple redis standalone nodes.

`sudo apt-get install screen`


### Redis Install

You can install through package manager or compile sources.

#### Package Manager

Installing from package manager:
```shell
sudo apt install lsb-release
curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d redis.list
sudo apt-get update
sudo apt-get install redis
```

#### Compile Redis

Getting and building from source:

```shell
sudo mkdir install && cd install
sudo echo vm.overcommit_memory = 1 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
sudo wget https://download.redis.io/redis-stable.tar.gz
sudo tar -xzvf redis-stable.tar.gz
sudo cd redis-stable
sudo make distclean BUILD_TLS=yes
sudo make install BUILD_TLS=yes
```

## Laravel Config
### .env

Example environment:
```shell
REDIS_USERNAME="redis_user_1"
REDIS_PASSWORD="ffaf11fewfqeqqvVVd203c493aa99"
REDIS_HOST=127.0.0.1
REDIS_PORT=5379
REDIS_DB=2
REDIS_CACHE_DB=3

```

### config/database.php

```json
    'redis' => [

        'client' => env('REDIS_CLIENT', 'phpredis'),

        'options' => [
            'cluster' => env('REDIS_CLUSTER', 'redis'),
            'prefix' => env('REDIS_PREFIX', Str::slug(env('APP_NAME', 'laravel'), '_').'_database_'),
        ],

        'default' => [
            'host' => env('REDIS_HOST', '127.0.0.1'),
            'username' => env('REDIS_USERNAME'),
            'password' => env('REDIS_PASSWORD'),
            'port' => env('REDIS_PORT', '6379'),
            'database' => env('REDIS_DB', '4'),
        ],

        'cache' => [
            'host' => env('REDIS_HOST', '127.0.0.1'),
            'username' => env('REDIS_USERNAME'),
            'password' => env('REDIS_PASSWORD'),
            'port' => env('REDIS_PORT', '6379'),
            'database' => env('REDIS_CACHE_DB', '5'),
        ],

    ]

```