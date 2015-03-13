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

goog.provide('org_apache_flex_html_supportClasses_DataItemRenderer');

goog.require('org_apache_flex_core_IItemRenderer');
goog.require('org_apache_flex_html_beads_controllers_ItemRendererMouseController');
goog.require('org_apache_flex_html_supportClasses_UIItemRendererBase');



/**
 * @constructor
 * @extends {org_apache_flex_html_supportClasses_UIItemRendererBase}
 * @implements {org_apache_flex_core_IItemRenderer}
 */
org_apache_flex_html_supportClasses_DataItemRenderer =
    function() {
  org_apache_flex_html_supportClasses_DataItemRenderer.base(this, 'constructor');
};
goog.inherits(
    org_apache_flex_html_supportClasses_DataItemRenderer,
    org_apache_flex_html_supportClasses_UIItemRendererBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_supportClasses_DataItemRenderer.
    prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'DataItemRenderer',
                qName: 'org_apache_flex_html_supportClasses_DataItemRenderer' }],
      interfaces: [org_apache_flex_core_IItemRenderer] };


/**
 * @override
 */
org_apache_flex_html_supportClasses_DataItemRenderer.
    prototype.createElement = function() {

  this.element = document.createElement('div');
  this.positioner = this.element;

  this.element.flexjs_wrapper = this;
  this.className = 'DataItemRenderer';

  // itemRenderers should provide something for the background to handle
  // the selection and highlight
  this.backgroundView = this.element;

  this.controller = new org_apache_flex_html_beads_controllers_ItemRendererMouseController();
  this.controller.strand = this;

  return this.element;
};


Object.defineProperties(org_apache_flex_html_supportClasses_DataItemRenderer.prototype, {
    'itemRendererParent': {
        get: function() {
            return this.rendererParent_;
        },
        set: function(value) {
            this.rendererParent_ = value;
        }
    },
    'index': {
        set: function(value) {
            this.index_ = value;
        }
    },
    'dataField': {
        set: function(value) {
            this.dataField_ = value;
        },
        get: function() {
            return this.dataField_;
        }
    },
    'selected': {
        set: function(value) {
            this.selected_ = value;

            if (value) {
                this.backgroundView.style.backgroundColor = '#9C9C9C';
            } else {
                this.backgroundView.style.backgroundColor = null;
            }
        }
    },
    'hovered': {
        set: function(value) {
            this.hovered_ = value;

            if (value) {
              this.backgroundView.style.backgroundColor = '#ECECEC';
            } else {
              if (this.selected_) {
                this.backgroundView.style.backgroundColor = '#9C9C9C';
              } else {
                this.backgroundView.style.backgroundColor = null;
              }
            }
        }
    }
});
