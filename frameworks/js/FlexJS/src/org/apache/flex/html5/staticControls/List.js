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

goog.provide('org.apache.flex.html5.staticControls.List');

goog.require('org.apache.flex.core.UIBase');

/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.html5.staticControls.List = function() {
    org.apache.flex.core.UIBase.call(this);

    /**
     * @private
     * @type {Array.<Object>}
     */
    this._dataProvider;

};
goog.inherits(
    org.apache.flex.html5.staticControls.List, org.apache.flex.core.UIBase
);

/**
 * @override
 * @this {org.apache.flex.html5.staticControls.List}
 * @param {Object} p The parent element.
 */
org.apache.flex.html5.staticControls.List.prototype.addToParent = function(p) {
    this.element = document.createElement('select');
    this.element.onChange = org.apache.flex.FlexGlobal.createProxy(
                this, this.changeHandler);
    this.element.size = 5;
                
    p.appendChild(this.element);

    this.positioner = this.element;
};

/**
 * @expose
 * @this {org.apache.flex.html5.staticControls.List}
 * @return {Array.<Object>} The collection of data.
 */
org.apache.flex.html5.staticControls.List.prototype.get_dataProvider =
function() {
    return this._dataProvider;
};

/**
 * @expose
 * @this {org.apache.flex.html5.staticControls.List}
 * @param {Array.<Object>} value The text setter.
 */
org.apache.flex.html5.staticControls.List.prototype.set_dataProvider =
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
 * @this {org.apache.flex.html5.staticControls.List}
 * @return {int} The selected index.
 */
org.apache.flex.html5.staticControls.List.prototype.get_selectedIndex =
function() {
    return this.element.selectedIndex;
};

/**
 * @expose
 * @this {org.apache.flex.html5.staticControls.List}
 * @param {int} value The selected index.
 */
org.apache.flex.html5.staticControls.List.prototype.set_selectedIndex =
function(value) {
    this.element.selectedIndex = value;
};

/**
 * @expose
 * @this {org.apache.flex.html5.staticControls.List}
 * @return {Object} The selected item.
 */
org.apache.flex.html5.staticControls.List.prototype.get_selectedItem =
function() {
    return this._dataProvider[this.element.selectedIndex];
};

/**
 * @expose
 * @this {org.apache.flex.html5.staticControls.List}
 * @param {Object} value The selected item.
 */
org.apache.flex.html5.staticControls.List.prototype.set_selectedItem =
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
 * @this {org.apache.flex.html5.staticControls.List}
 * @return {Object} The selected item.
 */
org.apache.flex.html5.staticControls.List.prototype.changeHandler =
function() {
    evt = document.createEvent('Event');
    evt.initEvent('change', false, false);
    this.element.dispatchEvent(evt);
};

