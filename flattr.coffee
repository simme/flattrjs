#
# # FlattrJS
#
# JavaScript client for accessing the Flattr API.
#
# See the [Flattr API Docs](http://developers.flattr.net/api/)
# for API documentation.
#

root = exports ? window

class root.Flattr

  #
  # ## _function_ constructor(@options)
  #
  # Setup the client to access Flattr.
  #
  constructor: (@options = {}) ->
    @api_endpoint = "https://api.flattr.com/rest/v2"

    if @options.accessToken?
      @isAuthorized = true

    if @options.client == 'NodeHTTP'
      @client = new NodeHTTP()

# ---------------------------------------------------------------------------

  #
  # # Things
  #
  # Functions for interacting with the **things** resource.
  #

  #
  # ## _function_ thingsByUser(username[, count, page], callback)
  #
  # Returns things by the specified user.
  #
  # No **authentication** required.
  #
  thingsByUser: (username, count, page, callback) ->
    if arguments.length == 3
      callback = page;
      page = null
    else if arguments.length == 2
      callback = count
      page = null
      count = null

    endpoint = "#{@api_endpoint}/users/#{username}/things"
    parameters = {}
    parameters.count = count if count
    parameters.page  = page  if count
    @client.get endpoint, parameters, callback

  #
  # ## _function_ thing(id, callback)
  #
  # Returns one single thing with the given _id_.
  #
  thing: (id, callback) ->
    headers = {}
    if @options.access_token
      headers =
        "Authorization": "Bearer #{@options.access_token}"

    endpoint = "#{@api_endpoint}/things/#{id}"
    @client.get endpoint, null, headers, callback

  #
  # ## _function_ things(ids, callback)
  #
  # Takes an array of `ids` and fetches things with those IDs.
  #
  # No **authentication** required.
  #
  things: (ids, callback) ->
    endpoint = "#{@api_endpoint}/things"
    parameters =
      id: ids.join(',')

    @client.get endpoint, parameters, headers, callback

  #
  # ## _function_ lookup(url, callback)
  #
  # Checks if the given _url_ is registred as a thing.
  #
  # No **authentication** required.
  #
  lookup: (url, callback) ->
    endpoint = "#{@api_endpoint}/things/lookup"
    parameters =
      url: url

    @client.get endpoint, parameters, callback

  #
  # ## _function_ search(query, options, callback)
  #
  # * `options` on object containing search parameters.
  #   * `query` is the string to search for.
  #   * `url` filter search results by their URL
  #   * `tags` either an array of tags to include or a string in the format
  #     described in the [Flattr API Docs](http://developers.flattr.net/api/resources/things/#search-things).
  #   * `language` filter by language.
  #   * `category` the name of a category to filter by, or an array with
  #     multiple categories.
  #   * `user` filter by username.
  #   * `sort` sort by _trend_, _flattrs_ (all time), _flattrs\_month_,
  #     _flattrs\_week_, _relevance_ (default).
  #   * `page` page to return.
  #   * `count` number of results per page.
  #
  # No **authentication** required.
  #
  search: (options, callback) ->
    endpoint = "#{@api_endpoint}/things/search"

    if options.tags? && options.tags.constructor == Array
      options.tags = options.tags.join(' & ')

    if options.categories? && options.categories.constructor == Array
      options.categories = options.categories.join(',')

    @client.get endpoint, options, callback

