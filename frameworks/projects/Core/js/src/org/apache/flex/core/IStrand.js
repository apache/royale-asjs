/**
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @fileoverview
 * @suppress {checkTypes}
 */

goog.provide('org.apache.flex.core.IStrand');



/**
 * IStrand
 *
 * @interface
 */
org.apache.flex.core.IStrand = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.core.IStrand.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'IStrand',
                qName: 'org.apache.flex.core.IStrand' }] };


/**
 * addBead()
 *
 * @export
 * @param {org.apache.flex.core.IBead} bead The bead to add.
 */
org.apache.flex.core.IStrand.prototype.addBead = function(bead) {};


/**
 * getBeadByType()
 *
 * @export
 * @param {Object} classOrInterface The type of bead to look for.
 * @return {org.apache.flex.core.IBead} The bead.
 */
org.apache.flex.core.IStrand.prototype.getBeadByType =
    function(classOrInterface) {};


/**
 * removeBead()
 *
 * @export
 * @param {org.apache.flex.core.IBead} bead The bead to remove.
 * @return {org.apache.flex.core.IBead} The bead that was removed.
 */
org.apache.flex.core.IStrand.prototype.removeBead = function(bead) {};
