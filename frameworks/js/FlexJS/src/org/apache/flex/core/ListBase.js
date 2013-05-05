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



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.core.ListBase = function() {
  goog.base(this);

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
 * @override
 * @this {org.apache.flex.core.ListBase}
 * @param {Object} p The parent element.
 */
org.apache.flex.core.ListBase.prototype.addToParent = function(p) {
  this.element = document.createElement('select');
  goog.events.listen(this.element, 'change',
      goog.bind(this.changeHandler, this));

  p.appendChild(this.element);

  this.positioner = this.element;
};


/**
 * @expose
 * @this {org.apache.flex.core.ListBase}
 * @return {Array.<Object>} The collection of data.
 */
org.apache.flex.core.ListBase.prototype.get_dataProvider =
    function() {
  return this.dataProvider;
};


/**
 * @expose
 * @this {org.apache.flex.core.ListBase}
 * @param {Array.<Object>} value The text setter.
 */
org.apache.flex.core.ListBase.prototype.set_dataProvider =
    function(value) {
  var dp, i, n, opt;

  this.dataProvider = value;

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
 * @this {org.apache.flex.core.ListBase}
 * @return {number} The selected index.
 */
org.apache.flex.core.ListBase.prototype.get_selectedIndex =
    function() {
  var result;

  if (this.element.selectedIndex !== undefined) {
    result = this.element.selectedIndex;
  } else {
    result = this.selectedIndex_;
  }

  return result;
};


/**
 * @expose
 * @this {org.apache.flex.core.ListBase}
 * @param {number} value The selected index.
 */
org.apache.flex.core.ListBase.prototype.set_selectedIndex =
    function(value) {
  this.selectedIndex_ = value;

  if (this.element.selectedIndex) {
    this.element.selectedIndex = value;
  }
};


/**
 * @expose
 * @this {org.apache.flex.core.ListBase}
 * @return {Object} The selected item.
 */
org.apache.flex.core.ListBase.prototype.get_selectedItem =
    function() {
  var si;

  si = this.get_selectedIndex();

  if (!this.dataProvider || si < 0 ||
      si >= this.dataProvider.length) {
    return null;
  }

  return this.dataProvider[si];
};


/**
 * @expose
 * @this {org.apache.flex.core.ListBase}
 * @param {Object} value The selected item.
 */
org.apache.flex.core.ListBase.prototype.set_selectedItem =
    function(value) {
  var dp, i, n;

  dp = this.dataProvider;
  n = dp.length;
  for (i = 0; i < n; i++) {
    if (dp[i] === value) {
      break;
    }
  }

  if (i < n) {
    this.selectedIndex_ = i;

    if (this.element.selectedIndex) {
      this.element.selectedIndex = i;
    }

    if (this.element.childNodes) {
      this.element.childNodes.item(0).value = dp[i];
    }
  }
};


/**
 * @protected
 * @this {org.apache.flex.core.ListBase}
 */
org.apache.flex.core.ListBase.prototype.changeHandler =
    function() {
  this.dispatchEvent('change');
};
