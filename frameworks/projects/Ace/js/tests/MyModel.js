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

goog.provide('MyModel');

goog.require('flash.events.EventDispatcher');

goog.require('org.apache.royale.FlexGlobal');

/**
 * @constructor
 * @extends {flash.events.EventDispatcher}
 */
MyModel = function() {
    flash.events.EventDispatcher.call(this);

    /**
     * @private
     * @type {string}
     */
    this.labelText_;
};
goog.inherits(MyModel, flash.events.EventDispatcher);

/**
 * @export
 * @this {MyModel}
 * @return {string} The labelText getter.
 */
MyModel.prototype.get_labelText = function() {
    return this.labelText_;
};

/**
 * @export
 * @this {MyModel}
 * @param {string} value The labelText setter.
 */
MyModel.prototype.set_labelText = function(value) {
    if (value != this.labelText_) {
        this.labelText_ = value;

        this.dispatchEvent(
            org.apache.royale.FlexGlobal.newObject(
                flash.events.Event, ['labelTextChanged']
            )
        );
    }
};
