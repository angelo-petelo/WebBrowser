# NeevaWebBrowser

1. How To Run

a. Unzip the project folder

b. Open project folder

c. Look for "NeevaWebBrowser.xcodeproj" and open that file. This should open up Xcode.

d. Xcode should be open at this point, now select an iOS simulator. I suggest using a more recent one like the iPhone 13.

e. Now build and run the project. On initial build it may a take a while to load but it should load eventually.

When using the simulator, in order to search the user must use the simulator keyboard and hit search. Use Command + K to toggle the keyboard when needed.

2. Additional Implementations

I did not implement any other additional features other than the 2 parts of the requirements.

3. Approach

  For this project, I tried to separate in 3 parts: an individual tab, tab switcher, and bookmarks. I decided to work on the individual tab first because that is where I figured most of the work needed to be done, and also I had to familiarize myself with WKWebView. I figured once I get this part completed, inserting it into a tab switcher component and adding a bookmark feature would be fairly straightforward. 
  
  For my architecual approach, I decided to create a View Controller that would handle the Web View. I created a View Controller for a tab and this contained that Web View and also the tab logic. I wanted to separate these two Controllers because it made for more modularity rather combining these two in one Controller. I also made View Controller for each the tab switcher and bookmark for the same reason. 
  
  For my design approach for the individual tab, I displayed the search bar and refresh at the top and the navigation buttons and add tab button at the bottom. I felt like this is fairly standard in mobile browsers and it would probably be what the user is familiar with. For my design approaach for the tab switcher, i just displayed a simple table view that would be a list of all the current tabs. I did this because it is the most simple way I could think of the to display and allow users to select a tab. A tradeoff here would be that the user does not know the snapshot of the tab, only the current URL. For my design approach for the bookmarkss, I decided to present a screen that would display a table view of the bookmarked urls. In here, the user can add the current page they are at and also edit their bookmark list. I just felt like having all the bookmark functionality in one place would make it easier on the user.
  



