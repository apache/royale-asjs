/**
 * @fileoverview 'vf2jsvf2js.display.InteractiveObject'
 *
 * @author erikdebruin@apache.org (Erik de Bruin)
 */

'use strict';

goog.provide('vf2js.display.InteractiveObject');

goog.require('vf2js.display.DisplayObject');



/**
 * @constructor
 * @struct
 * @extends {vf2js.display.DisplayObject}
 */
vf2js.display.InteractiveObject = function() {
  vf2js.display.InteractiveObject.base(this, 'constructor');
};
goog.inherits(vf2js.display.InteractiveObject, vf2js.display.DisplayObject);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
vf2js.display.InteractiveObject.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'InteractiveObject', qName: 'vf2js.display.InteractiveObject'}],
      interfaces: [] }
