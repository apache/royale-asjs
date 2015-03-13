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

goog.provide('org_apache_flex_createjs_core_UIBase');

goog.require('org_apache_flex_core_HTMLElementWrapper');



/**
 * @constructor
 * @extends {org_apache_flex_core_HTMLElementWrapper}
 */
org_apache_flex_createjs_core_UIBase = function() {
  org_apache_flex_createjs_core_UIBase.base(this, 'constructor');

  /**
     * @protected
     * @type {Object}
     */
  this.positioner = null;

  this.createElement();
};
goog.inherits(org_apache_flex_createjs_core_UIBase,
    org_apache_flex_core_HTMLElementWrapper);


/**
 * @param {Object} c The child element.
 */
org_apache_flex_createjs_core_UIBase.prototype.addElement =
    function(c) {
  this.addChild(c.element);
};


/**
 */
org_apache_flex_createjs_core_UIBase.prototype.createElement =
    function() {
  this.element = new createjs.Container();

  this.positioner = this.element;
};


Object.defineProperties(org_apache_flex_createjs_Label.prototype, {
    'x': {
        set: function(pixels) {
            this.positioner.x = pixels;
            this.element.getStage().update();
        }
    },
    'y': {
        set: function(pixels) {
            this.positioner.y = pixels;
            this.element.getStage().update();
        }
    },
    'width': {
        set: function(pixels) {
            this.positioner.width = pixels;
            this.element.getStage().update();
        }
    },
    'height': {
        set: function(pixels) {
            this.positioner.height = pixels;
            this.element.getStage().update();
        }
    },
    'id': {
        get: function() {
             return this.name;
        },
        set: function(value) {
            if (this.name !== value) {
              this.element.name = value;
              this.name = value;
              this.dispatchEvent('idChanged');
            }
        }
    },
    'model': {
        get: function() {
            return this.model;
        },
        set: function(value) {
            if (this.model !== value) {
              this.addBead(value);
              this.dispatchEvent('modelChanged');
            }
        }
    }
});


/**
 * @expose
 * @type {string}
 */
org_apache_flex_createjs_core_UIBase.prototype.id = null;


/**
 * @expose
 * @type {object}
 */
org_apache_flex_createjs_core_UIBase.prototype.model = null;
