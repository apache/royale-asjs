/**
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

goog.provide('org_apache_flex_net_HTTPService');

goog.require('org_apache_flex_core_HTMLElementWrapper');
goog.require('org_apache_flex_net_HTTPHeader');



/**
 * @constructor
 * @extends {org_apache_flex_core_HTMLElementWrapper}
 */
org_apache_flex_net_HTTPService = function() {
  org_apache_flex_net_HTTPService.base(this, 'constructor');

  /**
   * @private
   * @type {?string}
   */
  this.url_ = null;

  /**
   * @private
   * @type {number}
   */
  this.status_ = -1;

  /**
   * @private
   * @type {string}
   */
  this.method_ = 'GET';

  /**
   * @private
   * @type {Array}
   */
  this.headers_ = null;

  /**
   * @private
   * @type {Array}
   */
  this.responseHeaders_ = null;

  /**
   * @private
   * @type {?string}
   */
  this.responseURL_ = null;

  /**
   * @private
   * @type {Array.<Object>}
   */
  this.beads_ = null;

  /**
   * @private
   * @type {number}
   */
  this.timeout_ = 0;

  /**
   * @private
   * @type {?string}
   */
  this.contentData_ = null;

  /**
   * @private
   * @type {string}
   */
  this.contentType_ = 'application/x-www-form-urlencoded';

  /**
   * @private
   * @type {?string}
   */
  this.id_ = null;

  //try { // (erikdebruin) 'desperate' attempt to bypass XDR security in IE < 10
  //  this.contentType_ = 'text/plain';
  //  this.element = new XDomainRequest();
  //} catch (e) {}

  this.element = new XMLHttpRequest();
};
goog.inherits(org_apache_flex_net_HTTPService,
    org_apache_flex_core_HTMLElementWrapper);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_net_HTTPService.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'HTTPService',
                qName: 'org_apache_flex_net_HTTPService'}] };


/**
 * @expose
 * @type {string}
 */
org_apache_flex_net_HTTPService.HTTP_METHOD_GET = 'GET';


/**
 * @expose
 * @type {string}
 */
org_apache_flex_net_HTTPService.HTTP_METHOD_POST = 'POST';


/**
 * @expose
 * @type {string}
 */
org_apache_flex_net_HTTPService.HTTP_METHOD_PUT = 'PUT';


/**
 * @expose
 * @type {string}
 */
org_apache_flex_net_HTTPService.HTTP_METHOD_DELETE = 'DELETE';


