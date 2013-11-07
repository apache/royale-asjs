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
 * @type {string}
 */
org.apache.flex.binding.BindingBase.prototype.sourceID;


/**
 * @this {org.apache.flex.binding.BindingBase}
 * @param {Object} value The strand (owner) of the bead.
 */
org.apache.flex.binding.BindingBase.prototype.set_strand = function(value) {
  this.destination = value;

  if (this.sourceID != null)
  {
    try {
      this.source = this.document['get_' + this.sourceID]();
    } catch (e) {
      this.source = this.document[this.sourceID];
    }
  }
  else
    this.source = this.document;
};


/**
 * @this {org.apache.flex.binding.BindingBase}
 * @param {Object} document The MXML object.
 */
org.apache.flex.binding.BindingBase.prototype.setDocument = function(document) {
  this.document = document;
};
