(function() {
  var NodeHTTP, root;
  root = typeof exports !== "undefined" && exports !== null ? exports : window;
  root.Flattr = (function() {
    function Flattr(options) {
      this.options = options != null ? options : {};
      this.api_endpoint = "https://api.flattr.com/rest/v2";
      if (this.options.client === 'NodeHTTP') {
        this.client = new NodeHTTP();
      } else if (typeof this.options.client === 'object') {
        this.client = this.options.client;
      }
    }
    Flattr.prototype.thingsByUser = function(username, count, page, callback) {
      var endpoint, parameters;
      if (arguments.length === 3) {
        callback = page;
        page = null;
      } else if (arguments.length === 2) {
        callback = count;
        page = null;
        count = null;
      }
      endpoint = "" + this.api_endpoint + "/users/" + username + "/things";
      parameters = {};
      if (count) {
        parameters.count = count;
      }
      if (count) {
        parameters.page = page;
      }
      return this.client.get(endpoint, parameters, callback);
    };
    Flattr.prototype.currentUsersThings = function(callback) {
      var headers;
      if (!this.options.access_token) {
        callback({
          error: 'missing_access_token'
        });
      }
      headers = {
        "Authorization": "Bearer " + this.options.access_token
      };
      return this.client.get("" + this.api_endpoint + "/user/things", null, headers, callback);
    };
    Flattr.prototype.thing = function(id, callback) {
      var endpoint, headers;
      headers = {};
      if (this.options.access_token) {
        headers = {
          "Authorization": "Bearer " + this.options.access_token
        };
      }
      endpoint = "" + this.api_endpoint + "/things/" + id;
      return this.client.get(endpoint, null, headers, callback);
    };
    Flattr.prototype.things = function(ids, callback) {
      var endpoint, parameters;
      endpoint = "" + this.api_endpoint + "/things";
      parameters = {
        id: ids.join(',')
      };
      return this.client.get(endpoint, parameters, headers, callback);
    };
    Flattr.prototype.lookup = function(url, callback) {
      var endpoint, parameters;
      endpoint = "" + this.api_endpoint + "/things/lookup";
      parameters = {
        url: url
      };
      return this.client.get(endpoint, parameters, callback);
    };
    Flattr.prototype.search = function(options, callback) {
      var endpoint;
      endpoint = "" + this.api_endpoint + "/things/search";
      if ((options.tags != null) && options.tags.constructor === Array) {
        options.tags = options.tags.join(' & ');
      }
      if ((options.categories != null) && options.categories.constructor === Array) {
        options.categories = options.categories.join(',');
      }
      return this.client.get(endpoint, options, callback);
    };
    Flattr.prototype.userFlattrs = function(username, count, page, callback) {
      var endpoint, parameters;
      if (arguments.length === 3) {
        callback = page;
        page = null;
      } else if (arguments.length === 2) {
        callback = count;
        page = null;
        count = null;
      }
      endpoint = "" + this.api_endpoint + "/users/" + username + "/flattrs";
      parameters = {};
      if (page) {
        parameters.page = page;
      }
      if (count) {
        parameters.count = count;
      }
      return this.client.get(endpoint, parameters, callback);
    };
    Flattr.prototype.thingFlattrs = function(id, count, page, callback) {
      var endpoint, parameters;
      if (arguments.length === 3) {
        callback = page;
        page = null;
      } else if (arguments.length === 2) {
        callback = count;
        page = null;
        count = null;
      }
      endpoint = "" + this.api_endpoint + "/things/" + id + "/flattrs";
      parameters = {};
      if (page) {
        parameters.page = page;
      }
      if (count) {
        parameters.count = count;
      }
      return this.client.get(endpoint, parameters, callback);
    };
    Flattr.prototype.currentUsersFlattrs = function(callback) {
      var headers;
      if (!this.options.access_token) {
        callback({
          "error": "missing_access_token"
        }, null);
      }
      headers = {
        "Authorization": "Bearer " + this.options.access_token
      };
      return this.client.get("" + this.api_endpoint + "/user/flattrs", null, headers, callback);
    };
    Flattr.prototype.flattrThing = function(id, callback) {
      var endpoint, options;
      if (!this.options.access_token) {
        callback({
          "error": "missing_access_token"
        }, null);
      }
      options = {
        headers: {
          "Authorization": "Bearer " + this.options.access_token
        }
      };
      endpoint = "" + this.api_endpoint + "/things/" + id + "/flattr";
      return this.client.post(endpoint, null, options, callback);
    };
    Flattr.prototype.flattrURL = function(url, username, callback) {
      var options, parameters;
      if (!this.options.access_token) {
        callback({
          "error": "missing_access_token"
        }, null);
      }
      options = {
        headers: {
          "Authorization": "Bearer " + this.options.access_token
        }
      };
      if (arguments.length === 2) {
        callback = username;
        username = true;
      }
      if (username) {
        url = "http://flattr.com/submit/auto?url=" + encodeURIComponent(url);
        url += "&user_id=" + encodeURIComponent(username);
      }
      parameters = {
        url: url
      };
      return this.client.post("" + this.api_endpoint + "/flattr", parameters, options, callback);
    };
    Flattr.prototype.user = function(username, callback) {
      var endpoint;
      endpoint = "" + this.api_endpoint + "/users/" + username;
      return this.client.get(endpoint, callback);
    };
    Flattr.prototype.currentUser = function(callback) {
      var headers;
      if (!this.options.access_token) {
        callback({
          "error": "missing_access_token"
        }, null);
      }
      headers = {
        "Authorization": "Bearer " + this.options.access_token
      };
      return this.client.get("" + this.api_endpoint + "/user", null, headers, callback);
    };
    Flattr.prototype.categories = function(callback) {
      return this.client.get("" + this.api_endpoint + "/categories", callback);
    };
    Flattr.prototype.languages = function(callback) {
      return this.client.get("" + this.api_endpoint + "/languages", callback);
    };
    Flattr.prototype.authenticate = function(scopes) {
      var p, parameters, queryparts, querystring, v;
      if (scopes == null) {
        scopes = [];
      }
      parameters = {
        response_type: 'code',
        client_id: this.options.key
      };
      if (scopes.length > 0) {
        parameters.scope = scopes.join(' ');
      }
      queryparts = [];
      for (p in parameters) {
        v = parameters[p];
        queryparts.push(encodeURIComponent(p) + '=' + encodeURIComponent(v));
      }
      querystring = queryparts.join('&');
      return "http://flattr.com/oauth/authorize?" + querystring;
    };
    Flattr.prototype.getAccessToken = function(code, callback) {
      var endpoint, options, parameters;
      options = {
        auth: "" + this.options.key + ":" + this.options.secret
      };
      parameters = {
        code: code,
        grant_type: "authorization_code",
        redirect_uri: "http://127.0.0.1:1337"
      };
      endpoint = "https://flattr.com/oauth/token";
      return this.client.post(endpoint, parameters, options, callback);
    };
    return Flattr;
  })();
  NodeHTTP = (function() {
    function NodeHTTP() {
      this.http = require('https');
      this.url = require('url');
      this.q = require('querystring');
    }
    NodeHTTP.prototype.get = function(endpoint, parameters, headers, callback) {
      var options, querystring, req, urlParts;
      if (arguments.length === 3) {
        callback = headers;
        headers = null;
      } else if (arguments.length === 2) {
        callback = parameters;
        headers = null;
        parameters = null;
      }
      urlParts = this.url.parse(endpoint);
      querystring = parameters ? '?' + this.q.stringify(parameters) : '';
      options = {
        host: urlParts.host,
        path: urlParts.path + querystring,
        port: 443,
        method: 'GET',
        headers: headers
      };
      return req = this.http.get(options, function(res) {
        var data;
        data = '';
        res.on('data', function(chunk) {
          return data += chunk;
        });
        res.on('end', function() {
          return callback(null, JSON.parse(data));
        });
        return res.on('error', function(error) {
          return callback(error, null);
        });
      });
    };
    NodeHTTP.prototype.post = function(endpoint, parameters, options, callback) {
      var postData, request, urlParts;
      if (arguments.length === 3) {
        callback = options;
        options = {};
      } else if (arguments.length === 2) {
        callback = parameters;
        options = {};
        parameters = {};
      }
      urlParts = this.url.parse(endpoint);
      postData = parameters ? this.q.stringify(parameters) : '';
      options.host = urlParts.host;
      options.path = urlParts.path;
      options.port = 443;
      options.method = 'POST';
      options.headers = options.headers || {};
      options.headers['Content-Type'] = 'application/x-www-form-urlencoded';
      options.headers['Content-Length'] = postData.length;
      request = this.http.request(options, function(res) {
        var data;
        data = '';
        res.setEncoding('utf8');
        res.on('data', function(chunk) {
          return data += chunk;
        });
        res.on('end', function() {
          return callback(null, JSON.parse(data));
        });
        return res.on('error', function(error) {
          return callback(error, null);
        });
      });
      request.write(postData);
      return request.end();
    };
    return NodeHTTP;
  })();
}).call(this);
