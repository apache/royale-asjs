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

goog.provide('org_apache_flex_html_List');

goog.require('mx_core_IFactory');
goog.require('org_apache_flex_core_IDataProviderItemRendererMapper');
goog.require('org_apache_flex_core_IItemRendererClassFactory');
goog.require('org_apache_flex_core_IListPresentationModel');
goog.require('org_apache_flex_core_ItemRendererClassFactory');
goog.require('org_apache_flex_core_ListBase');
goog.require('org_apache_flex_core_ValuesManager');
goog.require('org_apache_flex_html_beads_ListView');
goog.require('org_apache_flex_html_beads_TextItemRendererFactoryForArrayData');
goog.require('org_apache_flex_html_beads_controllers_ListSingleSelectionMouseController');
goog.require('org_apache_flex_html_beads_models_ArraySelectionModel');
goog.require('org_apache_flex_html_beads_models_ListPresentationModel');
goog.require('org_apache_flex_html_supportClasses_DataItemRenderer');



/**
 * @constructor
 * @extends {org_apache_flex_core_ListBase}
 */
org_apache_flex_html_List = function() {
  org_apache_flex_html_List.base(this, 'constructor');
};
goog.inherits(org_apache_flex_html_List,
    org_apache_flex_core_ListBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_List.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'List',
                qName: 'org_apache_flex_html_List' }] };


Object.defineProperties(org_apache_flex_html_List.prototype, {
    /** @expose */
    itemRenderer: {
        /** @this {org_apache_flex_html_List} */
        get: function() {
            return this.itemRenderer_;
        },
        /** @this {org_apache_flex_html_List} */
        set: function(value) {
            this.itemRenderer_ = value;
        }
    },
    /** @expose */
    labelField: {
        /** @this {org_apache_flex_html_List} */
        get: function() {
            return this.model.labelField;
        },
        /** @this {org_apache_flex_html_List} */
        set: function(value) {
            this.model.labelField = value;
        }
    },
    /** @expose */
    rowHeight: {
        /** @this {org_apache_flex_html_List} */
        get: function() {
            return this.presentationModel.rowHeight;
        },
        /** @this {org_apache_flex_html_List} */
        set: function(value) {
            this.presentationModel.rowHeight = value;
        }
    },
    /** @expose */
    presentationModel: {
        /** @this {org_apache_flex_html_List} */
        get: function() {
            var presModel = this.getBeadByType(org_apache_flex_core_IListPresentationModel);
            if (presModel == null) {
              presModel = new org_apache_flex_html_beads_models_ListPresentationModel();
              this.addBead(presModel);
            }
            return presModel;
        }
    }
});


/**
 * @override
 */
org_apache_flex_html_List.prototype.createElement =
    function() {
  org_apache_flex_html_List.base(this, 'createElement');
  this.className = 'List';

  return this.element;
};


/**
 * @override
 */
org_apache_flex_html_List.prototype.addedToParent =
    function() {
  org_apache_flex_html_List.base(this, 'addedToParent');

  var dataFactory = this.getBeadByType(org_apache_flex_html_beads_DataItemRendererFactoryForArrayData);
  if (dataFactory == null) {
    var m1 = org_apache_flex_core_ValuesManager.valuesImpl.getValue(this, 'iDataProviderItemRendererMapper');
    dataFactory = new m1();
    this.addBead(dataFactory);
  }

  var itemRendererFactory = this.getBeadByType(org_apache_flex_core_IItemRendererClassFactory);
  if (itemRendererFactory == null) {
    var m2 = org_apache_flex_core_ValuesManager.valuesImpl.getValue(this, 'iItemRendererClassFactory');
    itemRendererFactory = new m2();
    this.addBead(itemRendererFactory);
  }
};


/**
 * @expose
 * @return {Array.<Object>} An array of objects that make up the actual
 *                          list (most likely itemRenderers).
 */
org_apache_flex_html_List.prototype.internalChildren =
    function() {
  var listView =
      this.getBeadByType(org_apache_flex_html_beads_ListView);
  var dg = listView.dataGroup;
  var items = null;
  if (dg.renderers) {
    items = dg.renderers;
  }
  return items;
};


/**
 * @expose
 * @param {Object} event The event that triggered the selection.
 */
org_apache_flex_html_List.prototype.selectedHandler =
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
