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

goog.provide('org.apache.flex.html.beads.ListView');

goog.require('org.apache.flex.core.IBeadLayout');
goog.require('org.apache.flex.core.IBeadView');
goog.require('org.apache.flex.core.IItemRendererParent');
goog.require('org.apache.flex.core.ILayoutParent');
goog.require('org.apache.flex.core.ValuesManager');
goog.require('org.apache.flex.html.beads.ContainerView');
goog.require('org.apache.flex.html.beads.IListView');
goog.require('org.apache.flex.html.beads.TextItemRendererFactoryForArrayData');
goog.require('org.apache.flex.html.beads.models.ArraySelectionModel');
goog.require('org.apache.flex.html.supportClasses.DataGroup');



/**
 * @constructor
 * @extends {org.apache.flex.html.beads.ContainerView}
 * @implements {org.apache.flex.core.ILayoutParent}
 * @implements {org.apache.flex.html.beads.IListView}
 */
org.apache.flex.html.beads.ListView = function() {
  this.lastSelectedIndex = -1;

  this.className = 'ListView';
  org.apache.flex.html.beads.ListView.base(this, 'constructor');
};
goog.inherits(
    org.apache.flex.html.beads.ListView,
    org.apache.flex.html.beads.ContainerView);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.beads.ListView.prototype.
    FLEXJS_CLASS_INFO =
    { names: [{ name: 'ListView',
                qName: 'org.apache.flex.html.beads.ListView' }],
      interfaces: [org.apache.flex.html.beads.IListView, org.apache.flex.core.ILayoutParent] };


/**
 * @override
 */
org.apache.flex.html.beads.ListView.
    prototype.completeSetup = function() {
  org.apache.flex.html.beads.ListView.base(this, 'completeSetup');
  this._strand.addEventListener('itemsCreated',
  goog.bind(this.changeHandler, this));
};


Object.defineProperties(org.apache.flex.html.beads.ListView.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.html.beads.ListView} */
        set: function(value) {
            org.apache.flex.utils.Language.superSetter(
                org.apache.flex.html.beads.ListView, this, 'strand', value);

            this.model = this._strand.model;
            this.model.addEventListener('selectedIndexChanged',
                goog.bind(this.selectionChangeHandler, this));
            this.model.addEventListener('dataProviderChanged',
                goog.bind(this.dataProviderChangeHandler, this));

            this.dataGroup.strand = this;

            /*if (this._strand.getBeadByType(org.apache.flex.core.IBeadLayout) == null) {
              var m3 = org.apache.flex.core.ValuesManager.valuesImpl.getValue(this._strand, 'iBeadLayout');
              this.layout_ = new m3();
              this._strand.addBead(this.layout_);
             }*/
        },
        /** @this {org.apache.flex.html.beads.ListView} */
        get: function() {
            return this._strand;
        }
    },
    /** @export */
    dataGroup: {
        /** @this {org.apache.flex.html.beads.ListView} */
        get: function() {
            return this.contentView;
        }
    },
    /** @export */
    border: {
        /** @this {org.apache.flex.html.beads.ListView} */
        get: function() {
            return null;
        }
    },
    /** @export */
    vScrollBar: {
        /** @this {org.apache.flex.html.beads.ListView} */
        get: function() {
            return null;
        },
        /** @this {org.apache.flex.html.beads.ListView} */
        set: function(value) {
        }
    },
    /** @export */
    resizeableView: {
        /** @this {org.apache.flex.html.beads.ListView} */
        get: function() {
            return this;
        }
    }
});


/**
 * @export
 * @param {org.apache.flex.events.Event} value The event that triggered the selection.
 */
org.apache.flex.html.beads.ListView.prototype.
    selectionChangeHandler = function(value) {
  var ir;
  if (this.lastSelectedIndex != -1) {
    ir = this.dataGroup.getItemRendererForIndex(this.lastSelectedIndex);
    if (ir) ir.selected = false;
  }
  if (this.model.selectedIndex != -1) {
    ir = this.dataGroup.getItemRendererForIndex(
        this.model.selectedIndex);
    if (ir) ir.selected = true;
  }
  this.lastSelectedIndex = this.model.selectedIndex;
};


/**
 * @export
 * @param {org.apache.flex.events.Event} value The event that triggered the selection.
 */
org.apache.flex.html.beads.ListView.prototype.
    dataProviderChangeHandler = function(value) {
    // override in subclass
    this.changeHandler(value);
};


/**
 * @export
 * @param {org.apache.flex.events.Event} event The event that triggered the resize.
 */
org.apache.flex.html.beads.ListView.prototype.handleSizeChange = function(event) {
  this.dataGroup.width = this._strand.width;
  this.dataGroup.height = this._strand.height;
};
