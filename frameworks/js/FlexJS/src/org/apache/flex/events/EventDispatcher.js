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

goog.provide('org.apache.flex.events.EventDispatcher');

goog.require('goog.events.EventTarget');



/**
 * @constructor
 * @extends {goog.events.EventTarget}
 */
org.apache.flex.events.EventDispatcher = function() {
  goog.base(this);

};
goog.inherits(org.apache.flex.events.EventDispatcher,
    goog.events.EventTarget);


/**
 * @override
 * @expose
 * @param {string} type The event type.
 * @param {function(?): ?} fn The event handler.
 */
org.apache.flex.events.EventDispatcher.prototype.addEventListener =
    function(type, fn) {
  var source;

  /**
   *  A bit of a hack, but for 'native' HTML element based controls, we
   *  want to listen to the 'native' events from the element; for other
   *  types of controls, we listen to 'custom' events.
   */
  source = this;
  if (this.element && this.element.nodeName &&
      this.element.nodeName.toLowerCase() !== 'div' &&
      this.element.nodeName.toLowerCase() !== 'body') {
    source = this.element;
  }

  goog.events.listen(source, type, fn);
};
