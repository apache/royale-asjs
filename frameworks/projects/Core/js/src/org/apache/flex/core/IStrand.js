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

goog.provide('org_apache_flex_core_IStrand');



/**
 * IStrand
 *
 * @interface
 */
org_apache_flex_core_IStrand = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_core_IStrand.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'IStrand',
                qName: 'org_apache_flex_core_IStrand' }] };


/**
 * addBead()
 *
 * @export
 * @param {org_apache_flex_core_IBead} bead The bead to add.
 */
org_apache_flex_core_IStrand.prototype.addBead = function(bead) {};


/**
 * getBeadByType()
 *
 * @export
 * @param {Object} classOrInterface The type of bead to look for.
 * @return {org_apache_flex_core_IBead} The bead.
 */
org_apache_flex_core_IStrand.prototype.getBeadByType =
    function(classOrInterface) {};


/**
 * removeBead()
 *
 * @export
 * @param {org_apache_flex_core_IBead} bead The bead to remove.
 * @return {org_apache_flex_core_IBead} The bead that was removed.
 */
org_apache_flex_core_IStrand.prototype.removeBead = function(bead) {};
