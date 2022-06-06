# Clean Architecture with RxSwift

# Requirements
 1. Cocoapods
 2. Xcode 13.3.1

# Installation

 1. Clone project
 2. cd path_to_project_folder
 3. pod install
 4. open AppetiserInterview.xcworkspace
 5. Build & Run

# Functionalities

 1. Movies list: Display movies that is fetched from [api](https://itunes.apple.com/search?term=star&country=au&media=movie&;all) and saved to local storage.
 2. Movie detail:  Display detailed about a movie.
 3. Favorites: Add movies to Favorites, display favorited movie in Favorites screen.
 4. Offline mode: Datas are stored in local storage. User can use all app's features without internet connection.

# Tech stack

 1. Clean Architecture
 2. Design pattern: MVVM-C (Model-View-ViewModel-Coordinator)
 3. Dependency manager: Cocoapods
 4. Dependency Injection: Resolver
 5. Coding languages: Swift, RxSwift
 6. Network calls using URLSession
 7. Libraries: UIKit, RxSwift, RxCocoa, RxDatasources, RxGesture, XCoordinator, RealmSwift, Kingfisher, SnapKit, Resolver, ReachabilitySwift

## Clean Architecture
![enter image description here](https://blog.cleancoder.com/uncle-bob/images/2012-08-13-the-clean-architecture/CleanArchitecture.jpg)
 - Divide the app into different layers. Each has at least one layer for business rules, and another for interfaces.
     - Independent of frameworks: The architecture does not depend on the existence of some library of feature laden software. This allows you to use such frameworks as tools, rather than having to cram your system into their limited constraints.
     - Testable. The business rules can be tested without the UI, Database, Web Server, or any other external element.
     - Independent of UI. The UI can change easily, without changing the rest of the system. A Web UI could be replaced with a console UI, for example, without changing the business rules.
     - Independent of Database. You can swap out Oracle or SQL Server, for Mongo, BigTable, CouchDB, or something else. Your business rules are not bound to the database.
     - Independent of any external agency. In fact your business rules simply don’t know anything at all about the outside world.

- Disadvantages: Lots of files. The number of layers will increase for each function.

## MVVM-C (Model-View-ViewModel-Coordinator)
![enter image description here](https://github.com/nannymcphee/clean-architecture-rx-swift/blob/main/images/mvvmc.jpg?raw=true)
### Coordinator
#### Overview
Coordinator is a object that handle app's navigation.
Coordinator's responsibilities:

- Initialize ViewControllers & ViewModels
- Inject dependencies into ViewControllers & ViewModels
- Present/push ViewControllers
- Handle Events between screens (passing data,...)

#### Why Coordinator?

- If we don't use Coordinator, ViewController will have to handle navigation itself. A ViewController should only display UI elements and handle user's controls. All navigation should be handled by another Object.

#### Disadvantages

 - Hard to understand
 - Have to create a lot of files

### MVVM
#### Advantages

 - ViewController doesn't contains logic, just display UI based on ViewModel
 - ViewModel is UIKit independent and fully testable
 - Data binding: Datas are kept in sync.

#### Disadvantages

 - Needs to create a lot of files: ViewControllers, ViewModels and binding them all together
 - Communication between various components and data binding can be painful

## Dependency Injection: [Resolver](https://github.com/hmlongco/Resolver)


Dependency Injection frameworks support the  [Inversion of Control](https://en.wikipedia.org/wiki/Inversion_of_control)  design pattern. Technical definitions aside, dependency injection pretty much boils down to:

|  **Giving an object the things it needs to do its job.**

That's it. Dependency injection allows us to write code that's loosely coupled, and as such, easier to reuse, to mock, and to test.

#### Types
-   Constructor Injection: Injecting dependencies through constructors or initializers.
-   Method Injection: Injecting dependencies through methods.
-   Property Injection: Injecting dependencies through properties.
-   Annotation Injection: Resolver uses  `@Injected`  as a property wrapper to inject dependencies.

#### Advantages

 - By injecting the dependencies of an object, the responsibilities and requirements of a class or structure become more clear and more transparent. By injecting a request manager into a view controller, we understand that the view controller **depends** on the request manager _and_ we can assume that the view controller is responsible for request managing and/or handling.
 - Dependency injection makes it very easy to replace an object's dependencies with mock objects, making unit tests easier to set up and isolate behavior.

#### Disadvantages

 - I don't see any disadvantages of Dependency Injection
 
### Networking: URLSession
URLSession is the key object responsible for sending and receiving requests.
Alamofire and URLSession both help us to make network requests in Swift. The URLSession API is part of the foundation framework, whereas Alamofire needs to be added as an external dependency. Personally, I always try to use as few third party libraries as possible, so I choose to use URLSession over Alamofire for api requests.

## [RxSwift](https://github.com/ReactiveX/RxSwift)

#### Advantages:
 - Asynchrony is simplified with Declarative Code
 - Multithreading is simplified
 - Cleaner code
 - Multi-platform

#### Disadvantages:

 - Hard to learn
 - Hard to debug
 - May cause **memory leaks** if not used carefully

## Local database: [Realm](https://github.com/realm/realm-swift)
I have experience working with Realm, so I choose to use it in this coding challenge.

### Advantages

 - Fast and lightweight
 - Simple to start and scale
 - Built-in mobile to cloud sync
 - Cross-platform support

### Disadvantages

 - Don't support multi-threading

# Persistence flow:
 - Datas are fetched from both local storage and API:
     - Save default data from [json file](https://itunes.apple.com/search?term=star&country=au&media=movie&;all) if needed (only save once)
     - Fetch from local first, then fetch from API
     - If API failed => display local datas
     - If API success => save to local database => Display to UI
 - If user launches app with or without internet connection, they can still use the app offline (Go through Movies List, Movie Detail, Add/remove movies to/from Favorites)
 - User's last visited screen's index and time are stored in UserDefaults
