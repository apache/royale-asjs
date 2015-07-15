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

goog.provide('org.apache.flex.utils.EffectTimer');

goog.require('org.apache.flex.core.IEffectTimer');
goog.require('org.apache.flex.core.ValuesManager');
goog.require('org.apache.flex.events.EventDispatcher');
goog.require('org.apache.flex.events.ValueEvent');



/**
 * @constructor
 * @extends {org.apache.flex.events.EventDispatcher}
 * @suppress {checkTypes}
 */
org.apache.flex.utils.EffectTimer = function() {
  org.apache.flex.utils.EffectTimer.base(this, 'constructor');

  /**
   * @protected
   * @type {number}
   */
  this.timerInterval = -1;

  /**
   * @protected
   * @type {number}
   */
  this._delay = org.apache.flex.core.ValuesManager.valuesImpl.getValue(this,
                                                        'effectTimerInterval');

};
goog.inherits(org.apache.flex.utils.EffectTimer,
    org.apache.flex.events.EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.utils.EffectTimer.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'EffectTimer',
               qName: 'org.apache.flex.utils.EffectTimer'}],
        interfaces: [org.apache.flex.core.IEffectTimer] };


/**
 * @export
 * Stops the timer.
 */
org.apache.flex.utils.EffectTimer.prototype.stop = function() {
  clearInterval(this.timerInterval);
  this.timerInterval = -1;
};


/**
 * @export
 * Starts the timer.
 * @return {number} The start time.
 */
org.apache.flex.utils.EffectTimer.prototype.start = function() {
  this.timerInterval =
      setInterval(goog.bind(this.timerHandler, this), this._delay);
  var d = new Date();
  return d.getTime();
};


/**
 * @protected
 */
org.apache.flex.utils.EffectTimer.prototype.timerHandler =
    function() {
  var d = new Date();
  this.dispatchEvent(new org.apache.flex.events.ValueEvent('update', d.getTime()));

};


