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
goog.require('org.apache.flex.html.beads.IListView');
goog.require('org.apache.flex.html.beads.TextItemRendererFactoryForArrayData');
goog.require('org.apache.flex.html.beads.models.ArraySelectionModel');
goog.require('org.apache.flex.html.supportClasses.NonVirtualDataGroup');



/**
 * @constructor
 * @implements {org.apache.flex.core.ILayoutParent}
 * @implements {org.apache.flex.html.beads.IListView}
 */
org.apache.flex.html.beads.ListView = function() {
  this.lastSelectedIndex = -1;

  this.className = 'ListView';
};


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
 * @expose
 * @param {Object} value The new host.
 */
org.apache.flex.html.beads.ListView.prototype.set_strand =
    function(value) {

  this.strand_ = value;

  this.strand_.addEventListener('sizeChanged',
      goog.bind(this.handleSizeChange, this));
  this.strand_.addEventListener('widthChanged',
      goog.bind(this.handleSizeChange, this));
  this.strand_.addEventListener('heightChanged',
      goog.bind(this.handleSizeChange, this));

  this.model = this.strand_.get_model();
  this.model.addEventListener('selectedIndexChanged',
      goog.bind(this.selectionChangeHandler, this));
  this.model.addEventListener('dataProviderChanged',
      goog.bind(this.dataProviderChangeHandler, this));

  if (this.dataGroup_ == null) {
    var m2 = org.apache.flex.core.ValuesManager.valuesImpl.
        getValue(this.strand_, 'iDataGroup');
    this.dataGroup_ = new m2();
  }
  this.dataGroup_.set_strand(this);
  this.strand_.addElement(this.dataGroup_);

  if (this.strand_.getBeadByType(org.apache.flex.core.IBeadLayout) == null) {
    var m3 = org.apache.flex.core.ValuesManager.valuesImpl.getValue(this.strand_, 'iBeadLayout');
    this.layout_ = new m3();
    this.strand_.addBead(this.layout_);
    //this.layout_.set_strand(this.strand_);
  }

  this.handleSizeChange(null);
};


/**
 * @expose
 * @return {Object} The DataGroup instance.
 */
org.apache.flex.html.beads.ListView.prototype.get_dataGroup =
    function() {
  return this.dataGroup_;
};


/**
 * @expose
 * @param {Object} value The DataGroup instance.
 */
org.apache.flex.html.beads.ListView.prototype.set_dataGroup =
    function(value) {
  this.dataGroup_ = value;
};


/**
 * @expose
 * @param {Object} value The event that triggered the selection.
 */
org.apache.flex.html.beads.ListView.prototype.
    selectionChangeHandler = function(value) {
  var ir;
  if (this.lastSelectedIndex != -1) {
    ir = this.dataGroup_.getItemRendererForIndex(this.lastSelectedIndex);
    if (ir) ir.set_selected(false);
  }
  if (this.model.get_selectedIndex() != -1) {
    ir = this.dataGroup_.getItemRendererForIndex(
        this.model.get_selectedIndex());
    if (ir) ir.set_selected(true);
  }
  this.lastSelectedIndex = this.model.get_selectedIndex();
};


/**
 * @expose
 * @param {Object} value The event that triggeed the selection.
 */
org.apache.flex.html.beads.ListView.prototype.
    dataProviderChangeHandler = function(value) {
    // override in subclass
};


/**
 * @expose
 * @return {Object} The view that contains the layout objects.
 */
org.apache.flex.html.beads.ListView.prototype.get_contentView = function() {
  return this.dataGroup_;
};


/**
 * @expose
 * @return {Object} The border for the layout area.
 */
org.apache.flex.html.beads.ListView.prototype.get_border = function() {
  return null;
};


/**
 * @expose
 * @return {Object} The vertical scrollbar.
 */
org.apache.flex.html.beads.ListView.prototype.get_vScrollBar = function() {
  return null;
};


/**
 * @expose
 * @param {Object} value The vertical scrollbar.
 */
org.apache.flex.html.beads.ListView.prototype.set_vScrollBar = function(value) {
};


/**
 * @expose
 * @return {Object} The view that can be resized.
 */
org.apache.flex.html.beads.ListView.prototype.get_resizeableView = function() {
  return this;
};


/**
 * @expose
 * @param {Object} event The event that triggered the resize.
 */
org.apache.flex.html.beads.ListView.prototype.handleSizeChange = function(event) {
  this.dataGroup_.set_width(this.strand_.get_width());
  this.dataGroup_.set_height(this.strand_.get_height());
};
