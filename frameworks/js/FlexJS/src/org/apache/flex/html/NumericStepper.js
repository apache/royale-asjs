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

goog.provide('org_apache_flex_html_NumericStepper');

goog.require('org_apache_flex_core_UIBase');
goog.require('org_apache_flex_html_Spinner');
goog.require('org_apache_flex_html_TextInput');
goog.require('org_apache_flex_html_beads_models_RangeModel');



/**
 * @constructor
 * @extends {org_apache_flex_core_UIBase}
 */
org_apache_flex_html_NumericStepper = function() {
  this.model =
      new org_apache_flex_html_beads_models_RangeModel();
  org_apache_flex_html_NumericStepper.base(this, 'constructor');
};
goog.inherits(org_apache_flex_html_NumericStepper,
    org_apache_flex_core_UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_NumericStepper.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'NumericStepper',
                qName: 'org_apache_flex_html_NumericStepper' }] };


/**
 * @override
 */
org_apache_flex_html_NumericStepper.prototype.createElement =
    function() {
  this.element = document.createElement('div');
  this.positioner = this.element;

  this.input = new org_apache_flex_html_TextInput();
  this.addElement(this.input);
  this.input.positioner.style.display = 'inline-block';
  this.input.positioner.style.width = '100px';

  this.spinner = new org_apache_flex_html_Spinner();
  this.spinner.positioner.style.display = 'inline-block';
  this.spinner.positioner.style.height = '24px';
  this.spinner.positioner.style.marginLeft = '-2px';
  this.spinner.positioner.style.marginTop = '2px';
  this.addElement(this.spinner);
  /* TODO: ajh move to view and css */
  this.spinner.incrementButton.positioner.style.display = 'block';
  this.spinner.incrementButton.positioner.style.marginBottom = '-1px';
  this.spinner.incrementButton.positioner.style.paddingTop = '1px';
  this.spinner.incrementButton.positioner.style.paddingBottom = '1px';
  this.spinner.incrementButton.positioner.style.fontSize = '6px';
  this.spinner.decrementButton.positioner.style.marginTop = '0px';
  this.spinner.decrementButton.positioner.style.display = 'block';
  this.spinner.decrementButton.positioner.style.paddingTop = '1px';
  this.spinner.decrementButton.positioner.style.paddingBottom = '1px';
  this.spinner.decrementButton.positioner.style.fontSize = '6px';
  this.spinner.positioner.style.display = 'inline-block';
  goog.events.listen(this.spinner, 'valueChange',
      goog.bind(this.spinnerChange, this));

  this.element.flexjs_wrapper = this;
  this.set_className('NumericStepper');

  this.input.set_text(String(this.spinner.get_value()));

  return this.element;
};


/**
 * @param {Object} event The input event.
 */
org_apache_flex_html_NumericStepper.prototype.spinnerChange =
    function(event)
    {
  var newValue = this.spinner.get_value();
  this.set_value(newValue);
  this.input.set_text(String(this.spinner.get_value()));
  this.dispatchEvent(new org_apache_flex_events_Event('valueChange'));
};


/**
 * @expose
 * @return {Number} The current minimum value.
 */
org_apache_flex_html_NumericStepper.prototype.get_minimum =
    function() {
  return this.model.get_minimum();
};


/**
 * @expose
 * @param {Number} value The new minimum value.
 */
org_apache_flex_html_NumericStepper.prototype.set_minimum =
    function(value) {
  this.model.set_minimum(value);
};


/**
 * @expose
 * @return {Number} The current maximum value.
 */
org_apache_flex_html_NumericStepper.prototype.get_maximum =
    function() {
  return this.model.get_maximum();
};


/**
 * @expose
 * @param {Number} value The new maximum value.
 */
org_apache_flex_html_NumericStepper.prototype.set_maximum =
    function(value) {
  this.model.set_maximum(value);
};


/**
 * @expose
 * @return {Number} The current value.
 */
org_apache_flex_html_NumericStepper.prototype.get_value =
    function() {
  return this.model.get_value();
};


/**
 * @expose
 * @param {Number} newValue The new value.
 */
org_apache_flex_html_NumericStepper.prototype.set_value =
    function(newValue) {
  this.model.set_value(newValue);
  this.spinner.set_value(newValue);
};


/**
 * @expose
 * @return {Number} The current snapInterval value.
 */
org_apache_flex_html_NumericStepper.prototype.get_snapInterval =
    function() {
  return this.model.get_snapInterval();
};


/**
 * @expose
 * @param {Number} value The new snapInterval value.
 */
org_apache_flex_html_NumericStepper.prototype.set_snapInterval =
    function(value) {
  this.model.set_snapInterval(value);
};


/**
 * @expose
 * @return {Number} The current stepSize value.
 */
org_apache_flex_html_NumericStepper.prototype.get_stepSize =
    function() {
  return this.model.get_stepSize();
};


/**
 * @expose
 * @param {Number} value The new stepSize value.
 */
org_apache_flex_html_NumericStepper.prototype.set_stepSize =
    function(value) {
  this.model.set_stepSize(value);
};

