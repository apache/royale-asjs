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
 * @fileoverview 'vf2js.display.DisplayObject'
 *
 * @author erikdebruin@apache.org (Erik de Bruin)
 */

'use strict';

goog.provide('vf2js.display.DisplayObject');

goog.require('flash.display.DisplayObject');
goog.require('flash.display.DisplayObjectContainer');
goog.require('flash.display.IBitmapDrawable');
goog.require('flash.display.LoaderInfo');
goog.require('vf2js.events.EventDispatcher');



/**
 * @constructor
 * @struct
 * @extends {vf2js.events.EventDispatcher}
 * @implements {flash.display.IBitmapDrawable}
 */
vf2js.display.DisplayObject = function() {
  vf2js.display.DisplayObject.base(this, 'constructor');
};
goog.inherits(vf2js.display.DisplayObject, vf2js.events.EventDispatcher);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
vf2js.display.DisplayObject.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'DisplayObject', qName: 'vf2js.display.DisplayObject'}],
      interfaces: [flash.display.IBitmapDrawable] };


//------------------------------------------------------------------------------
//
//  PROPERTIES
//
//------------------------------------------------------------------------------


/**
 * loaderInfo
 *
 * @return {flash.display.LoaderInfo}
 */
vf2js.display.DisplayObject.prototype.get_loaderInfo = function() {
	return window['apache-flex_loaderInfo'];
};


/**
 * parent_
 *
 * @type {flash.display.DisplayObjectContainer}
 */
vf2js.display.DisplayObject.prototype.parent_;


/**
 * parent
 *
 * @param {flash.display.DisplayObjectContainer} value The parent container.
 */
vf2js.display.DisplayObject.prototype.set_parent = function(value) {
	this.parent_ = value;
};


/**
 * parent
 *
 * @return {flash.display.DisplayObjectContainer}
 */
vf2js.display.DisplayObject.prototype.get_parent = function() {
    return this.parent_
};


/**
 * root
 *
 * @return {flash.display.DisplayObject}
 */
vf2js.display.DisplayObject.prototype.get_root = function() {
    return window['apache-flex_system-manager'];
};


/**
 * stage
 *
 * @return {flash.display.Stage}
 */
vf2js.display.DisplayObject.prototype.get_stage = function() {
    return window['apache-flex_stage'];
};


/**
 * scaleX_
 *
 * @type {number}
 */
vf2js.display.DisplayObject.prototype.scaleX_;


/**
 * scaleX
 *
 * @return {number}
 */
vf2js.display.DisplayObject.prototype.get_scaleX = function() {
  return scaleX_;
};


/**
 * scaleX
 *
 * @param {number} value The new value.
 */
vf2js.display.DisplayObject.prototype.set_scaleX = function(value) {
	this.scaleX_ = value;
};


/**
 * scaleY_
 *
 * @type {number}
 */
vf2js.display.DisplayObject.prototype.scaleY_;


/**
 * scaleY
 *
 * @return {number}
 */
vf2js.display.DisplayObject.prototype.get_scaleY = function() {
  return scaleY_;
};


/**
 * scaleY
 *
 * @param {number} value The new value.
 */
vf2js.display.DisplayObject.prototype.set_scaleY = function(value) {
	this.scaleY_ = value;
};
