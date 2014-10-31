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

/**
 * @fileoverview 'vf2js.display.Stage'
 *
 * @author erikdebruin@apache.org (Erik de Bruin)
 */

'use strict';

goog.provide('vf2js.display.Stage');

goog.require('flash.display.DisplayObjectContainer');
goog.require('flash.display.StageAlign');



/**
 * @constructor
 * @struct
 * @extends {flash.display.DisplayObjectContainer}
 */
vf2js.display.Stage = function() {
  vf2js.display.Stage.base(this, 'constructor');
};
goog.inherits(vf2js.display.Stage, flash.display.DisplayObjectContainer);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
vf2js.display.Stage.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Stage', qName: 'vf2js.display.Stage'}],
      interfaces: [] };


//------------------------------------------------------------------------------
//
//  PROPERTIES
//
//------------------------------------------------------------------------------


/**
 * align_
 *
 * @private
 * 
 * @type {string}
 */
vf2js.display.Stage.prototype.align_ = flash.display.StageAlign.TOP;


/**
 * align
 *
 * @return {string}
 */
vf2js.display.Stage.prototype.get_align = function() {
	return this.align_;
};


/**
 * align
 *
 * @type {undefined}
 */
vf2js.display.Stage.prototype.set_align = function(value) {
    this.align_ = value;
};


/**
 * quality_
 *
 * @private
 * 
 * @type {string}
 */
vf2js.display.Stage.prototype.quality_;


/**
 * quality
 *
 * @return {string}
 */
vf2js.display.Stage.prototype.get_quality = function() {
    return this.quality_;
};


/**
 * quality
 *
 * @param {string} value The new value.
 */
vf2js.display.Stage.prototype.set_quality = function(value) {
    this.quality_ = value;
};


/**
 * scaleMode_
 *
 * @private
 * 
 * @type {string}
 */
vf2js.display.Stage.prototype.scaleMode_;


/**
 * scaleMode
 *
 * @return {string}
 */
vf2js.display.Stage.prototype.get_scaleMode = function() {
    return this.scaleMode_;
};


/**
 * scaleMode
 *
 * @param {string} value The new value.
 */
vf2js.display.Stage.prototype.set_scaleMode = function(value) {
    this.scaleMode_ = value;
};


/**
 * stageHeight
 *
 * @return {number}
 */
vf2js.display.Stage.prototype.get_stageHeight = function() {
	return 768;
};


/**
 * stageWidth
 *
 * @return {number}
 */
vf2js.display.Stage.prototype.get_stageWidth = function() {
	return 1024;
};


//------------------------------------------------------------------------------
//
//  METHODS
//
//------------------------------------------------------------------------------


/**
 * addEventListener
 *
 * @param {string} arg0 Argument 0
 * @param {Function} arg1 Argument 1
 * @param {boolean=} opt_arg2 Argument 2 (optional)
 * @param {number=} opt_arg3 Argument 3 (optional)
 * @param {boolean=} opt_arg4 Argument 4 (optional)
 */
vf2js.display.Stage.prototype.addEventListener = function(arg0, arg1, opt_arg2, opt_arg3, opt_arg4) {
  vf2js.display.Stage.base(this, 'addEventListener', arg0, arg1, opt_arg2, opt_arg3, opt_arg4);
};


/**
 * dispatchEvent
 *
 * @param {Event} arg0 Argument 0
 *
 * @return {boolean}
 */
vf2js.display.Stage.prototype.dispatchEvent = function(arg0) {
  return vf2js.display.Stage.base(this, 'dispatchEvent', arg0);
};


/**
 * hasEventListener
 *
 * @param {string} arg0 Argument 0
 *
 * @return {boolean}
 */
vf2js.display.Stage.prototype.hasEventListener = function(arg0) {
  return vf2js.display.Stage.base(this, 'hasEventListener', arg0);
};
