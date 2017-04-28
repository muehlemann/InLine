# InLine

InLine is a social network (currently only for iOS) that allows users to categorize the different relationships in their life through the user of branches. There are six branches (Fun, Friends & Family, Work Life, Food & Fitness, Love, Mind & Spirit), and when accepting follower requests you can categorize the user into the different branches restricting theri access. This allows for a less intrusive social experience and allows users to have deeper control over their social activity.

## Architecture

The overlying architecture for InLine is based on a client/server pattern where the mobile app is the client and an application program interface (API) will be running on the server. With this architecture, the querying of data and interaction of data is easily maintainable due to the URL patterns for the API. 

The iPhone and it's accompanied App Store where chosen for the client because they allow for rapid development, integrated beta testing, and a worldwide network for distribution. This will be an advantage in development because backwards compatibility and security vulnerabilities will not have to be taken into consideration. 

The server in the architecture diagram is running node.js and the express API with a MongoDB database. Node.js is a JavaScript runtime built on Google Chrome’s V8 JavaScript engine (Node.js). Node.js was chosen, over Ruby on Rails and PHP (which are other popular web server technologies), because of its asynchronous event driven I/O, which is very beneficial to completing concurrent requests. This speed, along with the easy scalability of Node.js, are very beneficial because as the InLine user base grows, scaling the web server will be a manageable task. Express, a very flexible but powerful framework, is part of the server architecture because it provides Node.js to have all features necessary to create an API. MongoDB is part of the server database component because it stores JSON objects in filestores. This makes MongoDB and Node.js work very well together because the stored data is already in a usable format when queried by Node.js. Although other databases like MySQL or CouchDB would also work with Node.js, MongoDB was chosen due to the fact that the data is already in a format which is easily interpreted by the JavaScript language. 

## Set Up

To set up InLine and make it work one first has to install and deploy the InLine server code (not public) on a Node.JS server with a mongoDB. Once that is establishd one has to download the InLine mobile app source code, exchange the server link, and deploy it onto a iOS device.