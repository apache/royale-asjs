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

goog.provide('org.apache.flex.html.staticControls.SimpleList');

goog.require('org.apache.flex.core.ListBase');
goog.require('org.apache.flex.html.staticControls.beads.models.ArraySelectionModel');


/**
 * @constructor
 * @extends {org.apache.flex.core.ListBase}
 */
org.apache.flex.html.staticControls.SimpleList = function() {
  this.model =
     new org.apache.flex.html.staticControls.beads.models.ArraySelectionModel();
  goog.base(this);
};
goog.inherits(org.apache.flex.html.staticControls.SimpleList,
    org.apache.flex.core.ListBase);


/**
 * @override
 * @this {org.apache.flex.html.staticControls.SimpleList}
 */
org.apache.flex.html.staticControls.SimpleList.prototype.
createElement = function() {
  this.element = document.createElement('select');
  this.element.size = 5;
  goog.events.listen(this.element, 'change',
    goog.bind(this.changeHandler, this));
  this.positioner = this.element;
  this.set_className('SimpleList');
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.SimpleList}
 * @return {Object} Returns the dataProvider.
 */
org.apache.flex.html.staticControls.SimpleList.prototype.
get_dataProvider = function() {
  return this.model.get_dataProvider();
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.SimpleList}
 * @param {Object} value The new dataProvider.
 */
org.apache.flex.html.staticControls.SimpleList.prototype.
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
    opt.text = value[i];
    dp.add(opt);
  }

};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.SimpleList}
 * @return {Object} Returns the selected index.
 */
org.apache.flex.html.staticControls.SimpleList.prototype.
get_selectedIndex = function() {
  return this.model.get_selectedIndex();
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.SimpleList}
 * @param {Number} value The new selected index.
 */
org.apache.flex.html.staticControls.SimpleList.prototype.
set_selectedIndex = function(value) {
   this.model.set_selectedIndex(value);
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.SimpleList}
 * @return {Object} Returns the selectedItem.
 */
org.apache.flex.html.staticControls.SimpleList.prototype.
get_selectedItem = function() {
   return this.model.get_selectedItem();
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.SimpleList}
 * @param {Object} value The new selected item.
 */
org.apache.flex.html.staticControls.SimpleList.prototype.
set_selectedItem = function(value) {
   this.model.set_selectedItem(value);
};

