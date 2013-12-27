# Ushahidi iOS #

Ushahidi is an open source platform for democratizing information, increasing transparency and lowering the barriers for individuals to share their stories. 

The iPhone and iPad app synchronizes with any Ushahidi deployment allowing viewing and creation of incident reports on the go. 

The app supports loading of multiple deployments at one time, quick filtering through incident reports, exploring incident locations on the map, viewing incident photos, videos, news article, media as well as sharing incident reports via email, SMS, Twitter, Facebook or QRCode. 

Once the data has been downloaded, the app can function without an internet connection, allowing accurate collection of data utilizing the device's camera and GPS capabilities.

* [About](http://www.ushahidi.com)
* [Repository](http://github.com/ushahidi/Ushahidi_iPhone)
* [Issues](https://github.com/ushahidi/ushahidi_iphone/issues)
* [Documentation](http://wiki.ushahidi.com/display/WIKI/Public+API)
* [Translations](https://www.transifex.com/projects/p/ushahidi-ios/)

### Old Repository ###
The old Ushahidi iOS 2.X code repository can be found at [Ushahidi iOS 2.X](https://github.com/ushahidi/Ushahidi_iPhone/Old)

### Using The SDK ###
Including the Ushahidi SDK in your own project allows you to create your own custom app that synchronizes with an Ushahidi deployment.

* Add Ushahidi.framework into your project
* Add Ushahidi.bundle into your project
* Add libraries marked as Required: Foundation.framework, UIKit.framework, CoreFoundation.framework, CoreGraphics.framework, CoreData.framework, CoreLocation.framework, MobileCoreServices.framework, MapKit.framework, MessageUI.framework, QuartzCore.framework, Security.framework, SystemConfiguration.framework
* Add libraries marked as Optional: FacebookSDK.framework, Twitter.framework, Accounts.framework, Social.framework, AdSupport.framework
* Add linked library marked as Optional: libsqlite3.0.dylib

### How To White-Label ###
Whitelabeling the app allows you to quickly and easily create your own branded version of the app, with your own colors, graphics and pointing to your own map deployment. 

* Duplicate the Ushahidi target with the name of your map (ex MapATL)
* Right-click on your new target (ex MapATL) select Get Info > Build tab > rename Product Name to name of map without spaces (ex MapATL)
* Duplicate the /Themes/Ushahidi folder with the name of your map as folder name (ex /Themes/MapATL)
* In XCode, on your new theme folder (ex /Themes/MapATL) Right-Click > Get Info > Targets tab, uncheck Ushahidi and check your new target (ex MapATL)
* You can now customize your app by editing the following properties in Info.plist in your new Themes folder

##### Name and Identifier #####
* CFBundleIdentifier: unique identifier of your app (ex com.ushahidi.ios.mapatl)
* CFBundleName: title of your application (ex MapATL)
* CFBundleDisplayName: name of your application (ex MapATL)

##### Custom Map URL #####
* USHMapURL: URL for your map (ex http://crime.mapatl.com)
* USHMapURLS: leaving the USHMapURL blank, you can optionally define multiple maps in the USHMapURLS dictionary

##### Support Email and URL #####
* USHSupportEmail: support email for your deployment (ex crime@mapatl.com)
* USHSupportURL: website for your deployment (ex http://crime.mapatl.com)
* USHAppStoreURL: link on App Store to download your application (ex http://itunes.apple.com/app/ushahidi-ios/id410609585)
* USHAppDescription: sentence describing the application or the organization

##### Color Codes #####
* USHNavBarColor: color for navigation bar 
* USHTabBarColor: color for tab bar 
* USHToolBarColor: color for tool bar 
* USHSearchBarColor: color for search bar
* USHButtonDoneColor: color for done bar
* USHRefreshControlColor: color for refresh control
* USHTableBackColor: background color for tables
* USHTableRowColor: text color for header
* USHTableHeaderColor: text color for header
* USHTableSelectColor: background color of selected rows

##### Report Settings #####
* USHShowReportList: boolean flag whether to show the list/map of reports (disabling will prevent the downloading of reports)
* USHShowReportButton: boolean flag whether to show the new report button (disabling will prevent submitting new reports)
* USHSortReportsByDate: sort the report list by the report date

##### Optional URLs #####
Optionally you can define Privacy Policy and/or Terms Of Service URLs which require the user to visit before proceeding with the application.

* USHPrivacyPolicyURL: optional URL for privacy policy
* USHTermsOfServiceURL: optional URL for terms of service

##### Facebook App ID #####
Facebook will require you to register a new app at [Facebook Developers](https://developers.facebook.com/apps)

* FacebookAppID: identifier for your Facebook app
* CFBundleURLTypes: callback URL, update the CFBundleURLName value to fbXXXXXXXXXXXXXXX with your Facebook app id

##### YouTube Credentials #####
If you would like to publish videos under your own YouTube channel, you'll need to sign up for a [YouTube Developer Account](https://code.google.com/apis/youtube/dashboard/gwt/index.html).

* USHYouTubeUsername: Youtube login
* USHYouTubePassword: Youtube password
* USHYouTubeDeveloperKey: Youtube Developer Key

##### Custom Images #####
Replace each image in your theme folder with your own custom graphic, maintaining the image dimensions and filenames.

* Default.png: launch screen for iPhone 
* Default@2x.png: launch screen for iPhone with retina display
* Default-Portrait.png: launch screen for iPad 
* Default-Portrait@2x.png: launch screen for iPad with retina display
* Default-568h@2x.png: launch screen for iPad 5
* Icon-iPhone.png: app icon for iPhone 
* Icon-iPhone@2x.png: app icon for iPhone with retina display 
* Icon-iPad.png: app icon for iPad 
* Icon-iPad@2x.png: app icon for iPad with retina display
* Logo-iPhone.png: image in settings screen which links to USHSupportURL
* Logo-iPhone@2x.png: image in settings screen which links to USHSupportURL
* Logo-iPad.png: image on iPad in settings screen which links to USHSupportURL
* Logo-iPad@2x.png: image on iPad in settings screen which links to USHSupportURL
* Logo-Title.png: optional logo image in Nav Bar
* Logo-Title@2x.png: optional logo image in Nav Bar for retina display
* iTunesArtwork.png: artwork for the iTunes App Store

You should now be able to deploy your white-labelled version of the app to the Simulator for testing, enjoy!!