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

goog.provide('org_apache_flex_html_Container');

goog.require('org_apache_flex_core_ContainerBase');
goog.require('org_apache_flex_core_IContainer');



/**
 * @constructor
 * @implements {org_apache_flex_core_IContainer}
 * @extends {org_apache_flex_core_ContainerBase}
 */
org_apache_flex_html_Container = function() {
  org_apache_flex_html_Container.base(this, 'constructor');
};
goog.inherits(org_apache_flex_html_Container,
    org_apache_flex_core_ContainerBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_Container.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'Container',
                qName: 'org_apache_flex_html_Container' }],
      interfaces: [org_apache_flex_core_IContainer] };


/**
 * @override
 */
org_apache_flex_html_Container.prototype.createElement =
    function() {
  var cb;

  this.element = document.createElement('div');

  this.positioner = this.element;
  // absolute positioned children need a non-null
  // position value in the parent.  It might
  // get set to 'absolute' if the container is
  // also absolutely positioned
  this.positioner.style.position = 'relative';
  this.element.flexjs_wrapper = this;

  return this.element;
};


/**
 * @override
 */
org_apache_flex_html_Container.prototype.addElement =
    function(child) {
  org_apache_flex_html_Container.base(this, 'addElement', child);
  this.dispatchEvent('elementAdded');
};


/**
 * @export
 */
org_apache_flex_html_Container.prototype.childrenAdded =
    function() {
  this.dispatchEvent('childrenAdded');
};


/**
 * @export
 * @return {Array} the HTML DOM element children.
 */
org_apache_flex_html_Container.prototype.internalChildren =
    function() {
  return this.element.children;
};


/**
 * @return {Array} All of the children of the container.
 */
org_apache_flex_html_Container.prototype.getChildren = function() {
  var arr = this.element.children;
  var comparr = [];
  var n = arr.length;
  for (var i = 0; i < n; i++)
  {
    comparr.push(arr[i].flexjs_wrapper);
  }
  return comparr;
};

