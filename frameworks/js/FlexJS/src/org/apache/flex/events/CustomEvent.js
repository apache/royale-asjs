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

goog.provide('org.apache.flex.events.CustomEvent');

goog.require('goog.events.Event');



/**
 * @constructor
 * @extends {goog.events.Event}
 * @param {string} type The event type.
 */
org.apache.flex.events.CustomEvent = function(type) {
  goog.base(this, type);

  this.type = type;
};
goog.inherits(org.apache.flex.events.CustomEvent,
    goog.events.Event);


/**
 * @expose
 * @param {string} type The event type.
 */
org.apache.flex.events.CustomEvent.prototype.init = function(type) {
  this.type = type;
};


/**
 * @expose
 * @type {string} type The event type.
 */
org.apache.flex.events.CustomEvent.prototype.type = '';
