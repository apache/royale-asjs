/**
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

goog.provide('org.apache.flex.core.ItemRendererClassFactory');

goog.require('org.apache.flex.core.IItemRendererClassFactory');
goog.require('org.apache.flex.core.ValuesManager');



/**
 * @constructor
 * @implements {org.apache.flex.core.IItemRendererClassFactory}
 */
org.apache.flex.core.ItemRendererClassFactory = function() {
  this.itemRendererClass = null;
};


/**
 * @expose
 * @param {object} value The component strand.
 */
org.apache.flex.core.ItemRendererClassFactory.
    prototype.set_strand = function(value) {
  this.strand_ = value;

  this.itemRendererClass = org.apache.flex.core.ValuesManager.valuesImpl.
      getValue(this.strand_, 'iItemRenderer');
  if (this.itemRendererClass) {
    this.createFunction = this.createFromClass;
  }
};


/**
 * @expose
 * @param {object} parent The display parent of the new item renderer.
 * @return {object} The new item renderer.
 */
org.apache.flex.core.ItemRendererClassFactory.
    prototype.createItemRenderer = function(parent) {
  return this.createFunction(parent);
};


/**
 * @expose
 * @param {object} parent The parent of the new item renderer.
 * @return {object} The new item renderer.
 */
org.apache.flex.core.ItemRendererClassFactory.
    prototype.createFromClass = function(parent) {
  var renderer = new this.itemRendererClass();
  parent.addElement(renderer);
  return renderer;
};


/**
 * @const
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.ItemRendererClassFactory.
    prototype.FLEXJS_CLASS_INFO =
    { interfaces: [org.apache.flex.core.IItemRendererClassFactory] };
