!/bin/bash
Date: 26 November 2020 
v1.0

# usage: ./generate.sh example.org
DOMAIN="$1"
APP="$2"
Country="AU"
State="Vic"
City="Mel"
Company="foobar"
OU="people"
Email="foobar@example.com"
Expiry="" #(in days e.g. "365" (for certs to expire in one year.))

openssl genrsa -out ca.key 4096

openssl req -x509 -new -nodes -key ca.key -sha256 -days $Expiry -subj "/C=$Country/ST=$State/L=$City/O=$Company/OU=root/CN=$DOMAIN/emailAddress=$Email" -out ca.crt

openssl genrsa -out $APP.key 4096

####openssl req -new -key $APP.key -subj "/C=$Country/ST=$State/L=$City/O=$Company/OU=$OU/CN=$APP/emailAddress=$Email" -out $DOMAIN.csr

openssl req -new -sha256 -key $APP.key -subj "/C=$Country/ST=$State/L=$City/O=$Company/OU=$OU/CN=$APP/emailAddress=$Email" -out $DOMAIN.csr

openssl x509 -req -in $DOMAIN.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out $APP.crt -days $Expiry -sha256

openssl verify -CAfile ca.crt -untrusted $APP.crt

openssl dhparam -out dhparam.pem 2048

#--------------------------------------stout---------------------------------------------------#

openssl req -in ldap.csr -noout -text > ldap.text && sudo openssl x509 -in ldap.crt -noout -text >> ldap.text && openssl verify -CAfile ca.crt -untrusted ldap.crt >> ldap.text

