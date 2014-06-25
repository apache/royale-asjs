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


/**
 * @expose
 * @return {Object} Returns the application model.
 */
org.apache.flex.createjs.core.ViewBase.prototype.get_applicationModel =
    function() {
  return this.applicationModel;
};


/**
 * @expose
 * @param {Object} value The application model.
 */
org.apache.flex.createjs.core.ViewBase.prototype.set_applicationModel =
    function(value) {
  this.applicationModel = value;
};


/**
 * @expose
 * @type {Array}
 */
org.apache.flex.createjs.core.ViewBase.prototype.MXMLProperties = null;


/**
 * @expose
 * @type {Array}
 */
org.apache.flex.createjs.core.ViewBase.prototype.MXMLDescriptor = null;


/**
 * @param {Object} model The model for this view.
 */
org.apache.flex.createjs.core.ViewBase.prototype.initUI = function(model) {
  this.applicationModel = model;
  org.apache.flex.utils.MXMLDataInterpreter.generateMXMLProperties(this,
      this.get_MXMLProperties());
  org.apache.flex.utils.MXMLDataInterpreter.generateMXMLInstances(this,
      this, this.get_MXMLDescriptor());
};
