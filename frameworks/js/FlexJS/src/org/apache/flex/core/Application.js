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

goog.provide('org.apache.flex.core.Application');

goog.require('org.apache.flex.FlexGlobal');
goog.require('org.apache.flex.FlexObject');

goog.require('org.apache.flex.core.SimpleValuesImpl');
goog.require('org.apache.flex.core.ValuesManager');
goog.require('org.apache.flex.core.ViewBase');
goog.require('org.apache.flex.utils.MXMLDataInterpreter');

/**
 * @constructor
 * @extends {org.apache.flex.FlexObject}
 */
org.apache.flex.core.Application = function() {
    org.apache.flex.FlexObject.call(this);

    /**
     * @private
     * @type {Array.<Object>}
     */
    this.queuedListeners_;

    /**
     * @private
     * @type {Array}
     */
    this.strand;
};
goog.inherits(org.apache.flex.core.Application, org.apache.flex.FlexObject);

/**
 * @expose
 * @type {Object}
 */
org.apache.flex.core.Application.prototype.controller = null;

/**
 * @expose
 * @type {org.apache.flex.core.ViewBase}
 */
org.apache.flex.core.Application.prototype.initialView = null;

/**
 * @expose
 * @type {org.apache.flex.events.EventDispatcher}
 */
org.apache.flex.core.Application.prototype.model = null;

/**
 * @expose
 * @type {org.apache.flex.core.SimpleValuesImpl}
 */
org.apache.flex.core.Application.prototype.valuesImpl = null;

/**
 * @this {org.apache.flex.core.Application}
 * @param {string} t The event type.
 * @param {function(?): ?} fn The event handler.
 */
org.apache.flex.core.Application.prototype.addEventListener = function(t, fn) {
    if (!this.element) {
        if (!this.queuedListeners_) {
            this.queuedListeners_ = [];
        }

        this.queuedListeners_.push({ type: t, handler: fn });

        return;
    }

    if (typeof this.element.attachEvent == 'function') {
        this.element.attachEvent(org.apache.flex.FlexGlobal.EventMap[t], fn);
    } else if (typeof this.element.addEventListener == 'function') {
        this.element.addEventListener(t, fn);
    }
};

/**
 * @expose
 * @this {org.apache.flex.core.Application}
 */
org.apache.flex.core.Application.prototype.start = function() {
    var evt, i, n, q;

    this.element = document.getElementsByTagName('body')[0];

    if (this.queuedListeners_) {
        n = this.queuedListeners_.length;
        for (i = 0; i < n; i++) {
            q = this.queuedListeners_[i];

            this.addEventListener(q.type, q.handler);
        }
    }

    org.apache.flex.utils.MXMLDataInterpreter.generateMXMLProperties(this,
            this.get_MXMLProperties());

    org.apache.flex.core.ValuesManager.valuesImpl = this.valuesImpl;

    evt = document.createEvent('Event');
    evt.initEvent('initialize', true, true);
    this.element.dispatchEvent(evt);

    this.initialView.addToParent(this.element);
    this.initialView.initUI(this.model);

    evt = document.createEvent('Event');
    evt.initEvent('viewChanged', true, true);
    this.element.dispatchEvent(evt);
};

/**
 * @expose
 * @this {org.apache.flex.core.Application}
 * @return {Array} The array of descriptors.
 */
org.apache.flex.core.Application.prototype.get_MXMLDescriptor = function() {
    return null;
};

/**
 * @expose
 * @this {org.apache.flex.core.Application}
 * @return {Array} The array of properties.
 */
org.apache.flex.core.Application.prototype.get_MXMLProperties = function() {
    return null;
};

/**
 * @expose
 * @this {org.apache.flex.core.Application}
 * @param {object} bead The new bead.
 */
org.apache.flex.core.Application.prototype.addBead = function(bead) {
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
 * @this {org.apache.flex.core.Application}
 * @param {object} classOrInterface The requested bead type.
 * @return {object} The bead.
 */
org.apache.flex.core.Application.prototype.getBeadByType =
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
 * @this {org.apache.flex.core.Application}
 * @param {object} bead The bead to remove.
 * @return {object} The bead.
 */
org.apache.flex.core.Application.prototype.removeBead = function(bead) {
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

