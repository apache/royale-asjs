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

goog.provide('org.apache.flex.events.ValueChangeEvent');

goog.require('goog.events.Event');



/**
 * @constructor
 * @extends {goog.events.Event}
 * @param {string} type The event type.
 * @param {string} ov The old value.
 * @param {string} nv The new value.
 */
org.apache.flex.events.ValueChangeEvent = function(type, ov, nv) {
  goog.base(this);

  this.type = type;
  this.oldValue = ov;
  this.newValue = nv;
};
goog.inherits(org.apache.flex.events.ValueChangeEvent,
    goog.events.Event);


/**
 * @expose
 * @this {org.apache.flex.events.ValueChangeEvent}
 * @param {string} type The event type.
 */
org.apache.flex.events.ValueChangeEvent.prototype.init = function(type) {
  this.type = type;
};


/**
 * @expose
 * @type {string} type The event type.
 */
org.apache.flex.events.ValueChangeEvent.prototype.type = null;

/**
 * @expose
 * @type {Object} oldValue The old value.
 */
org.apache.flex.events.ValueChangeEvent.prototype.oldValue = null;

/**
 * @expose
 * @type {string} newValue The new value.
 */
org.apache.flex.events.ValueChangeEvent.prototype.newValue = null;
