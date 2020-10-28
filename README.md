# Saleforce Mobile SDK Demo of HealthKit Integration

This app is a sample application that demonstrates how data collected by Apple HealthKit can be integrated into Mobile SDK app and forwared to Salesforce Health Cloud into Care Observation object.

> IMPORTANT: This is the second part of the reqired setup, for required customizations of your HLS org please refer first to the following repository [here](https://github.com/ygavrylenko/healthkitdemo-sfdx.git).

<img src="images/HealthKitDemo-Measurements.png" height="250">
<img src="images/HealthKitDemo-Authorize.png" height="250">


# Setup Process

1. Clone this repository:

    ```
    git clone https://github.com/ygavrylenko/healthkitdemo.git
    cd healthkitdemo
    ```

1. Install Pod Dependencies (like Salesforce mobile SDK):

    ```
    ./install.js
	```

1. Open Workspace project from toor folder

    ```
    SFHealthKitDemoApp.xcworkspace
    ```

1. Go to **/Supporting Files/bootconfig.plist and add following entries (if already exist just fill the values):

> IMPORTANT: From the Part 1 you extracted **CONSUMER KEY** from connected app "HealthKitDemo Mobile App" 

    ```
    remoteAccessConsumerKey --> "REPLACE_WITH_CONSUMER_KEY"
    oauthRedirectURI --> "patientapp://auth/success"
    oauthScopes --> "offline_access, refresh_token,api" //3 entries, see image below
    ```

<img src="images/bootconfig.png">

1. Go to **/Supporting Files/Info.plist and add following entry (take the patient community endpoint from Part 1):

    ```
    SFDCOAuthLoginHost --> "sdodemo-main-COMMUNITYURL.force.com/anotherpath"
    ```

 1. Now you are good to go! 
 - Choose your emulator or your iPhone as a target (you have to specify develpment team if you use real iPhone)
 - build the project, your demo application starts now
 - you should also see some tasks for your patient on the first tab, retrieved from the org, if some exist
 - you should see communty log-in window, enter credentials of your communty patient (e.g. for Charles Green)
 - Before you start, close applicaton and enter some values in your HealthKit (you can do it manually)
 - click on the tab in the middle, you should see the values from HealthKit
 - click on arrow button in order to synchronize the data to health cloud
 - change to health cloud, now you should see the measurements as CareObservation objects in related list! 

