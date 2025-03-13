#!/bin/bash

cat <<FILE 
#!/usr/sbin/nft -f

flush ruleset

table ip filter {
     chain input {
          type filter hook input priority 0; policy drop;

          # accept traffic originated from us
          ct state established,related accept

          # accept any localhost traffic
          iif lo accept
     }
}
FILE