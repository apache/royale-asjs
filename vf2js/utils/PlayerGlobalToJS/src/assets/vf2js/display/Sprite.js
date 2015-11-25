/**
 * @fileoverview 'vf2jsvf2js.display.InteractiveObject'
 *
 * @author erikdebruin@apache.org (Erik de Bruin)
 */

'use strict';

goog.provide('vf2js.display.Sprite');

goog.require('vf2js.display.DisplayObjectContainer');



/**
 * @constructor
 * @struct
 * @extends {vf2js.display.DisplayObjectContainer}
 */
vf2js.display.Sprite = function() {
  vf2js.display.Sprite.base(this, 'constructor');
};
goog.inherits(vf2js.display.Sprite, vf2js.display.DisplayObjectContainer);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
vf2js.display.InteractiveObject.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Sprite', qName: 'vf2js.display.Sprite'}],
      interfaces: [] }
