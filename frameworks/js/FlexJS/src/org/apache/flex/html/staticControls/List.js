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

goog.require('org.apache.flex.core.ListBase');
goog.require('org.apache.flex.core.IItemRenderer');
goog.require('org.apache.flex.html.staticControls.beads.ListView');
goog.require('org.apache.flex.html.staticControls.beads.TextItemRendererFactoryForArrayData');
goog.require('org.apache.flex.html.staticControls.beads.controllers.ListSingleSelectionMouseController');
goog.require('org.apache.flex.html.staticControls.beads.models.ArraySelectionModel');



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
 * @override
 * @this {org.apache.flex.html.staticControls.List}
 */
org.apache.flex.html.staticControls.List.prototype.createElement =
    function() {
  goog.base(this, 'createElement');
  this.set_className('List');
};

/**
 * @override
 * @this {org.apache.flex.html.staticControls.List}
 */
org.apache.flex.html.staticControls.List.prototype.addedToParent =
function() {
  goog.base(this,'addedToParent');
  
  var c = this.getBeadByType(org.apache.flex.core.IItemRenderer);
  if (c == null) {
    this.addBead(new
                 org.apache.flex.html.staticControls.beads.
                 TextItemRendererFactoryForArrayData());
  }
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.List}
 * Returns an array of objects that make up the actual list (most likely
 * itemRenderers).
 */
org.apache.flex.html.staticControls.List.prototype.internalChildren =
function() {
  var listView = this.getBeadByType(org.apache.flex.html.staticControls.beads.ListView);
  var dg = listView.get_dataGroup();
  var items = dg.renderers;
  return items;
}

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.List}
 * @param {object} event The event that triggered the selection.
 */
org.apache.flex.html.staticControls.List.prototype.selectedHandler =
function(event) {
   var itemRenderer = event.currentTarget;
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
};
