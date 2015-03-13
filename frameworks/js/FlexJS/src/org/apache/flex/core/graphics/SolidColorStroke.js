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

goog.provide('org_apache_flex_core_graphics_SolidColorStroke');
goog.require('org_apache_flex_core_graphics_IStroke');



/**
 * @constructor
 * @implements {org_apache_flex_core_graphics_IStroke}
 *
 */
org_apache_flex_core_graphics_SolidColorStroke = function() {

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

  /**
   * @private
   * @type {number}
   */
  this.weight_ = 1.0;

};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_core_graphics_SolidColorStroke.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'SolidColorStroke',
                qName: 'org_apache_flex_core_graphics_SolidColorStroke' }] };


Object.defineProperties(org_apache_flex_core_graphics_SolidColorStroke.prototype, {
    'color': {
		get: function() {
            return this.color_;
		},
        set: function(value) {
            this.color_ = value;
		}
	},
    'alpha': {
		get: function() {
            return this.alpha_;
        },
        set: function(value) {
            this.alpha_ = value;
        }
	},
    'weight': {
		get: function() {
            return this.weight_;
		},
        set: function(value) {
            this.weight_ = value;
        }
	}
});


/**
 * addStrokeAttrib()
 *
 * @expose
 * @param {org_apache_flex_core_graphics_GraphicShape} value The GraphicShape object on which the stroke must be added.
 * @return {string}
 */
org_apache_flex_core_graphics_SolidColorStroke.prototype.addStrokeAttrib = function(value) {
    var strokeColor = Number(this.color).toString(16);
    if (strokeColor.length == 1) strokeColor = '00' + strokeColor;
    if (strokeColor.length == 2) strokeColor = '00' + strokeColor;
    if (strokeColor.length == 4) strokeColor = '00' + strokeColor;
    return 'stroke:#' + String(strokeColor) + ';stroke-width:' +
         String(this.weight) + ';stroke-opacity:' + String(this.alpha);
  };
