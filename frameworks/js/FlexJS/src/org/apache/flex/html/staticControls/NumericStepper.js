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

goog.provide('org.apache.flex.html.staticControls.NumericStepper');

goog.require('org.apache.flex.core.UIBase');
goog.require('org.apache.flex.html.staticControls.TextInput');
goog.require('org.apache.flex.html.staticControls.Spinner');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.html.staticControls.NumericStepper = function() {
  goog.base(this);

  this.minimum_ = 0;
  this.maximum_ = 100;
  this.value_ = 1;
  this.stepSize_ = 1;
  this.snapInterval_ = 1;
};
goog.inherits(org.apache.flex.html.staticControls.NumericStepper,
    org.apache.flex.core.UIBase);


/**
 * @override
 * @this {org.apache.flex.html.staticControls.NumericStepper}
 * @param {Object} p The parent element.
 */
org.apache.flex.html.staticControls.NumericStepper.prototype.addToParent = function(p) {
  goog.base(this, 'addToParent', p);
  
  this.element = document.createElement('div');
  this.positioner = this.element;
  
  this.input = new org.apache.flex.html.staticControls.TextInput();
  this.input.addToParent(this);
  this.input.positioner.style.display = "inline-block";
  
  this.spinner = new org.apache.flex.html.staticControls.Spinner();
  this.spinner.addToParent(this);
  this.spinner.positioner.style.display = "inline-block";
  goog.events.listen(this.spinner, 'valueChanged', goog.bind(this.handleSpinnerChange, this));
  
  p.internalAddChild(this.element);

  this.element.flexjs_wrapper = this;
  
  this.input.set_text( String(this.spinner.get_value()) );
}

/**
 * @this {org.apache.flex.html.staticControls.Spinner}
 * @return {void} Handles click on increment button.
 */
org.apache.flex.html.staticControls.NumericStepper.prototype.handleSpinnerChange = function(event)
{
   this.input.set_text( String(this.spinner.get_value()) );
   this.dispatchEvent(new org.apache.flex.events.Event("valueChanged"));
}