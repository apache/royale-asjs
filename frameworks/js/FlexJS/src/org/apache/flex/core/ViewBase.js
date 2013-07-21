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

// TODO: (aharui) bring this in via CSS
goog.require('org.apache.flex.core.SimpleStatesImpl');
goog.require('org.apache.flex.core.UIBase');
goog.require('org.apache.flex.events.ValueChangeEvent');
goog.require('org.apache.flex.utils.MXMLDataInterpreter');




/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.core.ViewBase = function() {
  goog.base(this);

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
   * @type {string}
   */
  this.currentState_ = null;

};
goog.inherits(org.apache.flex.core.ViewBase, org.apache.flex.core.UIBase);


/**
 * @expose
 * @type {Object}
 */
org.apache.flex.core.ViewBase.prototype.applicationModel = null;


/**
 * @expose
 * @type {Array}
 */
org.apache.flex.core.ViewBase.prototype.MXMLProperties = null;


/**
 * @expose
 * @type {Array}
 */
org.apache.flex.core.ViewBase.prototype.MXMLDescriptor = null;


/**
 * @this {org.apache.flex.core.ViewBase}
 */
org.apache.flex.core.ViewBase.prototype.addedToParent = function() {

  org.apache.flex.utils.MXMLDataInterpreter.generateMXMLProperties(this,
      this.get_MXMLProperties());

  org.apache.flex.utils.MXMLDataInterpreter.generateMXMLInstances(this,
      this, this.get_MXMLDescriptor());

  this.dispatchEvent(new org.apache.flex.events.Event('initComplete'));
};

/**
 * @expose
 * @this {org.apache.flex.core.ViewBase}
 * @return {Object} The application model.
 */
org.apache.flex.core.ViewBase.prototype.get_applicationModel = function() {
    return this.applicationModel;
};

/**
 * @expose
 * @this {org.apache.flex.core.ViewBase}
 * @return {Array} The array of State objects.
 */
org.apache.flex.core.ViewBase.prototype.get_states = function() {
    return this.states_;
};

/**
 * @expose
 * @this {org.apache.flex.core.ViewBase}
 * @param {Array} value The array of State objects.
 */
org.apache.flex.core.ViewBase.prototype.set_states = function(value) {
    this.states_ = value;

    // TODO: (aharui) check if bead already exists
    this.addBead(new org.apache.flex.core.SimpleStatesImpl());
};

/**
 * @expose
 * @this {org.apache.flex.core.ViewBase}
 * @param {string} state The name of the state.
 * @return {boolean} True if state in states array.
 */
org.apache.flex.core.ViewBase.prototype.hasState = function(state) {
    for (var p in this.states_)
    {
        var s = states_[p];
        if (s.name == state)
            return true;
    }
    return false;
};

/**
 * @expose
 * @this {org.apache.flex.core.ViewBase}
 * @return {string} The name of the current state.
 */
org.apache.flex.core.ViewBase.prototype.get_currentState = function() {
    return this.currentState_;
};

/**
 * @expose
 * @this {org.apache.flex.core.ViewBase}
 * @param {string} value The name of the current state.
 */
org.apache.flex.core.ViewBase.prototype.set_currentState = function(value) {
    var event = new org.apache.flex.events.ValueChangeEvent(
            'currentStateChanged', this.currentState_, value);
    this.currentState_ = value;
    this.dispatchEvent(event);
};

/**
 * @expose
 * @this {org.apache.flex.core.ViewBase}
 * @return {Array} The array of transitions.
 */
org.apache.flex.core.ViewBase.prototype.get_transitions = function() {
    return this.transitions_;
};

/**
 * @expose
 * @this {org.apache.flex.core.ViewBase}
 * @param {Array} value The array of transitions.
 */
org.apache.flex.core.ViewBase.prototype.set_transitions = function(value) {
    this.transitions_ = value;
};

