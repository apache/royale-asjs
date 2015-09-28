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
goog.provide('org.apache.flex.events.ElementEvents');



/**
 * @constructor
 */
org.apache.flex.events.ElementEvents = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.events.ElementEvents.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ElementEvents',
                qName: 'org.apache.flex.events.ElementEvents' }] };


/**
 * @type {Object}
 */
org.apache.flex.events.ElementEvents.elementEvents = {
  'click': 1,
  'change': 1,
  'keyup': 1,
  'keydown': 1,
  'load': 1,
  'mouseover': 1,
  'mouseout': 1,
  'mouseup': 1,
  'mousedown': 1,
  'mousemove': 1,
  'rollover': 1,
  'rollout': 1
};

