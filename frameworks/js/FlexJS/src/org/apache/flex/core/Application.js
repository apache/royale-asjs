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

goog.provide('org_apache_flex_core_Application');

goog.require('org_apache_flex_core_HTMLElementWrapper');
goog.require('org_apache_flex_core_IParent');
goog.require('org_apache_flex_core_IValuesImpl');
goog.require('org_apache_flex_core_ValuesManager');
goog.require('org_apache_flex_utils_MXMLDataInterpreter');



/**
 * @constructor
 * @extends {org_apache_flex_core_HTMLElementWrapper}
 */
org_apache_flex_core_Application = function() {
  org_apache_flex_core_Application.base(this, 'constructor');
};
goog.inherits(org_apache_flex_core_Application,
    org_apache_flex_core_HTMLElementWrapper);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_core_Application.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Application',
                qName: 'org_apache_flex_core_Application' }],
      interfaces: [org_apache_flex_core_IParent] };


/**
 * @expose
 * @type {Object}
 */
org_apache_flex_core_Application.prototype.controller = null;


/**
 * @expose
 * @type {Object}
 */
org_apache_flex_core_Application.prototype.initialView = null;


/**
 * @expose
 * @type {org_apache_flex_events_EventDispatcher}
 */
org_apache_flex_core_Application.prototype.model = null;


/**
 * @expose
 * @param {org_apache_flex_core_IValuesImpl} value The IValuesImpl.
 */
org_apache_flex_core_Application.prototype.set_valuesImpl =
    function(value) {
  org_apache_flex_core_ValuesManager.valuesImpl = value;
  if (value.init) {
    value.init(this);
  }
};


/**
 * @expose
 */
org_apache_flex_core_Application.prototype.start = function() {
  this.element = document.getElementsByTagName('body')[0];
  this.element.flexjs_wrapper = this;
  this.element.className = 'Application';

  org_apache_flex_utils_MXMLDataInterpreter.generateMXMLInstances(this, null, this.MXMLDescriptor);

  this.dispatchEvent('initialize');

  this.initialView.applicationModel = this.model;
  this.addElement(this.initialView);

  this.dispatchEvent('viewChanged');
};


/**
 * @expose
 * @param {Array} data The data for the attributes.
 */
org_apache_flex_core_Application.prototype.generateMXMLAttributes = function(data) {
  org_apache_flex_utils_MXMLDataInterpreter.generateMXMLProperties(this, data);
};


/**
 * @param {Object} c The child element.
 */
org_apache_flex_core_Application.prototype.addElement =
    function(c) {
  this.element.appendChild(c.element);
  c.addedToParent();
};

