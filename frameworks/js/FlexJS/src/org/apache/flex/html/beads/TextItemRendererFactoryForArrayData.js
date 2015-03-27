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

goog.provide('org_apache_flex_html_beads_TextItemRendererFactoryForArrayData');

goog.require('org_apache_flex_core_IDataProviderItemRendererMapper');
goog.require('org_apache_flex_core_IItemRenderer');
goog.require('org_apache_flex_events_Event');
goog.require('org_apache_flex_events_EventDispatcher');
goog.require('org_apache_flex_html_beads_models_ArraySelectionModel');
goog.require('org_apache_flex_html_supportClasses_StringItemRenderer');



/**
 * @constructor
 * @extends {org_apache_flex_events_EventDispatcher}
 * @implements {org_apache_flex_core_IItemRenderer}
 */
org_apache_flex_html_beads_TextItemRendererFactoryForArrayData =
    function() {
  org_apache_flex_html_beads_TextItemRendererFactoryForArrayData.base(this, 'constructor');
};
goog.inherits(
    org_apache_flex_html_beads_TextItemRendererFactoryForArrayData,
    org_apache_flex_events_EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_beads_TextItemRendererFactoryForArrayData.
    prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'TextItemRendererFactoryForArrayData',
                qName: 'org_apache_flex_html_beads_TextItemRendererFactoryForArrayData' }],
      interfaces: [org_apache_flex_core_IItemRenderer] };


Object.defineProperties(org_apache_flex_html_beads_TextItemRendererFactoryForArrayData.prototype, {
    'strand': {
        /** @this {org_apache_flex_html_beads_TextItemRendererFactoryForArrayData} */
        set: function(value) {
            this.strand_ = value;

            this.model = value.getBeadByType(
                org_apache_flex_html_beads_models_ArraySelectionModel);

            this.listView = value.getBeadByType(
                org_apache_flex_html_beads_ListView);
            this.dataGroup = this.listView.dataGroup;

            this.model.addEventListener('dataProviderChanged',
                goog.bind(this.dataProviderChangedHandler, this));

            this.dataProviderChangedHandler(null);
        }
    }
});


/**
 * @expose
 * @param {Object} event The event that triggered the dataProvider change.
 */
org_apache_flex_html_beads_TextItemRendererFactoryForArrayData.
    prototype.dataProviderChangedHandler = function(event) {
  var dp, i, n, opt;

  dp = this.model.dataProvider;
  n = dp.length;
  for (i = 0; i < n; i++) {
    opt = new
        org_apache_flex_html_supportClasses_StringItemRenderer();
    this.dataGroup.addElement(opt);
    opt.text = dp[i];
  }

  var newEvent = new org_apache_flex_events_Event('itemsCreated');
  this.strand_.dispatchEvent(newEvent);
};
