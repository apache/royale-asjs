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

goog.provide('org_apache_flex_core_graphics_GraphicsContainer');

goog.require('org_apache_flex_core_graphics_GraphicShape');



/**
 * @constructor
 * @extends {org_apache_flex_core_graphics_GraphicShape}
 */
org_apache_flex_core_graphics_GraphicsContainer = function() {
  org_apache_flex_core_graphics_GraphicsContainer.base(this, 'constructor');
};
goog.inherits(org_apache_flex_core_graphics_GraphicsContainer, org_apache_flex_core_graphics_GraphicShape);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_core_graphics_GraphicsContainer.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'GraphicsContainer',
      qName: 'org_apache_flex_core_graphics_GraphicsContainer'}] };


/**
 * @expose
 */
org_apache_flex_core_graphics_GraphicsContainer.prototype.removeAllElements = function() {
  var svg = this.element;
  while (svg.lastChild) {
    svg.removeChild(svg.lastChild);
  }
};


Object.defineProperties(org_apache_flex_core_graphics_GraphicsContainer.prototype, {
    /** @expose */
    numChildren: {
        /** @this {org_apache_flex_core_graphics_GraphicsContainer} */
        get: function() {
            return this.internalChildren().length;
        }
    },
    /** @expose */
    width: {
        /** @this {org_apache_flex_core_graphics_GraphicsContainer} */
        set: function(value) {
            org_apache_flex_utils_Language.superSetter(
                org_apache_flex_core_graphics_GraphicsContainer, this, 'width', value);
            this.element.setAttribute('width', String(value) + 'px');
            this.element.style.width = String(value) + 'px';
        }
    },
    /** @expose */
    height: {
        /** @this {org_apache_flex_core_graphics_GraphicsContainer} */
        set: function(value) {
            org_apache_flex_utils_Language.superSetter(
                org_apache_flex_core_graphics_GraphicsContainer, this, 'height', value);
            this.element.setAttribute('height', String(value) + 'px');
            this.element.style.height = String(value) + 'px';
        }
    },
    /** @expose */
    x: {
        /** @this {org_apache_flex_core_graphics_GraphicsContainer} */
        set: function(value) {
            org_apache_flex_utils_Language.superSetter(
                org_apache_flex_core_graphics_GraphicsContainer, this, 'x', value);
            this.element.setAttribute('x', String(value) + 'px');
            this.element.style.position = 'absolute';
            this.element.style.left = String(value) + 'px';
            this.element.offsetLeft = value;
        }
    },
    /** @expose */
    y: {
        /** @this {org_apache_flex_core_graphics_GraphicsContainer} */
        set: function(value) {
            org_apache_flex_utils_Language.superSetter(
                org_apache_flex_core_graphics_GraphicsContainer, this, 'y', value);
            this.element.setAttribute('y', String(value) + 'px');
            this.element.style.position = 'absolute';
            this.element.style.top = String(value) + 'px';
            this.element.offsetTop = value;
        }
    }
});


/**
 * @expose
 * @param {number} x The x position of the top-left corner of the rectangle.
 * @param {number} y The y position of the top-left corner.
 * @param {number} width The width of the rectangle.
 * @param {number} height The height of the rectangle.
 */
org_apache_flex_core_graphics_GraphicsContainer.prototype.drawRect = function(x, y, width, height) {
  var style = this.getStyleStr();
  var rect = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
  rect.flexjs_wrapper = this;
  rect.offsetLeft = x;
  rect.offsetTop = y;
  rect.offsetParent = this;
  rect.setAttribute('style', style);
  rect.setAttribute('x', String(x) + 'px');
  rect.setAttribute('y', String(y) + 'px');
  rect.setAttribute('width', String(width) + 'px');
  rect.setAttribute('height', String(height) + 'px');
  this.element.appendChild(rect);
};


/**
 * @expose
 * @param {number} x The x position of the top-left corner of the bounding box of the ellipse.
 * @param {number} y The y position of the top-left corner of the bounding box of the ellipse.
 * @param {number} width The width of the ellipse.
 * @param {number} height The height of the ellipse.
 */
org_apache_flex_core_graphics_GraphicsContainer.prototype.drawEllipse = function(x, y, width, height) {
  var style = this.getStyleStr();
  var ellipse = document.createElementNS('http://www.w3.org/2000/svg', 'ellipse');
  ellipse.flexjs_wrapper = this;
  ellipse.offsetLeft = x;
  ellipse.offsetTop = y;
  ellipse.offsetParent = this;
  ellipse.setAttribute('style', style);
  ellipse.setAttribute('cx', String(x + width / 2));
  ellipse.setAttribute('cy', String(y + height / 2));
  ellipse.setAttribute('rx', String(width / 2));
  ellipse.setAttribute('ry', String(height / 2));
  this.element.appendChild(ellipse);
};


/**
 * @expose
 * @param {number} x The x location of the center of the circle.
 * @param {number} y The y location of the center of the circle.
 * @param {number} radius The radius of the circle.
 */
org_apache_flex_core_graphics_GraphicsContainer.prototype.drawCircle = function(x, y, radius) {
  var style = this.getStyleStr();
  var circle = document.createElementNS('http://www.w3.org/2000/svg', 'ellipse');
  circle.flexjs_wrapper = this;
  circle.offsetLeft = x;
  circle.offsetTop = y;
  circle.offsetParent = this;
  circle.setAttribute('style', style);
  circle.setAttribute('cx', String(x));
  circle.setAttribute('cy', String(y));
  circle.setAttribute('rx', String(radius));
  circle.setAttribute('ry', String(radius));
  this.element.appendChild(circle);
};


/**
 * @expose
 * @param {string} data A string containing a compact represention of the path segments.
 *  The value is a space-delimited string describing each path segment. Each
 *  segment entry has a single character which denotes the segment type and
 *  two or more segment parameters.
 *
 *  If the segment command is upper-case, the parameters are absolute values.
 *  If the segment command is lower-case, the parameters are relative values.
 */
org_apache_flex_core_graphics_GraphicsContainer.prototype.drawPath = function(data) {
  var style = this.getStyleStr();
  var path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
  path.flexjs_wrapper = this;
  path.offsetLeft = 0;
  path.offsetTop = 0;
  path.offsetParent = this;
  path.setAttribute('style', style);
  path.setAttribute('d', data);
  this.element.appendChild(path);
};


/**
 * @expose
 * @param {string} value The text string to draw.
 * @param {number} x The x position of the text.
 * @param {number} y The y position of the text.
 * @return {object} The text node created to display the graphics.
 */
org_apache_flex_core_graphics_GraphicsContainer.prototype.drawText = function(value, x, y) {
  var style = this.getStyleStr();
  var text = document.createElementNS('http://www.w3.org/2000/svg', 'text');
  text.flexjs_wrapper = this;
  text.offsetLeft = x;
  text.offsetTop = y;
  text.offsetParent = this;
  text.setAttribute('style', style);
  text.setAttribute('x', String(x) + 'px');
  text.setAttribute('y', String(y + 15) + 'px');
  var textNode = document.createTextNode(value);
  text.appendChild(textNode);
  this.element.appendChild(text);
  return text;
};


/**
 * @expose
 */
org_apache_flex_core_graphics_GraphicsContainer.prototype.drawLine = function() {
};


/**
 * @expose
 */
org_apache_flex_core_graphics_GraphicsContainer.prototype.drawPolygon = function() {
};

