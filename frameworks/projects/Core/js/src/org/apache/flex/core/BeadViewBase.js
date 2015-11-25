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

goog.provide('org.apache.flex.core.BeadViewBase');

goog.require('org.apache.flex.core.IBeadView');
goog.require('org.apache.flex.events.EventDispatcher');



/**
 * @constructor
 * @extends {org.apache.flex.events.EventDispatcher}
 * @implements {org.apache.flex.core.IBeadView}
 */
org.apache.flex.core.BeadViewBase = function() {
    org.apache.flex.core.BeadViewBase.base(this, 'constructor');
  };
goog.inherits(
              org.apache.flex.core.BeadViewBase,
              org.apache.flex.events.EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.BeadViewBase.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'BeadViewBase',
                qName: 'org.apache.flex.core.BeadViewBase'}],
    interfaces: [org.apache.flex.core.IBeadView]};


/**
 * @type {Object}
 */
org.apache.flex.core.BeadViewBase.prototype._strand = null;


Object.defineProperties(org.apache.flex.core.BeadViewBase.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.core.BeadViewBase} */
        set: function(value) {
            if (this._strand !== value) {
              this._strand = value;
            }
        }
    },
    /** @export */
    host: {
        /** @this {org.apache.flex.core.BeadViewBase} */
        get: function() {
            return this._strand;
        }
    }
});


