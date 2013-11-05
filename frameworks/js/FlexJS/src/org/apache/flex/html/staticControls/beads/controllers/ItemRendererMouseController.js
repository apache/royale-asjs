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

goog.provide('org.apache.flex.html.staticControls.beads.controllers.ItemRendererMouseController');

goog.require('org.apache.flex.core.IBeadController');

/**
 * @constructor
 * @extends {org.apache.flex.core.IBeadController}
 */
org.apache.flex.html.staticControls.beads.controllers.
ItemRendererMouseController = function() {
  goog.base(this);
};
goog.inherits(org.apache.flex.html.staticControls.beads.controllers.ItemRendererMouseController,
              org.apache.flex.core.IBeadController);



/**
 * @expose
 * @this {org.apache.flex.html.staticControls.beads.controllers.
 *        ItemRendererMouseController}
 * @param {object} value The strand for this component.
 */
org.apache.flex.html.staticControls.beads.controllers.
ItemRendererMouseController.prototype.set_strand = function(value) {
  this.strand_ = value;

  goog.events.listen(this.strand_.element, goog.events.EventType.MOUSEOVER,
            goog.bind(this.handleMouseOver, this));

  goog.events.listen(this.strand_.element, goog.events.EventType.MOUSEOUT,
            goog.bind(this.handleMouseOut, this));

  goog.events.listen(this.strand_.element, goog.events.EventType.MOUSEDOWN,
            goog.bind(this.handleMouseDown, this));

  goog.events.listen(this.strand_.element, goog.events.EventType.MOUSEUP,
            goog.bind(this.handleMouseUp, this));
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.beads.controllers.
 *        ItemRendererMouseController}
 * @param {object} event The mouse event that triggered the hover.
 */
org.apache.flex.html.staticControls.beads.controllers.
ItemRendererMouseController.prototype.handleMouseOver = function(event) {

   this.strand_.set_hovered(true);
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.beads.controllers.
 *        ItemRendererMouseController}
 * @param {object} event The mouse-out event.
 */
org.apache.flex.html.staticControls.beads.controllers.
ItemRendererMouseController.prototype.handleMouseOut = function(event) {

   this.strand_.set_hovered(false);
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.beads.controllers.
 *        ItemRendererMouseController}
 * @param {object} event The mouse-down event.
 */
org.apache.flex.html.staticControls.beads.controllers.
ItemRendererMouseController.prototype.handleMouseDown = function(event) {

   // ??
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.beads.controllers.
 *        ItemRendererMouseController}
 * @param {object} event The mouse-up event that triggers the selection.
 */
org.apache.flex.html.staticControls.beads.controllers.
ItemRendererMouseController.prototype.handleMouseUp = function(event) {

   var newEvent = new goog.events.Event('selected');

   // normally you do not - and should not - change the target of an event,
   // but these events do not propagate nor bubble up the object tree, so
   // we have to force the event's target to be this item renderer instance.

   newEvent.target = this.strand_;

   // since the event is not going to up the chain, we also have to dispatch
   // it against its final destination.

   this.strand_.get_itemRendererParent().dispatchEvent(newEvent);
};
