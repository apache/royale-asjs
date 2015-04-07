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

goog.provide('org_apache_flex_core_ItemRendererClassFactory');

goog.require('mx_core_ClassFactory');
goog.require('org_apache_flex_core_IItemRendererClassFactory');
goog.require('org_apache_flex_core_ValuesManager');



/**
 * @constructor
 * @implements {org_apache_flex_core_IItemRendererClassFactory}
 */
org_apache_flex_core_ItemRendererClassFactory = function() {
  /**
   * @type {Function}
   */
  this.itemRendererClass = null;
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_core_ItemRendererClassFactory.
    prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ItemRendererClassFactory',
                qName: 'org_apache_flex_core_ItemRendererClassFactory'}],
      interfaces: [org_apache_flex_core_IItemRendererClassFactory] };


Object.defineProperties(org_apache_flex_core_ItemRendererClassFactory.prototype, {
    /** @expose */
    strand: {
        /** @this {org_apache_flex_core_ItemRendererClassFactory} */
        set: function(value) {
            this.strand_ = value;

            // see if the _strand has an itemRenderer property that isn't empty. if that's
            // true, use that value instead of pulling it from the the style
            if (this.strand_.hasOwnProperty('itemRenderer')) {
              this.itemRendererClassFactory = this.strand_.itemRenderer;
              if (this.itemRendererClassFactory) {
                this.createFunction = this.createFromClass;
                return;
              }
            }

            if (org_apache_flex_core_ValuesManager.valuesImpl.getValue) {
              this.itemRendererClass =
              /** @type {Function} */ (org_apache_flex_core_ValuesManager.valuesImpl.
                  getValue(this.strand_, 'iItemRenderer'));
              if (this.itemRendererClass) {
                this.itemRendererClassFactory = new mx_core_ClassFactory(this.itemRendererClass);
                this.createFunction = this.createFromClass;
              }
           }
        }
    }
});


/**
 * @expose
 * @param {Object} parent The display parent of the new item renderer.
 * @return {Object} The new item renderer.
 */
org_apache_flex_core_ItemRendererClassFactory.
    prototype.createItemRenderer = function(parent) {
  return this.createFunction(parent);
};


/**
 * @expose
 * @param {Object} parent The parent of the new item renderer.
 * @return {Object} The new item renderer.
 */
org_apache_flex_core_ItemRendererClassFactory.
    prototype.createFromClass = function(parent) {
  var renderer = this.itemRendererClassFactory.newInstance();
  parent.addElement(renderer);
  return renderer;
};
