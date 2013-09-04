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
goog.require('org.apache.flex.html.staticControls.beads.models.ArraySelectionModel');



/**
 * @constructor
 * @extends {org.apache.flex.core.ListBase}
 */
org.apache.flex.html.staticControls.List = function() {
  this.model = new org.apache.flex.html.staticControls.beads.models.ArraySelectionModel();
  
  this.renderers = new Array();
  
  this.model.addEventListener('dataProviderChanged',
      goog.bind(this.dataProviderChangedHandler,this));

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

  this.element.size = 5;
};

org.apache.flex.html.staticControls.List.prototype.dataProviderChangedHandler =
function(event) {
  var dp, i, n, opt;

  while (this.element.hasChildNodes()) {
    this.element.removeChild(this.element.lastChild);
  }
  
  this.renderers.splice(0,this.renderers.length);

  dp = this.model.get_dataProvider();
  n = dp.length;
  for (i = 0; i < n; i++) {
    opt = new org.apache.flex.html.staticControls.supportClasses.StringItemRenderer();
    this.addElement(opt);
    opt.set_strand(this);
    opt.set_text(dp[i]);
    
    this.renderers.push(opt);
    
    goog.events.listen(opt, 'selected',
            goog.bind(this.selectedHandler, this));
  }
};

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
