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

goog.provide('org_apache_flex_createjs_core_ViewBase');

goog.require('org_apache_flex_createjs_core_UIBase');
goog.require('org_apache_flex_utils_MXMLDataInterpreter');



/**
 * @constructor
 * @extends {org_apache_flex_createjs_core_UIBase}
 */
org_apache_flex_createjs_core_ViewBase = function() {
  org_apache_flex_createjs_core_ViewBase.base(this, 'constructor');

  /**
      * @private
      * @type {org_apache_flex_createjs_core_ViewBase}
      */
  this.currentObject_ = null;
};
goog.inherits(org_apache_flex_createjs_core_ViewBase,
    org_apache_flex_createjs_core_UIBase);


/**
 * @expose
 * @return {Object} Returns the application model.
 */
org_apache_flex_createjs_core_ViewBase.prototype.get_applicationModel =
    function() {
  return this.applicationModel;
};


/**
 * @expose
 * @param {Object} value The application model.
 */
org_apache_flex_createjs_core_ViewBase.prototype.set_applicationModel =
    function(value) {
  this.applicationModel = value;
};


/**
 * @expose
 * @type {Array}
 */
org_apache_flex_createjs_core_ViewBase.prototype.MXMLProperties = null;


/**
 * @expose
 * @type {Array}
 */
org_apache_flex_createjs_core_ViewBase.prototype.MXMLDescriptor = null;


/**
 * @param {Object} model The model for this view.
 */
org_apache_flex_createjs_core_ViewBase.prototype.initUI = function(model) {
  this.applicationModel = model;
  org_apache_flex_utils_MXMLDataInterpreter.generateMXMLProperties(this,
      this.get_MXMLProperties());
  org_apache_flex_utils_MXMLDataInterpreter.generateMXMLInstances(this,
      this, this.get_MXMLDescriptor());
};
