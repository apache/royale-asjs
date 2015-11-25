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

goog.provide('org.apache.flex.html.beads.DataItemRendererFactoryForArrayData');

goog.require('org.apache.flex.core.IDataProviderItemRendererMapper');
goog.require('org.apache.flex.core.IListPresentationModel');
goog.require('org.apache.flex.events.EventDispatcher');
goog.require('org.apache.flex.html.beads.ListView');
goog.require('org.apache.flex.html.beads.models.ArraySelectionModel');
goog.require('org.apache.flex.html.supportClasses.ButtonBarButtonItemRenderer');



/**
 * @constructor
 * @implements {org.apache.flex.core.IDataProviderItemRendererMapper}
 */
org.apache.flex.html.beads.DataItemRendererFactoryForArrayData =
    function() {
};


/**
 * @export
 */
org.apache.flex.html.beads.DataItemRendererFactoryForArrayData.prototype.itemRendererFactory = null;


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.beads.DataItemRendererFactoryForArrayData.
    prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'DataItemRendererFactoryForArrayData',
                qName: 'org.apache.flex.html.beads.DataItemRendererFactoryForArrayData' }],
      interfaces: [org.apache.flex.core.IDataProviderItemRendererMapper] };


/**
 * @private
 * @type {Object}
 */
org.apache.flex.html.beads.DataItemRendererFactoryForArrayData.
    prototype.itemRendererClass_ = null;


Object.defineProperties(org.apache.flex.html.beads.DataItemRendererFactoryForArrayData.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.html.beads.DataItemRendererFactoryForArrayData} */
        set: function(value) {
            this.strand_ = value;

            this.model = value.getBeadByType(
                org.apache.flex.html.beads.models.ArraySelectionModel);

            this.listView = value.getBeadByType(
                org.apache.flex.html.beads.ListView);
            this.dataGroup = this.listView.dataGroup;

            this.model.addEventListener('dataProviderChanged',
                goog.bind(this.dataProviderChangedHandler, this));

            if (org.apache.flex.core.ValuesManager.valuesImpl.getValue && !this.itemRendererFactory_) {
              /**
               * @type {Function}
               */
              var c = /** @type {Function} */ (org.apache.flex.core.ValuesManager.valuesImpl.getValue(this.strand_,
                  'iItemRendererClassFactory'));
              this.itemRendererFactory_ = new c();
              this.strand_.addBead(this.itemRendererFactory_);
            }

            this.dataProviderChangedHandler(null);
        }
    },
    /** @export */
    itemRendererClass: {
        /** @this {org.apache.flex.html.beads.DataItemRendererFactoryForArrayData} */
        get: function() {
            if (org.apache.flex.core.ValuesManager.valuesImpl.getValue && !this.itemRendererClass_) {
              var c = org.apache.flex.core.ValuesManager.valuesImpl.getValue(this.strand_, 'iItemRenderer');
              if (c) {
                this.itemRendererClass_ = c;
              }
            }
            return this.itemRendererClass_;
        },
        /** @this {org.apache.flex.html.beads.DataItemRendererFactoryForArrayData} */
        set: function(value) {
            this.itemRendererClass_ = value;
        }
    }
});


/**
 * @export
 * @param {Object} event The event that triggered the dataProvider change.
 */
org.apache.flex.html.beads.DataItemRendererFactoryForArrayData.
    prototype.dataProviderChangedHandler = function(event) {
  var dp, i, n, opt;

  this.dataGroup.removeAllElements();

  var presModel = this.strand_.getBeadByType(org.apache.flex.core.IListPresentationModel);

  dp = this.model.dataProvider;
  if (dp === undefined) return;

  n = dp.length;
  for (i = 0; i < n; i++) {
    var ir = this.itemRendererFactory_.createItemRenderer(this.dataGroup);
    ir.index = i;
    ir.labelField = this.model.labelField;
    ir.data = dp[i];
    if (presModel) {
      ir.element.style['margin-bottom'] = presModel.separatorThickness;
      ir.height = presModel.rowHeight;
    }
  }

  var newEvent = new org.apache.flex.events.Event('itemsCreated');
  this.strand_.dispatchEvent(newEvent);
};
