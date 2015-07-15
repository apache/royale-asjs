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

goog.provide('org.apache.flex.html.supportClasses.StringItemRenderer');

goog.require('org.apache.flex.core.IItemRenderer');
goog.require('org.apache.flex.core.UIBase');
goog.require('org.apache.flex.html.beads.controllers.ItemRendererMouseController');
goog.require('org.apache.flex.html.supportClasses.DataItemRenderer');
goog.require('org.apache.flex.utils.Language');



/**
 * @constructor
 * @extends {org.apache.flex.html.supportClasses.DataItemRenderer}
 * @implements {org.apache.flex.core.IItemRenderer}
 */
org.apache.flex.html.supportClasses.StringItemRenderer =
    function() {
  org.apache.flex.html.supportClasses.StringItemRenderer.base(this, 'constructor');
};
goog.inherits(
    org.apache.flex.html.supportClasses.StringItemRenderer,
    org.apache.flex.html.supportClasses.DataItemRenderer);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.supportClasses.StringItemRenderer.
    prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'StringItemRenderer',
                qName: 'org.apache.flex.html.supportClasses.StringItemRenderer' }],
      interfaces: [org.apache.flex.core.IItemRenderer] };


/**
 * @override
 */
org.apache.flex.html.supportClasses.StringItemRenderer.
    prototype.createElement = function() {

  this.element = document.createElement('div');
  this.positioner = this.element;

  this.element.flexjs_wrapper = this;
  this.className = 'StringItemRenderer';

  // itemRenderers should provide something for the background to handle
  // the selection and highlight
  this.backgroundView = this.element;

  this.controller = new org.apache.flex.html.beads.controllers.ItemRendererMouseController();
  this.controller.strand = this;

  return this.element;
};


Object.defineProperties(org.apache.flex.html.supportClasses.StringItemRenderer.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.html.supportClasses.StringItemRenderer} */
        set: function(value) {
            this.strand_ = value;
        },
        /** @this {org.apache.flex.html.supportClasses.StringItemRenderer} */
        get: function() {
             return this.strand_;
        }
    },
    /** @export */
    itemRendererParent: {
        /** @this {org.apache.flex.html.supportClasses.StringItemRenderer} */
        get: function() {
            return this.rendererParent_;
        },
        /** @this {org.apache.flex.html.supportClasses.StringItemRenderer} */
        set: function(value) {
            this.rendererParent_ = value;
        }
    },
    /** @export */
    index: {
        /** @this {org.apache.flex.html.supportClasses.StringItemRenderer} */
        set: function(value) {
            this.index_ = value;
        },
        /** @this {org.apache.flex.html.supportClasses.StringItemRenderer} */
        get: function() {
            return this.index_;
        }
    },
    /** @export */
    text: {
        /** @this {org.apache.flex.html.supportClasses.StringItemRenderer} */
        set: function(value) {
            this.element.innerHTML = value;
        },
        /** @this {org.apache.flex.html.supportClasses.StringItemRenderer} */
        get: function() {
            return this.element.innerHTML;
        }
    },
    /** @export */
    data: {
        /** @this {org.apache.flex.html.supportClasses.StringItemRenderer} */
        set: function(value) {
            org.apache.flex.utils.Language.superSetter(
                org.apache.flex.html.supportClasses.StringItemRenderer, this, 'data', value);

            if (this.labelField) {
              this.element.innerHTML = String(value[this.labelField]);
            }
            else if (this.dataField) {
              this.element.innerHTML = String(value[this.dataField]);
            }
            else if (value.toString) {
              this.element.innerHTML = value.toString();
            } else {
              this.element.innerHTML = String(value);
            }
        },
        /** @this {org.apache.flex.html.supportClasses.StringItemRenderer} */
        get: function() {
            return this.element.innerHTML;
        }
    }
});
