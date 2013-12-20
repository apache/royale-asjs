/**
 * org.apache.flex.html.staticControls.beads.IDataProviderItemRendererMapper
 *
 * @fileoverview
 *
 * @suppress {checkTypes}
 */

goog.provide('org.apache.flex.core.IDataProviderItemRendererMapper');

goog.require('org.apache.flex.core.IBead');



/**
 * @interface
 * @extends {org.apache.flex.core.IBead}
 */
org.apache.flex.core.IDataProviderItemRendererMapper =
function() {
};


/**
 * @expose
 */
org.apache.flex.core.IDataProviderItemRendererMapper.prototype.itemRendererFactory = null;


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.IDataProviderItemRendererMapper.prototype.FLEXJS_CLASS_INFO = {
   names: [{ name: 'IDataProviderItemRendererMapper',
             qName: 'org.apache.flex.core.IDataProviderItemRendererMapper'}],
  interfaces: [org.apache.flex.core.IBead] };
