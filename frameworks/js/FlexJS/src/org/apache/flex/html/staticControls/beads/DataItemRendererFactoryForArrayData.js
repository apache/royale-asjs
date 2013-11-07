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

goog.provide('org.apache.flex.html.staticControls.beads.DataItemRendererFactoryForArrayData');

goog.require('org.apache.flex.events.EventDispatcher');
goog.require('org.apache.flex.html.staticControls.beads.models.ArraySelectionModel');
goog.require('org.apache.flex.html.staticControls.supportClasses.ButtonBarButtonItemRenderer');



/**
 * @constructor
 * @extends {org.apache.flex.events.EventDispatcher}
 */
org.apache.flex.html.staticControls.beads.DataItemRendererFactoryForArrayData =
    function() {
  goog.base(this);
};
goog.inherits(
    org.apache.flex.html.staticControls.
        beads.DataItemRendererFactoryForArrayData,
    org.apache.flex.events.EventDispatcher);


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.beads.
          DataItemRendererFactoryForArrayData}
 * @param {object} value The component strand.
 */
org.apache.flex.html.staticControls.beads.DataItemRendererFactoryForArrayData.
    prototype.set_strand = function(value) {
  this.strand_ = value;

  this.model = value.getBeadByType(
      org.apache.flex.html.staticControls.beads.models.ArraySelectionModel);

  this.listView = value.getBeadByType(
      org.apache.flex.html.staticControls.beads.ListView);
  this.dataGroup = this.listView.get_dataGroup();

  this.model.addEventListener('dataProviderChanged',
      goog.bind(this.dataProviderChangedHandler, this));
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.beads.
 *        DataItemRendererFactoryForArrayData}
 * @return {object} Class used for the itemRenderer.
 */
org.apache.flex.html.staticControls.beads.DataItemRendererFactoryForArrayData.
    prototype.get_itemRendererClass = function() {
  return this.itemRendererClass_;
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.beads.
          DataItemRendererFactoryForArrayData}
 * @param {object} value class to use for the item renderer.
 */
org.apache.flex.html.staticControls.beads.DataItemRendererFactoryForArrayData.
    prototype.set_itemRendererClass = function(value) {
  this.itemRendererClass_ = value;
};


/**
 * @expose
 * @this {org.apache.flex.html.staticControls.beads.
          DataItemRendererFactoryForArrayData}
 * @param {object} event The event that triggered the dataProvider change.
 */
org.apache.flex.html.staticControls.beads.DataItemRendererFactoryForArrayData.
    prototype.dataProviderChangedHandler = function(event) {
  var dp, i, n, opt;

  dp = this.model.get_dataProvider();
  n = dp.length;
  for (i = 0; i < n; i++) {
    var expr = 'new ' + String(this.itemRendererClass_) + '()';
    opt = eval(expr);
    this.dataGroup.addElement(opt);
    opt.set_data(dp[i]);
  }

  var newEvent = new org.apache.flex.events.Event('itemsCreated');
  this.strand_.dispatchEvent(newEvent);
};
