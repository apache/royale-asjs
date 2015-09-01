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

goog.provide('org.apache.flex.utils.MixinManager');

goog.require('org.apache.flex.core.IBead');



/**
 * @constructor
 * @implements {org.apache.flex.core.IBead}
 * Initialize mixins.
 * Compiler may not be generating list of mixins right now.
 */
org.apache.flex.utils.MixinManager = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.utils.MixinManager.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'MixinManager',
                qName: 'org.apache.flex.utils.MixinManager'}],
     interfaces: [org.apache.flex.core.IBead]};


Object.defineProperties(org.apache.flex.utils.MixinManager.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.utils.MixinManager} */
        set: function(value) {
            this.strand_ = value;

            if (value) {
              if (typeof(value.info) == 'function') {
                var mixins = value.info()['mixins'];
                if (mixins) {
                  var n = mixins.length;
                  for (var i = 0; i < n; i++) {
                    mixins[i].init(value);
                  }
                }
              }
            }
        }
    }
});
