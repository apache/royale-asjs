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

goog.provide('org.apache.flex.html.DropDownList');

goog.require('org.apache.flex.core.ListBase');
goog.require('org.apache.flex.html.beads.models.ArraySelectionModel');



/**
 * @constructor
 * @extends {org.apache.flex.core.ListBase}
 */
org.apache.flex.html.DropDownList = function() {
  org.apache.flex.html.DropDownList.base(this, 'constructor');
  this.model = new org.apache.flex.html.beads.models.ArraySelectionModel();
};
goog.inherits(org.apache.flex.html.DropDownList,
    org.apache.flex.core.ListBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.DropDownList.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'DropDownList',
                qName: 'org.apache.flex.html.DropDownList'}] };


/**
 * @override
 */
org.apache.flex.html.DropDownList.prototype.
    createElement = function() {
  this.element = document.createElement('select');
  this.element.size = 1;
  goog.events.listen(this.element, 'change',
      goog.bind(this.changeHandler, this));
  this.positioner = this.element;

  this.element.flexjs_wrapper = this;

  return this.element;
};


Object.defineProperties(org.apache.flex.html.DropDownList.prototype, {
    /** @export */
    dataProvider: {
        /** @this {org.apache.flex.html.DropDownList} */
        set: function(value) {
            var dp, i, n, opt;

            this.model.dataProvider = value;

            dp = this.element.options;
            n = dp.length;
            for (i = 0; i < n; i++) {
              dp.remove(0);
            }

            n = value.length;
            for (i = 0; i < n; i++) {
              opt = document.createElement('option');
              opt.text = value[i];
              dp.add(opt);
            }
        }
    },
    /** @export */
    selectedIndex: {
        // TODO: (aharui) copied from ListBase because you
        // can't just override the setter in a defineProps
        // structure.
        /** @this {org.apache.flex.html.DropDownList} */
        get: function() {
            return this.model.selectedIndex;
        },
        /** @this {org.apache.flex.html.DropDownList} */
        set: function(value) {
            this.model.selectedIndex = value;
            this.element.selectedIndex = value;
        }
    },
    /** @export */
    selectedItem: {
        // TODO: (aharui) copied from ListBase because you
        // can't just override the setter in a defineProps
        // structure.
        /** @this {org.apache.flex.html.DropDownList} */
        get: function() {
            return this.model.selectedItem;
        },
        /** @this {org.apache.flex.html.DropDownList} */
        set: function(value) {
            this.model.selectedItem = value;
            this.element.selectedIndex = this.selectedIndex;
        }
    }
});


/**
 * @protected
 */
org.apache.flex.html.DropDownList.prototype.changeHandler =
    function() {
  this.model.selectedIndex = this.element.selectedIndex;
  this.dispatchEvent('change');
};
