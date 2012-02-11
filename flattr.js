(function() {
  var NodeHTTP, root;
  root = typeof exports !== "undefined" && exports !== null ? exports : window;
  root.Flattr = (function() {
    function Flattr(options) {
      this.options = options != null ? options : {};
      this.api_endpoint = "https://api.flattr.com/rest/v2";
      if ((this.options.key != null) && (this.options.secret != null)) {
        this.canAuthorize = true;
      }
      if (this.options.accessToken != null) {
        this.isAuthorized = true;
      }
      if (this.options.client === 'NodeHTTP') {
        this.client = new NodeHTTP();
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
    Flattr.prototype.thing = function(id, callback) {
      var endpoint;
      endpoint = "" + this.api_endpoint + "/things/" + id;
      return this.client.get(endpoint, callback);
    };
    Flattr.prototype.things = function(ids, callback) {
      var endpoint, parameters;
      endpoint = "" + this.api_endpoint + "/things";
      parameters = {
        id: ids.join(',')
      };
      return this.client.get(endpoint, parameters, callback);
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
    Flattr.prototype.user = function(username, callback) {
      var endpoint;
      endpoint = "" + this.api_endpoint + "/users/" + username;
      return this.client.get(endpoint, callback);
    };
    Flattr.prototype.categories = function(callback) {
      return this.client.get("" + this.api_endpoint + "/categories", callback);
    };
    Flattr.prototype.languages = function(callback) {
      return this.client.get("" + this.api_endpoint + "/languages", callback);
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
      var options, querystring, urlParts;
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
      console.log(options);
      return this.http.get(options, function(res) {
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
    return NodeHTTP;
  })();
}).call(this);
