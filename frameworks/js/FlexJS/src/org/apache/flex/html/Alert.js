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

goog.provide('org.apache.flex.html.Alert');

goog.require('org.apache.flex.core.UIBase');
goog.require('org.apache.flex.html.Container');
goog.require('org.apache.flex.html.Label');
goog.require('org.apache.flex.html.TextButton');
goog.require('org.apache.flex.html.TitleBar');



/**
 * @constructor
 * @extends {org.apache.flex.html.Container}
 */
org.apache.flex.html.Alert = function() {
  org.apache.flex.html.Alert.base(this, 'constructor');
};
goog.inherits(org.apache.flex.html.Alert,
    org.apache.flex.html.Container);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.Alert.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Alert',
                qName: 'org.apache.flex.html.Alert'}] };


/**
 * @type {number} The value for the Yes button option.
 */
org.apache.flex.html.Alert.YES = 0x000001;


/**
 * @type {number} The value for the No button option.
 */
org.apache.flex.html.Alert.NO = 0x000002;


/**
 * @type {number} The value for the OK button option.
 */
org.apache.flex.html.Alert.OK = 0x000004;


/**
 * @type {number} The value for the Cancel button option.
 */
org.apache.flex.html.Alert.CANCEL = 0x000008;


/**
 * @override
 */
org.apache.flex.html.Alert.prototype.createElement =
    function() {
  org.apache.flex.html.Alert.base(this, 'createElement');

  this.element.className = 'Alert';

  // add in a title bar
  this.titleBar = new org.apache.flex.html.TitleBar();
  this.addElement(this.titleBar);
  this.titleBar.element.id = 'titleBar';

  this.message = new org.apache.flex.html.Label();
  this.addElement(this.message);
  this.message.element.id = 'message';

  // add a place for the buttons
  this.buttonArea = new org.apache.flex.html.Container();
  this.addElement(this.buttonArea);
  this.buttonArea.element.id = 'buttonArea';

  return this.element;
};


/**
 * @param {string} message The message to be displayed.
 * @param {Object} host The object to display the alert.
 * @param {string} title The message to be displayed in the title bar.
 * @param {number} flags The options for the buttons.
 */
org.apache.flex.html.Alert.show =
    function(message, host, title, flags) {

  var a = new org.apache.flex.html.Alert();
  host.addElement(a);
  a.set_title(title);
  a.set_text(message);
  a.set_flags(flags);

  a.positioner.style.position = 'relative';
  a.positioner.style.width = '200px';
  a.positioner.style.margin = 'auto';
  a.positioner.style.top = '100px';
};


/**
 * @return {string} The message to be displayed in the title bar.
 */
org.apache.flex.html.Alert.prototype.get_title = function()
    {
  return this.titleBar.get_title();
};


/**
 * @param {string} value The message to be displayed in the title bar.
 */
org.apache.flex.html.Alert.prototype.set_title =
    function(value)
    {
  this.titleBar.set_title(value);
};


/**
 * @return {string} The message to be displayed.
 */
org.apache.flex.html.Alert.prototype.get_text = function()
    {
  return this.message.get_text();
};


/**
 * @param {string} value The message to be displayed.
 */
org.apache.flex.html.Alert.prototype.set_text =
    function(value)
    {
  this.message.set_text(value);
};


/**
 * @return {number} The button options.
 */
org.apache.flex.html.Alert.prototype.get_flags = function()
    {
  return this.flags;
};


/**
 * @param {number} value The button options.
 */
org.apache.flex.html.Alert.prototype.set_flags =
    function(value)
    {
  this.flags = value;

  // add buttons based on flags
  if (this.flags & org.apache.flex.html.Alert.OK) {
    var ok = new org.apache.flex.html.TextButton();
    this.buttonArea.addElement(ok);
    ok.set_text('OK');
    goog.events.listen(/** @type {EventTarget} */ (ok.element), 'click',
        goog.bind(this.dismissAlert, this));
  }
  if (this.flags & org.apache.flex.html.Alert.CANCEL) {
    var cancel = new org.apache.flex.html.TextButton();
    this.buttonArea.addElement(cancel);
    cancel.set_text('Cancel');
    goog.events.listen(/** @type {EventTarget} */ (cancel.element), 'click',
        goog.bind(this.dismissAlert, this));
  }
  if (this.flags & org.apache.flex.html.Alert.YES) {
    var yes = new org.apache.flex.html.TextButton();
    this.buttonArea.addElement(yes);
    yes.set_text('YES');
    goog.events.listen(/** @type {EventTarget} */ (yes.element), 'click',
        goog.bind(this.dismissAlert, this));
  }
  if (this.flags & org.apache.flex.html.Alert.NO) {
    var nob = new org.apache.flex.html.TextButton();
    this.buttonArea.addElement(nob);
    nob.set_text('NO');
    goog.events.listen(/** @type {EventTarget} */ (nob.element), 'click',
        goog.bind(this.dismissAlert, this));
  }
};


/**
 * @param {Object} event The event object.
 */
org.apache.flex.html.Alert.prototype.dismissAlert =
    function(event)
    {
  this.element.parentElement.removeChild(this.element);
};
