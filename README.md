Flattr API - JavaScript client
------------------------------

[![Flattr this git repo](http://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/submit/auto?user_id=simme&url=https://github.com/simme/flattrjs&title=FlattrJS&description=Flattr%20API%20client%20writtin%20in%20JavaScript&language=en_US&tags=flattr,javascript&category=software)

This is a JavaScript client for interacting with the Flattr API.

## Getting started

To get started you first need to [create an app](http://flattr.com/apps) on Flattr.

### NodeJS environment

To use _flattrjs_ in a node environment, use _npm_ to install it.

`npm install flattrjs` or preferably add it to your `package.json` file and
run `npm update`.

When `flattrjs` is installed you do something like this:

    Flattr = new require('flattrjs').Flattr({
      key: 'your_client_id_here'
    , secret: 'your_client_secret_here'
    , client: 'NodeHTTP' // Makes flattrjs use nodes HTTP module
    , access_token: 'current_users_access_token' // More on this below
    })

You can then use your brand new Flattr client to make requesrs to the Flattr
API.

    Flattr.thingsByUser('simme', function (err, response) {
      if (err) {
        throw err;
      }

      console.log response
    });

_All API methods_ takes a callback as it's last argument. This callback needs
to accept to parameters, `err` and `response`. The usual NodeJS pattern.

Check out the docs folder for in depth documentation on all of the available
methods. It's pretty well documented I'd like to think.

### In the Browser

Currently there is no HTTP client plugin for use in the browser. However
the interface for a client is very simple and writing one on top of jQuery
or any other library should be pretty easy.

Check out the implemented _NodeHTTP_ class for an example implementation.

The client needs two methods `get` and `post`.

#### `get(endpoint, options, headers, callback)`

Makes a good ol' HTTP get request. Parameters should be pretty self explanatory. It's the API endpoint, an object containing the GET-parameters, an object containing any additional headers that needs to be sent with the request (for authentication and stuff). And lastly a callback, this is the callback supplied to the Flattr client methods.

#### `post(endpoint, parameters, options, callback)`

Only difference from the GET-method is that headers is now called options. Options is an object that might contain a header property. This is because when authenticating a user basic auth parameters need to be sent.

## Authenticating

There's a couple of authentication helpers available.

### Flattr.authenticate(scopes)

Takes an array of scopes you wish to authenticate for. Returns a URL that you'll need to redirect your user to. The user will be sent to Flattr where he or she will be asked to authenticate your app. Once done the user will be redirected to the callback URL you specified in your app settings on Flattr.

Together with the redirect will be a code in the GET-parameter. You'll need to pass this to the next function!

### Flattr.getAccessToken(code, callback)

Posts the code to Flattr and if successfull calls your callback function with an access token to be used with the part of the API that requires authentication.

You will need to store this yourself, preferable in a secure manner. ;)

## Flattr API

For more information on the Flattr API itself, visit it's [documentation](http://developers.flattr.net/api/).
