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
goog.require('org.apache.flex.events.ElementEvents');
goog.require('org.apache.flex.events.IEventDispatcher');



/**
 * @constructor
 * @extends {goog.events.EventTarget}
 * @implements {org.apache.flex.events.IEventDispatcher}
 */
org.apache.flex.events.EventDispatcher = function() {
  org.apache.flex.events.EventDispatcher.base(this, 'constructor');
};
goog.inherits(org.apache.flex.events.EventDispatcher,
    goog.events.EventTarget);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.events.EventDispatcher.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'EventDispatcher',
                qName: 'org.apache.flex.events.EventDispatcher'}],
      interfaces: [org.apache.flex.events.IEventDispatcher] };


/**
 * @private
 * @param {string} type The event name.
 * @return {goog.events.EventTarget} The target.
 */
org.apache.flex.events.EventDispatcher.prototype.getActualDispatcher_ = function(type) {
  /**
   *  A bit of a hack, but for 'native' HTML element based controls, we
   *  want to listen to the 'native' events from the element; for other
   *  types of controls, we listen to 'custom' events.
   */
  var source = this;
  /*
  if (this.element && this.element.nodeName &&
      this.element.nodeName.toLowerCase() !== 'div' &&
      // we don't use any native img events right now, we wrapthem
      this.element.nodeName.toLowerCase() !== 'img' &&
      this.element.nodeName.toLowerCase() !== 'body') {
    source = this.element;
  } else */ if (org.apache.flex.events.ElementEvents.elementEvents[type]) {
    // mouse and keyboard events also dispatch off the element.
    source = this.element;
  }
  return source;
};


/**
 * @override
 * @export
 */
org.apache.flex.events.EventDispatcher.prototype.dispatchEvent = function(e) {
  var t;
  if (typeof(e) === 'string') {
    t = e;
    if (e === 'change')
      e = new Event(e);
  }
  else {
    t = e.type;
    if (org.apache.flex.events.ElementEvents.elementEvents[t]) {
        e = new Event(t);
    }
  }
  var source = this.getActualDispatcher_(t);
  if (source == this)
    return org.apache.flex.events.EventDispatcher.base(this, 'dispatchEvent', e);

  return source.dispatchEvent(e);
};


/**
 * @override
 * @export
 */
org.apache.flex.events.EventDispatcher.prototype.addEventListener =
    function(type, handler, opt_capture, opt_handlerScope) {
  var source;

  source = this.getActualDispatcher_(type);

  goog.events.listen(source, type, handler);
};


/**
 * @override
 * @export
 */
org.apache.flex.events.EventDispatcher.prototype.removeEventListener =
    function(type, handler, opt_capture, opt_handlerScope) {
  var source;

  source = this.getActualDispatcher_(type);

  goog.events.unlisten(source, type, handler);
};


/**
 * @export
 * @param {string} type The event name.
 * @return {boolean} True if there is a listener.
 */
org.apache.flex.events.EventDispatcher.prototype.hasEventListener =
    function(type) {
  var source;

  source = this.getActualDispatcher_(type);

  return goog.events.hasListener(source, type);
};
