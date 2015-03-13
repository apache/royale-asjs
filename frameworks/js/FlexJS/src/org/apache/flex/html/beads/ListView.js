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

goog.provide('org_apache_flex_html_beads_ListView');

goog.require('org_apache_flex_core_IBeadLayout');
goog.require('org_apache_flex_core_IBeadView');
goog.require('org_apache_flex_core_IItemRendererParent');
goog.require('org_apache_flex_core_ILayoutParent');
goog.require('org_apache_flex_core_ValuesManager');
goog.require('org_apache_flex_html_beads_IListView');
goog.require('org_apache_flex_html_beads_TextItemRendererFactoryForArrayData');
goog.require('org_apache_flex_html_beads_models_ArraySelectionModel');
goog.require('org_apache_flex_html_supportClasses_NonVirtualDataGroup');



/**
 * @constructor
 * @implements {org_apache_flex_core_ILayoutParent}
 * @implements {org_apache_flex_html_beads_IListView}
 */
org_apache_flex_html_beads_ListView = function() {
  this.lastSelectedIndex = -1;

  this.className = 'ListView';
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_beads_ListView.prototype.
    FLEXJS_CLASS_INFO =
    { names: [{ name: 'ListView',
                qName: 'org_apache_flex_html_beads_ListView' }],
      interfaces: [org_apache_flex_html_beads_IListView, org_apache_flex_core_ILayoutParent] };


/**
 * @expose
 * @param {Object} value The new host.
 */
org_apache_flex_html_beads_ListView.prototype.set_strand =
    function(value) {

  this.strand_ = value;

  this.strand_.addEventListener('sizeChanged',
      goog.bind(this.handleSizeChange, this));
  this.strand_.addEventListener('widthChanged',
      goog.bind(this.handleSizeChange, this));
  this.strand_.addEventListener('heightChanged',
      goog.bind(this.handleSizeChange, this));

  this.model = this.strand_.model;
  this.model.addEventListener('selectedIndexChanged',
      goog.bind(this.selectionChangeHandler, this));
  this.model.addEventListener('dataProviderChanged',
      goog.bind(this.dataProviderChangeHandler, this));

  if (this.dataGroup_ == null) {
    var m2 = org_apache_flex_core_ValuesManager.valuesImpl.
        getValue(this.strand_, 'iDataGroup');
    this.dataGroup_ = new m2();
  }
  this.dataGroup_.strand = this;
  this.strand_.addElement(this.dataGroup_);

  if (this.strand_.getBeadByType(org_apache_flex_core_IBeadLayout) == null) {
    var m3 = org_apache_flex_core_ValuesManager.valuesImpl.getValue(this.strand_, 'iBeadLayout');
    this.layout_ = new m3();
    this.strand_.addBead(this.layout_);
    //this.layout_.strand = this.strand_;
  }

  this.handleSizeChange(null);
};


/**
 * @expose
 * @return {Object} The DataGroup instance.
 */
org_apache_flex_html_beads_ListView.prototype.get_dataGroup =
    function() {
  return this.dataGroup_;
};


/**
 * @expose
 * @param {Object} value The DataGroup instance.
 */
org_apache_flex_html_beads_ListView.prototype.set_dataGroup =
    function(value) {
  this.dataGroup_ = value;
};


/**
 * @expose
 * @param {Object} value The event that triggered the selection.
 */
org_apache_flex_html_beads_ListView.prototype.
    selectionChangeHandler = function(value) {
  var ir;
  if (this.lastSelectedIndex != -1) {
    ir = this.dataGroup_.getItemRendererForIndex(this.lastSelectedIndex);
    if (ir) ir.selected = false;
  }
  if (this.model.selectedIndex != -1) {
    ir = this.dataGroup_.getItemRendererForIndex(
        this.model.selectedIndex);
    if (ir) ir.selected = true;
  }
  this.lastSelectedIndex = this.model.selectedIndex;
};


/**
 * @expose
 * @param {Object} value The event that triggeed the selection.
 */
org_apache_flex_html_beads_ListView.prototype.
    dataProviderChangeHandler = function(value) {
    // override in subclass
};


Object.defineProperties(org_apache_flex_html_beads_ListView.prototype, {
    'contentView': {
		get: function() {
            return this.dataGroup_;
        }
	},
    'border': {
		get: function() {
            return null;
		}
	},
    'vScrollBar': {
		get: function() {
            return null;
		},
        set: function(value) {
		}
	},
    'resizeableView': {
		get: function() {
            return this;
		}
	}
});


/**
 * @expose
 * @param {Object} event The event that triggered the resize.
 */
org_apache_flex_html_beads_ListView.prototype.handleSizeChange = function(event) {
  this.dataGroup_.width = this.strand_.width;
  this.dataGroup_.height = this.strand_.height;
};
