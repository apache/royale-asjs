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

goog.provide('org.apache.flex.utils.Timer');

goog.require('org.apache.flex.FlexGlobal');
goog.require('org.apache.flex.events.EventDispatcher');

/**
 * @constructor
 * @extends {org.apache.flex.events.EventDispatcher}
 */
org.apache.flex.utils.Timer = function(delay, repeatCount) {
    org.apache.flex.events.EventDispatcher.call(this);
    
    
    /**
     * @private
     * @type {number}
     */
    this.timerInterval = -1;

    /**
     * @private
     * @type {number}
     */
    this._delay = delay;
    
    /**
     * @private
     * @type {number}
     */
    this._currentCount = 0;
    

    if (typeof(repeatCount) != 'undefined') 
    { 
        this._repeatCount = repeatCount;
    }

};
goog.inherits(org.apache.flex.utils.Timer,
                org.apache.flex.events.EventDispatcher);

/**
 * @expose
 * @this {org.apache.flex.utils.Timer}
 * Stops the timer and sets currentCount = 0.
 */
org.apache.flex.utils.Timer.prototype.reset = function() {
    this.stop();
    this._currentCount = 0;
};

/**
 * @expose
 * @this {org.apache.flex.utils.Timer}
 * Stops the timer.
 */
org.apache.flex.utils.Timer.prototype.stop =
                                function() {
    clearInterval(this.timerInterval);
    this.timerInterval = -1;
};

/**
 * @expose
 * @this {org.apache.flex.utils.Timer}
 * Starts the timer.
 */
org.apache.flex.utils.Timer.prototype.start =
                                function() {
    this.timerInterval = setInterval(org.apache.flex.FlexGlobal.createProxy     
        (this, this.timerHandler),
        this._delay);
};

/**
 * @private
 * @this {org.apache.flex.utils.Timer}
 */
org.apache.flex.utils.Timer.prototype.timerHandler =
                                function() {
    this._currentCount++;
    if (this._repeatCount > 0 && this._currentCount >= this._repeatCount)
        this.stop();
        
    var evt = document.createEvent('Event');
    evt.initEvent('timer', false, false);
    this.dispatchEvent(evt);
    
};

/**
 * @expose
 * @this {org.apache.flex.utils.Timer}
 * @returns {Number} The currentCount.
 */
org.apache.flex.utils.Timer.prototype.get_currentCount = function() {
    return this._currentCount;
};

/**
 * @expose
 * @this {org.apache.flex.utils.Timer}
 * @returns {boolean} True if the timer is running.
 */
org.apache.flex.utils.Timer.prototype.get_running = function() {
    return this.timerInterval != -1;
};

/**
 * @expose
 * @this {org.apache.flex.utils.Timer}
 * @returns {Number} The number of milliseconds between events.
 */
org.apache.flex.utils.Timer.prototype.get_delay = function() {
    return this._delay;
};

/**
 * @expose
 * @this {org.apache.flex.utils.Timer}
 * @param {Number} value The number of milliseconds between events.
 */
org.apache.flex.utils.Timer.prototype.set_delay = function(value) {
    this._delay = value;
};

/**
 * @expose
 * @this {org.apache.flex.utils.Timer}
 * @returns {Number} The repeat count.
 */
org.apache.flex.utils.Timer.prototype.get_repeatCount = function() {
    return this._repeatCount;
};

/**
 * @expose
 * @this {org.apache.flex.utils.Timer}
 * @param {Number} value The repeat count.
 */
org.apache.flex.utils.Timer.prototype.set_repeatCount = function(value) {
    this._repeatCount = value;
};
