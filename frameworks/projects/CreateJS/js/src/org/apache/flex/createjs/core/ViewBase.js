/**
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

goog.provide('org.apache.flex.createjs.core.ViewBase');

goog.require('org.apache.flex.createjs.core.UIBase');
goog.require('org.apache.flex.utils.MXMLDataInterpreter');



/**
 * @constructor
 * @extends {org.apache.flex.createjs.core.UIBase}
 */
org.apache.flex.createjs.core.ViewBase = function() {
  org.apache.flex.createjs.core.ViewBase.base(this, 'constructor');

  /**
      * @private
      * @type {org.apache.flex.createjs.core.ViewBase}
      */
  this.currentObject_ = null;
};
goog.inherits(org.apache.flex.createjs.core.ViewBase,
    org.apache.flex.createjs.core.UIBase);


Object.defineProperties(org.apache.flex.createjs.core.ViewBase.prototype, {
    /** @export */
    applicationModel: {
        /** @this {org.apache.flex.createjs.core.ViewBase} */
        get: function() {
            return this.applicationModel_;
        },
        set: function(value) {
            this.applicationModel = value;
        }
    }
});


/**
 * @export
 * @type {Array}
 */
org.apache.flex.createjs.core.ViewBase.prototype.MXMLProperties = null;


/**
 * @export
 * @type {Array}
 */
org.apache.flex.createjs.core.ViewBase.prototype.MXMLDescriptor = null;


/**
 * @param {Object} model The model for this view.
 */
org.apache.flex.createjs.core.ViewBase.prototype.initUI = function(model) {
  this.applicationModel = model;
  org.apache.flex.utils.MXMLDataInterpreter.generateMXMLProperties(this,
      this.MXMLProperties);
  org.apache.flex.utils.MXMLDataInterpreter.generateMXMLInstances(this,
      this, this.MXMLDescriptor);
};
