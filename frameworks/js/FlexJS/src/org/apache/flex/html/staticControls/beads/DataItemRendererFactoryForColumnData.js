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

goog.require('org.apache.flex.events.EventDispatcher');
goog.require('org.apache.flex.core.IItemRenderer');
goog.require('org.apache.flex.html.staticControls.beads.models.ArraySelectionModel');
goog.require('org.apache.flex.html.staticControls.supportClasses.ButtonBarButtonItemRenderer');
goog.require('org.apache.flex.html.staticControls.beads.DataGridColumnView');
goog.require('org.apache.flex.core.ValuesManager');

/**
 * @constructor
 * @extends {org.apache.flex.core.IItemRenderer}
 */
org.apache.flex.html.staticControls.beads.DataItemRendererFactoryForColumnData =
function() {
  goog.base(this);
};
goog.inherits(
  org.apache.flex.html.staticControls.beads.DataItemRendererFactoryForColumnData,
  org.apache.flex.core.IItemRenderer,
  org.apache.flex.events.EventDispatcher);



/**
 * @expose
 * @this {org.apache.flex.html.staticControls.beads.
          DataItemRendererFactoryForColumnData}
 * @param {object} value The component strand.
 */
org.apache.flex.html.staticControls.beads.DataItemRendererFactoryForColumnData.
prototype.set_strand = function(value) {
  this.strand_ = value;

  this.model = value.getBeadByType(
          org.apache.flex.html.staticControls.beads.models.ArraySelectionModel);
          
  this.listView = value.getBeadByType(
          org.apache.flex.html.staticControls.beads.DataGridColumnView);
  this.dataGroup = this.listView.get_dataGroup();

  this.model.addEventListener('dataProviderChanged',
      goog.bind(this.dataProviderChangedHandler, this));

  if (!this.itemRendererFactory_) {
    var irf = org.apache.flex.core.ValuesManager.valuesImpl.getValue(this.strand_, 'iItemRendererClassFactory');
    this.itemRendererFactory_ = new irf;
    this.strand_.addBead(this.itemRendererFactory_);
  }

  this.dataProviderChangedHandler(null);
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.beads.
 *        DataItemRendererFactoryForColumnData}
 * @return {object} The factory class to use for creating item renderers.
 */
org.apache.flex.html.staticControls.beads.DataItemRendererFactoryForColumnData.
prototype.get_itemRendererFactory = function() {
  return this.itemRendererFactory_;
};

/**
 * @expose
 * @this {org.apache.flex.html.staticControls.beads.
 *        DataItemRendererFactoryForColumnData}
 * @param {object} value The factory class to use for creating item renderers.
 */
org.apache.flex.html.staticControls.beads.DataItemRendererFactoryForColumnData.
prototype.set_itemRendererFactory = function(value) {
  this.itemRendererFactory_ = value;
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.beads.
          DataItemRendererFactoryForColumnData}
 * @param {object} event The event that triggered the dataProvider change.
 */
org.apache.flex.html.staticControls.beads.DataItemRendererFactoryForColumnData.
prototype.dataProviderChangedHandler = function(event) {
  var dp, i, n, opt;


  dp = this.model.get_dataProvider();
  n = dp.length;

  // todo: this.dataGroup.removeAllElements();

  var view = this.listView;
  for (i = 0; i < n; i++) {
    var fieldName = view.get_labelField();
    
    // todo: grab an itemRenderer from a factory for this column
    var opt = new org.apache.flex.html.staticControls.supportClasses.StringItemRenderer();
    this.dataGroup.addElement(opt);
    opt.set_text(dp[i][fieldName]);
  }

  var newEvent = new org.apache.flex.events.Event('itemsCreated');
  this.strand_.dispatchEvent(newEvent);
};
