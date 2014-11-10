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



/**
 * @constructor
 * This is a shim class.  A native MouseEvent is actually
 * sent with additional properties like dragInitiator and
 * dragSource tacked on.
 *
 * @extends {MouseEvent}
 * @param {string} type The event type.
 */
org.apache.flex.events.DragEvent = function(type) {
  window.MouseEvent.base(this, 'constructor', type);

  this.type = type;
};
goog.inherits(org.apache.flex.events.DragEvent,
    window.MouseEvent);


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
 */
org.apache.flex.events.DragEvent.prototype.init = function(type) {
  this.type = type;
};


/**
 * @expose
 * @type {Object} dragInitiator The object that started the drag.
 */
org.apache.flex.events.DragEvent.prototype.dragInitiator = null;


/**
 * @expose
 * @type {Object} dragSource The data being dragged.
 */
org.apache.flex.events.DragEvent.prototype.dragSource = null;


/**
 * @expose
 * @param {MouseEvent} event The mouse event to copy.
 */
org.apache.flex.events.DragEvent.prototype.copyMouseEventProperties =
    function(event) {
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
