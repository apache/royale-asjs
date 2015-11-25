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

goog.provide('org.apache.flex.html.beads.models.ArraySelectionModel');

goog.require('org.apache.flex.core.ISelectionModel');
goog.require('org.apache.flex.events.EventDispatcher');



/**
 * @constructor
 * @extends {org.apache.flex.events.EventDispatcher}
 * @implements {org.apache.flex.core.ISelectionModel}
 */
org.apache.flex.html.beads.models.ArraySelectionModel =
    function() {
  org.apache.flex.html.beads.models.ArraySelectionModel.base(this, 'constructor');
  this.className = 'ArraySelectionModel';
};
goog.inherits(
    org.apache.flex.html.beads.models.ArraySelectionModel,
    org.apache.flex.events.EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.beads.models.ArraySelectionModel.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ArraySelectionModel',
                qName: 'org.apache.flex.html.beads.models.ArraySelectionModel' }],
      interfaces: [org.apache.flex.core.ISelectionModel] };


Object.defineProperties(org.apache.flex.html.beads.models.ArraySelectionModel.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.html.beads.models.ArraySelectionModel} */
        set: function(value) {
            this.strand_ = value;
        }
    },
    /** @export */
    dataProvider: {
        /** @this {org.apache.flex.html.beads.models.ArraySelectionModel} */
        get: function() {
            return this.dataProvider_;
        },
        /** @this {org.apache.flex.html.beads.models.ArraySelectionModel} */
        set: function(value) {
            if (value === this.dataProvider_) return;
            this.dataProvider_ = value;
            this.dispatchEvent('dataProviderChanged');
        }
    },
    /** @export */
    selectedIndex: {
        /** @this {org.apache.flex.html.beads.models.ArraySelectionModel} */
        get: function() {
            return this.selectedIndex_;
        },
        /** @this {org.apache.flex.html.beads.models.ArraySelectionModel} */
        set: function(value) {
            if (value === this.selectedIndex_) return;
            this.selectedIndex_ = value;
            this.dispatchEvent('selectedIndexChanged');
        }
    },
    /** @export */
    selectedItem: {
        /** @this {org.apache.flex.html.beads.models.ArraySelectionModel} */
        get: function() {
            var si;

            si = this.selectedIndex_;

            if (!this.dataProvider_ || si < 0 ||
                si >= this.dataProvider_.length) {
              return null;
            }

            return this.dataProvider_[si];
        },
        /** @this {org.apache.flex.html.beads.models.ArraySelectionModel} */
        set: function(value) {
            // find item in dataProvider and set selectedIndex or -1 if not exists

            this.selectedIndex_ = -1;
            var n = this.dataProvider_.length;
            for (var i = 0; i < n; i++) {
              var item = this.dataProvider_[i];
              if (item == value) {
                this.selectedIndex_ = i;
                break;
              }
            }

            this.dispatchEvent('selectedItemChanged');
            this.dispatchEvent('selectedIndexChanged');
        }
    },
    /** @export */
    labelField: {
        /** @this {org.apache.flex.html.beads.models.ArraySelectionModel} */
        get: function() {
            return this.labelField_;
        },
        /** @this {org.apache.flex.html.beads.models.ArraySelectionModel} */
        set: function(value) {
            this.labelField_ = value;
            this.dispatchEvent('labelFieldChanged');
        }
    }
});
