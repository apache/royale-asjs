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
goog.provide('org_apache_flex_events_Event');

goog.require('goog.debug.ErrorHandler');
goog.require('goog.events.Event');
goog.require('goog.events.EventHandler');



/**
 * @constructor
 * @extends {goog.events.Event}
 * @param {string} type The event type.
 */
org_apache_flex_events_Event = function(type) {
  org_apache_flex_events_Event.base(this, 'constructor', type);

  this.type = type;
};
goog.inherits(org_apache_flex_events_Event,
    goog.events.Event);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_events_Event.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Event',
                qName: 'org_apache_flex_events_Event' }] };


/**
 * Enum type for the events fired by the FlexJS Event
 * @enum {string}
 */
org_apache_flex_events_Event.EventType = {
    CHANGE: 'change'
  };


/**
 * @expose
 * @type {string} type The event type.
 */
org_apache_flex_events_Event.prototype.type = '';


/**
 * @expose
 * @param {string} type The event type.
 */
org_apache_flex_events_Event.prototype.init = function(type) {
  this.type = type;
};


Object.defineProperties(org_apache_flex_events_Event.prototype, {
    'type': {
 		/** @this {org_apache_flex_events_Event} */
        get: function() {
            return this.type;
        }
    },
    'target': {
 		/** @this {org_apache_flex_events_Event} */
        get: function() {
            return this.target;
        }
    },
    'currentTarget': {
 		/** @this {org_apache_flex_events_Event} */
        get: function() {
            return this.currentTarget;
        }
    }
});
