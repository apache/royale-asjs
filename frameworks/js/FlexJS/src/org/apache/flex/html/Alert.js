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

goog.provide('org_apache_flex_html_Alert');

goog.require('org_apache_flex_core_UIBase');
goog.require('org_apache_flex_html_Container');
goog.require('org_apache_flex_html_Label');
goog.require('org_apache_flex_html_TextButton');
goog.require('org_apache_flex_html_TitleBar');



/**
 * @constructor
 * @extends {org_apache_flex_html_Container}
 */
org_apache_flex_html_Alert = function() {
  org_apache_flex_html_Alert.base(this, 'constructor');
};
goog.inherits(org_apache_flex_html_Alert,
    org_apache_flex_html_Container);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_Alert.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Alert',
                qName: 'org_apache_flex_html_Alert'}] };


/**
 * @type {number} The value for the Yes button option.
 */
org_apache_flex_html_Alert.YES = 0x000001;


/**
 * @type {number} The value for the No button option.
 */
org_apache_flex_html_Alert.NO = 0x000002;


/**
 * @type {number} The value for the OK button option.
 */
org_apache_flex_html_Alert.OK = 0x000004;


/**
 * @type {number} The value for the Cancel button option.
 */
org_apache_flex_html_Alert.CANCEL = 0x000008;


/**
 * @override
 */
org_apache_flex_html_Alert.prototype.createElement =
    function() {
  org_apache_flex_html_Alert.base(this, 'createElement');

  this.element.className = 'Alert';

  // add in a title bar
  this.titleBar = new org_apache_flex_html_TitleBar();
  this.addElement(this.titleBar);
  this.titleBar.element.id = 'titleBar';

  this.message = new org_apache_flex_html_Label();
  this.addElement(this.message);
  this.message.element.id = 'message';

  // add a place for the buttons
  this.buttonArea = new org_apache_flex_html_Container();
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
org_apache_flex_html_Alert.show =
    function(message, host, title, flags) {

  var a = new org_apache_flex_html_Alert();
  host.addElement(a);
  a.title = title;
  a.text = message;
  a.flags = flags;

  a.positioner.style.position = 'relative';
  a.positioner.style.width = '200px';
  a.positioner.style.margin = 'auto';
  a.positioner.style.top = '100px';
};


Object.defineProperties(org_apache_flex_html_Alert.prototype, {
    'title': {
        get: function() {
            return this.titleBar.title;
        },
        set: function(value) {
            this.titleBar.title = value;
        }
    },
    'text': {
        get: function() {
            return this.message.text;
        },
        set: function(value) {
            this.message.text = value;
        }
    },
    'flags': {
        get: function() {
            return this.flags;
        }
    }
});


/**
 * @param {number} value The button options.
 */
org_apache_flex_html_Alert.prototype.set_flags =
    function(value)
    {
  this.flags = value;

  // add buttons based on flags
  if (this.flags & org_apache_flex_html_Alert.OK) {
    var ok = new org_apache_flex_html_TextButton();
    this.buttonArea.addElement(ok);
    ok.text = 'OK';
    goog.events.listen(/** @type {EventTarget} */ (ok.element), 'click',
        goog.bind(this.dismissAlert, this));
  }
  if (this.flags & org_apache_flex_html_Alert.CANCEL) {
    var cancel = new org_apache_flex_html_TextButton();
    this.buttonArea.addElement(cancel);
    cancel.text = 'Cancel';
    goog.events.listen(/** @type {EventTarget} */ (cancel.element), 'click',
        goog.bind(this.dismissAlert, this));
  }
  if (this.flags & org_apache_flex_html_Alert.YES) {
    var yes = new org_apache_flex_html_TextButton();
    this.buttonArea.addElement(yes);
    yes.text = 'YES';
    goog.events.listen(/** @type {EventTarget} */ (yes.element), 'click',
        goog.bind(this.dismissAlert, this));
  }
  if (this.flags & org_apache_flex_html_Alert.NO) {
    var nob = new org_apache_flex_html_TextButton();
    this.buttonArea.addElement(nob);
    nob.text = 'NO';
    goog.events.listen(/** @type {EventTarget} */ (nob.element), 'click',
        goog.bind(this.dismissAlert, this));
  }
};


/**
 * @param {Object} event The event object.
 */
org_apache_flex_html_Alert.prototype.dismissAlert =
    function(event)
    {
  this.element.parentElement.removeChild(this.element);
};
