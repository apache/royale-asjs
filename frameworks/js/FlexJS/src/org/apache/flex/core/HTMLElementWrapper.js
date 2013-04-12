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

goog.provide('org.apache.flex.core.HTMLElementWrapper');

goog.require('org.apache.flex.FlexObject');
goog.require('org.apache.flex.events.EventDispatcher');
goog.require('org.apache.flex.utils.IE8Utils');

/**
 * @constructor
 * @extends {org.apache.flex.FlexObject}
 */
org.apache.flex.core.HTMLElementWrapper = function() {
    org.apache.flex.FlexObject.call(this);

    /**
     * @private
     * @type {Array}
     */
    this.strand;
};
goog.inherits(org.apache.flex.core.HTMLElementWrapper,
    org.apache.flex.FlexObject);

/**
 * @this {org.apache.flex.core.HTMLElementWrapper}
 * @param {string} type The event type.
 * @param {function(?): ?} fn The event handler.
 */
org.apache.flex.core.HTMLElementWrapper.prototype.addEventListener =
    function(type, fn) {
    if (this.element.addEventListener) {
        this.element.addEventListener(type, fn);
    }
    else if (this.element.attachEvent || !this.element.dispatchEvent) {
        org.apache.flex.utils.IE8Utils.addEventListener(this, this.element, type, fn);
    } 
};

/**
 * @this {org.apache.flex.core.HTMLElementWrapper}
 * @param {org.apache.flex.events.Event} evt The event.
 */
org.apache.flex.core.HTMLElementWrapper.prototype.dispatchEvent = 
    function(evt) {
    if (this.element.addEventListener)
    {
        try {
            this.element.dispatchEvent(evt);
        } catch (e) {
            var domevt = this.createEvent(evt.type);
            this.element.dispatchEvent(domevt);
        }
    }
    else if (this.element.attachEvent || !this.element.dispatchEvent)
        org.apache.flex.utils.IE8Utils.dispatchEvent(this, this.element, evt)
};

/**
 * @this {org.apache.flex.core.HTMLElementWrapper}
 * @param {string} type The event type.
 */
org.apache.flex.core.HTMLElementWrapper.prototype.createEvent = 
    function(type) {
    return org.apache.flex.events.EventDispatcher.createEvent(type);
};

/**
 * @expose
 * @this {org.apache.flex.core.HTMLElementWrapper}
 * @param {object} bead The new bead.
 */
org.apache.flex.core.HTMLElementWrapper.prototype.addBead = function(bead) {
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
 * @this {org.apache.flex.core.HTMLElementWrapper}
 * @param {object} classOrInterface The requested bead type.
 * @return {object} The bead.
 */
org.apache.flex.core.HTMLElementWrapper.prototype.getBeadByType =
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
 * @this {org.apache.flex.core.HTMLElementWrapper}
 * @param {object} bead The bead to remove.
 * @return {object} The bead.
 */
org.apache.flex.core.HTMLElementWrapper.prototype.removeBead = function(bead) {
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
 * @this {org.apache.flex.core.HTMLElementWrapper}
 * @return {Array} The array of descriptors.
 */
org.apache.flex.core.HTMLElementWrapper.prototype.get_MXMLDescriptor = function() {
    return null;
};

/**
 * @expose
 * @this {org.apache.flex.core.HTMLElementWrapper}
 * @return {Array} The array of properties.
 */
org.apache.flex.core.HTMLElementWrapper.prototype.get_MXMLProperties = function() {
    return null;
};
