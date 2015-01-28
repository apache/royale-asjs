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

goog.provide('org_apache_flex_core_graphics_Path');

goog.require('org_apache_flex_core_graphics_GraphicShape');



/**
 * @constructor
 * @extends {org_apache_flex_core_graphics_GraphicShape}
 */
org_apache_flex_core_graphics_Path = function() {
  org_apache_flex_core_graphics_Path.base(this, 'constructor');

   /**
   * @private
   * @type {string}
   */
  this.data_ = '';
};
goog.inherits(org_apache_flex_core_graphics_Path,
    org_apache_flex_core_graphics_GraphicShape);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_core_graphics_Path.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Path',
                qName: 'org_apache_flex_core_graphics_Path' }] };


/**
 * @expose
 * @param {string} v The string representation of the path data.
 */
org_apache_flex_core_graphics_Path.prototype.set_data = function(v) {
  this.data_ = v;
};


/**
 * @expose
 * @return {string} The string representation of the path data.
 */
org_apache_flex_core_graphics_Path.prototype.get_data = function() {
  return this.data_;
};


/**
 * @expose
 * @param {number} x The x location of the Path.
 * @param {number} y The y location of the Path.
 * @param {string} data A string containing a compact represention of the path segments.
 *  The value is a space-delimited string describing each path segment. Each
 *  segment entry has a single character which denotes the segment type and
 *  two or more segment parameters.
 *
 *  If the segment command is upper-case, the parameters are absolute values.
 *  If the segment command is lower-case, the parameters are relative values.
 */
org_apache_flex_core_graphics_Path.prototype.drawPath = function(x, y, data) {
    if (data == null || data.length === 0) return;
    var style = this.getStyleStr();
    var path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
    path.flexjs_wrapper = this;
    path.setAttribute('style', style);
    path.setAttribute('d', data);
    this.element.appendChild(path);
    if (this.get_stroke())
    {
      this.setPosition(x, y, this.get_stroke().get_weight(), this.get_stroke().get_weight());
    }
    else
    {
      this.setPosition(x, y, 0, 0);
    }

    this.resize(x, y, path.getBBox());
  };


 /**
  * @override
  */
org_apache_flex_core_graphics_Path.prototype.draw = function() {
    this.drawPath(this.get_x(), this.get_y(), this.get_data());
  };
