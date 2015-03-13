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

goog.provide('org_apache_flex_net_BinaryUploader');

goog.require('org_apache_flex_core_HTMLElementWrapper');
goog.require('org_apache_flex_net_HTTPHeader');



/**
 * @constructor
 * @extends {org_apache_flex_core_HTMLElementWrapper}
 */
org_apache_flex_net_BinaryUploader = function() {
  org_apache_flex_net_BinaryUploader .base(this, 'constructor');

  /**
   * @private
   * @type {string}
   */
  this.url_ = null;

  /**
   * @private
   * @type {Number}
   */
  this.status_ = -1;

  /**
   * @private
   * @type {string}
   */
  this.method_ = 'POST';

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
   * @type {string}
   */
  this.responseURL_ = null;

  /**
   * @private
   * @type {Number}
   */
  this.timeout_ = 0;

  /**
   * @private
   * @type {string}
   */
  this.binaryData_ = null;

  /**
   * @private
   * @type {string}
   */
  this.contentType_ = 'application/octet-stream';

  //try { // (erikdebruin) 'desperate' attempt to bypass XDR security in IE < 10
  //  this.contentType_ = 'text/plain';
  //  this.element = new XDomainRequest();
  //} catch (e) {}

  this.element = new XMLHttpRequest();
};
goog.inherits(org_apache_flex_net_BinaryUploader,
    org_apache_flex_core_HTMLElementWrapper);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_net_BinaryUploader.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'BinaryUploader',
                qName: 'org_apache_flex_net_BinaryUploader'}] };


/**
 * @expose
 * @type {string}
 */
org_apache_flex_net_BinaryUploader.HTTP_METHOD_GET = 'GET';


/**
 * @expose
 * @type {string}
 */
org_apache_flex_net_BinaryUploader.HTTP_METHOD_POST = 'POST';


/**
 * @expose
 * @type {string}
 */
org_apache_flex_net_BinaryUploader.HTTP_METHOD_PUT = 'PUT';


/**
 * @expose
 * @type {string}
 */
org_apache_flex_net_BinaryUploader.HTTP_METHOD_DELETE = 'DELETE';


Object.defineProperties(org_apache_flex_net_BinaryUploader.prototype, {
    'data': {
		get: function() {
            return this.element.responseText;
		}
	},
    'binaryData': {
		get: function() {
            return this.binaryData_;
		},
        set: function(value) {
            this.binaryData_ = value;
		}
	},
    'contentType': {
		get: function() {
            return this.contentType_;
		},
        set: function(value) {
            this.contentType_ = value;
		}
	},
    'headers': {
		get: function() {
            if (this.headers_ === 'undefined') {
              this.headers_ = [];
            }

            return this.headers_;
		},
        set: function(value) {
            this.headers_ = value;
		}
	},
    'method': {
		get: function() {
            return this.method_;
		},
        set: function(value) {
            this.method_ = value;
		}
	},
    'responseHeaders': {
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
    'responseURL': {
		get: function() {
            return this.responseURL_;
		}
	},
    'status': {
		get: function() {
            return this.status_;
		}
	},
    'timeout': {
		get: function() {
            return this.timeout_;
		},
        set: function(value) {
            this.timeout_ = value;
		}
	},
    'url': {
		get: function() {
            return this.url_;
		},
        set: function(value) {
            this.url_ = value;
		}
	},
    'id': {
		get: function() {
            return this.id;
		},
        set: function(value) {
            if (this.id !== value) {
              this.id = value;
              this.dispatchEvent('idChanged');
            }
		}
	},
    'MXMLDescriptor': {
		get: function() {
            return null;
		}
	},
    'MXMLProperties': {
		get: function() {
            return null;
		}
	}
});


/**
 * @expose
 */
org_apache_flex_net_BinaryUploader.prototype.send = function() {
  var binaryData, header, i, n, sawContentType, url;

  this.element.onreadystatechange = goog.bind(this.progressHandler, this);

  url = this.url_;

  binaryData = null;
  if (this.binaryData_ !== undefined) {
    if (this.method_ === org_apache_flex_net_BinaryUploader.HTTP_METHOD_GET) {
      if (url.indexOf('?') !== -1) {
        url += this.binaryData_.data;
      } else {
        url += '?' + this.binaryData_.data;
      }
    } else {
      binaryData = this.binaryData_.data;
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

  if (this.method_ !== org_apache_flex_net_BinaryUploader.HTTP_METHOD_GET &&
      !sawContentType && binaryData) {
    this.element.setRequestHeader(
        org_apache_flex_net_HTTPHeader.CONTENT_TYPE, this.binaryType_);
  }

  if (binaryData) {
    this.element.setRequestHeader('Content-length', binaryData.length);
    this.element.setRequestHeader('Connection', 'close');
    this.element.send(binaryData);
  } else {
    this.element.send();
  }
};


/**
 * @protected
 */
org_apache_flex_net_BinaryUploader.prototype.progressHandler = function() {
  if (this.element.readyState === 2) {
    this.status_ = this.element.status;
    this.dispatchEvent('httpResponseStatus');
    this.dispatchEvent('httpStatus');
  } else if (this.element.readyState === 4) {
    this.dispatchEvent('complete');
  }
};


/**
 * @expose
 * @type {string}
 */
org_apache_flex_net_BinaryUploader.prototype.id = null;


/**
 * @param {Object} document The MXML object.
 * @param {string} id The id for the instance.
 */
org_apache_flex_net_BinaryUploader.prototype.setDocument =
    function(document, id) {
  this.document = document;
};
