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

goog.provide('org.apache.flex.utils.UIUtils');



/**
 * @constructor
 */
org.apache.flex.utils.UIUtils = function() {
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.utils.UIUtils.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'UIUtils',
                qName: 'org.apache.flex.utils.UIUtils' }] };


/**
 * @expose
 * @param {Object} item The item to be centered.
 * @param {Object} relativeTo The object used as reference.
 */
org.apache.flex.utils.UIUtils.center =
    function(item, relativeTo) {

  var xpos = (relativeTo.get_width() - item.get_width()) / 2;
  var ypos = (relativeTo.get_height() - item.get_height()) / 2;
  item.set_x(xpos);
  item.set_y(ypos);
};