# ---------------------------------------------------------------------------

  #
  # # Flattrs
  #
  # Functions for interacting with the **flattrs** resource.
  #

  #
  # ## _function_ userFlattrs(username, count, page, callback)
  #
  # List a user's flattrs.
  #
  userFlattrs: (username, count, page, callback) ->
    if arguments.length == 3
      callback = page;
      page = null
    else if arguments.length == 2
      callback = count
      page = null
      count = null

    endpoint = "#{@api_endpoint}/users/#{username}/flattrs"
    parameters = {}
    parameters.page  = page if page
    parameters.count = count if count
    @client.get endpoint, parameters, callback

  #
  # ## _function_ thingFlattrs(id, count, page, callback)
  #
  # List a thing's flattrs.
  #
  thingFlattrs: (id, count, page, callback) ->
    if arguments.length == 3
      callback = page;
      page = null
    else if arguments.length == 2
      callback = count
      page = null
      count = null

    endpoint = "#{@api_endpoint}/things/#{id}/flattrs"
    parameters = {}
    parameters.page  = page if page
    parameters.count = count if count
    @client.get endpoint, parameters, callback

  #
  # ## _function_ currentUsersFlattrs(callback)
  #
  # Retrieve the current users flattrs.
  #
  currentUsersFlattrs: (callback) ->
    if not @options.access_token
      callback {"error": "missing_access_token"}, null

    headers =
      "Authorization": "Bearer #{@options.access_token}"

    @client.get "#{@api_endpoint}/user/flattrs", null, headers, callback

  #
  # ## _function_ flattrThing(id, callback)
  #
  # Flattr the given thing.
  #
  # **Requires authentication with scope _flattr_**
  #
  flattrThing: (id, callback) ->
    if not @options.access_token
      callback {"error": "missing_access_token"}, null

    options =
      headers:
        "Authorization": "Bearer #{@options.access_token}"

    endpoint = "#{@api_endpoint}/things/#{id}/flattr"

    @client.post endpoint, null, options, callback

  #
  # ## _function_ flattrURL(url, username, callback)
  #
  # Flattr the given URL. If the URL is not already associated with a thing
  # in the Flattr database this won't work without supplying a username.
  #
  # Set `username` to false if you don't want to use the auto submit
  # functionality to flattr URLs that do not match a thing.
  #
  # **Requires authentication with scope _flattr_**
  #
  flattrURL: (url, username, callback) ->
    if not @options.access_token
      callback {"error": "missing_access_token"}, null

    options =
      headers:
        "Authorization": "Bearer #{@options.access_token}"

    if arguments.length == 2
      callback = username
      username = true

    if username
      url = "http://flattr.com/submit/auto?url=" + encodeURIComponent url
      url += "&user_id=" + encodeURIComponent username

    parameters =
      url: url

    @client.post "#{@api_endpoint}/flattr", parameters, options, callback

# ---------------------------------------------------------------------------

  #
  # # Users
  #
  # Functions for interacting with the **users** resource.
  #

  #
  # ## _function_ user(username, callback)
  #
  # Get information for the user with the given username.
  #
  user: (username, callback) ->
    endpoint = "#{@api_endpoint}/users/#{username}"

    @client.get endpoint, callback

  #
  # ## _function_ currentUser(callback)
  #
  # Get information for the currently authorized user. Requires an access
  # token from Flattr.
  #
  currentUser: (callback) ->
    if not @options.access_token
      callback {"error": "missing_access_token"}, null

    headers =
      "Authorization": "Bearer #{@options.access_token}"

    @client.get "#{@api_endpoint}/user", null, headers, callback

# ---------------------------------------------------------------------------

  #
  # # Categories
  #
  # Functions for interacting with the **categories** resource.
  #

  #
  # ## _function_ categories(callback)
  #
  # Return a list of all available categories.
  #
  categories: (callback) ->
    @client.get "#{@api_endpoint}/categories", callback

# ---------------------------------------------------------------------------

  #
  # # Languages
  #
  # Functions for interacting with the **languages** resource.
  #

  #
  # ## _function_ languages(callback)
  #
  # Get a list of available languages
  languages: (callback) ->
    @client.get "#{@api_endpoint}/languages", callback

