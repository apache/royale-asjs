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

goog.provide('org_apache_flex_html_Slider');

goog.require('org_apache_flex_core_UIBase');
goog.require('org_apache_flex_html_beads_SliderThumbView');
goog.require('org_apache_flex_html_beads_SliderTrackView');
goog.require('org_apache_flex_html_beads_controllers_SliderMouseController');
goog.require('org_apache_flex_html_beads_models_RangeModel');



/**
 * @constructor
 * @extends {org_apache_flex_core_UIBase}
 */
org_apache_flex_html_Slider = function() {
  this.model =
      new org_apache_flex_html_beads_models_RangeModel();
  org_apache_flex_html_Slider.base(this, 'constructor');
};
goog.inherits(org_apache_flex_html_Slider,
    org_apache_flex_core_UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_Slider.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Slider',
                qName: 'org_apache_flex_html_Slider'}] };


/**
 * @override
 */
org_apache_flex_html_Slider.prototype.createElement =
    function() {

  this.element = document.createElement('div');
  this.element.style.width = '200px';
  this.element.style.height = '30px';

  this.track = new org_apache_flex_html_beads_SliderTrackView();
  this.addBead(this.track);

  this.thumb = new org_apache_flex_html_beads_SliderThumbView();
  this.addBead(this.thumb);

  this.controller = new org_apache_flex_html_beads_controllers_SliderMouseController();
  this.addBead(this.controller);

  this.positioner = this.element;
  this.element.flexjs_wrapper = this;

  this.className = 'Slider';

  return this.element;
};


Object.defineProperties(org_apache_flex_html_Slider.prototype, {
    /** @expose */
    value: {
        /** @this {org_apache_flex_html_Slider} */
        get: function() {
            return this.model.value;
        },
        /** @this {org_apache_flex_html_Slider} */
        set: function(newValue) {
            this.model.value = newValue;
            this.setThumbFromValue(this.model.value);
        }
    },
    /** @expose */
    minimum: {
        /** @this {org_apache_flex_html_Slider} */
        get: function() {
            return this.model.minimum;
        },
        /** @this {org_apache_flex_html_Slider} */
        set: function(value) {
            this.model.minimum = value;
        }
    },
    /** @expose */
    maximum: {
        /** @this {org_apache_flex_html_Slider} */
        get: function() {
            return this.model.maximum;
        },
        /** @this {org_apache_flex_html_Slider} */
        set: function(value) {
            this.model.maximum = value;
        }
    },
    /** @expose */
    snapInterval: {
        /** @this {org_apache_flex_html_Slider} */
        get: function() {
            return this.model.snapInterval;
        },
        /** @this {org_apache_flex_html_Slider} */
        set: function(value) {
            this.model.snapInterval = value;
        }
    },
    /** @expose */
    stepSize: {
        /** @this {org_apache_flex_html_Slider} */
        get: function() {
            return this.model.stepSize;
        },
        /** @this {org_apache_flex_html_Slider} */
        set: function(value) {
            this.model.stepSize = value;
        }
    }
});


/**
 * @param {Object} value The current value.
 * @return {number} Calculates the new value based snapInterval and stepSize.
 */
org_apache_flex_html_Slider.prototype.snap = function(value)
    {
  var si = this.snapInterval;
  var n = Math.round((value - this.minimum) / si) *
      si + this.minimum;
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
 * @param {number} value The value used to calculate new position of the thumb.
 * @return {void} Moves the thumb to the corresponding position.
 */
org_apache_flex_html_Slider.prototype.setThumbFromValue =
    function(value)
    {
  var min = this.model.minimum;
  var max = this.model.maximum;
  var p = (value - min) / (max - min);
  var xloc = p * (parseInt(this.track.element.style.width, 10) -
             parseInt(this.thumb.element.style.width, 10));

  this.thumb.element.style.left = String(xloc) + 'px';
};

