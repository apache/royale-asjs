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
 * @fileoverview 'vf2js.display.MovieClip'
 *
 * @author erikdebruin@apache.org (Erik de Bruin)
 */

'use strict';

goog.provide('vf2js.display.MovieClip');

goog.require('vf2js.display.Sprite');



/**
 * @constructor
 * @struct
 * @extends {flash.display.Sprite}
 */
vf2js.display.MovieClip = function() {
  vf2js.display.MovieClip.base(this, 'constructor');
};
goog.inherits(vf2js.display.MovieClip, vf2js.display.Sprite);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
vf2js.display.MovieClip.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'MovieClip', qName: 'vf2js.display.MovieClip'}],
      interfaces: [] };


//------------------------------------------------------------------------------
//
//  PROPERTIES
//
//------------------------------------------------------------------------------


/**
 * framesLoaded
 *
 * @return {number}
 */
vf2js.display.MovieClip.prototype.get_framesLoaded = function() {
	return 2;
};


/**
 * currentFrame_
 *
 * @type {number}
 */
vf2js.display.MovieClip.prototype.currentFrame_ = 1;


/**
 * currentFrame
 *
 * @return {number}
 */
vf2js.display.MovieClip.prototype.get_currentFrame = function() {
	return this.currentFrame_;
};


/**
 * totalFrames
 *
 * @return {number}
 */
vf2js.display.MovieClip.prototype.get_totalFrames = function() {
	return 2;
};


//------------------------------------------------------------------------------
//
//  METHODS
//
//------------------------------------------------------------------------------


/**
 * nextFrame
 */
vf2js.display.MovieClip.prototype.nextFrame = function() {
    this.currentFrame_++;
};


/**
 * stop
 */
vf2js.display.MovieClip.prototype.stop = function() {
    // DO NOTHING, WE'RE NOT ON A TIMELINE
};
