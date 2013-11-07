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
goog.require('org.apache.flex.html.staticControls.beads.SliderThumbView');
goog.require('org.apache.flex.html.staticControls.beads.SliderTrackView');
goog.require('org.apache.flex.html.staticControls.beads.controllers.SliderMouseController');
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
  this.element.style.width = '200px';
  this.element.style.height = '30px';

  this.track = new org.apache.flex.html.staticControls.beads.SliderTrackView();
  this.addBead(this.track);

  this.thumb = new org.apache.flex.html.staticControls.beads.SliderThumbView();
  this.addBead(this.thumb);

  this.controller = new org.apache.flex.html.staticControls.beads.controllers.
                    SliderMouseController();
  this.addBead(this.controller);

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
 * @param {Number} value The value used to calculate new position of the thumb.
 * @return {void} Moves the thumb to the corresponding position.
 */
org.apache.flex.html.staticControls.Slider.prototype.setThumbFromValue =
    function(value)
    {
  var min = this.model.get_minimum();
  var max = this.model.get_maximum();
  var p = (value - min) / (max - min);
  var xloc = p * (parseInt(this.track.element.style.width, 10) -
             parseInt(this.thumb.element.style.width, 10));

  this.thumb.element.style.left = String(xloc) + 'px';
};

