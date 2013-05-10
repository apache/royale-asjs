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

goog.provide('org.apache.flex.html5.staticControls.ComboBox');

goog.require('org.apache.flex.core.ListBase');



/**
 * @constructor
 * @extends {org.apache.flex.core.ListBase}
 */
org.apache.flex.html5.staticControls.ComboBox = function() {
  goog.base(this);
};
goog.inherits(org.apache.flex.html5.staticControls.ComboBox,
    org.apache.flex.core.ListBase);


/**
 * @override
 * @this {org.apache.flex.html5.staticControls.ComboBox}
 * @param {Object} p The parent element.
 */
org.apache.flex.html5.staticControls.ComboBox.prototype.addToParent =
    function(p) {
  var button, input;

  this.element = document.createElement('div');

  input = document.createElement('input');
  input.style.position = 'absolute';
  input.style.width = '80px';
  this.element.appendChild(input);

  button = document.createElement('div');
  button.style.position = 'absolute';
  button.style.top = '0px';
  button.style.right = '0px';
  button.style.background = '#bbb';
  button.style.width = '16px';
  button.style.height = '20px';
  button.style.margin = '0';
  button.style.border = 'solid #609 1px';
  button.onclick = goog.bind(this.buttonClicked, this);
  this.element.appendChild(button);

  this.element.style.position = 'relative';

  p.internalAddChild(this.element);

  this.positioner = this.element;

  // add a click handler to p's parentElement so that a click
  // outside of the combo box can dismiss the pop-up should it
  // be visible
  p.parentElement.onclick = goog.bind(this.dismissPopup, this);
};


/**
 * @expose
 * @this {org.apache.flex.html5.staticControls.ComboBox}
 * @param {string} event The event.
 */
org.apache.flex.html5.staticControls.ComboBox.prototype.selectChanged =
    function(event) {
  var select;

  select = event.currentTarget;
  this.set_selectedItem(select.value);

  this.popup.parentNode.removeChild(this.popup);
  this.popup = null;

  this.dispatchEvent('change');
};


/**
 * @expose
 * @this {org.apache.flex.html5.staticControls.ComboBox}
 * @param {string} event The event.
 */
org.apache.flex.html5.staticControls.ComboBox.prototype.dismissPopup =
    function(event) {
  if (this.popup) {
    this.popup.parentNode.removeChild(this.popup);
    this.popup = null;
  }
};


/**
 * @expose
 * @this {org.apache.flex.html5.staticControls.ComboBox}
 * @param {string} event The event.
 */
org.apache.flex.html5.staticControls.ComboBox.prototype.buttonClicked =
    function(event) {
  var dp, i, input, left, n, opt, opts, pn, popup, select, si, top, width;

  event.stopPropagation();

  if (this.popup) {
    this.popup.parentNode.removeChild(this.popup);
    this.popup = null;
    return;
  }

  input = this.element.childNodes.item(0);

  pn = this.element;
  top = pn.offsetTop + input.offsetHeight;
  left = pn.offsetLeft;
  width = pn.offsetWidth;

  popup = document.createElement('div');
  popup.className = 'popup';
  popup.id = 'test';
  popup.style.position = 'absolute';
  popup.style.top = top.toString() + 'px';
  popup.style.left = left.toString() + 'px';
  popup.style.width = width.toString() + 'px';
  popup.style.margin = '0px auto';
  popup.style.padding = '0px';
  popup.style.zIndex = '10000';

  select = document.createElement('select');
  select.style.width = width.toString() + 'px';
  select.onchange = goog.bind(this.selectChanged, this);
  opts = select.options;

  dp = this.get_dataProvider();
  n = dp.length;
  for (i = 0; i < n; i++) {
    opt = document.createElement('option');
    opt.text = dp[i];
    opts.add(opt);
  }

  select.size = n;

  si = this.get_selectedIndex();
  if (si < 0) {
    select.value = null;
  } else {
    select.value = dp[si];
  }

  this.popup = popup;

  popup.appendChild(select);
  document.body.appendChild(popup);
};


/**
 * @override
 * @expose
 * @this {org.apache.flex.html5.staticControls.ComboBox}
 * @param {Array.<Object>} value The collection of data.
 */
org.apache.flex.html5.staticControls.ComboBox.prototype.set_dataProvider =
    function(value) {
  this.dataProvider = value;
};


/**
 * @expose
 * @this {org.apache.flex.html5.staticControls.ComboBox}
 * @return {string} The text getter.
 */
org.apache.flex.html5.staticControls.ComboBox.prototype.get_text = function() {
  return this.element.childNodes.item(0).value;
};


/**
 * @expose
 * @this {org.apache.flex.html5.staticControls.ComboBox}
 * @param {string} value The text setter.
 */
org.apache.flex.html5.staticControls.ComboBox.prototype.set_text =
    function(value) {
  this.element.childNodes.item(0).value = value;
};
