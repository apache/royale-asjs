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

goog.provide('org.apache.flex.events.DragEvent');

goog.require('goog.events.BrowserEvent');
goog.require('org.apache.flex.events.EventDispatcher');



/**
 * @constructor
 * This is a shim class.  A native MouseEvent is actually
 * sent with additional properties like dragInitiator and
 * dragSource tacked on.
 *
 * @extends {goog.events.BrowserEvent}
 * @param {string} type The event type.
 */
org.apache.flex.events.DragEvent = function(type) {
  org.apache.flex.events.DragEvent.base(this, 'constructor');

  this.type = type;
};
goog.inherits(org.apache.flex.events.DragEvent,
    goog.events.BrowserEvent);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.events.DragEvent.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'DragEvent',
                qName: 'org.apache.flex.events.DragEvent'}] };


/**
 * @expose
 * @param {string} type The event type.
 * @param {Event} event The mouse event to base the DragEvent on.
 * @return {MouseEvent} The new event.
 */
org.apache.flex.events.DragEvent.createDragEvent =
    function(type, event) {
  var out = new MouseEvent(type);
  out.initMouseEvent(type, true, true);
  out.screenX = event.screenX;
  out.screenY = event.screenY;
  out.clientX = event.clientX;
  out.clientY = event.clientY;
  out.ctrlKey = event.ctrlKey;
  out.shiftKey = event.shiftKey;
  out.alttKey = event.altKey;
  return out;
};


/**
 * @expose
 * @param {Event} event The drag event.
 * @param {Object} target The target for the event.
 */
org.apache.flex.events.DragEvent.dispatchDragEvent =
    function(event, target) {
  target.element.dispatchEvent(event);
};


/**
 * @expose
 * @type {string} DRAG_START The event type for starting drag-drop.
 */
org.apache.flex.events.DragEvent.DRAG_START = 'dragStart';


/**
 * @expose
 * @type {string} DRAG_MOVE The event type when moving mouse during drag-drop.
 */
org.apache.flex.events.DragEvent.DRAG_MOVE = 'dragMove';


/**
 * @expose
 * @type {string} DRAG_END The event type for ending drag-drop.
 */
org.apache.flex.events.DragEvent.DRAG_END = 'dragEnd';


/**
 * @expose
 * @type {string} DRAG_ENTER The event type for entering a potential drop target.
 */
org.apache.flex.events.DragEvent.DRAG_ENTER = 'dragEnter';


/**
 * @expose
 * @type {string} DRAG_OVER The event type for moving over a potential drop target.
 */
org.apache.flex.events.DragEvent.DRAG_OVER = 'dragOver';


/**
 * @expose
 * @type {string} DRAG_EXIT The event type for leaving a potential drop target.
 */
org.apache.flex.events.DragEvent.DRAG_EXIT = 'dragExit';


/**
 * @expose
 * @type {string} DRAG_DROP The event type for dropping on a target.
 */
org.apache.flex.events.DragEvent.DRAG_DROP = 'dragDrop';


/**
 * @return {boolean}
 */
org.apache.flex.events.DragEvent.installDragEventMixin = function() {
  var o = org.apache.flex.events.EventDispatcher.elementEvents;
  o['dragEnd'] = 1;
  o['dragMove'] = 1;
  return true;
};


/**
 * Add some other events to listen from the element
 */
/**
 * @type {boolean}
 */
org.apache.flex.events.DragEvent.dragEventMixin =
    org.apache.flex.events.DragEvent.installDragEventMixin();
