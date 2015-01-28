/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

goog.provide('org_apache_flex_events_ValueChangeEvent');

goog.require('goog.events.Event');



/**
 * @constructor
 * @extends {goog.events.Event}
 * @param {string} type The event type.
 * @param {boolean} b The bubbles parameter.
 * @param {boolean} c The cancelable parameter.
 * @param {*} ov The old value.
 * @param {*} nv The new value.
 */
org_apache_flex_events_ValueChangeEvent = function(type, b, c, ov, nv) {
  org_apache_flex_events_ValueChangeEvent.base(this, 'constructor', type);

  this.type = type;
  this.oldValue = ov;
  this.newValue = nv;
};
goog.inherits(org_apache_flex_events_ValueChangeEvent,
    goog.events.Event);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_events_ValueChangeEvent.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ValueChangeEvent',
                qName: 'org_apache_flex_events_ValueChangeEvent' }] };


/**
 * @expose
 * @param {string} type The event type.
 */
org_apache_flex_events_ValueChangeEvent.prototype.init = function(type) {
  this.type = type;
};


/**
 * @expose
 * @type {string} type The event type.
 */
org_apache_flex_events_ValueChangeEvent.prototype.type = '';


/**
 * @expose
 * @type {*} oldValue The old value.
 */
org_apache_flex_events_ValueChangeEvent.prototype.oldValue = null;


/**
 * @expose
 * @type {*} newValue The new value.
 */
org_apache_flex_events_ValueChangeEvent.prototype.newValue = null;


/**
 * @expose
 * @type {string} propertyName The property that changed.
 */
org_apache_flex_events_ValueChangeEvent.prototype.propertyName = '';


/**
 * @expose
 * @type {Object} source The object that changed.
 */
org_apache_flex_events_ValueChangeEvent.prototype.source = null;


/**
 * @expose
 * @param {Object} source The object that changed.
 * @param {string} name The property that changed.
 * @param {*} oldValue The old value.
 * @param {*} newValue The new value.
 * @return {Object} An event object.
 */
org_apache_flex_events_ValueChangeEvent.createUpdateEvent =
    function(source, name, oldValue, newValue)
    {
  var event = new org_apache_flex_events_ValueChangeEvent(
      org_apache_flex_events_ValueChangeEvent.VALUE_CHANGE,
      false, false, oldValue, newValue);
  event.propertyName = name;
  event.source = source;
  return event;
};


/**
 * @expose
 * @type {string} VALUE_CHANGE The type of the event.
 */
org_apache_flex_events_ValueChangeEvent.VALUE_CHANGE = 'valueChange';
