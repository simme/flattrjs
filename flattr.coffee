#
# # FlattrJS
#
# JavaScript client for accessing the Flattr API.
#
# See (flattr.net)[http://developers.flattr.net/api/] for API documentation.
#
# * Request functionality
#   HTTP client to fetch and post data from Flattr. Needs to be pluggable to
#   support both browser and server environment.
#
# * Authorization
#   Authorization helpers.
#
# * Flattrs
#
#   Implementation of the Flattrs resource.
#
# * Things
#
#   Implementation of the Things resource.
#
# * Users
#
#   Implementation of the Users resource.
#
# * Activities
#
#   Implementation of the Activities resource.
#
# * Categories
#
#   Implementation of the Categories resource.
#
# * Languages
#
#   Implementation of the Language resource.
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

    # If we got a key and secret we are able to authorize
    if @options.key? and @options.secret?
      @canAuthorize = true

    # If we got an access token we are already authorized
    if @options.accessToken?
      @isAuthorized = true

    # Get our HTTP client
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
    endpoint = "#{@api_endpoint}/things/#{id}"
    @client.get endpoint, callback

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

    @client.get endpoint, parameters, callback

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
  #     described on (Flattr API Docs)[http://developers.flattr.net/api/resources/things/#search-things].
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

    # Merge tags to a single string, defaults to the & operator.
    if options.tags? && options.tags.constructor == Array
      options.tags = options.tags.join(' & ')

    # Concatenate categories
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
# HTTP Client plugins.
#
# The HTTP client plugins all follow a simple pattern. Methods named after
# the different HTTP methods `get`, `post`, etc. The method takes four
# arguments:
#
# * Endpoint
#
#   The url string of the endpoint, *exluding https://api.flattr.com/rest/v2*.
#
# * Parameters
#
#   Parameters to accompany the request. **POST** and **GET** data etc.
#
# * Arguments
#
#   Headers 'n stuff.
#
# * Callback
#
#   A callback that takes to arguments, `error` and `data`.
#

#
# # NodeJS HTTP client
#
class NodeHTTP
  constructor: () ->
    @http = require 'https'
    @url  = require 'url'
    @q    = require 'querystring'

  #
  # _function_ get(endpoint, [parameters, headers], callback)
  #
  # Wraps the HTTP get request method.
  #
  get: (endpoint, parameters, headers, callback) ->
    if arguments.length == 3
      callback = headers;
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

    console.log options

    @http.get options, (res) ->
      data = ''
      res.on 'data', (chunk) ->
        data += chunk

      res.on 'end', () ->
        callback null, JSON.parse data

      res.on 'error', (error) ->
        callback error, null


