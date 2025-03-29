#!/bin/bash


cat <<NFT > /etc/nftables.conf
#!/usr/sbin/nft -f

flush ruleset 

table ip filter {
    chain input {
        type filter hook input priority 0; policy accept;
    }
    chain output {
        type filter hook output priority 0; policy accept;
    }
}

NFT

nft -f /etc/nftables.conf

nft add rule filter input ct state established accept
nft add rule filter input tcp dport 80 tcp flags == syn ct state new accept
nft add rule filter input tcp dport 443 tcp flags == syn ct state new accept
nft add rule filter input drop


nft add rule filter output tcp flags != accept

nft add rule filter output drop
# règle de limitation de requête en cas d'attaque DDOS


nft add rule filer input