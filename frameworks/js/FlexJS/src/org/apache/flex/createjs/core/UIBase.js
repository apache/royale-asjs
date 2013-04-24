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

goog.provide('org.apache.flex.createjs.core.UIBase');

goog.require('org.apache.flex.FlexGlobal');
goog.require('org.apache.flex.core.HTMLElementWrapper');

/**
 * @constructor
 * @extends {org.apache.flex.core.HTMLElementWrapper}
 */
org.apache.flex.createjs.core.UIBase = function() {
    org.apache.flex.core.HTMLElementWrapper.call(this);

    /**
     * @protected
     * @type {Object}
     */
    this.positioner;

};
goog.inherits(org.apache.flex.createjs.core.UIBase,
    org.apache.flex.core.HTMLElementWrapper);

/**
 * @this {org.apache.flex.createjs.core.UIBase}
 * @param {Object} p The parent element.
 */
org.apache.flex.createjs.core.UIBase.prototype.addToParent = function(p) {
    
    this.element = new createjs.Container();
    p.addChild(this.element);
    
    this.positioner = this.element;
};

/**
 * @expose
 * @this {org.apache.flex.createjs.core.UIBase}
 * @param {number} pixels The pixel count from the left edge.
 */
org.apache.flex.createjs.core.UIBase.prototype.set_x = function(pixels) {
    this.positioner.x = pixels;
    this.element.getStage().update();
};

/**
 * @expose
 * @this {org.apache.flex.createjs.core.UIBase}
 * @param {number} pixels The pixel count from the top edge.
 */
org.apache.flex.createjs.core.UIBase.prototype.set_y = function(pixels) {
    this.positioner.y = pixels;
    this.element.getStage().update();
};

/**
 * @expose
 * @this {org.apache.flex.createjs.core.UIBase}
 * @param {number} pixels The pixel count from the left edge.
 */
org.apache.flex.createjs.core.UIBase.prototype.set_width = function(pixels) {
    this.positioner.width = pixels;
    this.element.getStage().update();
};

/**
 * @expose
 * @this {org.apache.flex.createjs.core.UIBase}
 * @param {number} pixels The pixel count from the top edge.
 */
org.apache.flex.createjs.core.UIBase.prototype.set_height = function(pixels) {
    this.positioner.height = pixels;
    this.element.getStage().update();
};

/**
 * @expose
 * @type {string}
 */
org.apache.flex.createjs.core.UIBase.prototype.id;

/**
 * @expose
 * @this {org.apache.flex.createjs.core.UIBase}
 * @return {string} The id.
 */
org.apache.flex.createjs.core.UIBase.prototype.get_id = function() {
    return this.name;
};

/**
 * @expose
 * @this {org.apache.flex.createjs.core.UIBase}
 * @param {object} value The new id.
 */
org.apache.flex.createjs.core.UIBase.prototype.set_id = function(value) {
    if (this.name != value)
    {
        this.element.name = value;
        this.name = value;
        var evt = this.createEvent('idChanged');
        this.dispatchEvent(evt);
    }
};

/**
 * @expose
 * @type {object}
 */
org.apache.flex.createjs.core.UIBase.prototype.model;

/**
 * @expose
 * @this {org.apache.flex.createjs.core.UIBase}
 * @return {object} The model.
 */
org.apache.flex.createjs.core.UIBase.prototype.get_model = function() {
    return this.model;
};

/**
 * @expose
 * @this {org.apache.flex.createjs.core.UIBase}
 * @param {object} value The new model.
 */
org.apache.flex.createjs.core.UIBase.prototype.set_model = function(value) {
    if (this.model != value)
    {
        this.addBead(value);
        this.dispatchEvent(new Event('modelChanged'));
    }
};

