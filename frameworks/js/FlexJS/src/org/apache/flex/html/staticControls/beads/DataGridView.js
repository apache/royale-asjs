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

goog.provide('org.apache.flex.html.staticControls.beads.DataGridView');

goog.require('org.apache.flex.core.IBeadView');
goog.require('org.apache.flex.core.IItemRendererParent');
goog.require('org.apache.flex.events.Event');
goog.require('org.apache.flex.html.staticControls.ButtonBar');
goog.require('org.apache.flex.html.staticControls.Container');
goog.require('org.apache.flex.html.staticControls.SimpleList');
goog.require('org.apache.flex.html.staticControls.beads.DataGridColumnView');
goog.require('org.apache.flex.html.staticControls.beads.DataItemRendererFactoryForColumnData');
goog.require('org.apache.flex.html.staticControls.beads.TextItemRendererFactoryForArrayData');
goog.require('org.apache.flex.html.staticControls.beads.layouts.NonVirtualHorizontalLayout');
goog.require('org.apache.flex.html.staticControls.beads.models.ArraySelectionModel');
goog.require('org.apache.flex.html.staticControls.beads.models.DataGridModel');
goog.require('org.apache.flex.html.staticControls.beads.models.DataGridPresentationModel');



/**
 * @constructor
 * @extends {org.apache.flex.events.EventDispatcher}
 * @implements {org.apache.flex.core.IBeadView}
 */
org.apache.flex.html.staticControls.beads.DataGridView = function() {
  this.lastSelectedIndex = -1;
  goog.base(this);
};
goog.inherits(
    org.apache.flex.html.staticControls.beads.DataGridView,
    org.apache.flex.events.EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.staticControls.beads.DataGridView.prototype.
    FLEXJS_CLASS_INFO =
    { names: [{ name: 'DataGridView',
                qName: 'org.apache.flex.html.staticControls.beads.DataGridView' }],
      interfaces: [org.apache.flex.core.IBeadView] };


/**
 * @expose
 * @param {Object} value The new host.
 */
org.apache.flex.html.staticControls.beads.DataGridView.prototype.set_strand =
    function(value) {

  this.strand_ = value;

  // Use the presentation model's columnLabels as the dataProvider for the
  // ButtonBar header.
  var pm = value.getBeadByType(org.apache.flex.html.staticControls.
      beads.models.DataGridPresentationModel);
  this.buttonBarModel = new
      org.apache.flex.html.staticControls.beads.models.ArraySelectionModel();
  this.buttonBarModel.set_dataProvider(pm.get_columnLabels());
  this.buttonBar = new org.apache.flex.html.staticControls.ButtonBar();
  this.buttonBar.addBead(this.buttonBarModel);

  this.buttonBar.set_height(20);
  this.buttonBar.set_width(this.strand_.get_width());
  this.strand_.addElement(this.buttonBar);

  this.columnContainer = new org.apache.flex.html.staticControls.Container();
  var layout = new org.apache.flex.html.staticControls.beads.layouts.
      NonVirtualHorizontalLayout();
  this.columnContainer.addBead(layout);
  this.strand_.addElement(this.columnContainer);
  this.columnContainer.positioner.style.width =
      this.strand_.positioner.style.width;

  var sharedModel = value.getBeadByType(
      org.apache.flex.html.staticControls.beads.models.DataGridModel);
  var columnWidth = this.strand_.get_width() / pm.get_columnLabels().length - 2;
  var columnHeight = this.strand_.get_height() - this.buttonBar.get_height();

  this.columns = new Array();

  for (var i = 0; i < pm.get_columnLabels().length; i++) {
    var columnView = new
        org.apache.flex.html.staticControls.beads.DataGridColumnView();
    columnView.set_columnIndex(i);
    columnView.set_labelField(sharedModel.get_labelFields()[i]);

    var factory = new org.apache.flex.html.staticControls.beads.
        DataItemRendererFactoryForColumnData();

    var column = new org.apache.flex.html.staticControls.List();
    column.set_dataProvider(this.strand_.get_dataProvider());
    column.set_width(columnWidth);
    column.set_height(columnHeight);
    column.addBead(columnView);
    column.addBead(factory);
    column.addEventListener('change',
        goog.bind(this.columnListChangeHandler, this));

    this.columnContainer.addElement(column);
    this.columns.push(column);
  }
};


/**
 * @param {Object} event The selection change event from one of the column
 * lists.
 */
org.apache.flex.html.staticControls.beads.DataGridView.prototype.
    columnListChangeHandler = function(event) {
  var list = event.target;
  var index = list.get_selectedIndex();

  if (index != this.strand_.get_model().get_selectedIndex()) {
    for (var i = 0; i < this.columns.length; i++) {
      if (list != this.columns[i]) {
        this.columns[i].set_selectedIndex(index);
      }
    }
    this.strand_.get_model().set_selectedIndex(index);
    var newEvent = new org.apache.flex.events.Event('change');
    this.strand_.dispatchEvent(newEvent);
  }
};
