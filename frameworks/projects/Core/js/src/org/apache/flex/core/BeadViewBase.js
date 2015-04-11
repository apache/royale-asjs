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

goog.provide('org_apache_flex_core_BeadViewBase');

goog.require('org_apache_flex_core_IBeadView');
goog.require('org_apache_flex_events_EventDispatcher');



/**
 * @constructor
 * @extends {org_apache_flex_events_EventDispatcher}
 * @implements {org_apache_flex_core_IBeadView}
 */
org_apache_flex_core_BeadViewBase = function() {
    org_apache_flex_core_BeadViewBase.base(this, 'constructor');
  };
goog.inherits(
              org_apache_flex_core_BeadViewBase,
              org_apache_flex_events_EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_core_BeadViewBase.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'BeadViewBase',
                qName: 'org_apache_flex_core_BeadViewBase'}],
    interfaces: [org_apache_flex_core_IBeadView]};


/**
 * @protected
 * @type {Object}
 */
org_apache_flex_core_BeadViewBase.prototype._strand = null;


Object.defineProperties(org_apache_flex_core_BeadViewBase.prototype, {
    /** @expose */
    strand: {
        /** @this {org_apache_flex_core_BeadViewBase} */
        set: function(value) {
            if (this._strand !== value) {
              this._strand = value;
            }
        }
    },
    /** @expose */
    host: {
        /** @this {org_apache_flex_core_BeadViewBase} */
        get: function() {
            return this._strand;
        }
    }
});


