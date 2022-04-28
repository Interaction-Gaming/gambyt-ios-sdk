# LottoLog

![](LottoLogLogo.png)

[![Version](https://img.shields.io/cocoapods/v/LottoLog.svg?style=flat)](https://cocoapods.org/pods/LottoLog)

## Getting Started

LottoLog is available through the IG Private Podspec repo. 

To install it, simply add the repo via cocoapods
```
pod repo add ig-private-podspec https://github.com/Interaction-Gaming/ig-private-podspec.git
```
Next, add the following line to your Podfile 
```ruby
pod 'LottoLog'
```

#### Now you're ready to 🏕️🌲🪓 **LottoLog** 💯💥🎉

## Usage

LottoLog offers a quick snappy way to log to several independant logging subsystems at various severity levels.

LottoLog uses StaticStrings formatted with C-Style VarArgs

```swift

let myLogArg = "world"

LottoLog.standard.info(msg: "Hello, %@!", args: myLogArg)
```

The above sample code yields `2019-12-05 16:40:06.141566-0500 LottoLog_Example[62978:4639174] [app] ℹ️ Hello, world!`

### Log Levels
 - Info  ℹ️
 - Debug 🐞🐛
 - Error ⚠️☠️⚠️
 - Standard (std)

### Available Subsystems 

######  STANDARD (app level)
- General use Logger

###### FLUX
- This is to be used for Flux Architecture logging. i.e, logging dispatched actions and their parameters

###### SCANNER
- To be used for the Ticket Scanner feature

###### NETWORK
- Used for network service logging

### Cloud Logging Callbacks
LottoLog offers the `LLCloudLoggerDelegate`, which recieves calbacks for logs to be logged in the cloud. This allows for Cloud log integrations without having any 3rd party SDKs as a part of LottoLog. Implement this protocol and pass the log to your cloud logging service of choice. This can be done in a few lines, in the App Delegate, or in any other class.

Let's walk through an example to make things clear.

```swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LLCloudLoggerDelegate {
    
    
    func cloudLog(msg: StaticString, args: CVarArg?) {
        let msg = String.init(format: "\(msg)", args ?? "")
        
        // FireBase Crashlytics logs
        CLSLogv(msg, args)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Assign self as the cloudLogDelegate
        // Cloud logging will not recieve callbacks if the delegate is not assigned
        LottoLog.cloudLogDelegate = self
        LottoLog.standard.info(msg: "Application %@", args: "Launched")
        return true
    }

    // Rest of App delegate below...
}
```

## Example App

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Author

ignkarman, noah.karman@interactiongaming.com

## License
Copyright © 2019 Interaction Gaming. All rights reserved.
