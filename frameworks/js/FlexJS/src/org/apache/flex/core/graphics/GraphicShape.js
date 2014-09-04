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

goog.provide('org.apache.flex.core.graphics.GraphicShape');

goog.require('org.apache.flex.core.UIBase');
goog.require('org.apache.flex.core.graphics.SolidColor');
goog.require('org.apache.flex.core.graphics.SolidColorStroke');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.core.graphics.GraphicShape = function() {
  org.apache.flex.core.graphics.GraphicShape.base(this, 'constructor');

  /**
   * @private
   * @type {org.apache.flex.core.graphics.SolidColor}
   */
  this.fill_ = null;
  
  /**
   * @private
   * @type {org.apache.flex.core.graphics.SolidColorStroke}
   */
  this.stroke_ = null;
  
};
goog.inherits(org.apache.flex.core.graphics.GraphicShape,
    org.apache.flex.core.UIBase);

/**
 * @override
 */
org.apache.flex.core.graphics.GraphicShape.prototype.createElement =
    function() {

  this.element = document.createElementNS("http://www.w3.org/2000/svg","svg");
  this.element.setAttribute('width',1000);
  this.element.setAttribute('height',1000);

  this.positioner = this.element;

  return this.element;
};

/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.graphics.GraphicShape.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'GraphicShape',
                qName: 'org.apache.flex.core.graphics.GraphicShape' }] };



/**
 * @expose
 * @return {org.apache.flex.core.graphics.SolidColor} The fill object.
 */
org.apache.flex.core.graphics.GraphicShape.prototype.get_fill = function() {
  return this.fill_;
};

/**
 * @param {org.apache.flex.core.graphics.SolidColor} value The fill object.
 */
org.apache.flex.core.graphics.GraphicShape.prototype.set_fill = function(value) {
  this.fill_ = value;
};

/**
 * @expose
 * @return {org.apache.flex.core.graphics.SolidColorStroke} The stroke object.
 */
org.apache.flex.core.graphics.GraphicShape.prototype.get_stroke = function() {
  return this.stroke_;
};


/**
 * @param {org.apache.flex.core.graphics.SolidColorStroke} value The stroke object.
 */
org.apache.flex.core.graphics.GraphicShape.prototype.set_stroke = function(value) {
  this.stroke_ = value;
};