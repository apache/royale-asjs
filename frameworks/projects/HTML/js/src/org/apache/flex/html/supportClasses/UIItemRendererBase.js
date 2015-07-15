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

goog.provide('org.apache.flex.html.supportClasses.UIItemRendererBase');

goog.require('org.apache.flex.core.IItemRenderer');
goog.require('org.apache.flex.core.IItemRendererFactory');
goog.require('org.apache.flex.core.UIBase');
goog.require('org.apache.flex.events.Event');
goog.require('org.apache.flex.utils.MXMLDataInterpreter');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 * @implements {org.apache.flex.core.IItemRenderer}
 */
org.apache.flex.html.supportClasses.UIItemRendererBase =
function() {
  org.apache.flex.html.supportClasses.UIItemRendererBase.base(this, 'constructor');
};
goog.inherits(
    org.apache.flex.html.supportClasses.UIItemRendererBase,
    org.apache.flex.core.UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.supportClasses.UIItemRendererBase.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'UIItemRendererBase',
                qName: 'org.apache.flex.html.supportClasses.UIItemRendererBase' }],
      interfaces: [org.apache.flex.core.IItemRenderer, org.apache.flex.core.IItemRendererFactory]};


/**
 * @export
 */
org.apache.flex.html.supportClasses.UIItemRendererBase.prototype.addedToParent =
function() {
  org.apache.flex.html.supportClasses.UIItemRendererBase.base(this, 'addedToParent');

  // very common for item renderers to be resized by their containers,
  this.addEventListener('widthChanged', goog.bind(this.sizeChangeHandler, this));
  this.addEventListener('heightChanged', goog.bind(this.sizeChangeHandler, this));

  // each MXML file can also have styles in fx:Style block
  //? appropriate for JavaScript? ValuesManager.valuesImpl.init(this);

  org.apache.flex.utils.MXMLDataInterpreter.generateMXMLInstances(this, this, this.MXMLDescriptor);

  this.dispatchEvent(new org.apache.flex.events.Event('initComplete'));
};


/**
 * @export
 * @param {Array} data The data for the attributes.
 */
org.apache.flex.html.supportClasses.UIItemRendererBase.prototype.generateMXMLAttributes = function(data) {
  org.apache.flex.utils.MXMLDataInterpreter.generateMXMLProperties(this, data);
};


Object.defineProperties(org.apache.flex.html.supportClasses.UIItemRendererBase.prototype, {
    /** @export */
    MXMLDescriptor: {
        /** @this {org.apache.flex.html.supportClasses.UIItemRendererBase} */
        get: function() {
            return null;
        }
    },
    /** @export */
    data: {
        /** @this {org.apache.flex.html.supportClasses.UIItemRendererBase} */
        get: function() {
            return this.data_;
        },
        /** @this {org.apache.flex.html.supportClasses.UIItemRendererBase} */
        set: function(value) {
            this.data_ = value;
        }
    },
    /** @export */
    labelField: {
        /** @this {org.apache.flex.html.supportClasses.UIItemRendererBase} */
        get: function() {
            return this.labelField_;
        },
        /** @this {org.apache.flex.html.supportClasses.UIItemRendererBase} */
        set: function(value) {
            this.labelField_ = value;
        }
    },
    /** @export */
    index: {
        /** @this {org.apache.flex.html.supportClasses.UIItemRendererBase} */
        get: function() {
            return this.index_;
        },
        /** @this {org.apache.flex.html.supportClasses.UIItemRendererBase} */
        set: function(value) {
            this.index_ = value;
        }
    },
    /** @export */
    hovered: {
        /** @this {org.apache.flex.html.supportClasses.UIItemRendererBase} */
        get: function() {
            return this.hovered_;
        },
        /** @this {org.apache.flex.html.supportClasses.UIItemRendererBase} */
        set: function(value) {
            this.hovered_ = value;
        }
    },
    /** @export */
    selected: {
        /** @this {org.apache.flex.html.supportClasses.UIItemRendererBase} */
        get: function() {
            return this.selected_;
        },
        /** @this {org.apache.flex.html.supportClasses.UIItemRendererBase} */
        set: function(value) {
            this.selected_ = value;
        }
    },
    /** @export */
    down: {
        /** @this {org.apache.flex.html.supportClasses.UIItemRendererBase} */
        get: function() {
            return this.down_;
        },
        /** @this {org.apache.flex.html.supportClasses.UIItemRendererBase} */
        set: function(value) {
            this.down_ = value;
        }
    }
});


/**
 * @export
 */
org.apache.flex.html.supportClasses.UIItemRendererBase.prototype.updateRenderer =
function() {
};


/**
 * @export
 * @param {Event} value The event that triggered the size change.
 */
org.apache.flex.html.supportClasses.UIItemRendererBase.prototype.sizeChangeHandler =
function(value) {
  //this.adjustSize();
};


/**
 * @export
 */
org.apache.flex.html.supportClasses.UIItemRendererBase.prototype.adjustSize =
function() {
  // handle in sub-class
};
