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

goog.provide('org.apache.flex.html.NumericStepper');

goog.require('org.apache.flex.core.UIBase');
goog.require('org.apache.flex.html.Spinner');
goog.require('org.apache.flex.html.TextInput');
goog.require('org.apache.flex.html.beads.models.RangeModel');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.html.NumericStepper = function() {
  org.apache.flex.html.NumericStepper.base(this, 'constructor');
  this.model =
      new org.apache.flex.html.beads.models.RangeModel();
};
goog.inherits(org.apache.flex.html.NumericStepper,
    org.apache.flex.core.UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.NumericStepper.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'NumericStepper',
                qName: 'org.apache.flex.html.NumericStepper' }] };


/**
 * @override
 */
org.apache.flex.html.NumericStepper.prototype.createElement =
    function() {
  this.element = document.createElement('div');
  this.positioner = this.element;

  this.input = new org.apache.flex.html.TextInput();
  this.addElement(this.input);
  this.input.positioner.style.display = 'inline-block';
  this.input.positioner.style.width = '100px';

  this.spinner = new org.apache.flex.html.Spinner();
  this.spinner.positioner.style.display = 'inline-block';
  this.spinner.positioner.style.height = '24px';
  this.spinner.positioner.style.marginLeft = '-1px';
  this.spinner.positioner.style.marginTop = '-1px';
  this.addElement(this.spinner);
  /* TODO: ajh move to view and css */
  this.spinner.incrementButton.positioner.style.display = 'block';
  this.spinner.incrementButton.positioner.style.marginBottom = '-1px';
  this.spinner.incrementButton.positioner.style.paddingTop = '1.5px';
  this.spinner.incrementButton.positioner.style.paddingBottom = '2px';
  this.spinner.incrementButton.positioner.style.fontSize = '7px';
  this.spinner.decrementButton.positioner.style.marginTop = '0px';
  this.spinner.decrementButton.positioner.style.display = 'block';
  this.spinner.decrementButton.positioner.style.paddingTop = '2px';
  this.spinner.decrementButton.positioner.style.paddingBottom = '1.5px';
  this.spinner.decrementButton.positioner.style.fontSize = '7px';
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
org.apache.flex.html.NumericStepper.prototype.spinnerChange =
    function(event)
    {
  var newValue = this.spinner.value;
  this.value = newValue;
  this.input.text = String(this.spinner.value);
  this.dispatchEvent(new org.apache.flex.events.Event('valueChange'));
};


Object.defineProperties(org.apache.flex.html.NumericStepper.prototype, {
    /** @export */
    minimum: {
        /** @this {org.apache.flex.html.NumericStepper} */
        get: function() {
            return this.model.minimum;
        },
        /** @this {org.apache.flex.html.NumericStepper} */
        set: function(value) {
            this.model.minimum = value;
        }
    },
    /** @export */
    maximum: {
        /** @this {org.apache.flex.html.NumericStepper} */
        get: function() {
            return this.model.maximum;
        },
        /** @this {org.apache.flex.html.NumericStepper} */
        set: function(value) {
            this.model.maximum = value;
        }
    },
    /** @export */
    value: {
        /** @this {org.apache.flex.html.NumericStepper} */
        get: function() {
            return this.model.value;
        },
        /** @this {org.apache.flex.html.NumericStepper} */
        set: function(newValue) {
            this.model.value = newValue;
            this.spinner.value = newValue;
        }
    },
    /** @export */
    snapInterval: {
        /** @this {org.apache.flex.html.NumericStepper} */
        get: function() {
            return this.model.snapInterval;
        },
        /** @this {org.apache.flex.html.NumericStepper} */
        set: function(value) {
            this.model.snapInterval = value;
        }
    },
    /** @export */
    stepSize: {
        /** @this {org.apache.flex.html.NumericStepper} */
        get: function() {
            return this.model.stepSize;
        },
        /** @this {org.apache.flex.html.NumericStepper} */
        set: function(value) {
            this.model.stepSize = value;
        }
    }
});

