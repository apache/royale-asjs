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

goog.provide('org_apache_flex_binding_BindingBase');



/**
 * @constructor
 */
org_apache_flex_binding_BindingBase = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_binding_BindingBase.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'BindingBase',
                qName: 'org_apache_flex_binding_BindingBase'}] };


/**
 * @protected
 * @type {Object}
 */
org_apache_flex_binding_BindingBase.prototype.document = null;


/**
 * @expose
 * @type {Object}
 */
org_apache_flex_binding_BindingBase.prototype.destination = null;


/**
 * @expose
 * @type {string}
 */
org_apache_flex_binding_BindingBase.prototype.destinationPropertyName = '';


/**
 * @expose
 * @type {Object}
 */
org_apache_flex_binding_BindingBase.prototype.source = null;


/**
 * @expose
 * @type {string}
 */
org_apache_flex_binding_BindingBase.prototype.sourcePropertyName = '';


/**
 * @expose
 * @type {?string}
 */
org_apache_flex_binding_BindingBase.prototype.sourceID = null;


/**
 * @expose
 * @param {Object} document The MXML object.
 */
org_apache_flex_binding_BindingBase.prototype.setDocument = function(document) {
  this.document = document;
};


/**
 * @param {Object} event The event.
 */
org_apache_flex_binding_BindingBase.prototype.sourceChangeHandler = function(event) {
  if (event.propertyName != this.sourceID)
    return;

  if (this.source)
    this.source.removeEventListener(this.eventName,
        goog.bind(this.changeHandler, this));

  this.source = this.document[this.sourceID];
};


Object.defineProperties(org_apache_flex_binding_BindingBase.prototype, {
  'strand': {
 		/** @this {org_apache_flex_binding_BindingBase} */
      set: function(value) {
          if (this.destination == null)
            this.destination = value;
          if (this.sourceID != null) {
            this.source = this.document[this.sourceID];
            if (this.source == null) {
               this.document.addEventListener('valueChange',
                    goog.bind(this.sourceChangeHandler, this));
               return;
            }
          }
          else
            this.source = this.document;
        }
    }
});
