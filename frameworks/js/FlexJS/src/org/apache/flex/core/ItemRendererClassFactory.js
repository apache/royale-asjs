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

goog.require('mx.core.ClassFactory');
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
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.ItemRendererClassFactory.
    prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ItemRendererClassFactory',
                qName: 'org.apache.flex.core.ItemRendererClassFactory'}],
      interfaces: [org.apache.flex.core.IItemRendererClassFactory] };


/**
 * @expose
 * @param {Object} value The component strand.
 */
org.apache.flex.core.ItemRendererClassFactory.
    prototype.set_strand = function(value) {
  this.strand_ = value;

  // see if the _strand has an itemRenderer property that isn't empty. if that's
  // true, use that value instead of pulling it from the the style
  if (this.strand_.hasOwnProperty('itemRenderer')) {
    this.itemRendererClassFactory = this.strand_['itemRenderer'];
    if (this.itemRendererClassFactory) {
        this.createFunction = this.createFromClass;
        return;
    }
  }

  if (org.apache.flex.core.ValuesManager.valuesImpl.getValue) {
    this.itemRendererClass = org.apache.flex.core.ValuesManager.valuesImpl.
        getValue(this.strand_, 'iItemRenderer');
    if (this.itemRendererClass) {
      this.itemRendererClassFactory = new mx.core.ClassFactory(this.itemRendererClass);
      this.createFunction = this.createFromClass;
    }
  }
};


/**
 * @expose
 * @param {Object} parent The display parent of the new item renderer.
 * @return {Object} The new item renderer.
 */
org.apache.flex.core.ItemRendererClassFactory.
    prototype.createItemRenderer = function(parent) {
  return this.createFunction(parent);
};


/**
 * @expose
 * @param {Object} parent The parent of the new item renderer.
 * @return {Object} The new item renderer.
 */
org.apache.flex.core.ItemRendererClassFactory.
    prototype.createFromClass = function(parent) {
  var renderer = this.itemRendererClassFactory.newInstance();
  parent.addElement(renderer);
  return renderer;
};
