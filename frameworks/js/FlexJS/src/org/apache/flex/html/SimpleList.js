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

goog.provide('org_apache_flex_html_SimpleList');

goog.require('org_apache_flex_core_ListBase');
goog.require('org_apache_flex_html_beads_models_ArraySelectionModel');



/**
 * @constructor
 * @extends {org_apache_flex_core_ListBase}
 */
org_apache_flex_html_SimpleList = function() {
  org_apache_flex_html_SimpleList.base(this, 'constructor');
  this.model = new org_apache_flex_html_beads.models.ArraySelectionModel();
};
goog.inherits(org_apache_flex_html_SimpleList,
    org_apache_flex_core_ListBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_SimpleList.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'SimpleList',
                qName: 'org_apache_flex_html_SimpleList'}] };


/**
 * @override
 */
org_apache_flex_html_SimpleList.prototype.
    createElement = function() {
  this.element = document.createElement('select');
  this.element.size = 5;
  goog.events.listen(this.element, 'change',
      goog.bind(this.changeHandler, this));
  this.positioner = this.element;
  this.set_className('SimpleList');

  return this.element;
};


/**
 * @override
 */
org_apache_flex_html_SimpleList.prototype.
    get_dataProvider = function() {
  return this.model.get_dataProvider();
};


/**
 * @override
 */
org_apache_flex_html_SimpleList.prototype.
    set_dataProvider = function(value) {
  var dp, i, n, opt;

  this.model.set_dataProvider(value);

  dp = this.element.options;
  n = dp.length;
  for (i = 0; i < n; i++) {
    dp.remove(0);
  }

  n = value.length;
  for (i = 0; i < n; i++) {
    opt = document.createElement('option');
    opt.text = value[i].toString();
    dp.add(opt);
  }

};


/**
 * @override
 */
org_apache_flex_html_SimpleList.prototype.
    get_selectedIndex = function() {
  return this.model.get_selectedIndex();
};


/**
 * @override
 */
org_apache_flex_html_SimpleList.prototype.
    set_selectedIndex = function(value) {
  this.model.set_selectedIndex(value);
};


/**
 * @override
 */
org_apache_flex_html_SimpleList.prototype.
    get_selectedItem = function() {
  return this.model.get_selectedItem();
};


/**
 * @override
 */
org_apache_flex_html_SimpleList.prototype.
    set_selectedItem = function(value) {
  this.model.set_selectedItem(value);
};

