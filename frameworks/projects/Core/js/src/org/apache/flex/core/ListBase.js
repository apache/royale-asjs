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

goog.provide('org.apache.flex.core.ListBase');

goog.require('org.apache.flex.core.IContentViewHost');
goog.require('org.apache.flex.core.ListBaseStrandChildren');
goog.require('org.apache.flex.core.UIBase');
goog.require('org.apache.flex.html.supportClasses.StringItemRenderer');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 * @implements {org.apache.flex.core.IContentViewHost}
 */
org.apache.flex.core.ListBase = function() {
  org.apache.flex.core.ListBase.base(this, 'constructor');

  /**
   * @private
   * @type {number}
   */
  this.selectedIndex_ = -1;

  /**
   * @private
   * @type {Object}
   */
  this.strandChildren_ = new org.apache.flex.core.ListBaseStrandChildren(this);
};
goog.inherits(org.apache.flex.core.ListBase,
    org.apache.flex.core.UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.ListBase.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ListBase',
                qName: 'org.apache.flex.core.ListBase' }],
      interfaces: [org.apache.flex.core.IContentViewHost] };


/**
 * @override
 */
org.apache.flex.core.ListBase.prototype.createElement = function() {
  //  this.element = document.createElement('select');
  //  goog.events.listen(this.element, 'change',
  //      goog.bind(this.changeHandler, this));
  this.element = document.createElement('div');
  this.element.style.position = 'relative';
  this.element.style.overflow = 'auto';
  this.element.style.border = 'solid';
  this.element.style.borderWidth = '1px';
  this.element.style.borderColor = '#333333';
  this.positioner = this.element;
  this.element.flexjs_wrapper = this;

  return this.element;
};


/**
 * @expose
 * @return {number} The number of raw elements.
 */
org.apache.flex.core.ListBase.prototype.$numElements = function() {
  return this.numElements();
};


/**
 * @expose
 * @param {Object} c The element to add.
 * @param {boolean=} opt_dispatchEvent If true, an event is dispatched.
 */
org.apache.flex.core.ListBase.prototype.$addElement = function(c, opt_dispatchEvent) {
  this.addElement(c, opt_dispatchEvent);
};


/**
 * @expose
 * @param {Object} c The element to add.
 * @param {number} index The index of the element.
 * @param {boolean=} opt_dispatchEvent If true, an event is dispatched.
 */
org.apache.flex.core.ListBase.prototype.$addElementAt = function(c, index, opt_dispatchEvent) {
  this.addElementAt(c, index, opt_dispatchEvent);
};


/**
 * @expose
 * @param {number} index The index of the number.
 * @return {Object} The element at the given index.
 */
org.apache.flex.core.ListBase.prototype.$getElementAt = function(index) {
  return this.getElementAt(index);
};


/**
 * @expose
 * @param {Object} c The element being queried.
 * @return {number} The index of the element.
 */
org.apache.flex.core.ListBase.prototype.$getElementIndex = function(c) {
  return this.getElementIndex(c);
};


Object.defineProperties(org.apache.flex.core.ListBase.prototype, {
    /** @export */
    dataProvider: {
        /** @this {org.apache.flex.core.ListBase} */
        get: function() {
            return this.model.dataProvider;
        },
        /** @this {org.apache.flex.core.ListBase} */
        set: function(value) {
            this.model.dataProvider = value;
        }
    },
    /** @export */
    selectedIndex: {
        /** @this {org.apache.flex.core.ListBase} */
        get: function() {
            return this.model.selectedIndex;
        },
        /** @this {org.apache.flex.core.ListBase} */
        set: function(value) {
            this.model.selectedIndex = value;
        }
    },
    /** @export */
    selectedItem: {
        /** @this {org.apache.flex.core.ListBase} */
        get: function() {
            return this.model.selectedItem;
        },
        /** @this {org.apache.flex.core.ListBase} */
        set: function(value) {
            this.model.selectedItem = value;
        }
    },
    /** @export */
    strandChildren: {
        /** @this {org.apache.flex.core.ListBase} */
        get: function() {
             return this.strandChildren_;
        }
    }
});


/**
 * @protected
 */
org.apache.flex.core.ListBase.prototype.changeHandler =
    function() {
  this.dispatchEvent('change');
};
