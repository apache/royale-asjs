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

goog.provide('org_apache_flex_core_ListBase');

goog.require('org_apache_flex_core_UIBase');
goog.require('org_apache_flex_html_supportClasses_StringItemRenderer');



/**
 * @constructor
 * @extends {org_apache_flex_core_UIBase}
 */
org_apache_flex_core_ListBase = function() {
  org_apache_flex_core_ListBase.base(this, 'constructor');

  /**
   * @protected
   * @type {Array.<Object>}
   */
  this.dataProvider = null;

  /**
   * @private
   * @type {number}
   */
  this.selectedIndex_ = -1;
};
goog.inherits(org_apache_flex_core_ListBase,
    org_apache_flex_core_UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_core_ListBase.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ListBase',
                qName: 'org_apache_flex_core_ListBase' }] };


/**
 * @override
 */
org_apache_flex_core_ListBase.prototype.createElement = function() {
  //  this.element = document.createElement('select');
  //  goog.events.listen(this.element, 'change',
  //      goog.bind(this.changeHandler, this));
  this.element = document.createElement('div');
  this.element.style.overflow = 'auto';
  this.element.style.border = 'solid';
  this.element.style.borderWidth = '1px';
  this.element.style.borderColor = '#333333';
  this.positioner = this.element;
  this.element.flexjs_wrapper = this;

  return this.element;
};


Object.defineProperties(org_apache_flex_core_ListBase.prototype, {
    'dataProvider': {
        /** @this {org_apache_flex_core_ListBase} */
        get: function() {
            return this.model.dataProvider;
        },
        /** @this {org_apache_flex_core_ListBase} */
		set: function(value) {
            this.model.dataProvider = value;
		}
	},
    'selectedIndex': {
        /** @this {org_apache_flex_core_ListBase} */
        get: function() {
            return this.model.selectedIndex;
		},
        /** @this {org_apache_flex_core_ListBase} */
        set: function(value) {
            this.model.selectedIndex = value;
		}
	},
    'selectedItem': {
        /** @this {org_apache_flex_core_ListBase} */
        get: function() {
            return this.model.selectedItem;
		},
        /** @this {org_apache_flex_core_ListBase} */
        set: function(value) {
            this.model.selectedItem = value;
		}
	}
});


/**
 * @protected
 */
org_apache_flex_core_ListBase.prototype.changeHandler =
    function() {
  this.dispatchEvent('change');
};
