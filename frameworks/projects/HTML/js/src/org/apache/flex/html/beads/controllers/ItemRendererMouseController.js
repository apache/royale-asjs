/**
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

goog.provide('org.apache.flex.html.beads.controllers.ItemRendererMouseController');

goog.require('goog.events.Event');
goog.require('goog.events.EventType');
goog.require('org.apache.flex.core.IBeadController');



/**
 * @constructor
 * @implements {org.apache.flex.core.IBeadController}
 */
org.apache.flex.html.beads.controllers.ItemRendererMouseController = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.beads.controllers.ItemRendererMouseController.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ItemRendererMouseController',
                qName: 'org.apache.flex.html.beads.controllers.ItemRendererMouseController' }],
      interfaces: [org.apache.flex.core.IBeadController] };


Object.defineProperties(org.apache.flex.html.beads.controllers.ItemRendererMouseController.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.html.beads.controllers.ItemRendererMouseController} */
        set: function(value) {
            this.strand_ = value;

            goog.events.listen(this.strand_.element, goog.events.EventType.MOUSEOVER,
                goog.bind(this.handleMouseOver, this));

            goog.events.listen(this.strand_.element, goog.events.EventType.MOUSEOUT,
                goog.bind(this.handleMouseOut, this));

            goog.events.listen(this.strand_.element, goog.events.EventType.MOUSEDOWN,
                goog.bind(this.handleMouseDown, this));

            goog.events.listen(this.strand_.element, goog.events.EventType.MOUSEUP,
                goog.bind(this.handleMouseUp, this));
        }
    }
});


/**
 * @export
 * @param {Object} e The mouse event that triggered the hover.
 */
org.apache.flex.html.beads.controllers.ItemRendererMouseController.prototype.handleMouseOver = function(e) {

  this.strand_.hovered = true;

  var newEvent = new MouseEvent('rollover');
  newEvent.initMouseEvent('rollover', false, false,
    e.view, e.detail, e.screenX, e.screenY,
    e.clientX, e.clientY, e.ctrlKey, e.altKey,
    e.shiftKey, e.metaKey, e.button, e.relatedTarget);
  this.strand_.itemRendererParent.dispatchEvent(newEvent);
};


/**
 * @export
 * @param {Object} e The mouse-out event.
 */
org.apache.flex.html.beads.controllers.ItemRendererMouseController.prototype.handleMouseOut = function(e) {

  this.strand_.hovered = false;

  var newEvent = new MouseEvent('rollout');
  newEvent.initMouseEvent('rollout', false, false,
    e.view, e.detail, e.screenX, e.screenY,
    e.clientX, e.clientY, e.ctrlKey, e.altKey,
    e.shiftKey, e.metaKey, e.button, e.relatedTarget);
  this.strand_.itemRendererParent.dispatchEvent(newEvent);
};


/**
 * @export
 * @param {Object} event The mouse-down event.
 */
org.apache.flex.html.beads.controllers.ItemRendererMouseController.prototype.handleMouseDown = function(event) {

  // ??
};


/**
 * @export
 * @param {Object} event The mouse-up event that triggers the selection.
 */
org.apache.flex.html.beads.controllers.ItemRendererMouseController.prototype.handleMouseUp = function(event) {

  var newEvent = new goog.events.Event('selected');

  // normally you do not - and should not - change the target of an event,
  // but these events do not propagate nor bubble up the object tree, so
  // we have to force the event's target to be this item renderer instance.

  newEvent.target = this.strand_;

  // since the event is not going to up the chain, we also have to dispatch
  // it against its final destination.

  this.strand_.itemRendererParent.dispatchEvent(newEvent);
};
