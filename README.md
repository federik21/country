# Country

A simple app that displays informations about each country.

## Getting Started

This project was developed with Version 11.2 (11B52) using Swift 5.0.

### Prerequisites

Lastest version of Xcode and an iOS 13.0 device.

### Installing

```
Sync the pods
Open the workspace
Select Product List from Targets
Open General tab
Select a valid team
In the Signing Section, check automatically manage signing
Launch the app in the simulator or device
```

## Approach
This project was developed following MVVM architecture. Files are grouped by :

###ViewControllers
This group contains the view controllers. The main responsability of this layer is databinding and managing lifecycle of the screen.

###Entities
Rappresents the Model layer.

###Manager
This group contains the domain logic  (i.e: server communication). 

###Utilities
There are facility methods and extention.


## Built With

* [Alamofire](https://github.com/Alamofire/Alamofire) - Elegant HTTP Networking in Swift
* [Cocoapods](https://rometools.github.io/rome/) - Dependency Management

## Versioning
GIT

## Authors

* **Federico Piccirilli**
