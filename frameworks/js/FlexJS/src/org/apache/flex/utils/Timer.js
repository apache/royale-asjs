/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

goog.provide('org_apache_flex_utils_Timer');

goog.require('org_apache_flex_events_EventDispatcher');



/**
 * @constructor
 * @extends {org_apache_flex_events_EventDispatcher}
 * @param {number} delay The delay.
 * @param {number=} opt_repeatCount The repeatCount.
 */
org_apache_flex_utils_Timer = function(delay, opt_repeatCount) {
  org_apache_flex_utils_Timer.base(this, 'constructor');

  if (opt_repeatCount !== undefined) {
    this._repeatCount = opt_repeatCount;
  }

  /**
   * @protected
   * @type {number}
   */
  this.timerInterval = -1;

  /**
   * @protected
   * @type {number}
   */
  this._delay = delay;

  /**
   * @protected
   * @type {number}
   */
  this._currentCount = 0;
};
goog.inherits(org_apache_flex_utils_Timer,
    org_apache_flex_events_EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_utils_Timer.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Timer',
                qName: 'org_apache_flex_utils_Timer'}] };


/**
 * @expose
 * Stops the timer and sets currentCount = 0.
 */
org_apache_flex_utils_Timer.prototype.reset = function() {
  this.stop();
  this._currentCount = 0;
};


/**
 * @expose
 * Stops the timer.
 */
org_apache_flex_utils_Timer.prototype.stop = function() {
  clearInterval(this.timerInterval);
  this.timerInterval = -1;
};


/**
 * @expose
 * Starts the timer.
 */
org_apache_flex_utils_Timer.prototype.start = function() {
  this.timerInterval =
      setInterval(goog.bind(this.timerHandler, this), this._delay);
};


/**
 * @protected
 */
org_apache_flex_utils_Timer.prototype.timerHandler =
    function() {
  this._currentCount++;
  if (this._repeatCount > 0 && this._currentCount >= this._repeatCount) {
    this.stop();
  }

  this.dispatchEvent(new org_apache_flex_events_Event('timer'));

};


/**
 * @expose
 * @return {number} The currentCount.
 */
org_apache_flex_utils_Timer.prototype.get_currentCount = function() {
  return this._currentCount;
};


/**
 * @expose
 * @return {boolean} True if the timer is running.
 */
org_apache_flex_utils_Timer.prototype.get_running = function() {
  return this.timerInterval !== -1;
};


/**
 * @expose
 * @return {number} The number of milliseconds between events.
 */
org_apache_flex_utils_Timer.prototype.get_delay = function() {
  return this._delay;
};


/**
 * @expose
 * @param {number} value The number of milliseconds between events.
 */
org_apache_flex_utils_Timer.prototype.set_delay = function(value) {
  this._delay = value;
};


/**
 * @expose
 * @return {number} The repeat count.
 */
org_apache_flex_utils_Timer.prototype.get_repeatCount = function() {
  return this._repeatCount;
};


/**
 * @expose
 * @param {number} value The repeat count.
 */
org_apache_flex_utils_Timer.prototype.set_repeatCount = function(value) {
  this._repeatCount = value;
};
