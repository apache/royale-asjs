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
   * @type {org.apache.flex.core.graphics.IFill}
   */
  this.fill_ = null;

  /**
   * @private
   * @type {org.apache.flex.core.graphics.IStroke}
   */
  this.stroke_ = null;

   /**
   * @private
   * @type {number}
   */
  this.x_ = 0;

  /**
   * @private
   * @type {number}
   */
  this.y_ = 0;

  /**
   * @private
   * @type {number}
   */
  this.xOffset_ = 0;

  /**
   * @private
   * @type {number}
   */
  this.yOffset_ = 0;

    /**
   * @expose
   * @type {SVGElement}
   */
  this.element = document.createElementNS('http://www.w3.org/2000/svg', 'svg');
  this.element.flexjs_wrapper = this;
  this.element.offsetLeft = 0;
  this.element.offsetTop = 0;
  this.element.offsetParent = null;
  this.positioner = this.element;
};
goog.inherits(org.apache.flex.core.graphics.GraphicShape,
    org.apache.flex.core.UIBase);


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
 * @return {org.apache.flex.core.graphics.IFill} The fill object.
 */
org.apache.flex.core.graphics.GraphicShape.prototype.get_fill = function() {
  return this.fill_;
};


/**
 * @param {org.apache.flex.core.graphics.IFill} value The fill object.
 */
org.apache.flex.core.graphics.GraphicShape.prototype.set_fill = function(value) {
  this.fill_ = value;
};


/**
 * @expose
 * @return {org.apache.flex.core.graphics.IStroke} The stroke object.
 */
org.apache.flex.core.graphics.GraphicShape.prototype.get_stroke = function() {
  return this.stroke_;
};


/**
 * @expose
 * @param {org.apache.flex.core.graphics.IStroke} value The stroke object.
 */
org.apache.flex.core.graphics.GraphicShape.prototype.set_stroke = function(value) {
  this.stroke_ = value;
};


/**
 *
 */
org.apache.flex.core.graphics.GraphicShape.prototype.addedToParent = function() {
  this.draw();
  this.element.style.overflow = 'visible';
  /*
   * not sure this is valuable any longer
  var bbox = this.element.getBBox();
  if (bbox.width === 0 && !isNaN(this.get_width())) bbox.width = this.get_width();
  if (bbox.height === 0 && !isNaN(this.get_height())) bbox.height = this.get_height();
  this.resize(this.get_x(), this.get_y(), bbox);*/
};


/**
 * This is where the drawing methods get called from.
 */
org.apache.flex.core.graphics.GraphicShape.prototype.draw = function() {
  //Overwrite in subclass
};


/**
 * @expose
 * @return {string} The style attribute.
 */
org.apache.flex.core.graphics.GraphicShape.prototype.getStyleStr = function() {
  var fillStr;
  if (this.get_fill())
  {
    fillStr = this.get_fill().addFillAttrib(this);
  }
  else
  {
    fillStr = 'fill:none';
  }

  var strokeStr;
  if (this.get_stroke())
  {
    strokeStr = this.get_stroke().addStrokeAttrib(this);
  }
  else
  {
    strokeStr = 'stroke:none';
  }


  return fillStr + ';' + strokeStr;
};


/**
 * @expose
 * @param {number} x X position.
 * @param {number} y Y position.
 * @param {Object} bbox The bounding box of the svg element.
 */
org.apache.flex.core.graphics.GraphicShape.prototype.resize = function(x, y, bbox) {
  var width = Math.max(this.get_width(), bbox.width);
  var height = Math.max(this.get_height(), bbox.height);

  this.element.style.position = 'absolute';
  if (!isNaN(x)) this.element.style.top = String(x) + 'px';
  if (!isNaN(y)) this.element.style.left = String(y) + 'px';
  this.element.style.width = String(width) + 'px';
  this.element.style.height = String(height) + 'px';
  this.element.offsetLeft = x;
  this.element.offsetTop = y;
};


/**
 * @expose
 * @param {number} x X position.
 * @param {number} y Y position.
 * @param {number} xOffset offset from x position.
 * @param {number} yOffset offset from y position.
 */
org.apache.flex.core.graphics.GraphicShape.prototype.setPosition = function(x, y, xOffset, yOffset) {
  this.x_ = x;
  this.y_ = y;
  this.xOffset_ = xOffset;
  this.yOffset_ = yOffset;
  this.element.offsetLeft = xOffset;
  this.element.offsetTop = yOffset;
};

