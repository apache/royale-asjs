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

goog.provide('org.apache.flex.html.TextInput');

goog.require('org.apache.flex.core.UIBase');
goog.require('org.apache.flex.events.Event');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.html.TextInput = function() {
  org.apache.flex.html.TextInput.base(this, 'constructor');
};
goog.inherits(org.apache.flex.html.TextInput,
    org.apache.flex.core.UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.TextInput.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'TextInput',
                qName: 'org.apache.flex.html.TextInput'}] };


/**
 * @override
 */
org.apache.flex.html.TextInput.prototype.createElement = function() {
  this.element = document.createElement('input');
  this.element.setAttribute('type', 'input');

  //attach input handler to dispatch flexjs change event when user write in textinput
  //goog.events.listen(this.element, 'change', goog.bind(this.killChangeHandler, this));
  goog.events.listen(this.element, 'input', goog.bind(this.inputChangeHandler_, this));

  this.positioner = this.element;
  this.element.flexjs_wrapper = this;

  return this.element;
};


Object.defineProperties(org.apache.flex.html.TextInput.prototype, {
    /** @export */
    text: {
        /** @this {org.apache.flex.html.TextInput} */
        get: function() {
            return this.element.value;
        },
        /** @this {org.apache.flex.html.TextInput} */
        set: function(value) {
            this.element.value = value;
            this.dispatchEvent(new org.apache.flex.events.Event('textChange'));
        }
    }
});


/**
 * @export
 * @param {Object} event The event.
 */
/*org.apache.flex.html.TextInput.prototype.killChangeHandler = function(event) {
    //event.preventDefault();
};*/


/**
 * @private
 * @param {Object} event The event.
 */
org.apache.flex.html.TextInput.prototype.inputChangeHandler_ = function(event) {
  event.stopPropagation();

  this.dispatchEvent(new org.apache.flex.events.Event(org.apache.flex.events.Event.EventType.CHANGE));
  this.dispatchEvent(new org.apache.flex.events.Event('textChange'));
};
