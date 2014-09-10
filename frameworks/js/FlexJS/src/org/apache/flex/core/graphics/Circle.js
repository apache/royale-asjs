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

goog.provide('org.apache.flex.core.graphics.Circle');

goog.require('org.apache.flex.core.graphics.GraphicShape');



/**
 * @constructor
 * @extends {org.apache.flex.core.graphics.GraphicShape}
 */
org.apache.flex.core.graphics.Circle = function() {
  org.apache.flex.core.graphics.Circle.base(this, 'constructor');

};
goog.inherits(org.apache.flex.core.graphics.Circle,
    org.apache.flex.core.graphics.GraphicShape);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.graphics.Circle.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Circle',
                qName: 'org.apache.flex.core.graphics.Circle' }] };


/**
 * @expose
 * @param {number} x The x location of the center of the circle.
 * @param {number} y The y location of the center of the circle.
 * @param {number} radius The radius of the circle.
 */
org.apache.flex.core.graphics.Circle.prototype.drawCircle = function(x, y, radius) {
    var style = this.getStyleStr();
    var circle = document.createElementNS('http://www.w3.org/2000/svg', 'ellipse');
    circle.setAttribute('style', style);
	if(this.get_stroke())
	{
	  circle.setAttribute('cx', String(radius + this.get_stroke().get_weight()));
      circle.setAttribute('cy', String(radius + this.get_stroke().get_weight()));
	  this.setPosition(x-radius, y-radius, this.get_stroke().get_weight(), this.get_stroke().get_weight());
	}
	else
	{
	  circle.setAttribute('cx', String(radius));
      circle.setAttribute('cy', String(radius));
	  this.setPosition(x-radius, y-radius, 0, 0);
	}

    circle.setAttribute('rx', String(radius));
    circle.setAttribute('ry', String(radius));
    this.element.appendChild(circle);
    
  };
