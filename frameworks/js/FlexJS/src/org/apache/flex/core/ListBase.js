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

goog.require('org.apache.flex.core.UIBase');
goog.require('org.apache.flex.html.supportClasses.StringItemRenderer');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.core.ListBase = function() {
  org.apache.flex.core.ListBase.base(this, 'constructor');

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
goog.inherits(org.apache.flex.core.ListBase,
    org.apache.flex.core.UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.ListBase.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ListBase',
                qName: 'org.apache.flex.core.ListBase' }] };


/**
 * @override
 */
org.apache.flex.core.ListBase.prototype.createElement = function() {
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


/**
 * @expose
 * @return {Array.<Object>} The collection of data.
 */
org.apache.flex.core.ListBase.prototype.get_dataProvider =
    function() {
  return this.get_model().get_dataProvider();
};


/**
 * @expose
 * @param {Array.<Object>} value The text setter.
 */
org.apache.flex.core.ListBase.prototype.set_dataProvider =
    function(value) {
  this.get_model().set_dataProvider(value);
};


/**
 * @expose
 * @return {number} The selected index.
 */
org.apache.flex.core.ListBase.prototype.get_selectedIndex =
    function() {
  return this.get_model().get_selectedIndex();
};


/**
 * @expose
 * @param {number} value The selected index.
 */
org.apache.flex.core.ListBase.prototype.set_selectedIndex =
    function(value) {
  this.get_model().set_selectedIndex(value);
};


/**
 * @expose
 * @return {Object} The selected item.
 */
org.apache.flex.core.ListBase.prototype.get_selectedItem =
    function() {
  return this.get_model().get_selectedItem();
};


/**
 * @expose
 * @param {Object} value The selected item.
 */
org.apache.flex.core.ListBase.prototype.set_selectedItem =
    function(value) {
  this.get_model().set_selectedItem(value);
};


/**
 * @protected
 */
org.apache.flex.core.ListBase.prototype.changeHandler =
    function() {
  this.dispatchEvent('change');
};
