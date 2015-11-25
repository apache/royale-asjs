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

goog.provide('org.apache.flex.binding.BindingBase');



/**
 * @constructor
 */
org.apache.flex.binding.BindingBase = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.binding.BindingBase.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'BindingBase',
                qName: 'org.apache.flex.binding.BindingBase'}] };


/**
 * @protected
 * @type {Object}
 */
org.apache.flex.binding.BindingBase.prototype.document = null;


/**
 * @export
 * @type {Object}
 */
org.apache.flex.binding.BindingBase.prototype.destination = null;


/**
 * @export
 * @type {string}
 */
org.apache.flex.binding.BindingBase.prototype.destinationPropertyName = '';


/**
 * @export
 * @type {Object}
 */
org.apache.flex.binding.BindingBase.prototype.source = null;


/**
 * @export
 * @type {string}
 */
org.apache.flex.binding.BindingBase.prototype.sourcePropertyName = '';


/**
 * @export
 * @type {?string}
 */
org.apache.flex.binding.BindingBase.prototype.sourceID = null;


/**
 * @export
 * @param {Object} document The MXML object.
 */
org.apache.flex.binding.BindingBase.prototype.setDocument = function(document) {
  this.document = document;
};


/**
 * @param {Object} event The event.
 */
org.apache.flex.binding.BindingBase.prototype.sourceChangeHandler = function(event) {
  if (event.propertyName != this.sourceID)
    return;

  this.source = this.document[this.sourceID];
};


Object.defineProperties(org.apache.flex.binding.BindingBase.prototype, {
  /** @export */
  strand: {
        /** @this {org.apache.flex.binding.BindingBase} */
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
