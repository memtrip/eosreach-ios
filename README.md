# EOSREACH
An open source EOS wallet developed in Swift using the [eos-swift](https://github.com/memtrip/eos-swift) SDK.

## Foreword
The current generation of browser plugin dependant DApps are not fit for mass market consumption,
the average consumer has little interest in the fact that the products they use are running on top
of a blockchain technology. We do not see a future for generic wallet apps as a gateway to Dapps running in web views,
in comparison to native mobile experiences, the UX is slow and cumbersome.

This wallet serves as a blueprint for how other developers might want to utilise [eos-swift](https://github.com/memtrip/eos-swift) to develop native iOS apps that consume the EOS blockchain.
[App on Appstore](https://itunes.apple.com/us/app/eos-reach-eos-wallet/id1444511797)

## Design pattern
The app uses the model view intent (MVI) design pattern, a unidirectional data flow driven by a single
Rx PublishSubject.

## Key management
### Import private key


## Tests
The EarlGrey tests in `eosreachTests` run against the offline stubs defined in `eosreach/_stub`, these
tests are the quickest way to verify the core functionality.

## Vote for memtripblock
If you find this app useful, please consider voting for [memtripblock](https://www.memtrip.com/code_of_conduct.html)
as a block producer. We are committed to open sourcing all the software we develop, let’s build the future of EOS on mobile together!

## TODO
- Refactor Main.storyboard into small storyboards
- The stub target should stub out the KingFisher requeests

### Credits
- [Join us on telegram](http://t.me/joinchat/JcIXl0x7wC9cRI5uF_EiQA)
- [Developed by memtrip.com](http://memtrip.com)
