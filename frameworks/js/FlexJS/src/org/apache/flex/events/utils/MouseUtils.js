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


goog.provide('org.apache.flex.events.utils.MouseUtils');


/**
 * @param {Object} event The event.
 * @return {Object} class instance associated with the event.target.
 */
org.apache.flex.events.utils.MouseUtils.eventTarget = function(event) {
  var target = event.target;
  return target.flexjs_wrapper;
};


/**
 * @param {Object} event The event.
 * @return {number} The x position of the mouse with respect to its parent.
 */
org.apache.flex.events.utils.MouseUtils.localX = function(event) {
  return event.offsetX;
};


/**
 * @param {Object} event The event.
 * @return {number} The y position of the mouse with respect to its parent.
 */
org.apache.flex.events.utils.MouseUtils.localY = function(event) {
  return event.offsetY;
};


/**
 * @param {Object} event The event.
 * @return {number} The x position of the mouse with respect to the screen.
 */
org.apache.flex.events.utils.MouseUtils.globalX = function(event) {
  return event.clientX;
};


/**
 * @param {Object} event The event.
 * @return {number} The y position of the mouse with respect to the screen.
 */
org.apache.flex.events.utils.MouseUtils.globalY = function(event) {
  return event.clientY;
};
