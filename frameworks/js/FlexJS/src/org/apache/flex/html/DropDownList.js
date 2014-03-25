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

goog.provide('org.apache.flex.html.DropDownList');

goog.require('org.apache.flex.core.ListBase');



/**
 * @constructor
 * @extends {org.apache.flex.core.ListBase}
 */
org.apache.flex.html.DropDownList = function() {
  goog.base(this);
  this.model = new org.apache.flex.html.beads.
      models.ArraySelectionModel();
};
goog.inherits(org.apache.flex.html.DropDownList,
    org.apache.flex.core.ListBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.DropDownList.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'DropDownList',
                qName: 'org.apache.flex.html.DropDownList'}] };


/**
 * @override
 */
org.apache.flex.html.DropDownList.prototype.
    createElement = function() {
  this.element = document.createElement('select');
  this.element.size = 1;
  goog.events.listen(this.element, 'change',
      goog.bind(this.changeHandler, this));
  this.positioner = this.element;

  return this.element;
};


/**
 * @expose
 * @param {Object} value The new dataProvider.
 */
org.apache.flex.html.DropDownList.prototype.
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
 * @protected
 */
org.apache.flex.html.DropDownList.prototype.changeHandler =
    function() {
  this.model.set_selectedIndex(this.element.selectedIndex);
  this.dispatchEvent('change');
};


/**
 * @expose
 * @param {number} value The new selected index.
 */
org.apache.flex.html.DropDownList.prototype.
    set_selectedIndex = function(value) {
  this.model.set_selectedIndex(value);
  this.element.selectedIndex = value;
};


/**
 * @expose
 * @param {Object} value The new selected item.
 */
org.apache.flex.html.DropDownList.prototype.
    set_selectedItem = function(value) {
  this.model.set_selectedItem(value);
  this.element.selectedIndex = this.get_selectedIndex();
};
