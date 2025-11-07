#!/bin/bash

# Not Use

export domain_name="startup-expo.kr"
export subject_alternative_name="*.startup-expo.kr"

# Generate a self-signed X.509 certificate with a 4096-bit RSA key
openssl req -new -x509 \
    -sha256 -nodes \
    -newkey rsa:4096 \
    -keyout private.key \
    -out certificate.crt \
    -subj "/CN=${domain_name}" \
    -addext "subjectAltName=DNS:${domain_name},DNS:${subject_alternative_name}"

# Upload the certificate and private key to AWS ACM
aws acm import-certificate \
    --certificate fileb://certificate.crt \
    --private-key fileb://private.key