# ---------------------------------------------------------------------------

  #
  # # Auhtorization helpers
  #
  # Helpers for authorizing your app.
  #

  #
  # ## _function_ authenticate(scopes = [])
  #
  # Generates a URL that you need to redirect your user to. The user will
  # then be asked by Flattr to authorize your app. Once the user has
  # authorized your app he or she will be redirect to the URL you've,
  # specified in your Flattr app settings.
  #
  # Flattr will send a `code` parameter together with the redirect. You will
  # need to give that code to the `getAccessToken` function below.
  #
  # You will need to intialize your _Flattr API Client_ with a client `key`
  # for this function to work.
  #
  # For more information checkout the [docs](http://developers.flattr.net/api/#authenticate).
  #
  authenticate: (scopes = []) ->
    parameters =
      response_type: 'code'
      client_id: @options.key

    if scopes.length > 0
      parameters.scopes = scopes.join ' '

    queryparts = []
    for p, v of parameters
      queryparts.push encodeURIComponent(p) + '=' + encodeURIComponent(v)

    querystring = queryparts.join '&'

    return "http://flattr.com/oauth/authorize?#{querystring}"

  #
  # ## _function_ getAccessToken(code, callback)
  #
  # Generate an `access_token` from the `code` returned from Flattr.
  #
  getAccessToken: (code, callback) ->
    options =
      auth: "#{@options.key}:#{@options.secret}"

    parameters =
      code: code
      grant_type: "authorization_code"
      redirect_uri: "http://127.0.0.1:1337"

    endpoint = "https://flattr.com/oauth/token"
    @client.post endpoint, parameters, options, callback


# ---------------------------------------------------------------------------

#
# # HTTP Client plugins.
#
# The HTTP client plugins all follow a simple pattern. Methods named after
# the different HTTP methods `get`, `post`, etc. The method takes four
# arguments:
#
# * Endpoint
#
#   Endpoint URL string.
#
# * Parameters
#
#   Parameters to accompany the request. **POST** and **GET** data etc.
#
# * Options
#
#   HTTP headers to send with the request and other fun stuff.
#
# * Callback
#
#   A callback that takes two arguments, `error` and `data`.
#

#
# # NodeJS HTTP client
#
# Serverside client based on the NodeJS HTTP client.
#
class NodeHTTP
  constructor: () ->
    @http = require 'https'
    @url  = require 'url'
    @q    = require 'querystring'

  #
  # ## _function_ get(endpoint, [parameters, headers], callback)
  #
  # Wraps the HTTP get request method.
  #
  get: (endpoint, parameters, headers, callback) ->
    if arguments.length == 3
      callback = headers
      headers = null
    else if arguments.length == 2
      callback = parameters
      headers = null
      parameters = null

    urlParts = @url.parse endpoint
    querystring = if parameters then '?' + @q.stringify parameters else ''

    options =
      host: urlParts.host
      path: urlParts.path + querystring
      port: 443
      method: 'GET'
      headers: headers

    req = @http.get options, (res) ->
      data = ''
      res.on 'data', (chunk) ->
        data += chunk

      res.on 'end', () ->
        callback null, JSON.parse data

      res.on 'error', (error) ->
        callback error, null

  #
  # ## _function_ post(endpoint, [parameters, options], callback)
  #
  # Wraps the HTTP post request method.
  #
  post: (endpoint, parameters, options, callback) ->
    if arguments.length == 3
      callback = options;
      options = {}
    else if arguments.length == 2
      callback = parameters
      options = {}
      parameters = {}

    urlParts = @url.parse endpoint
    postData = if parameters then @q.stringify parameters else ''

    options.host = urlParts.host
    options.path = urlParts.path
    options.port = 443
    options.method = 'POST'
    options.headers = options.headers or {}

    options.headers['Content-Type'] = 'application/x-www-form-urlencoded'
    options.headers['Content-Length'] = postData.length

    request = @http.request options, (res) ->
      data = ''
      res.setEncoding 'utf8'
      res.on 'data', (chunk) ->
        data += chunk

      res.on 'end', () ->
        callback null, JSON.parse data

      res.on 'error', (error) ->
        callback error, null

    request.write postData
    request.end()
