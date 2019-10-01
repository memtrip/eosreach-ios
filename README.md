# EOSREACH
An EOS wallet developed in Swift using the [eos-swift](https://github.com/memtrip/eos-swift) SDK.

## Foreword
The current generation of browser plugin dependant DApps are not fit for mass market consumption,
the average consumer has little interest in the fact that the products they use are running on top
of a blockchain technology. We do not see a future for generic wallet apps as a gateway to Dapps running in web views,
in comparison to native mobile experiences, the UX is slow and cumbersome.

This wallet serves as a blueprint for how other developers might want to utilise [eos-swift](https://github.com/memtrip/eos-swift) to develop native iOS apps that consume the EOS blockchain.

## Design pattern
The app uses the model view intent (MVI) design pattern, a unidirectional data flow driven by a single
Rx PublishSubject.

## Key management
### Import private key
When an EOS private key is imported, the EOS public key counterpart is resolved and a new EllipticCurveKeyPair is generated in
SecureEnclave. The EOS private key bytes are encrypted by this SecureEnclave backed keypair, the base58 EOS public key and the encrypted bytes are stored as a key/value pair.
- [Read more about SecureEnclave.](https://developer.apple.com/documentation/security/certificate_key_and_trust_services/keys/storing_keys_in_the_secure_enclave)
- See [EosKeyManager](http://github.com/memtrip/) for implementation details.

### Create account
The memtripissue service is used to create an account on behalf of the user, in this scenario a new EOS key pair is generated on the device and the private key is encrypted using the aforementioned mechanism. The EOS public key counterpart as base58 is sent to the memtripissue service to be assigned as both the owner and active authority of the new account. Your private key NEVER leaves your device during this process.

### Transaction signing
When an EOS private key is required to sign a transaction, the base58 EOS public key counterpart is used to fetch the EllipticCurveKeyPair encrypted private key bytes. To decrypt the private key bytes, the user must enter a pin or verify a biometric. The decrypted private key bytes are used to sign the pending transaction, the private key bytes will only remain in memory during the transaction signing process.

## Tests
The EarlGrey tests in `eosreachStubTests` run against the offline stubs defined in `eosreachStub`, these
tests are the quickest way to verify the core functionality. The tests in `eosreachDevTests` run against the
jungle testnet and confirm nodeos integration.

## Vote for memtripblock
If you find this app useful, please consider voting for [memtripblock](https://www.memtrip.com/code_of_conduct.html)
as a block producer. We are committed to open sourcing all the software we develop, let’s build the future of EOS on mobile together!

## TODO
- Allow an EOS `active` key to be generated in SecureEnclave, this hardware backed key would ensure that private key bytes never have to enter the apps memory to perform signing.
- Refactor Main.storyboard into small storyboards
- The stub target should stub out the KingFisher requeests

### Credits
- [Join us on telegram](http://t.me/joinchat/JcIXl0x7wC9cRI5uF_EiQA)
- [Developed by memtrip.com](http://memtrip.com)
