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

goog.provide('org_apache_flex_core_ViewBase');

goog.require('org_apache_flex_core_IPopUpHost');
goog.require('org_apache_flex_core_UIBase');
goog.require('org_apache_flex_core_ValuesManager');
goog.require('org_apache_flex_events_Event');
goog.require('org_apache_flex_events_ValueChangeEvent');
goog.require('org_apache_flex_utils_MXMLDataInterpreter');



/**
 * @constructor
 * @implements {org_apache_flex_core_IPopUpHost}
 * @extends {org_apache_flex_core_UIBase}
 */
org_apache_flex_core_ViewBase = function() {
  org_apache_flex_core_ViewBase.base(this, 'constructor');

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
  this.currentState_ = '';

  /**
   * @private
   * @type {boolean}
   */
  this.initialized_ = false;

  this.document = this;

};
goog.inherits(org_apache_flex_core_ViewBase, org_apache_flex_core_UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_core_ViewBase.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ViewBase',
                qName: 'org_apache_flex_core_ViewBase' }],
      interfaces: [org_apache_flex_core_IPopUpHost] };


/**
 * @expose
 * @type {Object}
 */
org_apache_flex_core_ViewBase.prototype.applicationModel = null;


/**
 * @expose
 * @param {Array} data The data for the attributes.
 */
org_apache_flex_core_ViewBase.prototype.generateMXMLAttributes = function(data) {
  org_apache_flex_utils_MXMLDataInterpreter.generateMXMLProperties(this, data);
};


/**
 * @expose
 * @type {Array}
 */
org_apache_flex_core_ViewBase.prototype.MXMLDescriptor = null;


/**
 * @expose
 * @type {Object} The document.
 */
org_apache_flex_core_ViewBase.prototype.document = null;


/**
 * @expose
 * @param {Object} doc The document.
 * @param {Array} desc The descriptor data;
 */
org_apache_flex_core_ViewBase.prototype.setMXMLDescriptor =
    function(doc, desc) {
  this.MXMLDescriptor = desc;
  this.document = doc;
};


/**
 * @expose
 */
org_apache_flex_core_ViewBase.prototype.addedToParent = function() {

  //org_apache_flex_core_ViewBase.base(this,'addedToParent');
  this.element.flexjs_wrapper = this;
  if (org_apache_flex_core_ValuesManager.valuesImpl.init) {
    org_apache_flex_core_ValuesManager.valuesImpl.init(this);
  }

  org_apache_flex_core_ViewBase.base(this, 'addedToParent');

  if (!this.initialized_) {
    org_apache_flex_utils_MXMLDataInterpreter.generateMXMLInstances(this.document,
      this, this.MXMLDescriptor);

    this.dispatchEvent(new org_apache_flex_events_Event('initBindings'));
    this.dispatchEvent(new org_apache_flex_events_Event('initComplete'));
    this.initialized_ = true;
  }
  this.dispatchEvent(new org_apache_flex_events_Event('childrenAdded'));
};


/**
 * @expose
 * @param {string} state The name of the state.
 * @return {boolean} True if state in states array.
 */
org_apache_flex_core_ViewBase.prototype.hasState = function(state) {
  for (var p in this.states_)
  {
    var s = this.states_[p];
    if (s.name == state)
      return true;
  }
  return false;
};


Object.defineProperties(org_apache_flex_core_ViewBase.prototype, {
    /**
     * @return {Array} An array of descriptors.
     */
    'MXMLDescriptor': {
        /** @this {org_apache_flex_core_ViewBase} */
        get: function() {
            return this.MXMLDescriptor;
        }
    },
    /**
     * @return {Object} The application model.
     */
    'applicationModel': {
        /** @this {org_apache_flex_core_ViewBase} */
        get: function() {
            return this.applicationModel;
        }
    },
    'states': {
        /** @this {org_apache_flex_core_ViewBase} */
        get: function() {
            return this.states_;
        },
        /** @this {org_apache_flex_core_ViewBase} */
        set: function(value) {
            this.states_ = value;
            this.currentState_ = value[0].name;

            if (org_apache_flex_core_ValuesManager.valuesImpl.getValue) {
              /**
               * @type {Function}
               */
              var impl = /** @type {Function} */ (org_apache_flex_core_ValuesManager.valuesImpl.
                  getValue(this, 'iStatesImpl'));
              // TODO: (aharui) check if bead already exists
              this.addBead(new impl());
            }
        }
    },
    'currentState': {
        /** @this {org_apache_flex_core_ViewBase} */
        get: function() {
            return this.currentState_;
        },
        /** @this {org_apache_flex_core_ViewBase} */
        set: function(value) {
            var event = new org_apache_flex_events_ValueChangeEvent(
                'currentStateChange', false, false, this.currentState_, value);
            this.currentState_ = value;
            this.dispatchEvent(event);
        }
    },
    'transitions': {
        /** @this {org_apache_flex_core_ViewBase} */
        get: function() {
            return this.transitions_;
        },
        /** @this {org_apache_flex_core_ViewBase} */
        set: function(value) {
            this.transitions_ = value;
        }
    }
});
