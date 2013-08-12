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

goog.provide('org.apache.flex.html.staticControls.Slider');

goog.require('org.apache.flex.core.UIBase');
goog.require('org.apache.flex.html.staticControls.beads.models.RangeModel');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.html.staticControls.Slider = function() {
  this.model =
      new org.apache.flex.html.staticControls.beads.models.RangeModel();
  goog.base(this);
};
goog.inherits(org.apache.flex.html.staticControls.Slider,
    org.apache.flex.core.UIBase);

/**
 * @override
 * @this {org.apache.flex.html.staticControls.Slider}
 */
org.apache.flex.html.staticControls.Slider.prototype.createElement =
function() {

  this.element = document.createElement('div');
  this.element.className = 'Slider';
  this.element.style.width = '200px';
  this.element.style.height = '30px';

  this.track = document.createElement('div');
  this.track.className = 'SliderTrack';
  this.track.id = 'track';
  this.track.style.backgroundColor = '#E4E4E4';
  this.track.style.height = '10px';
  this.track.style.width = '200px';
  this.track.style.border = 'thin solid #C4C4C4';
  this.track.style.position = 'relative';
  this.track.style.left = '0px';
  this.track.style.top = '10px';
  this.track.style.zIndex = '1';
  this.element.appendChild(this.track);
  goog.events.listen(this.track, goog.events.EventType.CLICK,
                     this.handleTrackClick, false, this);

  this.thumb = document.createElement('div');
  this.thumb.className = 'SliderThumb';
  this.thumb.id = 'thumb';
  this.thumb.style.backgroundColor = '#949494';
  this.thumb.style.border = 'thin solid #747474';
  this.thumb.style.position = 'relative';
  this.thumb.style.height = '30px';
  this.thumb.style.width = '10px';
  this.thumb.style.zIndex = '2';
  this.thumb.style.top = '-10px';
  this.thumb.style.left = '20px';
  this.element.appendChild(this.thumb);
  goog.events.listen(this.thumb, goog.events.EventType.MOUSEDOWN,
                     this.handleThumbDown, false, this);

  this.positioner = this.element;
  this.element.flexjs_wrapper = this;

  this.set_className('Slider');
};



/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Slider}
 * @return {Number} The value getter.
 */
org.apache.flex.html.staticControls.Slider.prototype.get_value =
function() {
    return this.model.get_value();
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Slider}
 * @param {Object} newValue The new value.
 * @return {void} The value setter.
 */
org.apache.flex.html.staticControls.Slider.prototype.set_value =
function(newValue) {
  this.model.set_value(newValue);
  this.setThumbFromValue(this.model.get_value());
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Slider}
 * @return {Number} The minimum getter.
 */
org.apache.flex.html.staticControls.Slider.prototype.get_minimum =
function() {
  return this.model.get_minimum();
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Slider}
 * @param {Object} value The new minimum value.
 * @return {void} The minimum setter.
 */
org.apache.flex.html.staticControls.Slider.prototype.set_minimum =
function(value) {
  this.model.set_minimum(value);
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Slider}
 * @return {Number} The maximum getter.
 */
org.apache.flex.html.staticControls.Slider.prototype.get_maximum =
function() {
  return this.model.get_maximum();
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Slider}
 * @param {Object} value The new maximum value.
 * @return {void} The maximum setter.
 */
org.apache.flex.html.staticControls.Slider.prototype.set_maximum =
function(value) {
  this.model.set_maximum(value);
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Slider}
 * @return {Number} The snapInterval getter.
 */
org.apache.flex.html.staticControls.Slider.prototype.get_snapInterval =
function() {
  return this.model.get_snapInterval();
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Slider}
 * @param {Object} value The new snapInterval value.
 * @return {void} The snapInterval setter.
 */
org.apache.flex.html.staticControls.Slider.prototype.set_snapInterval =
function(value) {
  this.model.set_snapInterval(value);
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Slider}
 * @return {Number} The stepSize getter.
 */
org.apache.flex.html.staticControls.Slider.prototype.get_stepSize =
function() {
  return this.model.get_stepSize();
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Slider}
 * @param {Object} value The new stepSize value.
 * @return {void} The stepSize setter.
 */
org.apache.flex.html.staticControls.Slider.prototype.set_stepSize =
function(value) {
  this.model.set_stepSize(value);
};

/**
 * @this {org.apache.flex.html.staticControls.Slider}
 * @param {Object} value The current value.
 * @return {Number} Calculates the new value based snapInterval and stepSize.
 */
