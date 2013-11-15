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

goog.provide('org.apache.flex.html.staticControls.beads.ListView');

goog.require('org.apache.flex.core.IBeadLayout');
goog.require('org.apache.flex.core.IBeadView');
goog.require('org.apache.flex.core.IItemRendererParent');
goog.require('org.apache.flex.core.ValuesManager');
goog.require('org.apache.flex.html.staticControls.beads.TextItemRendererFactoryForArrayData');
goog.require('org.apache.flex.html.staticControls.beads.models.ArraySelectionModel');
goog.require('org.apache.flex.html.staticControls.supportClasses.NonVirtualDataGroup');



/**
 * @constructor
 * @implements {org.apache.flex.core.IBeadView}
 */
org.apache.flex.html.staticControls.beads.ListView = function() {
  this.lastSelectedIndex = -1;

  this.className = 'ListView';
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.staticControls.beads.ListView.prototype.
    FLEXJS_CLASS_INFO =
    { names: [{ name: 'ListView',
                qName: 'org.apache.flex.html.staticControls.beads.ListView' }],
      interfaces: [org.apache.flex.core.IBeadView] };


/**
 * @expose
 * @param {Object} value The new host.
 */
org.apache.flex.html.staticControls.beads.ListView.prototype.set_strand =
    function(value) {

  this.strand_ = value;

  /*if (this.strand_.getBeadByType(org.apache.flex.core.IBeadLayout) == null) {
    var m = org.apache.flex.core.ValuesManager.valuesImpl.
        getValue(this.strand_,'iBeadLayout');
    var c = new m();
    this.strand_.addBead(c);
  }*/

  this.model = this.strand_.get_model();
  this.model.addEventListener('selectedIndexChanged',
      goog.bind(this.selectionChangeHandler, this));

  this.dataGroup_ = new
      org.apache.flex.html.staticControls.supportClasses.NonVirtualDataGroup();
  this.dataGroup_.set_strand(this);
  this.strand_.addElement(this.dataGroup_);
};


/**
 * @expose
 * @return {Object} The DataGroup instance.
 */
org.apache.flex.html.staticControls.beads.ListView.prototype.get_dataGroup =
    function() {
  return this.dataGroup_;
};


/**
 * @expose
 * @param {Object} value The event that triggered the selection.
 */
org.apache.flex.html.staticControls.beads.ListView.prototype.
    selectionChangeHandler = function(value) {
  if (this.lastSelectedIndex != -1) {
    var ir = this.dataGroup_.getItemRendererForIndex(this.lastSelectedIndex);
    if (ir) ir.set_selected(false);
  }
  if (this.model.get_selectedIndex() != -1) {
    ir = this.dataGroup_.getItemRendererForIndex(
        this.model.get_selectedIndex());
    if (ir) ir.set_selected(true);
  }
  this.lastSelectedIndex = this.model.get_selectedIndex();
};
