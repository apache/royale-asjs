/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

goog.provide('org.apache.flex.net.HTTPService');

goog.require('org.apache.flex.FlexGlobal');
goog.require('org.apache.flex.FlexObject');
goog.require('org.apache.flex.net.HTTPHeader');

/**
 * @constructor
 * @extends {org.apache.flex.FlexObject}
 */
org.apache.flex.net.HTTPService = function() {
    org.apache.flex.FlexObject.call(this);

    /**
     * @protected
     * @type {String}
     */
    this._url;

    /**
     * @private
     * @type {Number}
     */
    this._status;

    /**
     * @private
     * @type {String}
     */
    this._method = "GET";

    /**
     * @private
     * @type {Array}
     */
    this._headers;

    /**
     * @private
     * @type {Array}
     */
    this._responseHeaders;

    /**
     * @private
     * @type {String}
     */
    this._responseURL;

    /**
     * @private
     * @type {Number}
     */
    this._timeout;

    /**
     * @private
     * @type {String}
     */
    this._contentData;

    /**
     * @private
     * @type {String}
     */
    this._contentType = "application/x-www-form-urlencoded";

    /**
     * @private
     * @type {Array}
     */
    this.strand;

    /**
     * @private
     * @type {XMLHttpRequest}
     */
    this.element;

    this.element = new XMLHttpRequest();
};
goog.inherits(org.apache.flex.net.HTTPService, org.apache.flex.FlexObject);

/**
 * @expose
 * @type {String}
 */
org.apache.flex.net.HTTPService.HTTP_METHOD_GET = "GET";

/**
 * @expose
 * @type {String}
 */
org.apache.flex.net.HTTPService.HTTP_METHOD_POST = "POST";

/**
 * @expose
 * @type {String}
 */
org.apache.flex.net.HTTPService.HTTP_METHOD_PUT = "PUT";

/**
 * @expose
 * @type {String}
 */
org.apache.flex.net.HTTPService.HTTP_METHOD_DELETE = "DELETE";

/**
 * @this {org.apache.flex.net.HTTPService}
 * @param {string} type The event type.
 * @param {function(?): ?} fn The event handler.
 */
org.apache.flex.net.HTTPService.prototype.addEventListener =
function(type, fn) {
    if (typeof this.element.attachEvent == 'function') {
        this.element.attachEvent(org.apache.flex.FlexGlobal.EventMap[type], fn);
    } else if (typeof this.element.addEventListener == 'function') {
        this.element.addEventListener(type, fn);
    }
};

/**
 * @this {org.apache.flex.net.HTTPService}
 * @param {org.apache.flex.events.Event} evt The event.
 */
org.apache.flex.net.HTTPService.prototype.dispatchEvent = function(evt) {
    this.element.dispatchEvent(evt);
};

/**
 * @expose
 * @this {org.apache.flex.net.HTTPService}
 * @return {string} value The data.
 */
org.apache.flex.net.HTTPService.prototype.get_data = function() {
    return this.element.responseText;
};

/**
 * @expose
 * @this {org.apache.flex.net.HTTPService}
 * @return {string} value The contentData.
 */
org.apache.flex.net.HTTPService.prototype.get_contentData = function() {
    return this._contentData;
};

/**
 * @expose
 * @this {org.apache.flex.net.HTTPService}
 * @param {string} value The contentData.
 */
org.apache.flex.net.HTTPService.prototype.set_contentData = function(value) {
    this._contentData = value;
};

/**
 * @expose
 * @this {org.apache.flex.net.HTTPService}
 * @return {string} value The contentType.
 */
org.apache.flex.net.HTTPService.prototype.get_contentType = function() {
    return this._contentType;
};

/**
 * @expose
 * @this {org.apache.flex.net.HTTPService}
 * @param {string} value The contentType.
 */
org.apache.flex.net.HTTPService.prototype.set_contentType = function(value) {
    this._contentType = value;
};

/**
 * @expose
 * @this {org.apache.flex.net.HTTPService}
 * @return {Array} value The array of HTTPHeaders.
 */
org.apache.flex.net.HTTPService.prototype.get_headers = function() {
    if (this._headers == undefined)
        this._headers = [];
    return this._headers;
};

