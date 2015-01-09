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
 * @expose
 * @type {Object}
 */
org.apache.flex.binding.BindingBase.prototype.destination = null;


/**
 * @expose
 * @type {string}
 */
org.apache.flex.binding.BindingBase.prototype.destinationPropertyName = '';


/**
 * @expose
 * @type {Object}
 */
org.apache.flex.binding.BindingBase.prototype.source = null;


/**
 * @expose
 * @type {string}
 */
org.apache.flex.binding.BindingBase.prototype.sourcePropertyName = '';


/**
 * @expose
 * @type {?string}
 */
org.apache.flex.binding.BindingBase.prototype.sourceID = null;


/**
 * @expose
 * @param {Object} value The strand (owner) of the bead.
 */
org.apache.flex.binding.BindingBase.prototype.set_strand = function(value) {
  if (this.destination == null)
    this.destination = value;
  if (this.sourceID != null) {
    if (typeof(this.document['get_' + this.sourceID]) === 'function')
      this.source = this.document['get_' + this.sourceID]();
    else
      this.source = this.document[this.sourceID];
    if (this.source == null) {
      this.document.addEventListener('valueChange',
          goog.bind(this.sourceChangeHandler, this));
        return;
    }
  }
  else
    this.source = this.document;
};


/**
 * @expose
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

  if (this.source)
    this.source.removeEventListener(this.eventName,
        goog.bind(this.changeHandler, this));

  if (typeof(this.document['get_' + this.sourceID]) === 'function')
    this.source = this.document['get_' + this.sourceID]();
  else
    this.source = this.document[this.sourceID];
};
