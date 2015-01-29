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

goog.provide('org_apache_flex_html_beads_controllers_ItemRendererMouseController');

goog.require('org_apache_flex_core_IBeadController');



/**
 * @constructor
 * @implements {org_apache_flex_core_IBeadController}
 */
org_apache_flex_html_beads_controllers_ItemRendererMouseController = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_beads_controllers_ItemRendererMouseController.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ItemRendererMouseController',
                qName: 'org_apache_flex_html_beads_controllers_ItemRendererMouseController' }],
      interfaces: [org_apache_flex_core_IBeadController] };


/**
 * @expose
 * @param {Object} value The strand for this component.
 */
org_apache_flex_html_beads_controllers_ItemRendererMouseController.prototype.set_strand = function(value) {
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
 * @param {Object} event The mouse event that triggered the hover.
 */
org_apache_flex_html_beads_controllers_ItemRendererMouseController.prototype.handleMouseOver = function(event) {

  this.strand_.set_hovered(true);

  var newEvent = new goog.events.Event('rollover');
  newEvent.target = this.strand_;
  this.strand_.itemRendererParent.dispatchEvent(newEvent);
};


/**
 * @expose
 * @param {Object} event The mouse-out event.
 */
org_apache_flex_html_beads_controllers_ItemRendererMouseController.prototype.handleMouseOut = function(event) {

  this.strand_.set_hovered(false);

  var newEvent = new goog.events.Event('rollout');
  newEvent.target = this.strand_;
  this.strand_.itemRendererParent.dispatchEvent(newEvent);
};


/**
 * @expose
 * @param {Object} event The mouse-down event.
 */
org_apache_flex_html_beads_controllers_ItemRendererMouseController.prototype.handleMouseDown = function(event) {

  // ??
};


/**
 * @expose
 * @param {Object} event The mouse-up event that triggers the selection.
 */
org_apache_flex_html_beads_controllers_ItemRendererMouseController.prototype.handleMouseUp = function(event) {

  var newEvent = new goog.events.Event('selected');

  // normally you do not - and should not - change the target of an event,
  // but these events do not propagate nor bubble up the object tree, so
  // we have to force the event's target to be this item renderer instance.

  newEvent.target = this.strand_;

  // since the event is not going to up the chain, we also have to dispatch
  // it against its final destination.

  this.strand_.itemRendererParent.dispatchEvent(newEvent);
};
