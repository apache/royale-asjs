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
 * @param {flash.events.Event} evt The event.
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
    this.element.open("GET",this._url,false);
    this.element.send();        
};

/**
 * @protected
 * @this {org.apache.flex.net.HTTPService}
 */
org.apache.flex.net.HTTPService.prototype.progressHandler = function() {
    if (this.element.readyState == 4)
    {
        evt = document.createEvent('Event');
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
        this.dispatchEvent(new Event('idChanged'));
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
