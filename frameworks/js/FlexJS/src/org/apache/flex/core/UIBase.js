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

goog.provide('org.apache.flex.core.UIBase');

goog.require('org.apache.flex.FlexGlobal');
goog.require('org.apache.flex.FlexObject');

/**
 * @constructor
 * @extends {org.apache.flex.FlexObject}
 */
org.apache.flex.core.UIBase = function() {
    org.apache.flex.FlexObject.call(this);

    /**
     * @protected
     * @type {Object}
     */
    this.positioner;

    /**
     * @private
     * @type {Array}
     */
    this.strand;
};
goog.inherits(org.apache.flex.core.UIBase, org.apache.flex.FlexObject);

/**
 * @this {org.apache.flex.core.UIBase}
 * @param {string} type The event type.
 * @param {function(?): ?} fn The event handler.
 */
org.apache.flex.core.UIBase.prototype.addEventListener = function(type, fn) {
    if (typeof this.element.attachEvent == 'function') {
        this.element.attachEvent(org.apache.flex.FlexGlobal.EventMap[type], fn);
    } else if (typeof this.element.addEventListener == 'function') {
        this.element.addEventListener(type, fn);
    }
};

/**
 * @this {org.apache.flex.core.UIBase}
 * @param {Object} p The parent element.
 */
org.apache.flex.core.UIBase.prototype.addToParent = function(p) {
    this.element = document.createElement('div');

    p.appendChild(this.element);
};

/**
 * @this {org.apache.flex.core.UIBase}
 * @param {flash.events.Event} evt The event.
 */
org.apache.flex.core.UIBase.prototype.dispatchEvent = function(evt) {
    this.element.dispatchEvent(evt);
};

/**
 * @expose
 * @this {org.apache.flex.core.UIBase}
 * @param {number} pixels The pixel count from the left edge.
 */
org.apache.flex.core.UIBase.prototype.set_x = function(pixels) {
    this.positioner.style.position = 'absolute';
    this.positioner.style.left = pixels.toString() + 'px';
};

/**
 * @expose
 * @this {org.apache.flex.core.UIBase}
 * @param {number} pixels The pixel count from the top edge.
 */
org.apache.flex.core.UIBase.prototype.set_y = function(pixels) {
    this.positioner.style.position = 'absolute';
    this.positioner.style.top = pixels.toString() + 'px';
};

/**
 * @expose
 * @this {org.apache.flex.core.UIBase}
 * @param {number} pixels The pixel count from the left edge.
 */
org.apache.flex.core.UIBase.prototype.set_width = function(pixels) {
    this.positioner.style.width = pixels.toString() + 'px';
};

/**
 * @expose
 * @this {org.apache.flex.core.UIBase}
 * @param {number} pixels The pixel count from the top edge.
 */
org.apache.flex.core.UIBase.prototype.set_height = function(pixels) {
    this.positioner.style.height = pixels.toString() + 'px';
};

/**
 * @expose
 * @type {string}
 */
org.apache.flex.core.UIBase.prototype.id;

/**
 * @expose
 * @this {org.apache.flex.core.UIBase}
 * @return {string} The id.
 */
org.apache.flex.core.UIBase.prototype.get_id = function() {
    return this.id;
};

/**
 * @expose
 * @this {org.apache.flex.core.UIBase}
 * @param {object} value The new id.
 */
org.apache.flex.core.UIBase.prototype.set_id = function(value) {
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
 * @type {object}
 */
org.apache.flex.core.UIBase.prototype.model;

/**
 * @expose
 * @this {org.apache.flex.core.UIBase}
 * @return {object} The model.
 */
org.apache.flex.core.UIBase.prototype.get_model = function() {
    return this.model;
};

/**
 * @expose
 * @this {org.apache.flex.core.UIBase}
 * @param {object} value The new model.
 */
org.apache.flex.core.UIBase.prototype.set_model = function(value) {
    if (this.model != value)
    {
        this.addBead(value);
        this.dispatchEvent(new Event('modelChanged'));
    }
};

/**
 * @expose
 * @this {org.apache.flex.core.UIBase}
 * @param {object} bead The new bead.
 */
org.apache.flex.core.UIBase.prototype.addBead = function(bead) {
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
 * @this {org.apache.flex.core.UIBase}
 * @param {object} classOrInterface The requested bead type.
 * @return {object} The bead.
 */
org.apache.flex.core.UIBase.prototype.getBeadByType =
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
 * @this {org.apache.flex.core.UIBase}
 * @param {object} bead The bead to remove.
 * @return {object} The bead.
 */
org.apache.flex.core.UIBase.prototype.remove = function(bead) {
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
 * @this {org.apache.flex.core.UIBase}
 * @return {Array} The array of descriptors.
 */
org.apache.flex.core.UIBase.prototype.get_MXMLDescriptor = function() {
    return null;
};

/**
 * @expose
 * @this {org.apache.flex.core.UIBase}
 * @return {Array} The array of properties.
 */
org.apache.flex.core.UIBase.prototype.get_MXMLProperties = function() {
    return null;
};
