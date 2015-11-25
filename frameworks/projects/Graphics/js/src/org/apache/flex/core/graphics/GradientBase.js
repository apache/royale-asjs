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
 * org.apache.flex.core.graphics.GradientBase
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org.apache.flex.core.graphics.GradientBase');



/**
 * @constructor
 */
org.apache.flex.core.graphics.GradientBase = function() {
};


/**
 * @protected
 * @type {Array}
 */
org.apache.flex.core.graphics.GradientBase.prototype.colors = [];


/**
 * @protected
 * @type {Array}
 */
org.apache.flex.core.graphics.GradientBase.prototype.ratios = [];


/**
 * @protected
 * @type {Array}
 */
org.apache.flex.core.graphics.GradientBase.prototype.alphas = [];


/**
 * @type {Array}
 */
org.apache.flex.core.graphics.GradientBase.prototype._entries = [];


/**
 * @type {number}
 */
org.apache.flex.core.graphics.GradientBase.prototype._rotation = 0.0;


Object.defineProperties(org.apache.flex.core.graphics.GradientBase.prototype, {
    /** @export */
    entries: {
        /** @this {org.apache.flex.core.graphics.GradientBase} */
        get: function() {
            return this._entries;
        },
        /** @this {org.apache.flex.core.graphics.GradientBase} */
        set: function(value) {
            this._entries = value;
        }
    },
    /** @export */
    rotation: {
        /** @this {org.apache.flex.core.graphics.GradientBase} */
        get: function() {
            return this._rotation;
        },
        /** @this {org.apache.flex.core.graphics.GradientBase} */
        set: function(value) {
            this._rotation = value;
        }
    },
    /** @export */
    x: {
        /** @this {org.apache.flex.core.graphics.GradientBase} */
        get: function() {
            return this._x;
        },
        /** @this {org.apache.flex.core.graphics.GradientBase} */
        set: function(value) {
            this._x = value;
        }
    },
    /** @export */
    y: {
        /** @this {org.apache.flex.core.graphics.GradientBase} */
        set: function(value) {
            this._y = value;
        },
        /** @this {org.apache.flex.core.graphics.GradientBase} */
        get: function() {
            return this._y;
        }
    },
    /** @export */
    newId: {
        /** @this {org.apache.flex.core.graphics.GradientBase} */
        get: function() {
            return 'gradient' + String(Math.floor((Math.random() * 100000) + 1));
        }
    }
});


/**
 * @type {number}
 */
org.apache.flex.core.graphics.GradientBase.prototype._x = 0;


/**
 * @type {number}
 */
org.apache.flex.core.graphics.GradientBase.prototype._y = 0;


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.graphics.GradientBase.prototype.FLEXJS_CLASS_INFO = {
    names: [{ name: 'GradientBase', qName: 'org.apache.flex.core.graphics.GradientBase'}]
  };
