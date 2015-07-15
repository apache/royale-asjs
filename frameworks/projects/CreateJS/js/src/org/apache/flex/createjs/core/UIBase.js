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

goog.provide('org.apache.flex.createjs.core.UIBase');

goog.require('org.apache.flex.core.HTMLElementWrapper');



/**
 * @constructor
 * @extends {org.apache.flex.core.HTMLElementWrapper}
 */
org.apache.flex.createjs.core.UIBase = function() {
  org.apache.flex.createjs.core.UIBase.base(this, 'constructor');

  /**
     * @protected
     * @type {Object}
     */
  this.positioner = null;

  this.createElement();
};
goog.inherits(org.apache.flex.createjs.core.UIBase,
    org.apache.flex.core.HTMLElementWrapper);


/**
 * @param {Object} c The child element.
 */
org.apache.flex.createjs.core.UIBase.prototype.addElement =
    function(c) {
  this.addChild(c.element);
};


/**
 */
org.apache.flex.createjs.core.UIBase.prototype.createElement =
    function() {
  this.element = new createjs.Container();

  this.positioner = this.element;
};


Object.defineProperties(org.apache.flex.createjs.core.UIBase.prototype, {
    /** @export */
    x: {
        /** @this {org.apache.flex.createjs.core.UIBase} */
        set: function(pixels) {
            this.positioner.x = pixels;
            this.element.getStage().update();
        }
    },
    /** @export */
    y: {
        /** @this {org.apache.flex.createjs.core.UIBase} */
        set: function(pixels) {
            this.positioner.y = pixels;
            this.element.getStage().update();
        }
    },
    /** @export */
    width: {
        /** @this {org.apache.flex.createjs.core.UIBase} */
        set: function(pixels) {
            this.positioner.width = pixels;
            this.element.getStage().update();
        }
    },
    /** @export */
    height: {
        /** @this {org.apache.flex.createjs.core.UIBase} */
        set: function(pixels) {
            this.positioner.height = pixels;
            this.element.getStage().update();
        }
    },
    /** @export */
    id: {
        /** @this {org.apache.flex.createjs.core.UIBase} */
        get: function() {
             return this.name;
        },
        /** @this {org.apache.flex.createjs.core.UIBase} */
        set: function(value) {
            if (this.name !== value) {
              this.element.name = value;
              this.name = value;
              this.dispatchEvent('idChanged');
            }
        }
    },
    /** @export */
    model: {
        /** @this {org.apache.flex.createjs.core.UIBase} */
        get: function() {
            return this.model;
        },
        /** @this {org.apache.flex.createjs.core.UIBase} */
        set: function(value) {
            if (this.model !== value) {
              this.addBead(value);
              this.dispatchEvent('modelChanged');
            }
        }
    }
});


/**
 * @export
 * @type {string}
 */
org.apache.flex.createjs.core.UIBase.prototype.id = null;


/**
 * @export
 * @type {object}
 */
org.apache.flex.createjs.core.UIBase.prototype.model = null;
