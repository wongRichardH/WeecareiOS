# weecare-ios-challenge

A client has an idea for an application but all that's been provided is the following description and mockup:

```
I want an app where you can see the best music albums from iTunes. It 
should have a modern design. They should also be able to sort the albums.
I tried to make the app myself but I am too busy. Recently released albums 
should also be noted. Thanks.

For reference here is the api we are using: https://rss.itunes.apple.com/en-us
```
![](./docs/mockup.jpeg)

Your task is to checkout the provided code and provide a submission that accomplishes the features the client is requesting. Beyond the functional requirements, we will also be considering the following areas (among others) of code quality:

- Architectures & Frameworks
- SOLID Principles
- File Structure
- Naming Conventions
- Bugfixes & Improvements
- Testing

If you have any questions, don't hesitate to email them to your contact at WeeCare. Treat this task as an opportunity to showcase your iOS, engineering, and design strengths. If you want to incorporate a design pattern or multi-module project, go for it! Similarly, if you see a compelling case for more functionality or a more refined design, go ahead and make those improvements. At the same time, we understand you're busy and expect no more than few hours spent on this submission.


-------------------------------------------------
UPDATE Sept. 28, 2021 - RICHARD WONG
-------------------------------------------------

Overall, very fun project!

Would love to discuss with you further about some of the tradeoffs and ideas using this flavor of MVVM structure.
I definitely learned some things and it helped challenge my ideas of what "flavor" of MVVM best suits a project.
I think this project satisfies the client's constraints in their ticket.

Notable changes:
1. Created viewmodel class for main ViewController "TopAlbumsViewController" to help dictate tableview population
2. Multiple extensions for convenience + organization down the road: date conversion, common UI tweaks, constants file/
3. Attempted modernization 


Below I'll note a few things I would love to discuss further 
1. Opinions on ViewModel vs ViewController responsibilities in MVVM - specifically: Network layer responsibility inside Viewmodel  vs. network call from ViewController
2. Creating ViewModels for "lower" level views. eg. Are viewmodels for TableView cells overkill or necessary when obeying archiecture philosophy?

and things I would love to work on more given time:
1. Dedicated drop down menu for filter options instead of using bar items inside of UINavigation
2. Dynamic height calculation for cells


-------------------------------------------------
UPDATE Sept. 29, 2021 - RICHARD WONG
-------------------------------------------------

- Made UI more similar to design specs
- Removed unused files
- Added dropdown filter class to improve previous bar button items
