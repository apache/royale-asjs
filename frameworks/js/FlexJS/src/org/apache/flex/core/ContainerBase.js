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

goog.provide('org_apache_flex_core_ContainerBase');

goog.require('org_apache_flex_core_IMXMLDocument');
goog.require('org_apache_flex_core_UIBase');
goog.require('org_apache_flex_core_ValuesManager');



/**
 * @constructor
 * @extends {org_apache_flex_core_UIBase}
 */
org_apache_flex_core_ContainerBase = function() {
  this.mxmlProperties = null;
  org_apache_flex_core_ContainerBase.base(this, 'constructor');

  /**
   * @private
   * @type {boolean}
   */
  this.initialized_ = false;

  /**
   * @private
   * @type {Array}
   */
  this.states_ = null;

  /**
   * @private
   * @type {Array}
   */
  this.transitions_ = null;

  /**
   * @private
   * @type {?String}
   */
  this.currentState_ = null;


  this.document = this;

};
goog.inherits(org_apache_flex_core_ContainerBase,
    org_apache_flex_core_UIBase);


/**
 * @expose
 */
org_apache_flex_core_ContainerBase.prototype.mxmlContent = null;


/**
 * @expose
 * @type {Array}
 */
org_apache_flex_core_ContainerBase.prototype.mxmlDescriptor = null;


/**
 * @expose
 * @type {Array}
 */
org_apache_flex_core_ContainerBase.prototype.mxmlsd = null;


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_core_ContainerBase.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ContainerBase',
                qName: 'org_apache_flex_core_ContainerBase'}] ,
      interfaces: [org_apache_flex_core_IMXMLDocument]};


/**
 * @override
 */
org_apache_flex_core_ContainerBase.prototype.addedToParent = function() {
  org_apache_flex_core_ContainerBase.base(this, 'addedToParent');

  if (!this.initialized_) {
    org_apache_flex_utils_MXMLDataInterpreter.generateMXMLInstances(this.document,
        this, this.get_MXMLDescriptor());

    this.dispatchEvent('initBindings');
    this.dispatchEvent('initComplete');
    this.initialized_ = true;
  }
  this.dispatchEvent('childrenAdded');
};


/**
 * @expose
 * @param {Array} data The data for the attributes.
 */
org_apache_flex_core_ContainerBase.prototype.generateMXMLAttributes = function(data) {
  org_apache_flex_utils_MXMLDataInterpreter.generateMXMLProperties(this, data);
};


/**
 * @expose
 * @return {Array} An array of descriptors.
 */
org_apache_flex_core_ContainerBase.prototype.get_MXMLDescriptor = function() {
  return this.mxmlDescriptor;
};


/**
 * @expose
 * @param {Object} doc The document.
 * @param {Array} desc The descriptor data.
 */
org_apache_flex_core_ContainerBase.prototype.setMXMLDescriptor =
    function(doc, desc) {
  this.mxmlDescriptor = desc;
  this.document = doc;
};


/**
 * @expose
 * @return {Array} An array of states.
 */
org_apache_flex_core_ContainerBase.prototype.get_states = function() {
  return this.states_;
};


/**
 * @expose
 * @param {Array} s An array of states.
 */
org_apache_flex_core_ContainerBase.prototype.set_states = function(s) {
  this.states_ = s;
  this.currentState_ = s[0].name;

  if (org_apache_flex_core_ValuesManager.valuesImpl.getValue) {
    /**
     * @type {Function}
     */
    var impl = /** @type {Function} */ (org_apache_flex_core_ValuesManager.valuesImpl.
        getValue(this, 'iStatesImpl'));
    // TODO: (aharui) check if bead already exists
    this.addBead(new impl());
  }
};


/**
 * @expose
 * @return {String} The current state.
 */
org_apache_flex_core_ContainerBase.prototype.get_currentState = function() {
  return this.currentState_;
};


/**
 * @expose
 * @param {String} s The current state.
 */
org_apache_flex_core_ContainerBase.prototype.set_currentState = function(s) {
  var event = new org_apache_flex_events_ValueChangeEvent(
      'currentStateChange', false, false, this.currentState_, s);
  this.currentState_ = s;
  this.dispatchEvent(event);
};


/**
 * @expose
 * @return {Array} An array of states.
 */
org_apache_flex_core_ContainerBase.prototype.get_transitions = function() {
  return this.transitions_;
};


/**
 * @expose
 * @param {Array} s An array of states.
 */
org_apache_flex_core_ContainerBase.prototype.set_transitions = function(s) {
  this.transitions_ = s;
};


