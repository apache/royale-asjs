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

goog.provide('org_apache_flex_createjs_core_UIBase');

goog.require('org_apache_flex_core_HTMLElementWrapper');



/**
 * @constructor
 * @extends {org_apache_flex_core_HTMLElementWrapper}
 */
org_apache_flex_createjs_core_UIBase = function() {
  org_apache_flex_createjs_core_UIBase.base(this, 'constructor');

  /**
     * @protected
     * @type {Object}
     */
  this.positioner = null;

  this.createElement();
};
goog.inherits(org_apache_flex_createjs_core_UIBase,
    org_apache_flex_core_HTMLElementWrapper);


/**
 * @param {Object} c The child element.
 */
org_apache_flex_createjs_core_UIBase.prototype.addElement =
    function(c) {
  this.addChild(c.element);
};


/**
 */
org_apache_flex_createjs_core_UIBase.prototype.createElement =
    function() {
  this.element = new createjs.Container();

  this.positioner = this.element;
};


/**
 * @expose
 * @param {number} pixels The pixel count from the left edge.
 */
org_apache_flex_createjs_core_UIBase.prototype.set_x = function(pixels) {
  this.positioner.x = pixels;
  this.element.getStage().update();
};


/**
 * @expose
 * @param {number} pixels The pixel count from the top edge.
 */
org_apache_flex_createjs_core_UIBase.prototype.set_y = function(pixels) {
  this.positioner.y = pixels;
  this.element.getStage().update();
};


/**
 * @expose
 * @param {number} pixels The pixel count from the left edge.
 */
org_apache_flex_createjs_core_UIBase.prototype.set_width = function(pixels) {
  this.positioner.width = pixels;
  this.element.getStage().update();
};


/**
 * @expose
 * @param {number} pixels The pixel count from the top edge.
 */
org_apache_flex_createjs_core_UIBase.prototype.set_height = function(pixels) {
  this.positioner.height = pixels;
  this.element.getStage().update();
};


/**
 * @expose
 * @type {string}
 */
org_apache_flex_createjs_core_UIBase.prototype.id = null;


/**
 * @expose
 * @return {string} The id.
 */
org_apache_flex_createjs_core_UIBase.prototype.get_id = function() {
  return this.name;
};


/**
 * @expose
 * @param {object} value The new id.
 */
org_apache_flex_createjs_core_UIBase.prototype.set_id = function(value) {
  if (this.name !== value)
  {
    this.element.name = value;
    this.name = value;
    this.dispatchEvent('idChanged');
  }
};


/**
 * @expose
 * @type {object}
 */
org_apache_flex_createjs_core_UIBase.prototype.model = null;


/**
 * @expose
 * @return {object} The model.
 */
org_apache_flex_createjs_core_UIBase.prototype.get_model = function() {
  return this.model;
};


/**
 * @expose
 * @param {object} value The new model.
 */
org_apache_flex_createjs_core_UIBase.prototype.set_model = function(value) {
  if (this.model !== value)
  {
    this.addBead(value);
    this.dispatchEvent('modelChanged');
  }
};

