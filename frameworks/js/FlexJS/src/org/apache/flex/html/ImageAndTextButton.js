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

goog.provide('org_apache_flex_html_ImageAndTextButton');

goog.require('org_apache_flex_html_Button');



/**
 * @constructor
 * @extends {org_apache_flex_html_Button}
 */
org_apache_flex_html_ImageAndTextButton = function() {
  org_apache_flex_html_ImageAndTextButton.base(this, 'constructor');

  this._text = '';
  this._src = '';
};
goog.inherits(org_apache_flex_html_ImageAndTextButton,
    org_apache_flex_html_Button);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_html_ImageAndTextButton.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'ImageAndTextButton',
                qName: 'org_apache_flex_html_ImageAndTextButton'}] };


/**
 * @override
 */
org_apache_flex_html_ImageAndTextButton.prototype.createElement =
    function() {
  this.element = document.createElement('button');
  this.element.setAttribute('type', 'button');

  this.positioner = this.element;
  this.element.flexjs_wrapper = this;

  if (org_apache_flex_core_ValuesManager.valuesImpl.getValue) {
    var impl = org_apache_flex_core_ValuesManager.valuesImpl.
        getValue(this, 'iStatesImpl');
  }

  return this.element;
};


Object.defineProperties(org_apache_flex_html_ImageAndTextButton.prototype, {
    /** @expose */
    text: {
        /** @this {org_apache_flex_html_ImageAndTextButton} */
        get: function() {
            return this._text;
        },
        /** @this {org_apache_flex_html_ImageAndTextButton} */
        set: function(value) {
            this._text = value;
            this.setInnerHTML();
        }
    },
    /** @expose */
    image: {
        /** @this {org_apache_flex_html_ImageAndTextButton} */
        get: function() {
            return this._src;
        },
        /** @this {org_apache_flex_html_ImageAndTextButton} */
        set: function(value) {
            this._src = value;
            this.setInnerHTML();
        }
    }
});


/**
 */
org_apache_flex_html_ImageAndTextButton.prototype.setInnerHTML = function() {
  var inner = '';
  if (this._src != null)
    inner += '<img src=\'' + this._src + '\'/>';
  inner += '&nbsp;';
  inner += this._text;
  this.element.innerHTML = inner;
};
