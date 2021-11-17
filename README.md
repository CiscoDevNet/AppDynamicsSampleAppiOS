# AppDynamics Sample App README



## License

This code is licensed under the Cisco Sample Code License.
Please see LICENSE.txt for more information.



## Overview

---------------------------------------------------------------

The AppDynamics iOS Sample App contains a selection of examples
demonstrating how an iOS mobile app is instrumented with the 
AppDynamics iOS Agent.

After installing the requirements and adding an App Key from
your Controller, you can:

- Build and run the Sample App.

- Explore the UI in the Sample App to see examples and code 
  snippets, which helps you learn how to instrument your own
  app. 
  
- Use the running Sample App to generate events and look at
  the logs in the Xcode Console, which helps you verify and 
  understand the way instrumentation works.

- View the results that show up in the AppDynamics Controller
  UI, which helps you see how events in the Sample App are 
  reflected in the Controller.


## Who Can Use the Sample App

Anyone can use the Sample App to test and demo AppDynamics
mobile instrumentation features. However, you must have access
to an AppDynamics Controller and have some knowledge of Xcode.


## Requirements

---------------------------------------------------------------

To use this Sample App, you will need the following development
tools:

- Xcode 11 or later

To install Xcode, download it from the Mac App Store.
Alternatively, if you need a different version of Xcode,
visit the Downloads page on https://developer.apple.com/ .
  
- Cocoapods

To install cocoapods, use `sudo gem install cocoapods`.
  


## Getting Started

---------------------------------------------------------------

1. Clone or download the Sample App project from GitHub:

    $ git clone https://github.com/CiscoDevNet/AppDynamicsSampleAppiOS

2. Use cocoapods to add the AppDynamics iOS Agent:

    $ cd AppDynamicsSampleApp
    $ pod install

3. If open, close the Sample App project in Xcode. Then re-open
   the project using AppDynamicsSampleApp.xcworkspace instead
   of AppDynamicsSampleApp.xcodeproj.

4. Get an App Key from your Controller:

   a. In the Controller, go to User Experience
   b. Under the Mobile Apps tab, click Add App
   c. Select iOS
   d. In the Getting Started Wizard > Step 3, select Auto
      Generate App Key
   e. In the Getting Started Wizard > Step 5, copy the
      generated App Key that is shown in the
      ADEumInstrumentationto.initWithKey() snippet.

5. Get the collector and screenshot URLs. To find the URLs for your
   region, see:

       [SaaS Domains and IP Ranges](https://docs.appdynamics.com/display/PAA/SaaS+Domains+and+IP+Ranges)

6. With the project open in Xcode, edit the AppDelegate.swift source
   file to add the App Key, collector URL, and screenshot URL in the
   places indicated by the markers inside that file.

To use the Sample App, build the project in Xcode and run it on the
iOS Simulator (You could also run it on an iOS device, but you may
get more use out of it for copying and pasting code examples if you
run it in the Simulator. See the section "Copy Sample App Code into
Your App" below.)

Features are organized into categories such as "Networking" or
"Error Conditions." Once the Sample App is running, there are
several ways to use it:

* Discover instrumentation features with sample code
* Copy the sample code into your iOS app
* Try features to exercise instrumentation
* Inspect instrumentation logs in the Xcode Console
* See instrumentation results in your AppDynamics Controller.

Each of these are covered in the sections below.


### Discover Instrumentation Features with Sample App Code

Exploring the Sample App will let you discover 
instrumentation features and view and read about sample code.

Each feature shows an event being tracked in the Sample App.
For example, when you tap on the View Controller transition
tracking feature, it invokes a View Controller transition,
which causes the iOS Agent to track the event and generate a 
"beacon" for the event. For this transition tracking feature, 
the "View Code" button for brings up a code snippet showing
code (if any code is needed) that activates the feature.

In some cases, the code snippets in the Sample App also contain
code comments for more context. In many cases, if your app uses
AppDynamics' auto-instrumentation of the iOS Agent, no code is
needed, so the code snippet will contain comments explaining
this, including other related information.


### Copy Sample App Code into Your App

You can also copy and paste the Sample App code into your app
to use instrumentation features.

To copy a Sample App snippet, you should first be running the
Sample App in the iOS Simulator. That way the snippet will be put
on the macOS system pasteboard, and can then be pasted into
your own app project in Xcode.

Once the Sample App snippet is in your app project, some changes
may be required to match the context of your app. It is up to you
to determine for each case whether the snippet needs to be
changed and how to do so, but the snippet should give you a good
starting point.


### Xcode Console Panel Overview

You can use the Xcode Console panel to learn about or verify
instrumentation packets by viewing logs in the Xcode Console as
the Sample App runs.

Xcode will often open the Xcode Console panel (along the bottom
side of the Xcode app window) automatically when you run an
app. If it doesn't, you can open the Xcode Console by accessing
the Xcode menu item View -> Debug Area -> Activate Console.
  
After you have followed the instructions above to instrument
and run the Sample App, logs from the instrumentation will show
up in the Xcode Console panel during any runs of the app where
the app is tethered to Xcode (any runs where the app is
running under Xcode control).

By contrast, if you did not launch the Sample App from Xcode,
but simply launched it by tapping on the icon in the home screen
of the Simulator or on an iOS device, then this usage scenario
will not apply, and no instrumentation logs will appear in
Xcode.

The value of running under Xcode control here is twofold:

1. You can see the instrumentation logs in the Xcode Console,
which can help build your understanding of how the
instrumentation works.

2. The logs can also be used as a debugging or
verification tool to see what instrumentation logs look like
in the instrumented Sample App, which you can then compare
with your own instrumented app and check for any discrepancies.
Note that the instrumentation behavior may vary depending on
the iOS Agent version, the configuration options passed into the
iOS Agent at initialization time, the choice of which features
were instrumented, and the path of execution for
each run.


### Controller Usage Overview

Once you have instrumented the Sample App with your App Key
and subsequently run the app, you can visit your Controller to see
the the results of instrumentation.

1. In your Controller, go to User Experience.
2. In the Mobile Apps tab, find the App Key.
3. Click on AppDSampleAppiOS.

The Mobile App dashboard will populate with session activity.
Since event beacons are only sent on a periodic interval, you
can expect some delay before events show up in your Controller.

