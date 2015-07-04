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

goog.provide('org_apache_flex_html_supportClasses_UIItemRendererBase');

goog.require('org_apache_flex_core_IItemRenderer');
goog.require('org_apache_flex_core_IItemRendererFactory');
goog.require('org_apache_flex_core_UIBase');
goog.require('org_apache_flex_events_Event');
goog.require('org_apache_flex_utils_MXMLDataInterpreter');



/**
 * @constructor
 * @extends {org_apache_flex_core_UIBase}
 * @implements {org_apache_flex_core_IItemRenderer}
 */
org_apache_flex_html_supportClasses_UIItemRendererBase =
function() {
  org_apache_flex_html_supportClasses_UIItemRendererBase.base(this, 'constructor');
};
goog.inherits(
    org_apache_flex_html_supportClasses_UIItemRendererBase,
    org_apache_flex_core_UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_supportClasses_UIItemRendererBase.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'UIItemRendererBase',
                qName: 'org_apache_flex_html_supportClasses_UIItemRendererBase' }],
      interfaces: [org_apache_flex_core_IItemRenderer, org_apache_flex_core_IItemRendererFactory]};


/**
 * @export
 */
org_apache_flex_html_supportClasses_UIItemRendererBase.prototype.addedToParent =
function() {
  org_apache_flex_html_supportClasses_UIItemRendererBase.base(this, 'addedToParent');

  // very common for item renderers to be resized by their containers,
  this.addEventListener('widthChanged', goog.bind(this.sizeChangeHandler, this));
  this.addEventListener('heightChanged', goog.bind(this.sizeChangeHandler, this));

  // each MXML file can also have styles in fx:Style block
  //? appropriate for JavaScript? ValuesManager.valuesImpl.init(this);

  org_apache_flex_utils_MXMLDataInterpreter.generateMXMLInstances(this, this, this.MXMLDescriptor);

  this.dispatchEvent(new org_apache_flex_events_Event('initComplete'));
};


/**
 * @export
 * @param {Array} data The data for the attributes.
 */
org_apache_flex_html_supportClasses_UIItemRendererBase.prototype.generateMXMLAttributes = function(data) {
  org_apache_flex_utils_MXMLDataInterpreter.generateMXMLProperties(this, data);
};


Object.defineProperties(org_apache_flex_html_supportClasses_UIItemRendererBase.prototype, {
    /** @export */
    MXMLDescriptor: {
        /** @this {org_apache_flex_html_supportClasses_UIItemRendererBase} */
        get: function() {
            return null;
        }
    },
    /** @export */
    data: {
        /** @this {org_apache_flex_html_supportClasses_UIItemRendererBase} */
        get: function() {
            return this.data_;
        },
        /** @this {org_apache_flex_html_supportClasses_UIItemRendererBase} */
        set: function(value) {
            this.data_ = value;
        }
    },
    /** @export */
    labelField: {
        /** @this {org_apache_flex_html_supportClasses_UIItemRendererBase} */
        get: function() {
            return this.labelField_;
        },
        /** @this {org_apache_flex_html_supportClasses_UIItemRendererBase} */
        set: function(value) {
            this.labelField_ = value;
        }
    },
    /** @export */
    index: {
        /** @this {org_apache_flex_html_supportClasses_UIItemRendererBase} */
        get: function() {
            return this.index_;
        },
        /** @this {org_apache_flex_html_supportClasses_UIItemRendererBase} */
        set: function(value) {
            this.index_ = value;
        }
    },
    /** @export */
    hovered: {
        /** @this {org_apache_flex_html_supportClasses_UIItemRendererBase} */
        get: function() {
            return this.hovered_;
        },
        /** @this {org_apache_flex_html_supportClasses_UIItemRendererBase} */
        set: function(value) {
            this.hovered_ = value;
        }
    },
    /** @export */
    selected: {
        /** @this {org_apache_flex_html_supportClasses_UIItemRendererBase} */
        get: function() {
            return this.selected_;
        },
        /** @this {org_apache_flex_html_supportClasses_UIItemRendererBase} */
        set: function(value) {
            this.selected_ = value;
        }
    },
    /** @export */
    down: {
        /** @this {org_apache_flex_html_supportClasses_UIItemRendererBase} */
        get: function() {
            return this.down_;
        },
        /** @this {org_apache_flex_html_supportClasses_UIItemRendererBase} */
        set: function(value) {
            this.down_ = value;
        }
    }
});


/**
 * @export
 */
org_apache_flex_html_supportClasses_UIItemRendererBase.prototype.updateRenderer =
function() {
};


/**
 * @export
 * @param {Event} value The event that triggered the size change.
 */
org_apache_flex_html_supportClasses_UIItemRendererBase.prototype.sizeChangeHandler =
function(value) {
  //this.adjustSize();
};


/**
 * @export
 */
org_apache_flex_html_supportClasses_UIItemRendererBase.prototype.adjustSize =
function() {
  // handle in sub-class
};
