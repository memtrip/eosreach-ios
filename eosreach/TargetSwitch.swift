import Foundation

class TargetSwitch {
    
    static func api() -> Target {
        #if STUB
        return Target.stub
        #elseif DEV
        return Target.dev
        #elseif PROD
        return Target.prod
        #else
        fatalError("The macros that drive the api() TargetSwitch are malformed.")
        #endif
    }
}

enum Target {
    case stub
    case dev
    case prod
}