/**
 * @expose
 * @this {org.apache.flex.net.HTTPService}
 * @param {Array} value The array of HTTPHeaders.
 */
org.apache.flex.net.HTTPService.prototype.set_headers = function(value) {
    this._headers = value;
};

/**
 * @expose
 * @this {org.apache.flex.net.HTTPService}
 * @return {String} value The method.
 */
org.apache.flex.net.HTTPService.prototype.get_method = function() {
    return this._method;
};

/**
 * @expose
 * @this {org.apache.flex.net.HTTPService}
 * @param {String} value The method.
 */
org.apache.flex.net.HTTPService.prototype.set_method = function(value) {
    this._method = value;
};

/**
 * @expose
 * @this {org.apache.flex.net.HTTPService}
 * @return {Array} value The array of HTTPHeaders.
 */
org.apache.flex.net.HTTPService.prototype.get_responseHeaders = function() {
    if (typeof this._responseHeaders == 'undefined')
    {
        var allHeaders = this.element.getAllResponseHeaders();
        this._responseHeaders = allHeaders.split('\n');
        var n = this._responseHeaders.length;
        for (var i = 0; i < n; i++)
        {
            var hdr = this._responseHeaders[i];
            var c = hdr.indexOf(':');
            var part1 = hdr.substring(0, c);
            var part2 = hdr.substring(c + 2);
            this._responseHeaders[i] = new org.apache.flex.net.HTTPHeader(part1, part2);
        }
    }
    return this._responseHeaders;
};

/**
 * @expose
 * @this {org.apache.flex.net.HTTPService}
 * @return {string} value The url.
 */
org.apache.flex.net.HTTPService.prototype.get_responseURL = function() {
    return this._responseURL;
};

/**
 * @expose
 * @this {org.apache.flex.net.HTTPService}
 * @return {Number} value The status.
 */
org.apache.flex.net.HTTPService.prototype.get_status = function() {
    return this._status;
};

/**
 * @expose
 * @this {org.apache.flex.net.HTTPService}
 * @return {Number} value The timeout.
 */
org.apache.flex.net.HTTPService.prototype.get_timeout = function() {
    return this._timeout;
};

/**
 * @expose
 * @this {org.apache.flex.net.HTTPService}
 * @param {Number} value The timeout.
 */
org.apache.flex.net.HTTPService.prototype.set_timeout = function(value) {
    this._timeout = value;
};

/**
 * @expose
 * @this {org.apache.flex.net.HTTPService}
 * @return {string} value The url.
 */
org.apache.flex.net.HTTPService.prototype.get_url = function() {
    return this._url;
};

/**
 * @expose
 * @this {org.apache.flex.net.HTTPService}
 * @param {string} value The url to fetch.
 */
org.apache.flex.net.HTTPService.prototype.set_url = function(value) {
    this._url = value;
};

/**
 * @expose
 * @this {org.apache.flex.net.HTTPService}
 */
org.apache.flex.net.HTTPService.prototype.send = function() {
    this.element.onreadystatechange = org.apache.flex.FlexGlobal.createProxy(
            this, this.progressHandler);
    var url = this._url;
    var contentData = null;
    if (this._contentData != undefined)
    {
        if (this._method == org.apache.flex.net.HTTPService.HTTP_METHOD_GET)
        {
            if (url.indexOf("?") != -1)
                url += this._contentData;
            else
                url += "?" + this._contentData;
        }
        else
            contentData = this._contentData;
    }
    
    this.element.timeout = this._timeout;
    this.element.open(this._method,this._url,true);
    var sawContentType = false;
    if (this._headers)
    {
        var n = this._headers.length;
        for (var i = 0; i < n; i++)
        {
            var header = this._headers[i];
            if (header.name == org.apache.flex.net.HTTPHeader.CONTENT_TYPE)
                sawContentType = true;
            this.element.setRequestHeader(header.name, header.value);
        }
    }
    if (this._method != org.apache.flex.net.HTTPService.HTTP_METHOD_GET &&
        !sawContentType && contentData != null)
    {
        this.element.setRequestHeader(org.apache.flex.net.HTTPHeader.CONTENT_TYPE,
            this._contentType);
    }
    
    if (contentData != null)
    {
        this.element.setRequestHeader("Content-length", contentData.length);
        this.element.setRequestHeader("Connection", "close");
        this.element.send(contentData);
    }
    else        
        this.element.send();        
};

