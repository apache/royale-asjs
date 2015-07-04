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

goog.provide('org_apache_flex_html_beads_controllers_SliderMouseController');

goog.require('org_apache_flex_html_beads_SliderThumbView');
goog.require('org_apache_flex_html_beads_SliderTrackView');



/**
 * @constructor
 */
org_apache_flex_html_beads_controllers_SliderMouseController =
    function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_beads_controllers_SliderMouseController.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'SliderMouseController',
                qName: 'org_apache_flex_html_beads_controllers_SliderMouseController' }] };


Object.defineProperties(org_apache_flex_html_beads_controllers_SliderMouseController.prototype, {
    /** @export */
    strand: {
        /** @this {org_apache_flex_html_beads_controllers_SliderMouseController} */
        set: function(value) {
            this.strand_ = value;

            this.track = this.strand_.getBeadByType(
                org_apache_flex_html_beads_SliderTrackView);
            this.thumb = this.strand_.getBeadByType(
                org_apache_flex_html_beads_SliderThumbView);

            goog.events.listen(this.track.element, goog.events.EventType.CLICK,
                     this.handleTrackClick, false, this);

            goog.events.listen(this.thumb.element, goog.events.EventType.MOUSEDOWN,
                     this.handleThumbDown, false, this);
        }
    }
});


/**
 *        SliderMouseController}
 * @param {Event} event The event triggering the function.
 * @return {void} Handles click on track.
 */
org_apache_flex_html_beads_controllers_SliderMouseController.
    prototype.handleTrackClick =
    function(event)
    {
  var xloc = event.clientX;
  var p = Math.min(1, xloc / parseInt(this.track.element.style.width, 10));
  var n = p * (this.strand_.maximum - this.strand_.minimum) +
          this.strand_.minimum;

  this.strand_.value = n;

  this.origin = parseInt(this.thumb.element.style.left, 10);
  this.position = parseInt(this.thumb.element.style.left, 10);

  this.calcValFromMousePosition(event, true);

  this.strand_.dispatchEvent(new org_apache_flex_events_Event('valueChange'));
};


/**
 *        SliderMouseController}
 * @param {Event} event The event triggering the function.
 * @return {void} Handles mouse-down on the thumb.
 */
org_apache_flex_html_beads_controllers_SliderMouseController.
    prototype.handleThumbDown =
    function(event)
    {
  goog.events.listen(this.strand_.element, goog.events.EventType.MOUSEUP,
                     this.handleThumbUp, false, this);
  goog.events.listen(this.strand_.element, goog.events.EventType.MOUSEMOVE,
                     this.handleThumbMove, false, this);

  this.origin = event.clientX;
  this.position = parseInt(this.thumb.element.style.left, 10);
};


/**
 *        SliderMouseController}
 * @param {Event} event The event triggering the function.
 * @return {void} Handles mouse-up on the thumb.
 */
org_apache_flex_html_beads_controllers_SliderMouseController.
    prototype.handleThumbUp =
    function(event)
    {
  goog.events.unlisten(this.strand_.element, goog.events.EventType.MOUSEUP,
                       this.handleThumbUp, false, this);
  goog.events.unlisten(this.strand_.element, goog.events.EventType.MOUSEMOVE,
                       this.handleThumbMove, false, this);

  this.calcValFromMousePosition(event, false);

  this.strand_.dispatchEvent(new org_apache_flex_events_Event('valueChange'));
};


/**
 *        SliderMouseController}
 * @param {Event} event The event triggering the function.
 * @return {void} Handles mouse-move on the thumb.
 */
org_apache_flex_html_beads_controllers_SliderMouseController.
    prototype.handleThumbMove =
    function(event)
    {
  this.calcValFromMousePosition(event, false);

  this.strand_.dispatchEvent(new org_apache_flex_events_Event('valueChange'));
};


/**
 *        SliderMouseController}
 * @param {Event} event The event triggering the function.
 * @param {boolean} useOffset If true, event.offsetX is used in the calculation.
 * @return {void} Determines the new value based on the movement of the mouse
 * along the slider.
 */
org_apache_flex_html_beads_controllers_SliderMouseController.
    prototype.calcValFromMousePosition =
    function(event, useOffset)
    {
  var deltaX = (useOffset ? event.offsetX : event.clientX) - this.origin;
  var thumbW = parseInt(this.thumb.element.style.width, 10) / 2;
  var newX = this.position + deltaX;

  var p = newX / parseInt(this.track.element.style.width, 10);
  var n = p * (this.strand_.maximum - this.strand_.minimum) +
          this.strand_.minimum;
  n = this.strand_.snap(n);
  if (n < this.strand_.minimum) n = this.strand_.minimum;
  else if (n > this.strand_.maximum) n = this.strand_.maximum;

  p = (n - this.strand_.minimum) / (this.strand_.maximum -
      this.strand_.minimum);
  newX = p * parseInt(this.track.element.style.width, 10);

  this.thumb.element.style.left = String(newX -
      parseInt(this.thumb.element.style.width, 10) / 2) + 'px';

  this.strand_.value = n;
};

