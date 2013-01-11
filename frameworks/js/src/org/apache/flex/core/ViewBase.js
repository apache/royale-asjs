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

goog.provide('org.apache.flex.core.ViewBase');

goog.require('org.apache.flex.FlexGlobal');

goog.require('org.apache.flex.core.UIBase');

goog.require('org.apache.flex.utils.MXMLDataInterpreter');

/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.core.ViewBase = function() {
    org.apache.flex.core.UIBase.call(this);

     /**
      * @private
      * @type {org.apache.flex.core.ViewBase}
      */
      this.currentObject_;
};
goog.inherits(org.apache.flex.core.ViewBase, org.apache.flex.core.UIBase);

/**
 * @expose
 * @type {Object}
 */
org.apache.flex.core.ViewBase.prototype.applicationModel;

/**
 * @expose
 * @type {Array}
 */
org.apache.flex.core.ViewBase.prototype.MXMLProperties;

/**
 * @expose
 * @type {Array}
 */
org.apache.flex.core.ViewBase.prototype.MXMLDescriptor;

/**
 * @this {org.apache.flex.core.ViewBase}
 * @param {Object} model The model for this view.
 */
org.apache.flex.core.ViewBase.prototype.initUI = function(model) {
    this.applicationModel = model;
    org.apache.flex.utils.MXMLDataInterpreter.generateMXMLProperties(this, this.get_MXMLProperties());
    org.apache.flex.utils.MXMLDataInterpreter.generateMXMLInstances(this, this, this.get_MXMLDescriptor());
};
