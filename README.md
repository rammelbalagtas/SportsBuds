# SportsBuds
SportsBuds is an iOS mobile application which allows a user to view and participate in different sporting events nearby his/her location. Along with this, the user also has the capability to create and organize his/her own sporting event which other users may join to.

### Technologies/Framework used:
- Swift
  - UIKit
  - Mapkit
- ASP.Net Web API (for the backend)
- Azure SQL Database (to store application data)
- Azure Blob Storage (to store image files)
- Azure App Service (to host the web API)
- Firebase Authentication

### Wiring Diagram

![UML Activity Diagram sample - Page 9](https://user-images.githubusercontent.com/22863383/163407214-3af67e37-d8ba-4cfb-9383-b039398773f8.png)

## User Classes and Use Cases
### Sports Event Organizer/Host
A Sports Organizer is someone who can create a post regarding a specific sporting event.

#### Use cases:
- Create a sports event post
- View own listing of sports events
- Update sports event information
- Delete sports event posting

## Sports Enthusiast
A Sports Enthusiast is someone interested in joining a sports event.

#### Use cases:
- View listing of sports event
- Filter list of sports events
- View details of sports event
- Add a sports event to Favorites list
- Remove a sports event from Favorites list
