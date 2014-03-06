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

goog.provide('org.apache.flex.html.staticControls.TextInput');

goog.require('goog.events.InputHandler');
goog.require('org.apache.flex.core.UIBase');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.html.staticControls.TextInput = function() {
  goog.base(this);
};
goog.inherits(org.apache.flex.html.staticControls.TextInput,
    org.apache.flex.core.UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.staticControls.TextInput.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'TextInput',
                qName: 'org.apache.flex.html.staticControls.TextInput'}] };


/**
 * @override
 */
org.apache.flex.html.staticControls.TextInput.prototype.createElement =
    function() {
  this.element = document.createElement('input');
  this.element.setAttribute('type', 'input');

  //attach input handler to dispatch flexjs change event when user write in textinput
  var ih = new goog.events.InputHandler(this.element);
  goog.events.listen(ih, goog.events.InputHandler.EventType.INPUT, goog.bind(this.inputChangeHandler_, this));

  this.positioner = this.element;
  this.element.flexjs_wrapper = this;

  return this.element;
};


/**
 * @expose
 * @return {string} The text getter.
 */
org.apache.flex.html.staticControls.TextInput.prototype.get_text = function() {
  return this.element.value;
};


/**
 * @expose
 * @param {string} value The text setter.
 */
org.apache.flex.html.staticControls.TextInput.prototype.set_text =
    function(value) {
  this.element.value = value;
};


/**
 * @private
 * @param {Object} event The event.
 */
org.apache.flex.html.staticControls.TextInput.prototype.inputChangeHandler_ =
    function(event) {
        event.stopPropagation();
        
        this.dispatchEvent(new org.apache.flex.events.Event(org.apache.flex.events.Event.EventType.CHANGE));
      };
