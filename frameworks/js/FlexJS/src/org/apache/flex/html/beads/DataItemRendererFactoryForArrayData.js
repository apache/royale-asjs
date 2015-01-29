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

goog.provide('org_apache_flex_html_beads_DataItemRendererFactoryForArrayData');

goog.require('org_apache_flex_core_IDataProviderItemRendererMapper');
goog.require('org_apache_flex_core_IListPresentationModel');
goog.require('org_apache_flex_events_EventDispatcher');
goog.require('org_apache_flex_html_beads_ListView');
goog.require('org_apache_flex_html_beads_models_ArraySelectionModel');
goog.require('org_apache_flex_html_supportClasses_ButtonBarButtonItemRenderer');



/**
 * @constructor
 * @implements {org_apache_flex_core_IDataProviderItemRendererMapper}
 */
org_apache_flex_html_beads_DataItemRendererFactoryForArrayData =
    function() {
};


/**
 * @expose
 */
org_apache_flex_html_beads_DataItemRendererFactoryForArrayData.prototype.itemRendererFactory = null;


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_beads_DataItemRendererFactoryForArrayData.
    prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'DataItemRendererFactoryForArrayData',
                qName: 'org_apache_flex_html_beads_DataItemRendererFactoryForArrayData' }],
      interfaces: [org_apache_flex_core_IDataProviderItemRendererMapper] };


/**
 * @private
 * @type {Object}
 */
org_apache_flex_html_beads_DataItemRendererFactoryForArrayData.
    prototype.itemRendererClass_ = null;


/**
 * @expose
 * @param {Object} value The component strand.
 */
org_apache_flex_html_beads_DataItemRendererFactoryForArrayData.
    prototype.set_strand = function(value) {
  this.strand_ = value;

  this.model = value.getBeadByType(
      org_apache_flex_html_beads_models_ArraySelectionModel);

  this.listView = value.getBeadByType(
      org_apache_flex_html_beads_ListView);
  this.dataGroup = this.listView.dataGroup;

  this.model.addEventListener('dataProviderChanged',
      goog.bind(this.dataProviderChangedHandler, this));

  if (org_apache_flex_core_ValuesManager.valuesImpl.getValue && !this.itemRendererFactory_) {
    /**
     * @type {Function}
     */
    var c = /** @type {Function} */ (org_apache_flex_core_ValuesManager.valuesImpl.getValue(this.strand_,
            'iItemRendererClassFactory'));
    this.itemRendererFactory_ = new c();
    this.strand_.addBead(this.itemRendererFactory_);
  }

  this.dataProviderChangedHandler(null);
};


/**
 * @expose
 * @return {Object} The itemRenderer.
 */
org_apache_flex_html_beads_DataItemRendererFactoryForArrayData.
    prototype.get_itemRendererClass = function() {
  if (org_apache_flex_core_ValuesManager.valuesImpl.getValue && !this.itemRendererClass_) {
    var c = org_apache_flex_core_ValuesManager.valuesImpl.getValue(this.strand_, 'iItemRenderer');
    if (c) {
      this.itemRendererClass_ = c;
    }
  }
  return this.itemRendererClass_;
};


/**
 * @expose
 * @param {Object} value class to use for the item renderer.
 */
org_apache_flex_html_beads_DataItemRendererFactoryForArrayData.
    prototype.set_itemRendererClass = function(value) {
  this.itemRendererClass_ = value;
};


/**
 * @expose
 * @param {Object} event The event that triggered the dataProvider change.
 */
org_apache_flex_html_beads_DataItemRendererFactoryForArrayData.
    prototype.dataProviderChangedHandler = function(event) {
  var dp, i, n, opt;

  this.dataGroup.removeAllElements();

  var presModel = this.strand_.getBeadByType(org_apache_flex_core_IListPresentationModel);

  dp = this.model.dataProvider;
  n = dp.length;
  for (i = 0; i < n; i++) {
    var ir = this.itemRendererFactory_.createItemRenderer(this.dataGroup);
    ir.set_index(i);
    ir.set_labelField(this.model.labelField);
    ir.set_data(dp[i]);
    if (presModel) ir.set_height(presModel.rowHeight);
  }

  var newEvent = new org_apache_flex_events_Event('itemsCreated');
  this.strand_.dispatchEvent(newEvent);
};