org.apache.flex.html.staticControls.Slider.prototype.snap = function(value)
{
  var si = this.get_snapInterval();
  var n = Math.round((value - this.get_minimum()) / si) *
                     si + this.get_minimum();
  if (value > 0)
  {
    if (value - n < n + si - value)
      return n;
    return n + si;
  }
  if (value - n > n + si - value)
    return n + si;
  return n;
};

/**
 * @this {org.apache.flex.html.staticControls.Slider}
 * @param {Event} event The event triggering the function.
 * @return {void} Handles click on track.
 */
org.apache.flex.html.staticControls.Slider.prototype.handleTrackClick =
function(event)
{
  var xloc = event.clientX;
  var p = Math.min(1, xloc / parseInt(this.track.style.width, 10));
  var n = p * (this.get_maximum() - this.get_minimum()) + this.get_minimum();

  this.set_value(n);

  this.origin = parseInt(this.thumb.style.left, 10);
  this.position = parseInt(this.thumb.style.left, 10);

  this.calcValFromMousePosition(event, true);

  this.dispatchEvent(new org.apache.flex.events.Event('valueChanged'));
};

/**
 * @this {org.apache.flex.html.staticControls.Slider}
 * @param {Event} event The event triggering the function.
 * @return {void} Handles mouse-down on the thumb.
 */
org.apache.flex.html.staticControls.Slider.prototype.handleThumbDown =
function(event)
{
  goog.events.listen(this.element, goog.events.EventType.MOUSEUP,
                     this.handleThumbUp, false, this);
  goog.events.listen(this.element, goog.events.EventType.MOUSEMOVE,
                     this.handleThumbMove, false, this);

  this.origin = event.clientX;
  this.position = parseInt(this.thumb.style.left, 10);
};

/**
 * @this {org.apache.flex.html.staticControls.Slider}
 * @param {Event} event The event triggering the function.
 * @return {void} Handles mouse-up on the thumb.
 */
org.apache.flex.html.staticControls.Slider.prototype.handleThumbUp =
function(event)
{
  goog.events.unlisten(this.element, goog.events.EventType.MOUSEUP,
                       this.handleThumbUp, false, this);
  goog.events.unlisten(this.element, goog.events.EventType.MOUSEMOVE,
                       this.handleThumbMove, false, this);

  this.calcValFromMousePosition(event, false);

  this.dispatchEvent(new org.apache.flex.events.Event('valueChanged'));
};

/**
 * @this {org.apache.flex.html.staticControls.Slider}
 * @param {Event} event The event triggering the function.
 * @return {void} Handles mouse-move on the thumb.
 */
org.apache.flex.html.staticControls.Slider.prototype.handleThumbMove =
function(event)
{
  this.calcValFromMousePosition(event, false);

  this.dispatchEvent(new org.apache.flex.events.Event('valueChanged'));
};

/**
 * @this {org.apache.flex.html.staticControls.Slider}
 * @param {Event} event The event triggering the function.
 * @param {Boolean} useOffset If true, event.offsetX is used in the calculation.
 * @return {void} Determines the new value based on the movement of the mouse
 * along the slider.
 */
org.apache.flex.html.staticControls.Slider.prototype.calcValFromMousePosition =
function(event, useOffset)
{
  var deltaX = (useOffset ? event.offsetX : event.clientX) - this.origin;
  var thumbW = parseInt(this.thumb.style.width, 10) / 2;
  var newX = this.position + deltaX;

  var p = newX / parseInt(this.track.style.width, 10);
  var n = p * (this.get_maximum() - this.get_minimum()) + this.get_minimum();
  n = this.snap(n);
  if (n < this.get_minimum()) n = this.get_minimum();
  else if (n > this.get_maximum()) n = this.get_maximum();

  p = (n - this.get_minimum()) / (this.get_maximum() - this.get_minimum());
  newX = p * parseInt(this.track.style.width, 10);

  this.thumb.style.left = String(newX -
                                 parseInt(this.thumb.style.width, 10) / 2) +
                                          'px';

  this.set_value(n);
};

/**
 * @this {org.apache.flex.html.staticControls.Slider}
 * @param {Number} value The value used to calculate new position of the thumb.
 * @return {void} Moves the thumb to the corresponding position.
 */
org.apache.flex.html.staticControls.Slider.prototype.setThumbFromValue =
function(value)
{
  var min = this.model.get_minimum();
  var max = this.model.get_maximum();
  var p = (value-min) / (max - min);
  var xloc = p * (parseInt(this.track.style.width, 10) -
             parseInt(this.thumb.style.width, 10));

  this.thumb.style.left = String(xloc) + 'px';
}
