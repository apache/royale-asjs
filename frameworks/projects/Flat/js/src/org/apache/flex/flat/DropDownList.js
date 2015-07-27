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

goog.provide('org.apache.flex.flat.DropDownList');

goog.require('org.apache.flex.core.ListBase');
goog.require('org.apache.flex.html.beads.models.ArraySelectionModel');



/**
 * @constructor
 * @extends {org.apache.flex.core.ListBase}
 */
org.apache.flex.flat.DropDownList = function() {
  org.apache.flex.flat.DropDownList.base(this, 'constructor');
  this.model = new org.apache.flex.html.beads.models.ArraySelectionModel();
};
goog.inherits(org.apache.flex.flat.DropDownList,
    org.apache.flex.core.ListBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.flat.DropDownList.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'DropDownList',
                qName: 'org.apache.flex.flat.DropDownList'}] };


/**
 * @override
 */
org.apache.flex.flat.DropDownList.prototype.createElement =
    function() {
  var button, input;

  this.element = document.createElement('div');

  this.button = button = document.createElement('button');
  button.className = 'dropdown-toggle-open-btn';
  goog.events.listen(button, 'click', goog.bind(this.buttonClicked, this));
  this.element.appendChild(button);

  var caret = document.createElement('span');
  caret.className = 'dropdown-caret';

  this.element.style.position = 'relative';

  this.positioner = this.element;

  // add a click handler so that a click outside of the combo box can
  // dismiss the pop-up should it be visible.
  goog.events.listen(document, 'click',
      goog.bind(this.dismissPopup, this));

  button.flexjs_wrapper = this;
  this.element.flexjs_wrapper = this;
  caret.flexjs_wrapper = this;

  return this.element;
};


/**
 * @export
 * @param {Object} event The event.
 */
org.apache.flex.flat.DropDownList.prototype.selectChanged =
    function(event) {
  var select;

  select = event.target;

  this.selectedIndex = parseInt(select.id, 10);

  this.menu.parentNode.removeChild(this.menu);
  this.menu = null;

  this.dispatchEvent('change');
};


/**
 * @export
 * @param {Object=} opt_event The event.
 */
org.apache.flex.flat.DropDownList.prototype.dismissPopup =
    function(opt_event) {
  // remove the popup if it already exists
  if (this.menu) {
    this.menu.parentNode.removeChild(this.menu);
    this.menu = null;
  }
};


/**
 * @export
 * @param {Object} event The event.
 */
org.apache.flex.flat.DropDownList.prototype.buttonClicked =
    function(event) {
  /**
   * @type {Array.<string>}
   */
  var dp;
  var i, button, left, n, opt, opts, pn, popup, select, si, top, width;

  event.stopPropagation();

  if (this.popup) {
    this.dismissPopup();

    return;
  }

  button = this.element.childNodes.item(0);

  pn = this.element;
  top = pn.offsetTop + button.offsetHeight;
  left = pn.offsetLeft;
  width = pn.offsetWidth;

  /*
  popup = document.createElement('div');
  popup.className = 'dropdown-menu';
  popup.id = 'test';
  popup.style.position = 'absolute';
  popup.style.top = top.toString() + 'px';
  popup.style.left = left.toString() + 'px';
  popup.style.width = width.toString() + 'px';
  popup.style.margin = '0px auto';
  popup.style.padding = '0px';
  popup.style.zIndex = '10000';
  */

  this.menu = select = document.createElement('ul');
  select.style.width = width.toString() + 'px';
  goog.events.listen(select, 'click', goog.bind(this.selectChanged, this));
  select.className = 'dropdown-menu';

  dp = /** @type {Array.<string>} */ (this.dataProvider);
  n = dp.length;
  for (i = 0; i < n; i++) {
    opt = document.createElement('li');
    opt.style.backgroundColor = 'transparent';
    var ir = document.createElement('a');
    ir.innerHTML = dp[i];
    ir.id = i.toString();
    if (i == this.selectedIndex)
      ir.className = 'dropdown-menu-item-renderer-selected';
    else
      ir.className = 'dropdown-menu-item-renderer';
    opt.appendChild(ir);
    select.appendChild(opt);
  }

  this.element.appendChild(select);
};


Object.defineProperties(org.apache.flex.flat.DropDownList.prototype, {
    dataProvider: {
        /** @this {org.apache.flex.flat.DropDownList} */
        get: function() {
            return this.model.dataProvider;
        },
        /** @this {org.apache.flex.flat.DropDownList} */
        set: function(value) {
            var dp, i, n, opt;

            this.model.dataProvider = value;
        }
    },
    /** @export */
    selectedIndex: {
        // TODO: (aharui) copied from ListBase because you
        // can't just override the setter in a defineProps
        // structure.
        /** @this {org.apache.flex.flat.DropDownList} */
        get: function() {
            return this.model.selectedIndex;
        },
        /** @this {org.apache.flex.flat.DropDownList} */
        set: function(value) {
            this.model.selectedIndex = value;
            this.button.innerHTML = this.selectedItem + '<span class="dropdown-caret"/>';
        }
    },
    /** @export */
    selectedItem: {
        // TODO: (aharui) copied from ListBase because you
        // can't just override the setter in a defineProps
        // structure.
        /** @this {org.apache.flex.flat.DropDownList} */
        get: function() {
            return this.model.selectedItem;
        },
        /** @this {org.apache.flex.flat.DropDownList} */
        set: function(value) {
            this.model.selectedItem = value;
            this.button.innerHTML = this.selectedItem + '<span class="dropdown-caret"/>';
         }
    }
});
