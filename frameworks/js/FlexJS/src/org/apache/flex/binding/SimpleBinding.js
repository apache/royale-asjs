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

goog.provide('org_apache_flex_binding_SimpleBinding');

goog.require('org_apache_flex_binding_BindingBase');



/**
 * @constructor
 * @extends {org_apache_flex_binding_BindingBase}
 */
org_apache_flex_binding_SimpleBinding = function() {
  org_apache_flex_binding_SimpleBinding.base(this, 'constructor');
};
goog.inherits(org_apache_flex_binding_SimpleBinding,
    org_apache_flex_binding_BindingBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_binding_SimpleBinding.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'SimpleBinding',
                qName: 'org_apache_flex_binding_SimpleBinding'}] };


/**
 * @expose
 * @type {string}
 */
org_apache_flex_binding_SimpleBinding.prototype.eventName = '';


/**
 * @expose
 */
org_apache_flex_binding_SimpleBinding.prototype.changeHandler = function() {
  this.destination[this.destinationPropertyName] =
      this.source[this.sourcePropertyName];
};


/**
 * @param {Object} event The event.
 */
org_apache_flex_binding_SimpleBinding.prototype.sourceChangeHandler = function(event) {
  org_apache_flex_binding_SimpleBinding.base(this, 'sourceChangeHandler', event);
  if (this.source) {
    this.source.addEventListener(this.eventName,
        goog.bind(this.changeHandler, this));
    this.changeHandler();
  }
};


Object.defineProperties(org_apache_flex_binding_SimpleBinding.prototype, {
    'strand': {
         set: function(value) {
             org_apache_flex_binding_SimpleBinding.base(this, 'set_strand', value);

             if (!this.source)
                 return;

             this.source.addEventListener(this.eventName,
                 goog.bind(this.changeHandler, this));

             this.changeHandler();
         }
    }
});


