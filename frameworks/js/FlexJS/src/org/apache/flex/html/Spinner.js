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

goog.provide('org_apache_flex_html_Spinner');

goog.require('org_apache_flex_core_UIBase');
goog.require('org_apache_flex_html_TextButton');
goog.require('org_apache_flex_html_beads_controllers_SpinnerMouseController');



/**
 * @constructor
 * @extends {org_apache_flex_core_UIBase}
 */
org_apache_flex_html_Spinner = function() {
  org_apache_flex_html_Spinner.base(this, 'constructor');

  this.minimum_ = 0;
  this.maximum_ = 100;
  this.value_ = 1;
  this.stepSize_ = 1;
  this.snapInterval_ = 1;
};
goog.inherits(org_apache_flex_html_Spinner,
    org_apache_flex_core_UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_Spinner.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Spinner',
                qName: 'org_apache_flex_html_Spinner'}] };


/**
 * @override
 */
org_apache_flex_html_Spinner.prototype.createElement =
    function() {
  this.element = document.createElement('div');
  this.positioner = this.element;

  this.element.style.verticalAlign = 'middle';

  this.incrementButton = new org_apache_flex_html_TextButton();
  this.incrementButton.text = '\u25B2';
  this.addElement(this.incrementButton);

  this.decrementButton = new org_apache_flex_html_TextButton();
  this.decrementButton.text = '\u25BC';
  this.addElement(this.decrementButton);

  this.controller = new org_apache_flex_html_beads_controllers_SpinnerMouseController();
  this.addBead(this.controller);

  this.element.flexjs_wrapper = this;

  return this.element;
};


/**
 * @expose
 * @return {number} The current value.
 */
org_apache_flex_html_Spinner.prototype.get_value =
    function() {
  return this.value_;
};


/**
 * @expose
 * @param {number} value The new value.
 */
org_apache_flex_html_Spinner.prototype.set_value =
    function(value) {
  if (value != this.value_) {
    this.value_ = value;
    this.dispatchEvent('valueChange');
  }
};


/**
 * @expose
 * @return {number} The minimum value.
 */
org_apache_flex_html_Spinner.prototype.get_minimum = function() {
  return this.minimum_;
};


/**
 * @expose
 * @param {number} value The new minimum value.
 */
org_apache_flex_html_Spinner.prototype.set_minimum =
    function(value) {
  if (value != this.minimum_) {
    this.minimum_ = value;
    this.dispatchEvent('minimumChanged');
  }
};


/**
 * @expose
 * @return {number} The maximum value.
 */
org_apache_flex_html_Spinner.prototype.get_maximum =
    function() {
  return this.maximum_;
};


/**
 * @expose
 * @param {number} value The new maximum setter.
 */
org_apache_flex_html_Spinner.prototype.set_maximum =
    function(value) {
  if (value != this.maximum_) {
    this.maximum_ = value;
    this.dispatchEvent('maximumChanged');
  }
};


/**
 * @expose
 * @return {number} The snapInterval.
 */
org_apache_flex_html_Spinner.prototype.get_snapInterval =
    function() {
  return this.snapInterval_;
};


/**
 * @expose
 * @param {number} value The new snapInterval value.
 */
org_apache_flex_html_Spinner.prototype.set_snapInterval =
    function(value) {
  if (value != this.snapInterval_) {
    this.snapInterval_ = value;
    this.dispatchEvent('snapIntervalChanged');
  }
};


/**
 * @expose
 * @return {number} The stepSize.
 */
org_apache_flex_html_Spinner.prototype.get_stepSize =
    function() {
  return this.stepSize_;
};


/**
 * @expose
 * @param {number} value The new stepSize value.
 */
org_apache_flex_html_Spinner.prototype.set_stepSize =
    function(value) {
  if (value != this.stepSize_) {
    this.stepSize_ = value;
    this.dispatchEvent('stepSizeChanged');
  }
};


/**
 * @param {number} value The proposed value.
 * @return {number} The new value based on snapInterval
 * and stepSize.
 */
org_apache_flex_html_Spinner.prototype.snap = function(value)
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

