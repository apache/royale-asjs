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

goog.provide('org.apache.flex.html.SimpleList');

goog.require('org.apache.flex.core.ListBase');
goog.require('org.apache.flex.html.beads.models.ArraySelectionModel');



/**
 * @constructor
 * @extends {org.apache.flex.core.ListBase}
 */
org.apache.flex.html.SimpleList = function() {
  goog.base(this);
  this.model = new org.apache.flex.html.
      beads.models.ArraySelectionModel();
};
goog.inherits(org.apache.flex.html.SimpleList,
    org.apache.flex.core.ListBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.SimpleList.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'SimpleList',
                qName: 'org.apache.flex.html.SimpleList'}] };


/**
 * @override
 */
org.apache.flex.html.SimpleList.prototype.
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
org.apache.flex.html.SimpleList.prototype.
    get_dataProvider = function() {
  return this.model.get_dataProvider();
};


/**
 * @override
 */
org.apache.flex.html.SimpleList.prototype.
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
org.apache.flex.html.SimpleList.prototype.
    get_selectedIndex = function() {
  return this.model.get_selectedIndex();
};


/**
 * @override
 */
org.apache.flex.html.SimpleList.prototype.
    set_selectedIndex = function(value) {
  this.model.set_selectedIndex(value);
};


/**
 * @override
 */
org.apache.flex.html.SimpleList.prototype.
    get_selectedItem = function() {
  return this.model.get_selectedItem();
};


/**
 * @override
 */
org.apache.flex.html.SimpleList.prototype.
    set_selectedItem = function(value) {
  this.model.set_selectedItem(value);
};

