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

goog.provide('org.apache.flex.jquery.CheckBox');

goog.require('org.apache.flex.core.UIBase');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.jquery.CheckBox = function() {
  goog.base(this);

};
goog.inherits(org.apache.flex.jquery.CheckBox,
    org.apache.flex.core.UIBase);


/**
 * @override
 */
org.apache.flex.jquery.CheckBox.prototype.createElement =
    function() {
  var cb, d, lb;

  d = document.createElement('div');
  cb = document.createElement('input');
  cb.type = 'checkbox';
  cb.id = 'checkbox1';

  lb = document.createElement('label');
  lb.htmlFor = 'checkbox1';

  d.appendChild(cb);
  d.appendChild(lb);

  this.element = d;

  $(cb).button();

  this.positioner = this.element;
  this.element.flexjs_wrapper = this;
};


/**
 * @expose
 * @return {string} The text getter.
 */
org.apache.flex.jquery.CheckBox.prototype.get_text = function() {
  return this.element.childNodes.item(1).value;
};


/**
 * @expose
 * @param {string} value The text setter.
 */
org.apache.flex.jquery.CheckBox.prototype.set_text =
    function(value) {
  this.element.childNodes.item(1).appendChild(document.createTextNode(value));
};


/**
 * @expose
 * @return {bool} The selected getter.
 */
org.apache.flex.jquery.CheckBox.prototype.get_selected =
    function() {
  return this.element.childNodes.item(0).checked;
};


/**
 * @expose
 * @param {bool} value The selected setter.
 */
org.apache.flex.jquery.CheckBox.prototype.set_selected =
    function(value) {
  this.element.childNodes.item(0).checked = value;
};
