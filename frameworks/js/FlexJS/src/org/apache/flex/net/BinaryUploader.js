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

goog.provide('org.apache.flex.net.BinaryUploader');

goog.require('org.apache.flex.core.HTMLElementWrapper');
goog.require('org.apache.flex.net.HTTPHeader');



/**
 * @constructor
 * @extends {org.apache.flex.core.HTMLElementWrapper}
 */
org.apache.flex.net.BinaryUploader = function() {
  goog.base(this);

  /**
   * @protected
   * @type {string}
   */
  this.url_;

  /**
   * @private
   * @type {Number}
   */
  this.status_;

  /**
   * @private
   * @type {string}
   */
  this.method_ = 'POST';

  /**
   * @private
   * @type {Array}
   */
  this.headers_;

  /**
   * @private
   * @type {Array}
   */
  this.responseHeaders_;

  /**
   * @private
   * @type {string}
   */
  this.responseURL_;

  /**
   * @private
   * @type {Number}
   */
  this.timeout_ = 0;

  /**
   * @private
   * @type {string}
   */
  this.binaryData_;

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
goog.inherits(org.apache.flex.net.BinaryUploader,
    org.apache.flex.core.HTMLElementWrapper);


/**
 * @expose
 * @type {string}
 */
org.apache.flex.net.BinaryUploader.HTTP_METHOD_GET = 'GET';


/**
 * @expose
 * @type {string}
 */
org.apache.flex.net.BinaryUploader.HTTP_METHOD_POST = 'POST';


/**
 * @expose
 * @type {string}
 */
org.apache.flex.net.BinaryUploader.HTTP_METHOD_PUT = 'PUT';


/**
 * @expose
 * @type {string}
 */
org.apache.flex.net.BinaryUploader.HTTP_METHOD_DELETE = 'DELETE';


/**
 * @expose
 * @this {org.apache.flex.net.BinaryUploader}
 * @return {string} value The data.
 */
org.apache.flex.net.BinaryUploader.prototype.get_data = function() {
  return this.element.responseText;
};


/**
 * @expose
 * @this {org.apache.flex.net.BinaryUploader}
 * @return {org.apache.flex.utils.BinaryData} value The binary Data.
 */
org.apache.flex.net.BinaryUploader.prototype.get_binaryData = function() {
  return this.binaryData_;
};


/**
 * @expose
 * @this {org.apache.flex.net.BinaryUploader}
 * @param {org.apache.flex.utils.BinaryData} value The binary Data.
 */
org.apache.flex.net.BinaryUploader.prototype.set_binaryData = function(value) {
  this.binaryData_ = value;
};


/**
 * @expose
 * @this {org.apache.flex.net.BinaryUploader}
 * @return {string} value The contentType.
 */
org.apache.flex.net.BinaryUploader.prototype.get_contentType = function() {
  return this.contentType_;
};


/**
 * @expose
 * @this {org.apache.flex.net.BinaryUploader}
 * @param {string} value The contentType.
 */
org.apache.flex.net.BinaryUploader.prototype.set_contentType = function(value) {
  this.contentType_ = value;
};


/**
 * @expose
 * @this {org.apache.flex.net.BinaryUploader}
 * @return {Array} value The array of HTTPHeaders.
 */
org.apache.flex.net.BinaryUploader.prototype.get_headers = function() {
  if (this.headers_ === 'undefined') {
    this.headers_ = [];
  }

  return this.headers_;
};


/**
 * @expose
 * @this {org.apache.flex.net.BinaryUploader}
 * @param {Array} value The array of HTTPHeaders.
 */
org.apache.flex.net.BinaryUploader.prototype.set_headers = function(value) {
  this.headers_ = value;
};


/**
 * @expose
 * @this {org.apache.flex.net.BinaryUploader}
 * @return {string} value The method.
 */
org.apache.flex.net.BinaryUploader.prototype.get_method = function() {
  return this.method_;
};


/**
 * @expose
 * @this {org.apache.flex.net.BinaryUploader}
 * @param {string} value The method.
 */
org.apache.flex.net.BinaryUploader.prototype.set_method = function(value) {
  this.method_ = value;
};


/**
 * @expose
 * @this {org.apache.flex.net.BinaryUploader}
 * @return {Array} value The array of HTTPHeaders.
 */
org.apache.flex.net.BinaryUploader.prototype.get_responseHeaders = function() {
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
          new org.apache.flex.net.HTTPHeader(part1, part2);
    }
  }
  return this.responseHeaders_;
};


