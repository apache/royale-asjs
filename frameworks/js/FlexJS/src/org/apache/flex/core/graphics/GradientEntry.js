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

/**
 * org_apache_flex_core_graphics_GradientEntry
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org_apache_flex_core_graphics_GradientEntry');



/**
 * @constructor
 * @param {number} alpha
 * @param {number} color
 * @param {number} ratio
 */
org_apache_flex_core_graphics_GradientEntry = function(alpha, color, ratio) {
  this._alpha = alpha;
  this._color = color;
  this._ratio = ratio;
};


/**
 * @type {number}
 */
org_apache_flex_core_graphics_GradientEntry.prototype._alpha = 1.0;


/**
 * @type {number}
 */
org_apache_flex_core_graphics_GradientEntry.prototype._color = 0x000000;


/**
 * @type {number}
 */
org_apache_flex_core_graphics_GradientEntry.prototype._ratio = 0x000000;


Object.defineProperties(org_apache_flex_core_graphics_GradientEntry.prototype, {
    'alpha': {
        get: function() {
            return this._alpha;
        },
        set: function(value) {
            var /** @type {number} */ oldValue = this._alpha;
            if (value != oldValue) {
                this._alpha = value;
            }
        }
    },
    'color': {
        get: function() {
            return this._color;
        },
        set: function(value) {
            var /** @type {number} */ oldValue = this._color;
            if (value != oldValue) {
              this._color = value;
            }
        }
    },
    'ratio': {
        get: function() {
            return this._ratio;
        },
        set: function(value) {
            this._ratio = value;
        }
    }
});


/**
 * @expose
 * @param {org_apache_flex_core_graphics_GraphicShape} s
 */
org_apache_flex_core_graphics_GradientEntry.prototype.begin = function(s) {
  s.graphics.beginFill(this.color, this.alpha);
};


/**
 * @expose
 * @param {org_apache_flex_core_graphics_GraphicShape} s
 */
org_apache_flex_core_graphics_GradientEntry.prototype.end = function(s) {
  s.graphics.endFill();
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_core_graphics_GradientEntry.prototype.FLEXJS_CLASS_INFO = {
    names: [{ name: 'GradientEntry', qName: 'org_apache_flex_core_graphics_GradientEntry'}]
  };
