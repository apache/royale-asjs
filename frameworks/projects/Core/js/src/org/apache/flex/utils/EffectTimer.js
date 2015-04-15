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

goog.provide('org_apache_flex_utils_EffectTimer');

goog.require('org_apache_flex_core_IEffectTimer');
goog.require('org_apache_flex_core_ValuesManager');
goog.require('org_apache_flex_events_EventDispatcher');
goog.require('org_apache_flex_events_ValueEvent');



/**
 * @constructor
 * @extends {org_apache_flex_events_EventDispatcher}
 * @suppress {checkTypes}
 */
org_apache_flex_utils_EffectTimer = function() {
  org_apache_flex_utils_EffectTimer.base(this, 'constructor');

  /**
   * @protected
   * @type {number}
   */
  this.timerInterval = -1;

  /**
   * @protected
   * @type {number}
   */
  this._delay = org_apache_flex_core_ValuesManager.valuesImpl.getValue(this,
                                                        'effectTimerInterval');

};
goog.inherits(org_apache_flex_utils_EffectTimer,
    org_apache_flex_events_EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_utils_EffectTimer.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'EffectTimer',
               qName: 'org_apache_flex_utils_EffectTimer'}],
        interfaces: [org_apache_flex_core_IEffectTimer] };


/**
 * @expose
 * Stops the timer.
 */
org_apache_flex_utils_EffectTimer.prototype.stop = function() {
  clearInterval(this.timerInterval);
  this.timerInterval = -1;
};


/**
 * @expose
 * Starts the timer.
 * @return {number} The start time.
 */
org_apache_flex_utils_EffectTimer.prototype.start = function() {
  this.timerInterval =
      setInterval(goog.bind(this.timerHandler, this), this._delay);
  var d = new Date();
  return d.getTime();
};


/**
 * @protected
 */
org_apache_flex_utils_EffectTimer.prototype.timerHandler =
    function() {
  var d = new Date();
  this.dispatchEvent(new org_apache_flex_events_ValueEvent('update', d.getTime()));

};


