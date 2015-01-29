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

goog.provide('org_apache_flex_utils_UIUtils');

goog.require('org_apache_flex_core_IPopUpHost');
goog.require('org_apache_flex_utils_Language');



/**
 * @constructor
 */
org_apache_flex_utils_UIUtils = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_utils_UIUtils.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'UIUtils',
                qName: 'org_apache_flex_utils_UIUtils' }] };


/**
 * @expose
 * @param {Object} item The item to be centered.
 * @param {Object} relativeTo The object used as reference.
 */
org_apache_flex_utils_UIUtils.center =
    function(item, relativeTo) {

  var rw = relativeTo.width;
  if (isNaN(rw)) rw = window.innerWidth;
  var rh = relativeTo.height;
  if (isNaN(rh)) rh = window.innerHeight;

  var xpos = (rw - item.width) / 2;
  var ypos = (rh - item.height) / 2;
  item.set_x(xpos);
  item.set_y(ypos);
};


/**
 * @expose
 * @param {Object} start A component to start the search.
 * @return {Object} A component that implements IPopUpHost.
 */
org_apache_flex_utils_UIUtils.findPopUpHost =
    function(start) {

  while (start != null && !org_apache_flex_utils_Language.is(start, org_apache_flex_core_IPopUpHost)) {
    start = start.parent;
  }

  return start;
};


/**
 * @expose
 * @param {Object} popUp An IPopUpHost component looking to be removed.
 */
org_apache_flex_utils_UIUtils.removePopUp =
    function(popUp) {

  var p = popUp.parent;
  p.removeElement(popUp);
};
