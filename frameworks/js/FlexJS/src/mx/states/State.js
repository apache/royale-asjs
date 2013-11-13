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

goog.provide('mx.states.State');



/**
 * @constructor
 * @param {Object=} opt_props The initial properties.
 */
mx.states.State = function(opt_props) {
  opt_props = typeof opt_props !== 'undefined' ? opt_props : null;
};


/**
 * @expose
 * @type {string} name The state name.
 */
mx.states.State.prototype.name = '';


/**
 * @expose
 * @type {Array} overrides The state data.
 */
mx.states.State.prototype.overrides = null;
