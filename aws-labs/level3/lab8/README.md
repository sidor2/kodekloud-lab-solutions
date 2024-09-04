### Securing Data with AWS KMS

```
aws kms encrypt \
  --key-id <key-id> \
  --plaintext fileb:///root/SensitiveData.txt \
  --output text \
  --query CiphertextBlob | base64 --decode > /root/EncryptedData.bin
```

```
aws kms decrypt \
  --ciphertext-blob fileb:///root/EncryptedData.bin \
  --output text \
  --query Plaintext | base64 --decode > /root/DecryptedData.txt
```