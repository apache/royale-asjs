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
  org_apache_flex_html_NumericStepper.base(this, 'constructor');
  this.model =
      new org_apache_flex_html_beads_models_RangeModel();
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
  this.className = 'NumericStepper';

  this.input.text = String(this.spinner.value);

  return this.element;
};


/**
 * @param {Object} event The input event.
 */
org_apache_flex_html_NumericStepper.prototype.spinnerChange =
    function(event)
    {
  var newValue = this.spinner.value;
  this.value = newValue;
  this.input.text = String(this.spinner.value);
  this.dispatchEvent(new org_apache_flex_events_Event('valueChange'));
};


Object.defineProperties(org_apache_flex_html_NumericStepper.prototype, {
    /** @expose */
    minimum: {
        /** @this {org_apache_flex_html_NumericStepper} */
        get: function() {
            return this.model.minimum;
        },
        /** @this {org_apache_flex_html_NumericStepper} */
        set: function(value) {
            this.model.minimum = value;
        }
    },
    /** @expose */
    maximum: {
        /** @this {org_apache_flex_html_NumericStepper} */
        get: function() {
            return this.model.maximum;
        },
        /** @this {org_apache_flex_html_NumericStepper} */
        set: function(value) {
            this.model.maximum = value;
        }
    },
    /** @expose */
    value: {
        /** @this {org_apache_flex_html_NumericStepper} */
        get: function() {
            return this.model.value;
        },
        /** @this {org_apache_flex_html_NumericStepper} */
        set: function(newValue) {
            this.model.value = newValue;
            this.spinner.value = newValue;
        }
    },
    /** @expose */
    snapInterval: {
        /** @this {org_apache_flex_html_NumericStepper} */
        get: function() {
            return this.model.snapInterval;
        },
        /** @this {org_apache_flex_html_NumericStepper} */
        set: function(value) {
            this.model.snapInterval = value;
        }
    },
    /** @expose */
    stepSize: {
        /** @this {org_apache_flex_html_NumericStepper} */
        get: function() {
            return this.model.stepSize;
        },
        /** @this {org_apache_flex_html_NumericStepper} */
        set: function(value) {
            this.model.stepSize = value;
        }
    }
});

