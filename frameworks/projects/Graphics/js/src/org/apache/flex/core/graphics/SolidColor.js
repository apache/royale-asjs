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

goog.provide('org_apache_flex_core_graphics_SolidColor');
goog.require('org_apache_flex_core_graphics_IFill');



/**
 * @constructor
 * @implements {org_apache_flex_core_graphics_IFill}
 */
org_apache_flex_core_graphics_SolidColor = function() {

  /**
   * @private
   * @type {number}
   */
  this.alpha_ = 1.0;

    /**
   * @private
   * @type {number}
   */
  this.color_ = 1.0;

};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_core_graphics_SolidColor.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'SolidColor',
                qName: 'org_apache_flex_core_graphics_SolidColor' }],
                interfaces: [org_apache_flex_core_graphics_IFill] };


Object.defineProperties(org_apache_flex_core_graphics_SolidColor.prototype, {
    /** @export */
    color: {
        /** @this {org_apache_flex_core_graphics_SolidColor} */
        get: function() {
            return this.color_;
        },
        /** @this {org_apache_flex_core_graphics_SolidColor} */
        set: function(value) {
            this.color_ = value;
        }
    },
    /** @export */
    alpha: {
        /** @this {org_apache_flex_core_graphics_SolidColor} */
        get: function() {
            return this.alpha_;
        },
        /** @this {org_apache_flex_core_graphics_SolidColor} */
        set: function(value) {
            this.alpha_ = value;
        }
    }
});


/**
 * addFillAttrib()
 *
 * @export
 * @param {org_apache_flex_core_graphics_GraphicShape} value The GraphicShape object on which the fill must be added.
 * @return {string}
 */
org_apache_flex_core_graphics_SolidColor.prototype.addFillAttrib = function(value) {
  var color = Number(this.color).toString(16);
  if (color.length == 1) color = '00' + color;
  if (color.length == 2) color = '00' + color;
  if (color.length == 4) color = '00' + color;
  return 'fill:#' + String(color) + ';fill-opacity:' + String(this.alpha);
};

