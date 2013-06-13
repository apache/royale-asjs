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

goog.provide('org.apache.flex.html.staticControls.Alert');

goog.require('org.apache.flex.core.UIBase');
goog.require('org.apache.flex.html.staticControls.TitleBar');
goog.require('org.apache.flex.html.staticControls.Label');
goog.require('org.apache.flex.html.staticControls.TextButton');
goog.require('org.apache.flex.html.staticControls.Container');


/**
 * @constructor
 * @extends {org.apache.flex.html.staticControls.Container}
 */
org.apache.flex.html.staticControls.Alert = function() {
  goog.base(this);
 };

goog.inherits(org.apache.flex.html.staticControls.Alert,
    org.apache.flex.html.staticControls.Container);
    
org.apache.flex.html.staticControls.Alert.YES    = 0x000001;
org.apache.flex.html.staticControls.Alert.NO     = 0x000002;
org.apache.flex.html.staticControls.Alert.OK     = 0x000004;
org.apache.flex.html.staticControls.Alert.CANCEL = 0x000008;
    
org.apache.flex.html.staticControls.Alert.prototype.addToParent = function(p) {
  goog.base(this, 'addToParent', p);
  
  // add in a title bar
  this.titleBar = new org.apache.flex.html.staticControls.TitleBar();
  this.titleBar.addToParent(this);
  
  this.message = new org.apache.flex.html.staticControls.Label();
  this.message.addToParent(this);
  
  // add a place for the buttons
  this.buttonArea = new org.apache.flex.html.staticControls.Container();
  this.buttonArea.addToParent(this);
};


org.apache.flex.html.staticControls.Alert.show = function( message, host, title, flags ) {

	var a = new org.apache.flex.html.staticControls.Alert();
	a.addToParent(host);
	a.set_title(title);
	a.set_text(message);
	a.set_flags(flags);
	
	a.positioner.style.position = "relative";
	a.positioner.style.width = "200px";
	a.positioner.style.margin = "auto";
	a.positioner.style.top = "100px";
}

org.apache.flex.html.staticControls.Alert.prototype.set_title = function( value )
{
	this.titleBar.set_title(value);
}
org.apache.flex.html.staticControls.Alert.prototype.get_title = function()
{
	return this.titleBar.get_title();
}

org.apache.flex.html.staticControls.Alert.prototype.set_text = function( value )
{
	this.message.set_text(value);
}
org.apache.flex.html.staticControls.Alert.prototype.get_text = function()
{
	return this.message.get_text();
}

org.apache.flex.html.staticControls.Alert.prototype.set_flags = function( value )
{
	this.flags = value;
	
  // add buttons based on flags
  if( this.flags & org.apache.flex.html.staticControls.Alert.OK ) {
  	var ok = new org.apache.flex.html.staticControls.TextButton();
  	ok.addToParent(this.buttonArea);
  	ok.set_text("OK");
  	goog.events.listen(ok.element, 'click', goog.bind(this.dismissAlert, this));
  }
  if( this.flags & org.apache.flex.html.staticControls.Alert.CANCEL ) {
  	var cancel = new org.apache.flex.html.staticControls.TextButton();
  	cancel.addToParent(this.buttonArea);
  	cancel.set_text("Cancel");
  	goog.events.listen(cancel.element, 'click', goog.bind(this.dismissAlert, this));
  }
  if( this.flags & org.apache.flex.html.staticControls.Alert.YES ) {
  	var yes = new org.apache.flex.html.staticControls.TextButton();
  	yes.addToParent(this.buttonArea);
  	yes.set_text("YES");
  	goog.events.listen(yes.element, 'click', goog.bind(this.dismissAlert, this));
  }
  if( this.flags & org.apache.flex.html.staticControls.Alert.NO ) {
  	var nob = new org.apache.flex.html.staticControls.TextButton();
  	nob.addToParent(this.buttonArea);
  	nob.set_text("NO");
  	goog.events.listen(nob.element, 'click', goog.bind(this.dismissAlert, this));
  }
}
org.apache.flex.html.staticControls.Alert.prototype.get_flags = function()
{
	return this.flags;
}

org.apache.flex.html.staticControls.Alert.prototype.dismissAlert = function(event)
{
	this.element.parentElement.removeChild(this.element);
}