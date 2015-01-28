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


/**
 * @expose
 * @param {Array.<Object>} value The array of beads.
 */
org_apache_flex_net_HTTPService.prototype.set_beads = function(value) {
  this.beads_ = value;
};


/**
 * @expose
 * @return {string} value The data.
 */
org_apache_flex_net_HTTPService.prototype.get_data = function() {
  return this.element.responseText;
};


/**
 * @expose
 * @return {?string} value The contentData.
 */
org_apache_flex_net_HTTPService.prototype.get_contentData = function() {
  return this.contentData_;
};


/**
 * @expose
 * @param {string} value The contentData.
 */
org_apache_flex_net_HTTPService.prototype.set_contentData = function(value) {
  this.contentData_ = value;
};


/**
 * @expose
 * @return {string} value The contentType.
 */
org_apache_flex_net_HTTPService.prototype.get_contentType = function() {
  return this.contentType_;
};


/**
 * @expose
 * @param {string} value The contentType.
 */
org_apache_flex_net_HTTPService.prototype.set_contentType = function(value) {
  this.contentType_ = value;
};


/**
 * @expose
 * @return {Array} value The array of HTTPHeaders.
 */
org_apache_flex_net_HTTPService.prototype.get_headers = function() {
  if (this.headers_ === undefined) {
    this.headers_ = [];
  }

  return this.headers_;
};


/**
 * @expose
 * @param {Array} value The array of HTTPHeaders.
 */
org_apache_flex_net_HTTPService.prototype.set_headers = function(value) {
  this.headers_ = value;
};


/**
 * @expose
 * @return {string} value The method.
 */
org_apache_flex_net_HTTPService.prototype.get_method = function() {
  return this.method_;
};


/**
 * @expose
 * @param {string} value The method.
 */
org_apache_flex_net_HTTPService.prototype.set_method = function(value) {
  this.method_ = value;
};


/**
 * @expose
 * @return {Array} value The array of HTTPHeaders.
 */
org_apache_flex_net_HTTPService.prototype.get_responseHeaders = function() {
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
};


/**
 * @expose
 * @return {?string} value The url.
 */
org_apache_flex_net_HTTPService.prototype.get_responseURL = function() {
  return this.responseURL_;
};


/**
 * @expose
 * @return {number} value The status.
 */
org_apache_flex_net_HTTPService.prototype.get_status = function() {
  return this.status_;
};


/**
 * @expose
 * @return {number} value The timeout.
 */
org_apache_flex_net_HTTPService.prototype.get_timeout = function() {
  return this.timeout_;
};


/**
 * @expose
 * @param {number} value The timeout.
 */
org_apache_flex_net_HTTPService.prototype.set_timeout = function(value) {
  this.timeout_ = value;
};


/**
 * @expose
 * @return {?string} value The url.
 */
org_apache_flex_net_HTTPService.prototype.get_url = function() {
  return this.url_;
};


/**
 * @expose
 * @param {string} value The url to fetch.
 */
org_apache_flex_net_HTTPService.prototype.set_url = function(value) {
  this.url_ = value;
};


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
 * @expose
 * @type {?string}
 */
org_apache_flex_net_HTTPService.prototype.id = null;


/**
 * @expose
 * @return {?string} The id.
 */
org_apache_flex_net_HTTPService.prototype.get_id = function() {
  return this.id;
};


/**
 * @expose
 * @param {string} value The new id.
 */
org_apache_flex_net_HTTPService.prototype.set_id = function(value) {
  if (this.id !== value) {
    this.id = value;
    this.dispatchEvent('idChanged');
  }
};


/**
 * @expose
 * @return {Array} The array of descriptors.
 */
org_apache_flex_net_HTTPService.prototype.get_MXMLDescriptor = function() {
  return null;
};


/**
 * @expose
 * @return {Array} The array of properties.
 */
org_apache_flex_net_HTTPService.prototype.get_MXMLProperties = function() {
  return null;
};


/**
 * @param {Object} document The MXML object.
 * @param {string} id The id for the instance.
 */
org_apache_flex_net_HTTPService.prototype.setDocument = function(document, id) {
  this.document = document;
};


/**
 * @expose
 * @param {Object} value The strand.
 */
org_apache_flex_net_HTTPService.prototype.set_strand = function(value) {
  if (this.strand_ !== value) {
    this.strand_ = value;
  }
  var n = this.beads_ ? this.beads_.length : 0;
  for (var i = 0; i < n; i++) {
    this.addBead(this.beads_[i]);
  }
};
