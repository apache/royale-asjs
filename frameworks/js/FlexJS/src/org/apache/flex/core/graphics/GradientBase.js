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
 * org_apache_flex_core_graphics_GradientBase
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org_apache_flex_core_graphics_GradientBase');



/**
 * @constructor
 */
org_apache_flex_core_graphics_GradientBase = function() {
};


/**
 * @protected
 * @type {Array}
 */
org_apache_flex_core_graphics_GradientBase.prototype.colors = [];


/**
 * @protected
 * @type {Array}
 */
org_apache_flex_core_graphics_GradientBase.prototype.ratios = [];


/**
 * @protected
 * @type {Array}
 */
org_apache_flex_core_graphics_GradientBase.prototype.alphas = [];


/**
 * @type {Array}
 */
org_apache_flex_core_graphics_GradientBase.prototype._entries = [];


/**
 * @type {number}
 */
org_apache_flex_core_graphics_GradientBase.prototype._rotation = 0.0;


Object.defineProperties(org_apache_flex_core_graphics_GradientBase.prototype, {
    'entries': {
        /** @this {org_apache_flex_core_graphics_GradientBase} */
        get: function() {
            return this._entries;
        },
        /** @this {org_apache_flex_core_graphics_GradientBase} */
        set: function(value) {
            this._entries = value;
        }
    },
    /**
     *  By default, the LinearGradientStroke defines a transition
     *  from left to right across the control.
     *  Use the <code>rotation</code> property to control the transition direction.
     *  For example, a value of 180.0 causes the transition
     *  to occur from right to left, rather than from left to right.
     * @return {number}
     */
    'rotation': {
        /** @this {org_apache_flex_core_graphics_GradientBase} */
        get: function() {
            return this._rotation;
        },
        /** @this {org_apache_flex_core_graphics_GradientBase} */
        set: function(value) {
            this._rotation = value;
        }
    },
    'x': {
        /** @this {org_apache_flex_core_graphics_GradientBase} */
        get: function() {
            return this._x;
        },
        /** @this {org_apache_flex_core_graphics_GradientBase} */
        set: function(value) {
            this._x = value;
        }
    },
    'y': {
        /** @this {org_apache_flex_core_graphics_GradientBase} */
        set: function(value) {
            this._y = value;
        },
        /** @this {org_apache_flex_core_graphics_GradientBase} */
        get: function() {
            return this._y;
        }
    },
    'newId': {
        /** @this {org_apache_flex_core_graphics_GradientBase} */
        get: function() {
            return 'gradient' + String(Math.floor((Math.random() * 100000) + 1));
        }
    }
});


/**
 * @type {number}
 */
org_apache_flex_core_graphics_GradientBase.prototype._x = 0;


/**
 * @type {number}
 */
org_apache_flex_core_graphics_GradientBase.prototype._y = 0;


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_core_graphics_GradientBase.prototype.FLEXJS_CLASS_INFO = {
    names: [{ name: 'GradientBase', qName: 'org_apache_flex_core_graphics_GradientBase'}]
  };
