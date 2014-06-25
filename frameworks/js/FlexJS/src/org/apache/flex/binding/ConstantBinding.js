/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

goog.provide('org.apache.flex.binding.ConstantBinding');

goog.require('org.apache.flex.binding.BindingBase');



/**
 * @constructor
 * @extends {org.apache.flex.binding.BindingBase}
 */
org.apache.flex.binding.ConstantBinding = function() {
  org.apache.flex.binding.ConstantBinding.base(this, 'constructor');
};
goog.inherits(org.apache.flex.binding.ConstantBinding,
    org.apache.flex.binding.BindingBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.binding.ConstantBinding.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ConstantBinding',
                qName: 'org.apache.flex.binding.ConstantBinding'}] };


/**
 * @override
 * @param {Object} value The strand (owner) of the bead.
 */
org.apache.flex.binding.ConstantBinding.prototype.set_strand = function(value) {
  org.apache.flex.binding.ConstantBinding.base(this, 'set_strand', value);

  this.destination['set_' + this.destinationPropertyName](
      this.source['get_' + this.sourcePropertyName]()
  );
};
