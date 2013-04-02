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

goog.provide('org.apache.flex.html5.staticControls.DropDownList');

goog.require('org.apache.flex.core.UIBase');

/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.html5.staticControls.DropDownList = function() {
    org.apache.flex.core.UIBase.call(this);

    /**
     * @private
     * @type {Array.<Object>}
     */
    this._dataProvider;

};
goog.inherits(
    org.apache.flex.html5.staticControls.DropDownList, org.apache.flex.core.UIBase
);

/**
 * @override
 * @this {org.apache.flex.html5.staticControls.DropDownList}
 * @param {Object} p The parent element.
 */
org.apache.flex.html5.staticControls.DropDownList.prototype.addToParent = function(p) {
    this.element = document.createElement('select');
    this.element.onchange = org.apache.flex.FlexGlobal.createProxy(
                this, this.changeHandler);
                
    p.appendChild(this.element);

    this.positioner = this.element;
};

/**
 * @expose
 * @this {org.apache.flex.html5.staticControls.DropDownList}
 * @return {Array.<Object>} The collection of data.
 */
org.apache.flex.html5.staticControls.DropDownList.prototype.get_dataProvider =
function() {
    return this._dataProvider;
};

/**
 * @expose
 * @this {org.apache.flex.html5.staticControls.DropDownList}
 * @param {Array.<Object>} value The text setter.
 */
org.apache.flex.html5.staticControls.DropDownList.prototype.set_dataProvider =
function(value) {
    this._dataProvider = value;

    var dp = this.element.options;
    var n = dp.length;
    for (var i = 0; i < n; i++)
        dp.remove(0);

    n = value.length;
    for (i = 0; i < n; i++)
    {
        var opt = document.createElement('option');
        opt.text = value[i];
        dp.add(opt);
    }
};

/**
 * @expose
 * @this {org.apache.flex.html5.staticControls.DropDownList}
 * @return {int} The selected index.
 */
org.apache.flex.html5.staticControls.DropDownList.prototype.get_selectedIndex =
function() {
    return this.element.selectedIndex;
};

/**
 * @expose
 * @this {org.apache.flex.html5.staticControls.DropDownList}
 * @param {int} value The selected index.
 */
org.apache.flex.html5.staticControls.DropDownList.prototype.set_selectedIndex =
function(value) {
    this.element.selectedIndex = value;
};

/**
 * @expose
 * @this {org.apache.flex.html5.staticControls.DropDownList}
 * @return {Object} The selected item.
 */
org.apache.flex.html5.staticControls.DropDownList.prototype.get_selectedItem =
function() {
    return this._dataProvider[this.element.selectedIndex];
};

/**
 * @expose
 * @this {org.apache.flex.html5.staticControls.DropDownList}
 * @param {Object} value The selected item.
 */
org.apache.flex.html5.staticControls.DropDownList.prototype.set_selectedItem =
function(value) {

    var dp = this._dataProvider;
    var n = dp.length;
    for (var i = 0; i < n; i++)
    {
        if (dp[i] == value)
            break;
    }
    if (i < n)
        this.element.selectedIndex = i;
};

/**
 * @protected
 * @this {org.apache.flex.html5.staticControls.DropDownList}
 * @return {Object} The selected item.
 */
org.apache.flex.html5.staticControls.DropDownList.prototype.changeHandler =
function() {
    evt = this.createEvent('change');
    this.dispatchEvent(evt);
};

