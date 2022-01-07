#!/bin/sh -ex

COMMONNAME=$1

echo "=== GENERATING self cert for ${COMMONNAME}"

RSASECRET=rsa-secret.key
REQCSR=request.csr
CERT=server-cert.crt

echo "STEP1: generate RSA secret key"
openssl genrsa -out $RSASECRET 1024
echo ""

echo "> show RSA secret key ($RSASECRET)"
cat $RSASECRET
echo ""

echo "STEP2: generate CSR"
openssl req -new -x509 -days 3650 -key $RSASECRET -out $REQCSR \
	-subj "/C=JP/CN=${COMMONNAME}"
echo ""

echo "> show CSR ($REQCSR)"
cat $REQCSR
echo ""

echo "STEP3: generate certificate"
openssl x509 -in $REQCSR -out $CERT -days 3650
echo ""

echo "> show certificate"
openssl x509 -in $CERT -text
echo ""
