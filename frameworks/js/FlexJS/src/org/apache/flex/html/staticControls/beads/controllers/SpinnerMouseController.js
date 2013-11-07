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

goog.provide('org.apache.flex.html.staticControls.beads.controllers.SpinnerMouseController');

goog.require('org.apache.flex.html.staticControls.TextButton');



/**
 * @constructor
 */
org.apache.flex.html.staticControls.beads.controllers.SpinnerMouseController =
    function() {
};


/**
 * @expose
 *        SpinnerMouseController}
 * @param {Object} value The strand.
 */
org.apache.flex.html.staticControls.beads.controllers.SpinnerMouseController.
    prototype.set_strand = function(value) {
  this.strand_ = value;

  this.incrementButton = this.strand_.incrementButton;
  this.decrementButton = this.strand_.decrementButton;

  goog.events.listen(this.incrementButton.element, goog.events.EventType.CLICK,
      goog.bind(this.handleIncrementClick, this));

  goog.events.listen(this.decrementButton.element, goog.events.EventType.CLICK,
      goog.bind(this.handleDecrementClick, this));
};


/**
 *        SpinnerMouseController}
 * @param {Object} event The event object.
 */
org.apache.flex.html.staticControls.beads.controllers.SpinnerMouseController.
    prototype.handleIncrementClick = function(event)
    {
  var newValue = this.strand_.snap(Math.min(this.strand_.get_maximum(),
      this.strand_.get_value() +
      this.strand_.get_stepSize()));
  this.strand_.set_value(newValue);
};


/**
 *        SpinnerMouseController}
 * @param {event} event The event object.
 */
org.apache.flex.html.staticControls.beads.controllers.SpinnerMouseController.
    prototype.handleDecrementClick =
    function(event)
    {
  var newValue = this.strand_.snap(Math.max(this.strand_.get_minimum(),
      this.strand_.get_value() -
      this.strand_.get_stepSize()));
  this.strand_.set_value(newValue);
};
