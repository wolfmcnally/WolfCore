To build WolfCore from the Linux command line:

```
# cd <directory with Package.swift>
# swift build
```

To use WolfCore from the Linux REPL:

```
# swift -I /usr/lib/swift/clang/include -I .build/debug -L .build/debug -lWolfCore

Welcome to Swift version 3.1 (swift-3.1-RELEASE). Type :help for assistance.
1> import WolfCore
2> SHA256.test()
35fb7cc2337d10d618a1bad35c7a9e957c213f00d0ed32f2454b2a99a971c0d8
true
```
