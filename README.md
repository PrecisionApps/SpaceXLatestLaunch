# SpaceXLatestLaunch



The project requires no extra steps to run on a simulator. To test it on a real device, be sure to change the Signing to your current team and change the bundleID accordingly


The ViewModel in the project contains "fetchLaunch" function for fetching the latest launches via "https://api.spacexdata.com/v4/launches/latest" url. To simplify testing, "fetchRandomLaunch" function has been added which uses "https://api.spacexdata.com/v4/launches/" and selects a random launch from the resulting array. Test configuration can be changed inside of the init of the same file.
