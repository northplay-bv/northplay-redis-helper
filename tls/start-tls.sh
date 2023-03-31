#!/bin/bash

redis-server ./redis.conf --tls-port 4379 --port 0 --tls-cert-file ../certs/redis.crt --tls-key-file ../certs/redis.key --tls-ca-cert-file ../certs/ca.crt