/**
 * @protected
 * @this {org.apache.flex.net.HTTPService}
 */
org.apache.flex.net.HTTPService.prototype.progressHandler = function() {
    var foo = this.element.readyState;
    if (this.element.readyState == 2)
    {
        this._status = this.element.status;
        var evt = document.createEvent('Event');
        evt.initEvent('httpResponseStatus', true, true);
        this.element.dispatchEvent(evt);
        evt = document.createEvent('Event');
        evt.initEvent('httpStatus', true, true);
        this.element.dispatchEvent(evt);
    }
    else if (this.element.readyState == 4)
    {
        var evt = document.createEvent('Event');
        evt.initEvent('complete', true, true);
        this.element.dispatchEvent(evt);
    }
};

/**
 * @expose
 * @type {string}
 */
org.apache.flex.net.HTTPService.prototype.id;

/**
 * @expose
 * @this {org.apache.flex.net.HTTPService}
 * @return {string} The id.
 */
org.apache.flex.net.HTTPService.prototype.get_id = function() {
    return this.id;
};

/**
 * @expose
 * @this {org.apache.flex.net.HTTPService}
 * @param {object} value The new id.
 */
org.apache.flex.net.HTTPService.prototype.set_id = function(value) {
    if (this.id != value)
    {
        this.id = value;
        var evt = document.createEvent('Event');
        evt.initEvent('idChanged', false, false);
        this.dispatchEvent(evt);
    }
};

/**
 * @expose
 * @this {org.apache.flex.net.dataConverters.LazyCollection}
 * @param {object} value The new host.
 */
org.apache.flex.net.HTTPService.prototype.set_strand =
function(value) {
    if (this.strand != value)
    {
        this.strand = value;
    }
};

/**
 * @expose
 * @this {org.apache.flex.net.HTTPService}
 * @param {object} bead The new bead.
 */
org.apache.flex.net.HTTPService.prototype.addBead = function(bead) {
    if (!this.strand)
        this.strand = [];
    this.strand.push(bead);
    if (typeof(bead.constructor.$implements) != 'undefined' &&
        typeof(bead.constructor.$implements.IBeadModel != 'undefined'))
        this.model = bead;
    bead.set_strand(this);
};

/**
 * @expose
 * @this {org.apache.flex.net.HTTPService}
 * @param {object} classOrInterface The requested bead type.
 * @return {object} The bead.
 */
org.apache.flex.net.HTTPService.prototype.getBeadByType =
                                    function(classOrInterface) {
    var n;
    n = this.strand.length;
    for (var i = 0; i < n; i++)
    {
        var bead = strand[i];
        if (bead instanceof classOrInterface)
            return bead;
        if (classOrInterface in bead.constructor.$implements)
            return bead;
    }
    return null;
};

/**
 * @expose
 * @this {org.apache.flex.net.HTTPService}
 * @param {object} bead The bead to remove.
 * @return {object} The bead.
 */
org.apache.flex.net.HTTPService.prototype.removeBead = function(bead) {
    var n = this.strand.length;
    for (var i = 0; i < n; i++)
    {
        var bead = strand[i];
        if (bead == value)
        {
            this.strand.splice(i, 1);
            return bead;
        }
    }
    return null;
};

/**
 * @expose
 * @this {org.apache.flex.net.HTTPService}
 * @return {Array} The array of descriptors.
 */
org.apache.flex.net.HTTPService.prototype.get_MXMLDescriptor = function() {
    return null;
};

/**
 * @expose
 * @this {org.apache.flex.net.HTTPService}
 * @return {Array} The array of properties.
 */
org.apache.flex.net.HTTPService.prototype.get_MXMLProperties = function() {
    return null;
};

/**
 * @this {org.apache.flex.binding.SimpleBinding}
 * @param {object} document The MXML object.
 * @param {string} id The id for the instance.
 */
org.apache.flex.net.HTTPService.prototype.setDocument =
                                                    function(document, id) {
    this.document = document;

};
