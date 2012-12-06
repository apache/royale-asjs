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

goog.provide('flash.events.Event');

/**
 * @constructor
 */
flash.events.Event = function() {
    /**
     * @private
     * @type {string}
     */
     this.type_;
};

/**
 * @this {flash.events.Event}
 * @param {string} type The event type.
 */
flash.events.Event.prototype.init = function(type) {
    this.type_ = type;
};
