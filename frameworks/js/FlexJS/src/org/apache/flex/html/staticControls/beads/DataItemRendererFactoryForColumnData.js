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

goog.provide('org.apache.flex.html.staticControls.beads.DataItemRendererFactoryForColumnData');

goog.require('org.apache.flex.core.IItemRenderer');
goog.require('org.apache.flex.core.ValuesManager');
goog.require('org.apache.flex.events.EventDispatcher');
goog.require('org.apache.flex.html.staticControls.beads.DataGridColumnView');
goog.require('org.apache.flex.html.staticControls.beads.models.ArraySelectionModel');
goog.require('org.apache.flex.html.staticControls.supportClasses.ButtonBarButtonItemRenderer');
goog.require('org.apache.flex.html.staticControls.supportClasses.StringItemRenderer');



/**
 * @constructor
 * @extends {org.apache.flex.events.EventDispatcher}
 * @implements {org.apache.flex.core.IItemRenderer}
 */
org.apache.flex.html.staticControls.beads.DataItemRendererFactoryForColumnData =
    function() {
  goog.base(this);
};
goog.inherits(
    org.apache.flex.html.staticControls.beads.
        DataItemRendererFactoryForColumnData,
    org.apache.flex.events.EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.staticControls.beads.DataItemRendererFactoryForColumnData
  .prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'DataItemRendererFactoryForColumnData',
                qName: 'org.apache.flex.html.staticControls.beads.DataItemRendererFactoryForColumnData'}],
      interfaces: [org.apache.flex.core.IItemRenderer] };


/**
 * @expose
          DataItemRendererFactoryForColumnData}
 * @param {Object} value The component strand.
 */
org.apache.flex.html.staticControls.beads.DataItemRendererFactoryForColumnData.
    prototype.set_strand = function(value) {
  var Irf;

  this.strand_ = value;

  this.model = value.getBeadByType(
      org.apache.flex.html.staticControls.beads.models.ArraySelectionModel);

  this.listView = value.getBeadByType(
      org.apache.flex.html.staticControls.beads.DataGridColumnView);
  this.dataGroup = this.listView.get_dataGroup();

  this.model.addEventListener('dataProviderChanged',
      goog.bind(this.dataProviderChangedHandler, this));

  if (!this.itemRendererFactory_) {
    Irf = org.apache.flex.core.ValuesManager.valuesImpl.
        getValue(this.strand_, 'iItemRendererClassFactory');
    this.itemRendererFactory_ = new Irf();
    this.strand_.addBead(this.itemRendererFactory_);
  }

  this.dataProviderChangedHandler(null);
};


/**
 * @expose
 *        DataItemRendererFactoryForColumnData}
 * @return {Object} The factory class to use for creating item renderers.
 */
org.apache.flex.html.staticControls.beads.DataItemRendererFactoryForColumnData.
    prototype.get_itemRendererFactory = function() {
  return this.itemRendererFactory_;
};


/**
 * @expose
 *        DataItemRendererFactoryForColumnData}
 * @param {Object} value The factory class to use for creating item renderers.
 */
org.apache.flex.html.staticControls.beads.DataItemRendererFactoryForColumnData.
    prototype.set_itemRendererFactory = function(value) {
  this.itemRendererFactory_ = value;
};


/**
 * @expose
          DataItemRendererFactoryForColumnData}
 * @param {Object} event The event that triggered the dataProvider change.
 */
org.apache.flex.html.staticControls.beads.DataItemRendererFactoryForColumnData.
    prototype.dataProviderChangedHandler = function(event) {
  var dp, fieldName, i, n, newEvent, opt, view;

  dp = this.model.get_dataProvider();
  n = dp.length;

  // todo: this.dataGroup.removeAllElements();

  view = this.listView;
  for (i = 0; i < n; i++) {
    fieldName = view.get_labelField();

    // todo: grab an itemRenderer from a factory for this column
    opt = this.itemRendererFactory_.createItemRenderer(this.dataGroup);
    this.dataGroup.addElement(opt);
    opt.set_data(dp[i]);
  }

  newEvent = new org.apache.flex.events.Event('itemsCreated');
  this.strand_.dispatchEvent(newEvent);
};
