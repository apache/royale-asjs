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

goog.provide('org.apache.flex.core.ContainerBase');

goog.require('org.apache.flex.core.IMXMLDocument');
goog.require('org.apache.flex.core.UIBase');
goog.require('org.apache.flex.core.ValuesManager');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.core.ContainerBase = function() {
  this.mxmlProperties = null;
  org.apache.flex.core.ContainerBase.base(this, 'constructor');

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
goog.inherits(org.apache.flex.core.ContainerBase,
    org.apache.flex.core.UIBase);


/**
 * @export
 */
org.apache.flex.core.ContainerBase.prototype.mxmlContent = null;


/**
 * @export
 * @type {Array}
 */
org.apache.flex.core.ContainerBase.prototype.mxmlDescriptor = null;


/**
 * @export
 * @type {Array}
 */
org.apache.flex.core.ContainerBase.prototype.mxmlsd = null;


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.ContainerBase.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ContainerBase',
                qName: 'org.apache.flex.core.ContainerBase'}] ,
      interfaces: [org.apache.flex.core.IMXMLDocument]};


/**
 * @override
 */
org.apache.flex.core.ContainerBase.prototype.addedToParent = function() {
  org.apache.flex.core.ContainerBase.base(this, 'addedToParent');

  if (!this.initialized_) {
    org.apache.flex.utils.MXMLDataInterpreter.generateMXMLInstances(this.document,
        this, this.MXMLDescriptor);

    this.dispatchEvent('initBindings');
    this.dispatchEvent('initComplete');
    this.initialized_ = true;
  }
  this.dispatchEvent('childrenAdded');
};


/**
 * @export
 * @param {Array} data The data for the attributes.
 */
org.apache.flex.core.ContainerBase.prototype.generateMXMLAttributes = function(data) {
  org.apache.flex.utils.MXMLDataInterpreter.generateMXMLProperties(this, data);
};


/**
 * @export
 * @param {Object} doc The document.
 * @param {Array} desc The descriptor data.
 */
org.apache.flex.core.ContainerBase.prototype.setMXMLDescriptor =
    function(doc, desc) {
  this.mxmlDescriptor = desc;
  this.document = doc;
};


Object.defineProperties(org.apache.flex.core.ContainerBase.prototype, {
    /** @export */
    MXMLDescriptor: {
        /** @this {org.apache.flex.core.ContainerBase} */
        get: function() {
            return this.mxmlDescriptor;
        }
    },
    /** @export */
    states: {
        /** @this {org.apache.flex.core.ContainerBase} */
        get: function() {
            return this.states_;
        },
        /** @this {org.apache.flex.core.ContainerBase} */
        set: function(s) {
            this.states_ = s;
            this.currentState_ = s[0].name;

            if (org.apache.flex.core.ValuesManager.valuesImpl.getValue) {
              /**
               * @type {Function}
               */
              var impl = /** @type {Function} */ (org.apache.flex.core.ValuesManager.valuesImpl.
                  getValue(this, 'iStatesImpl'));
              // TODO: (aharui) check if bead already exists
              this.addBead(new impl());
            }
        }
    },
    /** @export */
    currentState: {
        /** @this {org.apache.flex.core.ContainerBase} */
        get: function() {
             return this.currentState_;
        },
        /** @this {org.apache.flex.core.ContainerBase} */
        set: function(s) {
             var event = new org.apache.flex.events.ValueChangeEvent(
                  'currentStateChange', false, false, this.currentState_, s);
             this.currentState_ = s;
             this.dispatchEvent(event);
        }
    },
    /** @export */
    transitions: {
        /** @this {org.apache.flex.core.ContainerBase} */
        get: function() {
             return this.transitions_;
        },
        /** @this {org.apache.flex.core.ContainerBase} */
        set: function(s) {
           this.transitions_ = s;
        }
    }
});
