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

goog.provide('org.apache.flex.html.staticControls.List');

goog.require('org.apache.flex.core.IDataProviderItemRendererMapper');
goog.require('org.apache.flex.core.IItemRendererClassFactory');
goog.require('org.apache.flex.core.ItemRendererClassFactory');
goog.require('org.apache.flex.core.ListBase');
goog.require('org.apache.flex.core.ValuesManager');
goog.require('org.apache.flex.html.staticControls.beads.ListView');
goog.require('org.apache.flex.html.staticControls.beads.TextItemRendererFactoryForArrayData');
goog.require('org.apache.flex.html.staticControls.beads.controllers.ListSingleSelectionMouseController');
goog.require('org.apache.flex.html.staticControls.beads.models.ArraySelectionModel');
goog.require('org.apache.flex.html.staticControls.supportClasses.DataItemRenderer');



/**
 * @constructor
 * @extends {org.apache.flex.core.ListBase}
 */
org.apache.flex.html.staticControls.List = function() {
  goog.base(this);
};
goog.inherits(org.apache.flex.html.staticControls.List,
    org.apache.flex.core.ListBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.staticControls.List.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'List',
                qName: 'org.apache.flex.html.staticControls.List' }] };


/**
 * @override
 */
org.apache.flex.html.staticControls.List.prototype.createElement =
    function() {
  goog.base(this, 'createElement');
  this.set_className('List');

  return this.element;
};


/**
 * @override
 */
org.apache.flex.html.staticControls.List.prototype.addedToParent =
    function() {
  goog.base(this, 'addedToParent');

  var c = this.getBeadByType(org.apache.flex.core.IDataProviderItemRendererMapper);
  if (org.apache.flex.core.ValuesManager.valuesImpl.getValue && !c) {
    c = org.apache.flex.core.ValuesManager.valuesImpl.getValue(this,
                            'iDataProviderItemRendererMapper');
    if (c) {
      var bead = new c;
      this.addBead(bead);
    }
  }
//  var c = this.getBeadByType(org.apache.flex.core.IItemRenderer);
//  if (c == null) {
//    c = this.getBeadByType(
//          org.apache.flex.html.staticControls.supportClasses.DataItemRenderer);
//    if (c == null) {
//      this.addBead(new
//                   org.apache.flex.html.staticControls.beads.
//                   TextItemRendererFactoryForArrayData());
//    }
//  }
};


/**
 * @expose
 * @return {Array.<Object>} An array of objects that make up the actual
 *                          list (most likely itemRenderers).
 */
org.apache.flex.html.staticControls.List.prototype.internalChildren =
    function() {
  var listView =
      this.getBeadByType(org.apache.flex.html.staticControls.beads.ListView);
  var dg = listView.get_dataGroup();
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
org.apache.flex.html.staticControls.List.prototype.selectedHandler =
    function(event) {
  var itemRenderer = event.currentTarget;
  if (this.renderers) {
    var n = this.renderers.length;
    var i;
    for (i = 0; i < n; i++) {
      var test = this.renderers[i];
      if (test == itemRenderer) {
        this.model.set_selectedIndex(i);
        itemRenderer.set_selected(true);
      }
      else {
        test.set_selected(false);
      }
    }
  }
};