Object.defineProperties(org_apache_flex_net_HTTPService.prototype, {
    /** @expose */
    beads: {
        /** @this {org_apache_flex_net_HTTPService} */
        set: function(value) {
            this.beads_ = value;
        }
    },
    /** @expose */
    data: {
        /** @this {org_apache_flex_net_HTTPService} */
        get: function() {
            return this.element.responseText;
        }
    },
    /** @expose */
    contentData: {
        /** @this {org_apache_flex_net_HTTPService} */
        get: function() {
            return this.contentData_;
        },
        /** @this {org_apache_flex_net_HTTPService} */
        set: function(value) {
            this.contentData_ = value;
        }
    },
    /** @expose */
    contentType: {
        /** @this {org_apache_flex_net_HTTPService} */
        get: function() {
            return this.contentType_;
        },
        /** @this {org_apache_flex_net_HTTPService} */
        set: function(value) {
            this.contentType_ = value;
        }
    },
    /** @expose */
    headers: {
        /** @this {org_apache_flex_net_HTTPService} */
        get: function() {
            if (this.headers_ === undefined) {
              this.headers_ = [];
            }

            return this.headers_;
        },
        /** @this {org_apache_flex_net_HTTPService} */
        set: function(value) {
            this.headers_ = value;
        }
    },
    /** @expose */
    method: {
        /** @this {org_apache_flex_net_HTTPService} */
        get: function() {
            return this.method_;
        },
        /** @this {org_apache_flex_net_HTTPService} */
        set: function(value) {
            this.method_ = value;
        }
    },
    /** @expose */
    responseHeaders: {
        /** @this {org_apache_flex_net_HTTPService} */
        get: function() {
            var allHeaders, c, hdr, i, n, part1, part2;

            if (typeof this.responseHeaders_ === 'undefined') {
              allHeaders = this.element.getAllResponseHeaders();
              this.responseHeaders_ = allHeaders.split('\n');
              n = this.responseHeaders_.length;
              for (i = 0; i < n; i++) {
                hdr = this.responseHeaders_[i];
                c = hdr.indexOf(':');
                part1 = hdr.substring(0, c);
                part2 = hdr.substring(c + 2);
                this.responseHeaders_[i] =
                    new org_apache_flex_net_HTTPHeader(part1, part2);
              }
            }
            return this.responseHeaders_;
        }
    },
    /** @expose */
    responseURL: {
        /** @this {org_apache_flex_net_HTTPService} */
        get: function() {
            return this.responseURL_;
        }
    },
    /** @expose */
    status: {
        /** @this {org_apache_flex_net_HTTPService} */
        get: function() {
            return this.status_;
        }
    },
    /** @expose */
    timeout: {
        /** @this {org_apache_flex_net_HTTPService} */
        get: function() {
            return this.timeout_;
        },
        /** @this {org_apache_flex_net_HTTPService} */
        set: function(value) {
            this.timeout_ = value;
        }
    },
    /** @expose */
    url: {
        /** @this {org_apache_flex_net_HTTPService} */
        get: function() {
            return this.url_;
        },
        /** @this {org_apache_flex_net_HTTPService} */
        set: function(value) {
            this.url_ = value;
        }
    },
    /** @expose */
    id: {
        /** @this {org_apache_flex_net_HTTPService} */
        get: function() {
            return this.id_;
        },
        /** @this {org_apache_flex_net_HTTPService} */
        set: function(value) {
            if (this.id_ !== value) {
              this.id_ = value;
              this.dispatchEvent('idChanged');
            }
        }
    },
    /** @expose */
    MXMLDescriptor: {
        /** @this {org_apache_flex_net_HTTPService} */
        get: function() {
            return null;
        }
    },
    /** @expose */
    MXMLProperties: {
        /** @this {org_apache_flex_net_HTTPService} */
        get: function() {
            return null;
        }
    }
});


/**
 * @expose
 */
org_apache_flex_net_HTTPService.prototype.send = function() {
  var contentData, header, i, n, sawContentType, url;

  if (this.strand == null && this.beads_) {
    var m = this.beads_.length;
    for (var j = 0; j < m; j++) {
      this.addBead(this.beads_[j]);
    }
  }

  this.element.onreadystatechange = goog.bind(this.progressHandler, this);

  url = this.url_;

  contentData = null;
  if (this.contentData_ !== undefined) {
    if (this.method_ === org_apache_flex_net_HTTPService.HTTP_METHOD_GET) {
      if (url.indexOf('?') !== -1) {
        url += this.contentData_;
      } else {
        url += '?' + this.contentData_;
      }
    } else {
      contentData = this.contentData_;
    }
  }

  this.element.open(this.method_, this.url_, true);
  this.element.timeout = this.timeout_;

  sawContentType = false;
  if (this.headers_) {
    n = this.headers_.length;
    for (i = 0; i < n; i++) {
      header = this.headers_[i];
      if (header.name === org_apache_flex_net_HTTPHeader.CONTENT_TYPE) {
        sawContentType = true;
      }

      this.element.setRequestHeader(header.name, header.value);
    }
  }

  if (this.method_ !== org_apache_flex_net_HTTPService.HTTP_METHOD_GET &&
      !sawContentType && contentData) {
    this.element.setRequestHeader(
        org_apache_flex_net_HTTPHeader.CONTENT_TYPE, this.contentType_);
  }

  if (contentData) {
    this.element.setRequestHeader('Content-length', contentData.length);
    this.element.setRequestHeader('Connection', 'close');
    this.element.send(contentData);
  } else {
    this.element.send();
  }
};


/**
 * @protected
 */
org_apache_flex_net_HTTPService.prototype.progressHandler = function() {
  if (this.element.readyState === 2) {
    this.status_ = this.element.status;
    this.dispatchEvent('httpResponseStatus');
    this.dispatchEvent('httpStatus');
  } else if (this.element.readyState === 4) {
    this.dispatchEvent('complete');
  }
};


/**
 * @param {Object} document The MXML object.
 * @param {string} id The id for the instance.
 */
org_apache_flex_net_HTTPService.prototype.setDocument = function(document, id) {
  this.document = document;
};
