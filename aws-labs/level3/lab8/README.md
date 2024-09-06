### Securing Data with AWS KMS

1. Create a symmetric KMS key named devops-KMS-Key to manage encryption and decryption.
2. Encrypt the provided SensitiveData.txt file (located in /root/), base64 encode the ciphertext, and save the encrypted version as EncryptedData.bin in the /root/ directory.
3. Try to decrypt the same and verify that the decrypted data matches the original file.

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