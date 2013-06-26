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

goog.provide('org.apache.flex.html.staticControls.Spinner');

goog.require('org.apache.flex.core.UIBase');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.html.staticControls.Spinner = function() {
  goog.base(this);

  this.minimum_ = 0;
  this.maximum_ = 100;
  this.value_ = 1;
  this.stepSize_ = 1;
  this.snapInterval_ = 1;
};
goog.inherits(org.apache.flex.html.staticControls.Spinner,
    org.apache.flex.core.UIBase);


/**
 * @override
 * @this {org.apache.flex.html.staticControls.Spinner}
 * @param {Object} p The parent element.
 */
org.apache.flex.html.staticControls.Spinner.prototype.addToParent = function(p) {
  goog.base(this, 'addToParent', p);

  this.element = document.createElement('div');
  this.positioner = this.element;
  
  this.element.style.verticalAlign = "middle";
  
  this.incrementButton = document.createElement('button');
  this.incrementButton.id = "incrementButton";
  this.incrementButton.style.display = "block";
  this.incrementButton.innerHTML = '\u2191';
  this.element.appendChild(this.incrementButton);
  goog.events.listen(this.incrementButton, 'click', goog.bind(this.handleIncrementClick, this));
  
  this.decrementButton = document.createElement('button');
  this.decrementButton.id = "decrementButton";
  this.decrementButton.style.display = "block";
  this.decrementButton.innerHTML = '\u2193';
  this.element.appendChild(this.decrementButton);
  goog.events.listen(this.decrementButton, 'click', goog.bind(this.handleDecrementClick, this));
  
  p.internalAddChild(this.element);

  this.element.flexjs_wrapper = this;
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Spinner}
 * @return {Number} The value getter.
 */
org.apache.flex.html.staticControls.Spinner.prototype.get_value = function() {
	return this.value_;
}

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Spinner}
 * @return {void} The value setter.
 */
org.apache.flex.html.staticControls.Spinner.prototype.set_value = function(newValue) {
	this.value_ = newValue;
}

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Spinner}
 * @return {Number} The minimum getter.
 */
org.apache.flex.html.staticControls.Spinner.prototype.get_minimum = function() {
	return this.minimum_;
}

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Spinner}
 * @return {void} The minimum setter.
 */
org.apache.flex.html.staticControls.Spinner.prototype.set_minimum = function(value) {
	this.minimum_ = value;
}

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Spinner}
 * @return {Number} The maximum getter.
 */
org.apache.flex.html.staticControls.Spinner.prototype.get_maximum = function() {
	return this.maximum_;
}

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Spinner}
 * @return {void} The maximum setter.
 */
org.apache.flex.html.staticControls.Spinner.prototype.set_maximum = function(value) {
	this.maximum_ = value;
}

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Spinner}
 * @return {Number} The snapInterval getter.
 */
org.apache.flex.html.staticControls.Spinner.prototype.get_snapInterval = function() {
	return this.snapInterval_;
}

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Spinner}
 * @return {void} The snapInterval setter.
 */
org.apache.flex.html.staticControls.Spinner.prototype.set_snapInterval = function(value) {
	this.snapInterval_ = value;
}

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Spinner}
 * @return {Number} The stepSize getter.
 */
org.apache.flex.html.staticControls.Spinner.prototype.get_stepSize = function() {
	return this.stepSize_;
}

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.Spinner}
 * @return {void} The stepSize setter.
 */
org.apache.flex.html.staticControls.Spinner.prototype.set_stepSize = function(value) {
	this.stepSize_ = value;
}


/**
 * @this {org.apache.flex.html.staticControls.Spinner}
 * @return {Number} Calculates the new value based snapInterval and stepSize.
 */
org.apache.flex.html.staticControls.Spinner.prototype.snap = function(value)
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
}

/**
 * @this {org.apache.flex.html.staticControls.Spinner}
 * @return {void} Handles click on increment button.
 */
org.apache.flex.html.staticControls.Spinner.prototype.handleIncrementClick = function(event)
{
  this.value_ = this.snap(Math.min(this.maximum_, this.value_ + this.stepSize_));	
  this.dispatchEvent(new org.apache.flex.events.Event("valueChanged"));
};

/**
 * @this {org.apache.flex.html.staticControls.Spinner}
 * @return {void} Handles click on decrement button.
 */
org.apache.flex.html.staticControls.Spinner.prototype.handleDecrementClick = function(event)
{
  this.value_ = this.snap(Math.max(this.minimum_, this.value_ - this.stepSize_));
  this.dispatchEvent(new org.apache.flex.events.Event("valueChanged"));
};