/**
 * @expose
 * @this {org.apache.flex.net.BinaryUploader}
 * @return {string} value The url.
 */
org.apache.flex.net.BinaryUploader.prototype.get_responseURL = function() {
  return this.responseURL_;
};


/**
 * @expose
 * @this {org.apache.flex.net.BinaryUploader}
 * @return {Number} value The status.
 */
org.apache.flex.net.BinaryUploader.prototype.get_status = function() {
  return this.status_;
};


/**
 * @expose
 * @this {org.apache.flex.net.BinaryUploader}
 * @return {Number} value The timeout.
 */
org.apache.flex.net.BinaryUploader.prototype.get_timeout = function() {
  return this.timeout_;
};


/**
 * @expose
 * @this {org.apache.flex.net.BinaryUploader}
 * @param {Number} value The timeout.
 */
org.apache.flex.net.BinaryUploader.prototype.set_timeout = function(value) {
  this.timeout_ = value;
};


/**
 * @expose
 * @this {org.apache.flex.net.BinaryUploader}
 * @return {string} value The url.
 */
org.apache.flex.net.BinaryUploader.prototype.get_url = function() {
  return this.url_;
};


/**
 * @expose
 * @this {org.apache.flex.net.BinaryUploader}
 * @param {string} value The url to fetch.
 */
org.apache.flex.net.BinaryUploader.prototype.set_url = function(value) {
  this.url_ = value;
};


/**
 * @expose
 * @this {org.apache.flex.net.BinaryUploader}
 */
org.apache.flex.net.BinaryUploader.prototype.send = function() {
  var contentData, header, i, n, sawContentType, url;

  this.element.onreadystatechange = goog.bind(this.progressHandler, this);

  url = this.url_;

  binaryData = null;
  if (this.binaryData_ !== undefined) {
    if (this.method_ === org.apache.flex.net.BinaryUploader.HTTP_METHOD_GET) {
      if (url.indexOf('?') !== -1) {
        url += this.binaryData_.get_data();
      } else {
        url += '?' + this.binaryData_.get_data();
      }
    } else {
      binaryData = this.binaryData_.get_data();
    }
  }

  this.element.open(this.method_, this.url_, true);
  this.element.timeout = this.timeout_;

  sawContentType = false;
  if (this.headers_) {
    n = this.headers_.length;
    for (i = 0; i < n; i++) {
      header = this.headers_[i];
      if (header.name === org.apache.flex.net.HTTPHeader.CONTENT_TYPE) {
        sawContentType = true;
      }

      this.element.setRequestHeader(header.name, header.value);
    }
  }

  if (this.method_ !== org.apache.flex.net.BinaryUploader.HTTP_METHOD_GET &&
      !sawContentType && binaryData) {
    this.element.setRequestHeader(
        org.apache.flex.net.HTTPHeader.CONTENT_TYPE, this.binaryType_);
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
 * @this {org.apache.flex.net.BinaryUploader}
 */
org.apache.flex.net.BinaryUploader.prototype.progressHandler = function() {
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
org.apache.flex.net.BinaryUploader.prototype.id;


/**
 * @expose
 * @this {org.apache.flex.net.BinaryUploader}
 * @return {string} The id.
 */
org.apache.flex.net.BinaryUploader.prototype.get_id = function() {
  return this.id;
};


/**
 * @expose
 * @this {org.apache.flex.net.BinaryUploader}
 * @param {Object} value The new id.
 */
org.apache.flex.net.BinaryUploader.prototype.set_id = function(value) {
  if (this.id !== value) {
    this.id = value;
    this.dispatchEvent('idChanged');
  }
};


/**
 * @expose
 * @this {org.apache.flex.net.BinaryUploader}
 * @return {Array} The array of descriptors.
 */
org.apache.flex.net.BinaryUploader.prototype.get_MXMLDescriptor = function() {
  return null;
};


/**
 * @expose
 * @this {org.apache.flex.net.BinaryUploader}
 * @return {Array} The array of properties.
 */
org.apache.flex.net.BinaryUploader.prototype.get_MXMLProperties = function() {
  return null;
};


/**
 * @this {org.apache.flex.net.BinaryUploader}
 * @param {Object} document The MXML object.
 * @param {string} id The id for the instance.
 */
org.apache.flex.net.BinaryUploader.prototype.setDocument = function(document, id) {
  this.document = document;
};
