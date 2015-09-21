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

goog.require('org.apache.flex.core.ContainerBaseStrandChildren');
goog.require('org.apache.flex.core.IContentViewHost');
goog.require('org.apache.flex.core.IMXMLDocument');
goog.require('org.apache.flex.core.UIBase');
goog.require('org.apache.flex.core.ValuesManager');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 * @implements {org.apache.flex.core.IMXMLDocument}
 * @implements {org.apache.flex.core.IContentViewHost}
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

  /**
   * @private
   * @type {Object}
   */
  this.strandChildren_ = new org.apache.flex.core.ContainerBaseStrandChildren(this);

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
 * @export
 * @type {boolean}
 */
org.apache.flex.core.ContainerBase.prototype.supportsChrome = true;


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.ContainerBase.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ContainerBase',
                qName: 'org.apache.flex.core.ContainerBase'}] ,
      interfaces: [org.apache.flex.core.IMXMLDocument,
                   org.apache.flex.core.IContentViewHost]};


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
//??  this.dispatchEvent('childrenAdded');
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


/**
 * @override
 * @param {Object} c
 * @param {boolean=} opt_dispatchEvent
 */
org.apache.flex.core.ContainerBase.prototype.addElement = function(c, opt_dispatchEvent) {
  if (opt_dispatchEvent === undefined)
    opt_dispatchEvent = true;

  var contentView = this.view;
  if (contentView != null) {
    contentView.addElement(c, opt_dispatchEvent);
  }
  else {
    this.$addElement(c, opt_dispatchEvent);
  }
};


/**
 * @override
 * @param {Object} c
 * @param {number} index
 * @param {boolean=} opt_dispatchEvent
 */
org.apache.flex.core.ContainerBase.prototype.addElementAt = function(c, index, opt_dispatchEvent) {
  if (opt_dispatchEvent === undefined)
    opt_dispatchEvent = true;

  var contentView = this.view;
  if (contentView != null) {
    contentView.addElementAt(c, index, opt_dispatchEvent);
  }
  else {
    this.$addElementAt(c, index, opt_dispatchEvent);
  }
};


/**
 * @override
 */
org.apache.flex.core.ContainerBase.prototype.getElementAt = function(index) {
  var contentView = this.view;
  if (contentView != null) {
    return contentView.getElementAt(index);
  } else {
    return this.$getElementAt(index);
  }
};


/**
 * @override
 * @param {Object} c
 * @param {boolean=} opt_dispatchEvent
 */
org.apache.flex.core.ContainerBase.prototype.removeElement = function(c, opt_dispatchEvent) {
  var contentView = this.view;
  if (contentView != null) {
    contentView.removeElement(c, opt_dispatchEvent);
  } else {
    this.$removeElement(c, opt_dispatchEvent);
  }
};


/**
 * @override
 */
org.apache.flex.core.ContainerBase.prototype.getElementIndex = function(c) {
  var contentView = this.view;
  if (contentView != null) {
    return contentView.getElementIndex(c);
  } else {
    return this.$getElementIndex(c);
  }
};


/**
 * @expose
 * @return {number} The number of raw elements.
 */
org.apache.flex.core.ContainerBase.prototype.$numElements = function() {
  return this.internalChildren().length;
};


/**
 * @expose
 * @param {Object} c The element to add.
 * @param {boolean=} opt_dispatchEvent If true, an event is dispatched.
 */
org.apache.flex.core.ContainerBase.prototype.$addElement = function(c, opt_dispatchEvent) {
  if (opt_dispatchEvent === undefined)
    opt_dispatchEvent = true;
  this.element.appendChild(c.positioner);
  c.addedToParent();
  if (opt_dispatchEvent)
     this.dispatchEvent('childrenAdded');
};


/**
 * @expose
 * @param {Object} c The element to add.
 * @param {number} index The index of the element.
 * @param {boolean=} opt_dispatchEvent If true, an event is dispatched.
 */
org.apache.flex.core.ContainerBase.prototype.$addElementAt = function(c, index, opt_dispatchEvent) {
  if (opt_dispatchEvent === undefined)
    opt_dispatchEvent = true;
  var children1 = this.internalChildren();
  if (index >= children1.length) {
    this.$addElement(c, false);
  } else {
    this.element.insertBefore(c.positioner,
        children1[index]);
    c.addedToParent();
  }
  if (opt_dispatchEvent)
     this.dispatchEvent('childrenAdded');
};


/**
 * @expose
 * @param {Object} c The element to add.
 * @param {boolean=} opt_dispatchEvent If true, an event is dispatched.
 */
org.apache.flex.core.ContainerBase.prototype.$removeElement = function(c, opt_dispatchEvent) {
  this.element.removeChild(c.element);
  if (opt_dispatchEvent)
     this.dispatchEvent('childrenRemoved');
};


/**
 * @expose
 * @param {number} index The index of the number.
 * @return {Object} The element at the given index.
 */
org.apache.flex.core.ContainerBase.prototype.$getElementAt = function(index) {
  var children = this.internalChildren();
  return children[index].flexjs_wrapper;
};


/**
 * @expose
 * @param {Object} c The element being queried.
 * @return {number} The index of the element.
 */
org.apache.flex.core.ContainerBase.prototype.$getElementIndex = function(c) {
  var children = this.internalChildren();
   var n = children.length;
   for (var i = 0; i < n; i++)
   {
     if (children[i] == c.element)
       return i;
   }
   return -1;
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
    },
    /** @export */
    strandChildren: {
        /** @this {org.apache.flex.core.ContainerBase} */
        get: function() {
             return this.strandChildren_;
        }
    }
});
