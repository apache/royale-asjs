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


Object.defineProperties(org.apache.flex.binding.ConstantBinding.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.binding.ConstantBinding} */
        set: function(value) {
            org.apache.flex.utils.Language.superSetter(org.apache.flex.binding.ConstantBinding, this, 'strand', value);

            var val;
            if (this.sourcePropertyName in this.source) {
              val = this.source[this.sourcePropertyName];
            } else if (this.sourcePropertyName in this.source.constructor) {
              val = this.source.constructor[this.sourcePropertyName];
            } else {
              // GCC optimizer only puts exported class constants on
              // Window and not on the class itself (which got renamed)
              var cname = this.source.FLEXJS_CLASS_INFO;
              if (cname) {
                cname = cname.names[0].qName;
                var parts = cname.split('.');
                var n = parts.length;
                var o = window;
                for (var i = 0; i < n; i++) {
                  o = o[parts[i]];
                }
                val = o[this.sourcePropertyName];
              }
            }
            this.destination[this.destinationPropertyName] = val;
        }
    }
});
