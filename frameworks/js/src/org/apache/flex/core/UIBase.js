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
