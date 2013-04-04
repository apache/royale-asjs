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

goog.require('org.apache.flex.core.UIBase');


/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.html5.staticControls.ComboBox = function() {
    org.apache.flex.core.UIBase.call(this);
    
    /**
     * @private
     * @type {Array.<Object>}
     */
    this._dataProvider;
    this._selectedIndex = -1;
};
goog.inherits(
    org.apache.flex.html5.staticControls.ComboBox, org.apache.flex.core.UIBase
);


/**
 * @override
 * @this {org.apache.flex.html5.staticControls.ComboBox}
 * @param {Object} p The parent element.
 */
org.apache.flex.html5.staticControls.ComboBox.prototype.addToParent = 
function(p) {
	this.element = document.createElement('div');
	
	var input = document.createElement('input');
	input.style.position = "absolute";
	input.style.width = "80px";
	this.element.appendChild(input);
	
	var button = document.createElement('div');
	button.style.position = "absolute";
	button.style.top = "0px";
	button.style.right = "0px";
	button.style.background = "#bbb";
	button.style.width = "16px";
	button.style.height = "20px";
	button.style.margin = "0";
	button.style.border = "solid #609 1px";
	button.onclick = org.apache.flex.FlexGlobal.createProxy(
                this, this.buttonClicked);
	this.element.appendChild(button);
	
	this.element.style.position = "relative";
	
    p.appendChild(this.element);

    this.positioner = this.element;
    
    // add a click handler to p's parentElement so that a click
    // outside of the combo box can dismiss the pop-up should it
    // be visible
    p.parentElement.onclick = org.apache.flex.FlexGlobal.createProxy(
                this, this.dismissPopup);
};

/**
 * @expose
 * @this {org.apache.flex.html5.staticControls.ComboBox}
 */
org.apache.flex.html5.staticControls.ComboBox.prototype.selectChanged =
function(event) {
	var select = event.currentTarget;
//	var input = this.element.childNodes.item(0);
//	input.value = select.value;
	this.set_selectedItem(select.value);
	
	this.popup.parentNode.removeChild(this.popup);
	this.popup = null;
	
	var evt = this.createEvent('change');
    this.dispatchEvent(evt);
};


/**
 * @expose
 * @this {org.apache.flex.html5.staticControls.ComboBox}
 */
org.apache.flex.html5.staticControls.ComboBox.prototype.dismissPopup =
function(event) {

	// remove the popup if it already exists
	if( this.popup ) {
		this.popup.parentNode.removeChild(this.popup);
		this.popup = null;
	}
};

/**
 * @expose
 * @this {org.apache.flex.html5.staticControls.ComboBox}
 */
org.apache.flex.html5.staticControls.ComboBox.prototype.buttonClicked =
function(event) {

	event.stopPropagation();
	
	// remove the popup if it already exists
	if( this.popup ) {
		this.popup.parentNode.removeChild(this.popup);
		this.popup = null;
		return;
	}
	
	var input = this.element.childNodes.item(0);
	
	var pn = this.element;
	var top = pn.offsetTop + input.offsetHeight;
	var left = pn.offsetLeft;
	var width = pn.offsetWidth;
	
    var popup = document.createElement('div');
    popup.className = 'popup';
    popup.id = 'test';
    popup.style.position = "absolute";
    popup.style.top = top.toString() + "px";
    popup.style.left = left.toString() + "px";
    popup.style.width = width.toString() + "px";
    popup.style.margin = "0px auto";
    popup.style.padding = "0px";
    popup.style.zIndex = "10000";
    
    var select = document.createElement('select');
    select.style.width = width.toString() + "px";
	select.onchange = org.apache.flex.FlexGlobal.createProxy(
                this, this.selectChanged);
    var opts = select.options;

    var dp = this._dataProvider;
    var n = dp.length;
    for (i = 0; i < n; i++)
    {
        var opt = document.createElement('option');
        opt.text = dp[i];
        opts.add(opt);
    }
    select.size = n;
    if( this._selectedIndex < 0 ) select.value = null;
    else select.value = this._dataProvider[this._selectedIndex];
    
    this.popup = popup;

    popup.appendChild(select); 
    document.body.appendChild(popup);
    

};

/**
 * @expose
 * @this {org.apache.flex.html5.staticControls.ComboBox}
 * @return {Array.<Object>} The collection of data.
 */
org.apache.flex.html5.staticControls.ComboBox.prototype.get_dataProvider =
function() {
    return this._dataProvider;
};

/**
 * @expose
 * @this {org.apache.flex.html5.staticControls.ComboBox}
 * @param {Array.<Object>} value The text setter.
 */
org.apache.flex.html5.staticControls.ComboBox.prototype.set_dataProvider =
function(value) {
    this._dataProvider = value;
};

/**
 * @expose
 * @this {org.apache.flex.html5.staticControls.ComboBox}
 * @return {int} The selected index.
 */
org.apache.flex.html5.staticControls.ComboBox.prototype.get_selectedIndex =
function() {
    return this._selectedIndex;
};

/**
 * @expose
 * @this {org.apache.flex.html5.staticControls.ComboBox}
 * @param {int} value The selected index.
 */
org.apache.flex.html5.staticControls.ComboBox.prototype.set_selectedIndex =
function(value) {
    this._selectedIndex = value;
};

/**
 * @expose
 * @this {org.apache.flex.html5.staticControls.ComboBox}
 * @return {Object} The selected item.
 */
org.apache.flex.html5.staticControls.ComboBox.prototype.get_selectedItem =
function() {
	if( this._dataProvider == null || this._selectedIndex < 0 || this._selectedIndex >= this._dataProvider.length ) return null;
    return this._dataProvider[this._selectedIndex];
};

/**
 * @expose
 * @this {org.apache.flex.html5.staticControls.ComboBox}
 * @param {Object} value The selected item.
 */
org.apache.flex.html5.staticControls.ComboBox.prototype.set_selectedItem =
function(value) {

    var dp = this._dataProvider;
    var n = dp.length;
    for (var i = 0; i < n; i++)
    {
        if (dp[i] == value)
            break;
    }
    if (i < n) {
        this._selectedIndex = i;
        this.element.childNodes.item(0).value = this._dataProvider[i];
    }
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
org.apache.flex.html5.staticControls.ComboBox.prototype.set_text = function(value) {
    this.element.childNodes.item(0).value = value;
};
