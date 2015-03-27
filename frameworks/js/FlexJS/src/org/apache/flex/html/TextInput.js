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

goog.provide('org_apache_flex_html_TextInput');

goog.require('org_apache_flex_core_UIBase');
goog.require('org_apache_flex_events_Event');



/**
 * @constructor
 * @extends {org_apache_flex_core_UIBase}
 */
org_apache_flex_html_TextInput = function() {
  org_apache_flex_html_TextInput.base(this, 'constructor');
};
goog.inherits(org_apache_flex_html_TextInput,
    org_apache_flex_core_UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_TextInput.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'TextInput',
                qName: 'org_apache_flex_html_TextInput'}] };


/**
 * @override
 */
org_apache_flex_html_TextInput.prototype.createElement = function() {
  this.element = document.createElement('input');
  this.element.setAttribute('type', 'input');

  //attach input handler to dispatch flexjs change event when user write in textinput
  //goog.events.listen(this.element, 'change', goog.bind(this.killChangeHandler, this));
  goog.events.listen(this.element, 'input', goog.bind(this.inputChangeHandler_, this));

  this.positioner = this.element;
  this.element.flexjs_wrapper = this;

  return this.element;
};


Object.defineProperties(org_apache_flex_html_TextInput.prototype, {
    'text': {
        /** @this {org_apache_flex_html_TextInput} */
        get: function() {
            return this.element.value;
        },
        /** @this {org_apache_flex_html_TextInput} */
        set: function(value) {
            this.element.value = value;
            this.dispatchEvent(new org_apache_flex_events_Event('textChange'));
        }
    }
});


/**
 * @expose
 * @param {Object} event The event.
 */
/*org_apache_flex_html_TextInput.prototype.killChangeHandler = function(event) {
    //event.preventDefault();
};*/


/**
 * @private
 * @param {Object} event The event.
 */
org_apache_flex_html_TextInput.prototype.inputChangeHandler_ = function(event) {
  event.stopPropagation();

  this.dispatchEvent(new org_apache_flex_events_Event(org_apache_flex_events_Event.EventType.CHANGE));
  this.dispatchEvent(new org_apache_flex_events_Event('textChange'));
};
