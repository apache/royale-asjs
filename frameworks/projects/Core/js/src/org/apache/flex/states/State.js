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

goog.provide('org.apache.flex.states.State');



/**
 * @constructor
 * @param {Object=} opt_props The initial properties.
 */
org.apache.flex.states.State = function(opt_props) {
  opt_props = typeof opt_props !== 'undefined' ? opt_props : null;
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.states.State.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'State',
                qName: 'org.apache.flex.states.State' }] };


/**
 * @private
 * @type {string} name The state name.
 */
org.apache.flex.states.State.prototype.name_ = '';


/**
 * @private
 * @type {Array} overrides The state data.
 */
org.apache.flex.states.State.prototype.overrides_ = null;


Object.defineProperties(org.apache.flex.states.State.prototype,
  /** @lends {org.apache.flex.states.State.prototype} */ {
  /** @export */
  name: {
    /** @this {org.apache.flex.states.State} */
    get: function() {
      return this.name_;
    },

    /** @this {org.apache.flex.states.State} */
    set: function(value) {
      if (value != this.name_) {
        this.name_ = value;
      }
    }
  },
  /** @export */
  overrides: {
    /** @this {org.apache.flex.states.State} */
    get: function() {
      return this.overrides_;
    },

    /** @this {org.apache.flex.states.State} */
    set: function(value) {
      if (value != this.overrides_) {
        this.overrides_ = value;
      }
    }
  }
});
