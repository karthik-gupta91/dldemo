# dldemo

To display the list of deliveries retrieved from API. Each delivery contains the customer photo and location description. Each delivery can be clicked to display the location & details of customer on the map.

## Requirements

iOS 10.0+ 
Xcode 10.2+
Swift 5+

## Installation

* Download the project.Unarchive the file
* Open Terminal 
* Install Cocoapods by using following command - $ sudo gem install cocoapods
* Now open project directory in terminal by using this command :- cd "Folder-Path"
* Run 'pod install' command in terminal
* Go to project folder. Open 'dldemo.xcworkspace' file on xcode.
* Run the project in any iPhone Simulator. 

## Code Style

This repository is written in swift 5 (latest swift version) and architecture design used is based on VIPER(View,Interactor,Presenter,Entity/Model,Router). Caching is implemented using CoreData. 

## Why VIPER?

- Easy to iterate on
- Collaboration friendly
- Separated out concerns
- Spec-ability

### VIPER diagram overview
![](/assets/viper_diagram.png)
### Description:
* View is responsible for receiving user actions, for example: pull to refresh, scroll to bottom, did select row and update view.
* Presenter is responsible to ask interactor for fetching data online or offline, responsible to update the delivery list view and responsible to tell router to do transition to delivery detail view.
* Interactor is responsible for fetching the data online from server and offline from coredata and notify the presenter with updated result.
* Router is responsible to present delivery detail view with data.
* Entity is responsible for decoding the data from network and coredata and provide the usable data to interactor.

## Assumptions

### Views assumption- offline
* Delivery List Screen: App should show offline page when cache not available otherwise should fetch 20 deliveries from stored data and display it. scroll to bottom should fetch another 20 deliveries if available otherwise show network error. pull to refresh should not change any data. 
* Detail List Screen: App should show location description and profile image, but map should not load.

### Views assumption- online
* Delivery List Screen: App should fetch 20 deliveries from network and display it, if error occured it should fetch data from cache or display error, in case no cache available. scroll to bottom should fetch another 20 deliveries from network otherwise show network error. pull to refresh should show new deliveries available on server by refreshing the list. 
* Detail List Screen: App should show location detail,marker on map, location description and profile image.

### Data assumption for cache
* Data should be saved on the basis of "id". if an object is already present with the same "id" in cache, app should update that object, otherwise save it. Deletion of data should not be implemented for now.
* Fetching of online and offline data should be based on offset and limit.


## Implementations

### Case: Application Launched first time
* Scenerio 1: Network offline - offline view will be shown, when network become active, use pull to refresh to retrieve the list of 20 deliveries.
* Scenerio 2: Network online - App will try to retrieve the data from online, In case of success list will be shown on the screen, if it fails, Offline view will be shown & user will have to use pull to refresh in order to try retrieving list again. Once list is recieved it will automatically be saved in the cache for future purposes.

### Case: Application Launched In future.
* Scenerio 1: Network offline - Try to retrieve the list from cache or show banner error in case it fails.
* Scenerio 2: Network online - App will try to retrieve the data from online and show it on the screen, if it fails it will try to fetch the data from cache or show banner error in case it fails.

### Case: User scroll down
* Scenerio 1: Network offline - App will try to retrieve list from cache,if it fails will show banner error.
* Scenerio 2: Network online - App will try to retrieve another list of 20 deliveries, In case it fails it will try to retrieve the list according to offset from cache or show error in case it fails.

### Case: User use pull to refresh
* Scenerio 1: Network offline - Nothing will happen
* Scenerio 2: Network online - App will to try to retrieve new list of 20 deliveries with offset zero and replace the old list with the new one.

### Case: Delivery clicked
* Scenerio 1: Network offline - Location detail will be shown. Exact location will not be display on map.
* Scenerio 2: Network online - Location detail & exact loocation will be shown on map.

## Screenshots
![delivery_detail_view](https://user-images.githubusercontent.com/37572470/68192028-bd912100-ffd6-11e9-9737-06d6c4d81732.PNG)
![delivery_list_view](https://user-images.githubusercontent.com/37572470/68192029-bd912100-ffd6-11e9-86b8-01cb3e9b242f.PNG)
![network_offline](https://user-images.githubusercontent.com/37572470/68192030-be29b780-ffd6-11e9-8eac-d73b64ce459d.PNG)
![no_more_data](https://user-images.githubusercontent.com/37572470/68192033-be29b780-ffd6-11e9-856b-1f0c06511c01.PNG)
![pull_to_refresh](https://user-images.githubusercontent.com/37572470/68192035-bec24e00-ffd6-11e9-9b29-44df7a50570b.PNG)
![scroll_to_bottom](https://user-images.githubusercontent.com/37572470/68192037-bec24e00-ffd6-11e9-972f-57920b6df781.PNG)

## Running the tests

Unit test cases are implemented without using any framework. Mock classes are written in order to execute the test cases for different test files. Saving the information in local variable(InputCallbackResults) of Mock classes in order to verify/assert the case.

### Execution of test cases
* CMD+U to run test cases
* CMD+9 to check the code coverage, Logs

```
For Example:

private var interactor: DeliveryListInterator!
private var mockPresenter: MockDLPresenter!
private var mockClient: MockRemoteClient!
private var mockCdProtocol: MockCDProtocol!

override func setUp() {
    self.mockPresenter = MockDLPresenter()
    self.mockClient = MockRemoteClient()
    self.mockCdProtocol = MockCDProtocol()
    self.interactor = DeliveryListInterator(networkService: mockClient, presenter: mockPresenter, cdProtocol: mockCdProtocol)
}

func testFetchDataOfflineWhenDataFetchingError() {
    self.mockCdProtocol.list = nil
    self.interactor.fetchOfflineCache(Constants.INTIAL_OFFSET_VALUE, Constants.FETCH_LIMIT)
    XCTAssertEqual(self.mockPresenter.inputCallbackResults[TestConstants.ERROR_KEY]?.description, AppError.coreDataError.errorDescription)
}

```
### Explanation of test cases
* Arrange - First we are setting up our main test file. In order to test the interator class we need to mainly interact with Network,Coredata & Presenter. we have mocked these test classes or their protocol for testing purpose.In the first line of test case, we are overriding the list of deliveries we are fetching from coredata to check offline cache method. 

* Act - Finally we are calling our method under test.

* Assert - Verifying if presenter method got a call on fetch delivery error method of mock class by checking the variable set in that method.


## Libraries Used
* 'Alamofire' - For network call and fetching data.
* 'AlamofireImage' - For image caching.
* 'ReachabilitySwift' - To check network connectivity.
* 'GoogleMaps' - To display location on maps.
* 'NotificationBannerSwift' - To display error or notify user of local events.
* 'Fabric/Crashlytics' - To log any crash from users.

