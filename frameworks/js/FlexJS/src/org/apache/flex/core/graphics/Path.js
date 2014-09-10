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

goog.provide('org.apache.flex.core.graphics.Path');

goog.require('org.apache.flex.core.graphics.GraphicShape');



/**
 * @constructor
 * @extends {org.apache.flex.core.graphics.GraphicShape}
 */
org.apache.flex.core.graphics.Path = function() {
  org.apache.flex.core.graphics.Path.base(this, 'constructor');

};
goog.inherits(org.apache.flex.core.graphics.Path,
    org.apache.flex.core.graphics.GraphicShape);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.graphics.Path.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Path',
                qName: 'org.apache.flex.core.graphics.Path' }] };


/**
 * @expose
 * @param {number} x The x location of the center of the Path.
 * @param {number} y The y location of the center of the Path.
 * @param {string} data A string containing a compact represention of the path segments.
 *  The value is a space-delimited string describing each path segment. Each
 *  segment entry has a single character which denotes the segment type and
 *  two or more segment parameters.
 *
 *  If the segment command is upper-case, the parameters are absolute values.
 *  If the segment command is lower-case, the parameters are relative values.
 */
org.apache.flex.core.graphics.Path.prototype.drawPath = function(x, y, data) {
    var style = this.getStyleStr();
    var path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
    path.setAttribute('style', style);
    path.setAttribute('d', data);
    this.element.appendChild(path);
	if(this.get_stroke())
	{
	  this.setPosition(x, y, this.get_stroke().get_weight(), this.get_stroke().get_weight());
	}
    else
	{
	  this.setPosition(x, y, 0, 0);
	}
  };
