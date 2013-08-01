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



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.html.staticControls.Slider = function() {
  goog.base(this);

  this.minimum_ = 0;
  this.maximum_ = 100;
  this.value_ = 1;
  this.snapInterval_ = 1;
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
    return this.value_;
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Slider}
 * @param {Object} newValue The new value.
 * @return {void} The value setter.
 */
org.apache.flex.html.staticControls.Slider.prototype.set_value =
function(newValue) {
  if (newValue != this.value_) {
    this.value_ = newValue;
    this.dispatchEvent('valueChanged');
  }
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Slider}
 * @return {Number} The minimum getter.
 */
org.apache.flex.html.staticControls.Slider.prototype.get_minimum =
function() {
  return this.minimum_;
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Slider}
 * @param {Object} value The new minimum value.
 * @return {void} The minimum setter.
 */
org.apache.flex.html.staticControls.Slider.prototype.set_minimum =
function(value) {
  if (value != this.minimum_) {
    this.minimum_ = value;
    this.dispatchEvent('minimumChanged');
  }
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Slider}
 * @return {Number} The maximum getter.
 */
org.apache.flex.html.staticControls.Slider.prototype.get_maximum =
function() {
  return this.maximum_;
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Slider}
 * @param {Object} value The new maximum value.
 * @return {void} The maximum setter.
 */
org.apache.flex.html.staticControls.Slider.prototype.set_maximum =
function(value) {
  if (value != this.maximum_) {
    this.maximum_ = value;
    this.dispatchEvent('maximumChanged');
  }
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Slider}
 * @return {Number} The snapInterval getter.
 */
org.apache.flex.html.staticControls.Slider.prototype.get_snapInterval =
function() {
  return this.snapInterval_;
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Slider}
 * @param {Object} value The new snapInterval value.
 * @return {void} The snapInterval setter.
 */
org.apache.flex.html.staticControls.Slider.prototype.set_snapInterval =
function(value) {
  if (value != this.snapInterval_) {
    this.snapInterval_ = value;
    this.dispatchEvent('snapIntervalChanged');
  }
};

/**
 * @this {org.apache.flex.html.staticControls.Slider}
 * @param {Object} value The current value.
 * @return {Number} Calculates the new value based snapInterval and stepSize.
 */
org.apache.flex.html.staticControls.Slider.prototype.snap = function(value)
{
  var si = this.snapInterval_;
  var n = Math.round((value - this.minimum_) / si) * si + this.minimum_;
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
  this.value_ = this.snap(Math.min(this.maximum_, this.value_ +
                this.stepSize_));
  this.dispatchEvent(new org.apache.flex.events.Event('valueChanged'));

  this.origin = parseInt(this.thumb.style.left, 10);
  this.position = parseInt(this.thumb.style.left, 10);

  this.calcValFromMousePosition(event, true);
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
  var n = p * (this.maximum_ - this.minimum_) + this.minimum_;
  n = this.snap(n);
  if (n < this.minimum_) n = this.minimum_;
  else if (n > this.maximum_) n = this.maximum_;

  p = (n - this.minimum_) / (this.maximum_ - this.minimum_);
  newX = p * parseInt(this.track.style.width, 10);

  this.thumb.style.left = String(newX -
                                 parseInt(this.thumb.style.width, 10) / 2) +
                                          'px';

  this.value_ = n;
};
