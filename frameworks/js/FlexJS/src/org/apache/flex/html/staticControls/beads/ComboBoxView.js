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

goog.provide('org.apache.flex.html.staticControls.beads.ComboBoxView');

goog.require('org.apache.flex.core.IItemRendererParent');
goog.require('org.apache.flex.html.staticControls.beads.TextItemRendererFactoryForArrayData');
goog.require('org.apache.flex.html.staticControls.beads.models.ArraySelectionModel');
goog.require('org.apache.flex.html.staticControls.supportClasses.NonVirtualDataGroup');

/**
 * @constructor
 */
org.apache.flex.html.staticControls.beads.ComboBoxView = function() {
  this.lastSelectedIndex = -1;
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.beads.ComboBoxView}
 * @param {Object} value The new host.
 */
org.apache.flex.html.staticControls.beads.ComboBoxView.prototype.set_strand =
    function(value) {

  this.strand_ = value;

  this.model = value.getBeadByType(
        org.apache.flex.html.staticControls.beads.models.ArraySelectionModel);
  this.model.addEventListener('selectedIndexChanged',
    goog.bind(this.selectionChangeHandler, this));
    
  this.input = document.createElement('input');
  this.input.style.position = 'relative';
  this.input.style.width = '80px';
  this.input.style.height = '21px';
  this.strand_.element.appendChild(this.input);

  this.button = document.createElement('div');
  this.button.style.position = 'relative';
  this.button.style.top = '0px';
  this.button.style.left = '80px';
  this.button.style.background = '#bbb';
  this.button.style.width = '50px';
  this.button.style.height = '21px';
  this.button.style.margin = '0';
  this.button.style.border = 'solid #609 1px';
  goog.events.listen(this.button, 'click', goog.bind(this.buttonClicked, this));
  this.strand_.element.appendChild(this.button);


  // add a click handler so that a click outside of the combo box can 
  // dismiss the pop-up should it be visible.
  goog.events.listen(document, 'click',
      goog.bind(this.dismissPopup, this));
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.ComboBox}
 * @param {string} event The event.
 */
org.apache.flex.html.staticControls.beads.ComboBoxView.prototype.dismissPopup =
    function(event) {
  // remove the popup if it already exists
  if (this.popup) {
    this.popup.parentNode.removeChild(this.popup);
    this.popup = null;
  }
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.ComboBox}
 * @param {string} event The event.
 */
org.apache.flex.html.staticControls.beads.ComboBoxView.prototype.buttonClicked =
    function(event) {
  var dp, i, left, n, opt, opts, pn, popup, select, si, top, width;

  event.stopPropagation();

  if (this.popup) {
    this.dismissPopup();

    return;
  }

  pn = this.strand_.element;
  top = pn.offsetTop + this.input.offsetHeight;
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
  goog.events.listen(select, 'change', goog.bind(this.selectChanged, this));
  opts = select.options;

  dp = this.strand_.get_dataProvider();
  n = dp.length;
/*  for (i = 0; i < n; i++) {
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
*/
  this.popup = popup;

  popup.appendChild(select);
  document.body.appendChild(popup);
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.beads.ComboBoxView}
 * @param {string} event The event.
 */
org.apache.flex.html.staticControls.beads.ComboBoxView.prototype.selectChanged =
    function(event) {
  var select;

  select = event.currentTarget;

  this.set_selectedItem(select.options[select.selectedIndex].value);

  this.popup.parentNode.removeChild(this.popup);
  this.popup = null;

  this.dispatchEvent(event);
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.beads.ComboBoxView}
 * @param {object} value The event that triggered the selection.
 */
org.apache.flex.html.staticControls.beads.ComboBoxView.prototype.
selectionChangeHandler = function(value) {
/*
  if (this.lastSelectedIndex != -1) {
    var ir = this.dataGroup_.getItemRendererForIndex(this.lastSelectedIndex);
    if (ir) ir.set_selected(false);
  }
  if (this.model.get_selectedIndex() != -1) {
    ir = this.dataGroup_.getItemRendererForIndex(
            this.model.get_selectedIndex());
    if (ir) ir.set_selected(true);
  }
  this.lastSelectedIndex = this.model.get_selectedIndex();
*/
};
