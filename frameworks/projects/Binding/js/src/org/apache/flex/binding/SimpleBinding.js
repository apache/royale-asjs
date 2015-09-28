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

goog.provide('org.apache.flex.binding.SimpleBinding');

goog.require('org.apache.flex.binding.BindingBase');
goog.require('org.apache.flex.utils.Language');



/**
 * @constructor
 * @extends {org.apache.flex.binding.BindingBase}
 */
org.apache.flex.binding.SimpleBinding = function() {
  org.apache.flex.binding.SimpleBinding.base(this, 'constructor');
};
goog.inherits(org.apache.flex.binding.SimpleBinding,
    org.apache.flex.binding.BindingBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.binding.SimpleBinding.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'SimpleBinding',
                qName: 'org.apache.flex.binding.SimpleBinding'}] };


/**
 * @export
 * @type {string}
 */
org.apache.flex.binding.SimpleBinding.prototype.eventName = '';


/**
 * @export
 */
org.apache.flex.binding.SimpleBinding.prototype.changeHandler = function() {
  try {
    this.destination[this.destinationPropertyName] =
        this.source[this.sourcePropertyName];
  }
  catch (e) {}
};


/**
 * @param {Object} event The event.
 */
org.apache.flex.binding.SimpleBinding.prototype.sourceChangeHandler = function(event) {
  org.apache.flex.binding.SimpleBinding.base(this, 'sourceChangeHandler', event);
  if (this.source) {
    this.source.addEventListener(this.eventName,
        goog.bind(this.changeHandler, this));
    this.changeHandler();
  }
};


Object.defineProperties(org.apache.flex.binding.SimpleBinding.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.binding.SimpleBinding} */
         set: function(value) {
            org.apache.flex.utils.Language.superSetter(
                org.apache.flex.binding.SimpleBinding, this, 'strand', value);

            if (!this.source)
                return;

            this.source.addEventListener(this.eventName,
                goog.bind(this.changeHandler, this));

            this.changeHandler();
         }
    }
});


