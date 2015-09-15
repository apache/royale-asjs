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

goog.provide('org.apache.flex.core.Application');

goog.require('org.apache.flex.core.HTMLElementWrapper');
goog.require('org.apache.flex.core.IParent');
goog.require('org.apache.flex.core.IValuesImpl');
goog.require('org.apache.flex.core.ValuesManager');
goog.require('org.apache.flex.utils.MXMLDataInterpreter');



/**
 * @constructor
 * @extends {org.apache.flex.core.HTMLElementWrapper}
 */
org.apache.flex.core.Application = function() {
  org.apache.flex.core.Application.base(this, 'constructor');
};
goog.inherits(org.apache.flex.core.Application,
    org.apache.flex.core.HTMLElementWrapper);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.Application.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Application',
                qName: 'org.apache.flex.core.Application' }],
      interfaces: [org.apache.flex.core.IParent] };


/**
 * @private
 * @type {Object}
 */
org.apache.flex.core.Application.prototype.controller_ = null;


/**
 * @private
 * @type {Object}
 */
org.apache.flex.core.Application.prototype.initialView_ = null;


/**
 * @private
 * @type {org.apache.flex.events.EventDispatcher}
 */
org.apache.flex.core.Application.prototype.model_ = null;


/**
 * @export
 */
org.apache.flex.core.Application.prototype.start = function() {
  this.element = document.getElementsByTagName('body')[0];
  this.element.flexjs_wrapper = this;
  this.element.className = 'Application';
  if (!this.element.style.overflow)
    this.element.style.overflow = 'hidden';

  org.apache.flex.utils.MXMLDataInterpreter.generateMXMLInstances(this, null, this.MXMLDescriptor);

  this.dispatchEvent('initialize');

  if (this.model) this.addBead(this.model);
  if (this.controller) this.addBead(this.controller);

  this.initialView.applicationModel = this.model;
  this.addElement(this.initialView);
  if (!isNaN(this.initialView.percentWidth) || !isNaN(this.initialView.percentHeight)) {
    this.element.style.height = window.innerHeight.toString() + 'px';
    this.element.style.width = window.innerWidth.toString() + 'px';
    this.initialView.dispatchEvent('sizeChanged'); // kick off layout if % sizes
  }
  this.dispatchEvent('viewChanged');
};


/**
 * @export
 * @param {Array} data The data for the attributes.
 */
org.apache.flex.core.Application.prototype.generateMXMLAttributes = function(data) {
  org.apache.flex.utils.MXMLDataInterpreter.generateMXMLProperties(this, data);
};


/**
 * @param {Object} c The child element.
 */
org.apache.flex.core.Application.prototype.addElement =
    function(c) {
  this.element.appendChild(c.element);
  c.addedToParent();
};


Object.defineProperties(org.apache.flex.core.Application.prototype,
  /** @lends {org.apache.flex.core.Application.prototype} */ {
  /** @export */
  valuesImpl: {
      /** @this {org.apache.flex.core.Application} */
      set: function(value) {
          org.apache.flex.core.ValuesManager.valuesImpl = value;
          if (value.init) {
            value.init(this);
          }
      }
  },
  /** @export */
  MXMLDescriptor: {
      /** @this {org.apache.flex.core.Application} */
      get: function() {
          return null;
      }
  },
  /** @export */
  controller: {
    /** @this {org.apache.flex.core.Application} */
    get: function() {
      return this.controller_;
    },

    /** @this {org.apache.flex.core.Application} */
    set: function(value) {
      if (value != this.controller_) {
        this.controller_ = value;
      }
    }
  },
  /** @export */
  initialView: {
    /** @this {org.apache.flex.core.Application} */
    get: function() {
      return this.initialView_;
    },

    /** @this {org.apache.flex.core.Application} */
    set: function(value) {
      if (value != this.initialView_) {
        this.initialView_ = value;
      }
    }
  },
  /** @export */
  model: {
    /** @this {org.apache.flex.core.Application} */
    get: function() {
      return this.model_;
    },

    /** @this {org.apache.flex.core.Application} */
    set: function(value) {
      if (value != this.model_) {
        this.model_ = value;
      }
    }
  }
});
