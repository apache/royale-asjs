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

goog.provide('org.apache.flex.html.staticControls.TitleBar');

goog.require('org.apache.flex.html.staticControls.Container');
goog.require('org.apache.flex.html.staticControls.Label');
goog.require('org.apache.flex.html.staticControls.TextButton');



/**
 * @constructor
 * @extends {org.apache.flex.html.staticControls.Container}
 */
org.apache.flex.html.staticControls.TitleBar = function() {
  goog.base(this);
  
  this._showCloseButton = false;
  
};
goog.inherits(org.apache.flex.html.staticControls.TitleBar,
    org.apache.flex.html.staticControls.Container);


/**
 * @override
 * @this {org.apache.flex.html.staticControls.TitleBar}
 * @param {Object} p The parent element.
 */
org.apache.flex.html.staticControls.TitleBar.prototype.addToParent =
    function(p) {

  this.element = document.createElement('div');
  
  this.titleLabel = new org.apache.flex.html.staticControls.Label();
  this.titleLabel.addToParent(this);
  this.titleLabel.positioner.style.display = "inline-block";
  this.titleLabel.set_className("TitleBarLabel");
  
  this.titleButton = new org.apache.flex.html.staticControls.TextButton();
  this.titleButton.addToParent(this);
  this.titleButton.text = 'Close';
  this.titleButton.positioner.style.display = this._showCloseButton ? "inline-block" : "none";
  
  //this.element.appendChild(this.titleLabel);
  //this.element.appendChild(this.titleButton);

  p.internalAddChild(this.element);

  this.positioner = this.element;
  this.element.flexjs_wrapper = this;
  
  this.set_className("TitleBar");
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.TitleBar}
 * @return {string} The title getter.
 */
org.apache.flex.html.staticControls.TitleBar.prototype.get_title = function() {
  return this.titleLabel.get_text();
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.TitleBar}
 * @param {string} value The title setter.
 */
org.apache.flex.html.staticControls.TitleBar.prototype.set_title = function(value) {
  this.titleLabel.set_text(value);
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.TitleBar}
 * @return {string} The showCloseButton getter.
 */
org.apache.flex.html.staticControls.TitleBar.prototype.get_showCloseButton = function() {
  return this._showCloseButton;
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.TitleBar}
 * @param {string} value The title setter.
 */
org.apache.flex.html.staticControls.TitleBar.prototype.set_showCloseButton = function(value) {
  this._showCloseButton = value;
  this.titleButton.positioner.style.display = value ? "inline-block" : "none";
};