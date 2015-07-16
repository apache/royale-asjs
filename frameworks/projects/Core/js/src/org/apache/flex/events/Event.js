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
// EventHandler and ErrorHandler are not listed as deps for
// some of the event classes because they would cause
// circularities so we force them in here.
goog.provide('org.apache.flex.events.Event');

goog.require('goog.debug.ErrorHandler');
goog.require('goog.events.Event');
goog.require('goog.events.EventHandler');



/**
 * @constructor
 * @extends {goog.events.Event}
 * @param {string} type The event type.
 */
org.apache.flex.events.Event = function(type) {
  org.apache.flex.events.Event.base(this, 'constructor', type);

  this.type = type;
};
goog.inherits(org.apache.flex.events.Event,
    goog.events.Event);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.events.Event.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Event',
                qName: 'org.apache.flex.events.Event' }] };


/**
 * Enum type for the events fired by the FlexJS Event
 * @enum {string}
 */
org.apache.flex.events.Event.EventType = {
    CHANGE: 'change'
  };


/**
 * @export
 * @type {string} type The event type.
 */
org.apache.flex.events.Event.prototype.type = '';


/**
 * @export
 * @param {string} type The event type.
 */
org.apache.flex.events.Event.prototype.init = function(type) {
  this.type = type;
};
