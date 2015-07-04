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

goog.provide('org_apache_flex_events_ValueEvent');

goog.require('goog.events.Event');



/**
 * @constructor
 * @extends {goog.events.Event}
 * @param {string} type The event type.
 * @param {*} v The value.
 */
org_apache_flex_events_ValueEvent = function(type, v) {
  org_apache_flex_events_ValueEvent.base(this, 'constructor', type);

  this.type = type;
  this.value = v;
};
goog.inherits(org_apache_flex_events_ValueEvent,
    goog.events.Event);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_events_ValueEvent.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ValueEvent',
                qName: 'org_apache_flex_events_ValueEvent' }] };


/**
 * @export
 * @param {string} type The event type.
 */
org_apache_flex_events_ValueEvent.prototype.init = function(type) {
  this.type = type;
};


/**
 * @export
 * @type {string} type The event type.
 */
org_apache_flex_events_ValueEvent.prototype.type = '';


/**
 * @export
 * @type {*} value The old value.
 */
org_apache_flex_events_ValueEvent.prototype.value = null;


