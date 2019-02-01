import Foundation
import RxSwift

extension ConnectableObservableType {
    func autoconnect() -> Observable<E> {
        return Observable.create { observer in
            return self.do(onSubscribe: {
                _ = self.connect()
            }).subscribe { (event: Event<Self.E>) in
                switch event {
                case .next(let value):
                    observer.on(.next(value))
                case .error(let error):
                    observer.on(.error(error))
                case .completed:
                    observer.on(.completed)
                }
            }
        }
    }
}
