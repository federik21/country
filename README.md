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
This project follows MVP architecture. Files are grouped by :


###View
The main responsability of this layer is databinding and managing lifecycle of the screen, and how the data is displayed to the user.

###Presenter
Connects the View and the model.

###Model
Contains and loads the data.

###Domain
This group contains the network communication layer.

## Built With

* [SVGKit](https://github.com/SVGKit/SVGKit/) - Cocoa framework for rendering SVG files natively
* [Cocoapods](https://rometools.github.io/rome/) - Dependency Management

## Versioning
GIT

## Authors

* **Federico Piccirilli**
