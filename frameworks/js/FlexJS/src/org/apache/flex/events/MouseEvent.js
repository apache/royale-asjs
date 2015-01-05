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

goog.provide('org.apache.flex.events.MouseEvent');



/**
 * @constructor
 * @extends {MouseEvent}
 * This is a shim class.  As long as you don't test
 * with "is" or "as", your code should work even
 * if the runtime is actually sending a native
 * browser MouseEvent
 */
org.apache.flex.events.MouseEvent = function() {
  window.MouseEvent.base(this, 'constructor');
};
goog.inherits(org.apache.flex.events.MouseEvent,
    window.MouseEvent);


/**
 * @type {string}
 */
org.apache.flex.events.MouseEvent.ROLL_OVER = 'rollover';


/**
 * @type {string}
 */
org.apache.flex.events.MouseEvent.ROLL_OUT = 'rollout';


/**
 * @type {string}
 */
org.apache.flex.events.MouseEvent.MOUSE_OVER = 'mouseover';


/**
 * @type {string}
 */
org.apache.flex.events.MouseEvent.MOUSE_OUT = 'mouseout';


/**
 * @type {string}
 */
org.apache.flex.events.MouseEvent.MOUSE_UP = 'mouseup';


/**
 * @type {string}
 */
org.apache.flex.events.MouseEvent.MOUSE_DOWN = 'mousedown';


/**
 * @type {string}
 */
org.apache.flex.events.MouseEvent.MOUSE_MOVE = 'mousemove';


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.events.MouseEvent.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'MouseEvent',
                qName: 'org.apache.flex.events.MouseEvent' }] };

