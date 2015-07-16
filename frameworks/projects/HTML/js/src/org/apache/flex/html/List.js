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

goog.provide('org.apache.flex.html.List');

goog.require('org.apache.flex.core.IDataProviderItemRendererMapper');
goog.require('org.apache.flex.core.IFactory');
goog.require('org.apache.flex.core.IItemRendererClassFactory');
goog.require('org.apache.flex.core.IListPresentationModel');
goog.require('org.apache.flex.core.ItemRendererClassFactory');
goog.require('org.apache.flex.core.ListBase');
goog.require('org.apache.flex.core.ValuesManager');
goog.require('org.apache.flex.html.beads.ListView');
goog.require('org.apache.flex.html.beads.TextItemRendererFactoryForArrayData');
goog.require('org.apache.flex.html.beads.controllers.ListSingleSelectionMouseController');
goog.require('org.apache.flex.html.beads.models.ArraySelectionModel');
goog.require('org.apache.flex.html.beads.models.ListPresentationModel');
goog.require('org.apache.flex.html.supportClasses.DataItemRenderer');



/**
 * @constructor
 * @extends {org.apache.flex.core.ListBase}
 */
org.apache.flex.html.List = function() {
  org.apache.flex.html.List.base(this, 'constructor');
};
goog.inherits(org.apache.flex.html.List,
    org.apache.flex.core.ListBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.List.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'List',
                qName: 'org.apache.flex.html.List' }] };


Object.defineProperties(org.apache.flex.html.List.prototype, {
    /** @export */
    itemRenderer: {
        /** @this {org.apache.flex.html.List} */
        get: function() {
            return this.itemRenderer_;
        },
        /** @this {org.apache.flex.html.List} */
        set: function(value) {
            this.itemRenderer_ = value;
        }
    },
    /** @export */
    labelField: {
        /** @this {org.apache.flex.html.List} */
        get: function() {
            return this.model.labelField;
        },
        /** @this {org.apache.flex.html.List} */
        set: function(value) {
            this.model.labelField = value;
        }
    },
    /** @export */
    rowHeight: {
        /** @this {org.apache.flex.html.List} */
        get: function() {
            return this.presentationModel.rowHeight;
        },
        /** @this {org.apache.flex.html.List} */
        set: function(value) {
            this.presentationModel.rowHeight = value;
        }
    },
    /** @export */
    presentationModel: {
        /** @this {org.apache.flex.html.List} */
        get: function() {
            var presModel = this.getBeadByType(org.apache.flex.core.IListPresentationModel);
            if (presModel == null) {
              presModel = new org.apache.flex.html.beads.models.ListPresentationModel();
              this.addBead(presModel);
            }
            return presModel;
        }
    }
});


/**
 * @override
 */
org.apache.flex.html.List.prototype.createElement =
    function() {
  org.apache.flex.html.List.base(this, 'createElement');
  this.className = 'List';

  return this.element;
};


/**
 * @override
 */
org.apache.flex.html.List.prototype.addedToParent =
    function() {
  org.apache.flex.html.List.base(this, 'addedToParent');

  var dataFactory = this.getBeadByType(org.apache.flex.html.beads.DataItemRendererFactoryForArrayData);
  if (dataFactory == null) {
    var m1 = org.apache.flex.core.ValuesManager.valuesImpl.getValue(this, 'iDataProviderItemRendererMapper');
    dataFactory = new m1();
    this.addBead(dataFactory);
  }

  var itemRendererFactory = this.getBeadByType(org.apache.flex.core.IItemRendererClassFactory);
  if (itemRendererFactory == null) {
    var m2 = org.apache.flex.core.ValuesManager.valuesImpl.getValue(this, 'iItemRendererClassFactory');
    itemRendererFactory = new m2();
    this.addBead(itemRendererFactory);
  }
};


/**
 * @export
 * @return {Array.<Object>} An array of objects that make up the actual
 *                          list (most likely itemRenderers).
 */
org.apache.flex.html.List.prototype.internalChildren =
    function() {
  var listView =
      this.getBeadByType(org.apache.flex.html.beads.ListView);
  var dg = listView.dataGroup;
  var items = null;
  if (dg.renderers) {
    items = dg.renderers;
  }
  return items;
};


/**
 * @export
 * @param {Object} event The event that triggered the selection.
 */
org.apache.flex.html.List.prototype.selectedHandler =
    function(event) {
  var itemRenderer = event.currentTarget;
  if (this.renderers) {
    var n = this.renderers.length;
    var i;
    for (i = 0; i < n; i++) {
      var test = this.renderers[i];
      if (test == itemRenderer) {
        this.model.selectedIndex = i;
        itemRenderer.selected = true;
      }
      else {
        test.selected = false;
      }
    }
  }
};
