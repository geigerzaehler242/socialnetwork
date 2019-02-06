# socialnetwork challenge project for League

this project uses carthage as a package manager instead of cocopods as it is superior tool

1) ensure carthage is installed

this link has the details:

https://github.com/Carthage/Carthage

otherwise use this command:

brew install carthage

2) the cartfile exists in the project with dependencies included already. just run the update

carthage update


3) deviations to the design

a)
since the API doesn't seem to allow to download only one photo from an album a deviation was made in the design to just show album title on the cell instead of a photo. Otherwise downloading full photo collections to just show the first photo image on each cell is a potential huge bandwidth issue.a proper solution is for the api to allow for downloading jsut one image per call.

b)
i added the ability to swipe left/right on the photo to traverse the album photos when a user opens an album
