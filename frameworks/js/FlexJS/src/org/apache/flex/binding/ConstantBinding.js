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

goog.provide('org_apache_flex_binding_ConstantBinding');

goog.require('org_apache_flex_binding_BindingBase');



/**
 * @constructor
 * @extends {org_apache_flex_binding_BindingBase}
 */
org_apache_flex_binding_ConstantBinding = function() {
  org_apache_flex_binding_ConstantBinding.base(this, 'constructor');
};
goog.inherits(org_apache_flex_binding_ConstantBinding,
    org_apache_flex_binding_BindingBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_binding_ConstantBinding.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ConstantBinding',
                qName: 'org_apache_flex_binding_ConstantBinding'}] };


/**
 * @override
 * @param {Object} value The strand (owner) of the bead.
 */
org_apache_flex_binding_ConstantBinding.prototype.set_strand = function(value) {
  org_apache_flex_binding_ConstantBinding.base(this, 'set_strand', value);

  var val;
  try {
    val = this.source[this.sourcePropertyName];
  } catch (e) {
    try {
      val = this.source.constructor[this.sourcePropertyName];
    } catch (e2) {
    }
  }
  this.destination[this.destinationPropertyName] = val;
};
