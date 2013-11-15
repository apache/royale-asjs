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

goog.provide('org.apache.flex.html.staticControls.TitleBar');

goog.require('org.apache.flex.html.staticControls.Container');
goog.require('org.apache.flex.html.staticControls.Label');
goog.require('org.apache.flex.html.staticControls.TextButton');
goog.require('org.apache.flex.html.staticControls.beads.models.TitleBarModel');



/**
 * @constructor
 * @extends {org.apache.flex.html.staticControls.Container}
 */
org.apache.flex.html.staticControls.TitleBar = function() {

  this.model =
      new org.apache.flex.html.staticControls.beads.models.TitleBarModel();

  goog.base(this);
};
goog.inherits(org.apache.flex.html.staticControls.TitleBar,
    org.apache.flex.html.staticControls.Container);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.staticControls.TitleBar.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'TitleBar',
                qName: 'org.apache.flex.html.staticControls.TitleBar'}] };


/**
 * @override
 */
org.apache.flex.html.staticControls.TitleBar.prototype.createElement =
    function() {

  this.element = document.createElement('div');

  this.titleLabel = new org.apache.flex.html.staticControls.Label();
  this.addElement(this.titleLabel);
  this.titleLabel.element.id = 'title';
  this.titleLabel.positioner.style.display = 'inline-block';
  this.titleLabel.set_className('TitleBarLabel');

  this.titleButton = new org.apache.flex.html.staticControls.TextButton();
  this.addElement(this.titleButton);
  this.titleButton.element.id = 'closeButton';
  this.titleButton.text = 'Close';
  this.titleButton.positioner.style.position = 'absolute';
  this.titleButton.positioner.style.right = '0px';

  this.positioner = this.element;
  this.element.flexjs_wrapper = this;

  this.set_className('TitleBar');

  // listen for changes to the model so items can be changed in the view
  this.model.addEventListener('titleChange',
      goog.bind(this.changeHandler, this));
};


/**
 * @override
 */
org.apache.flex.html.staticControls.TitleBar.prototype.addedToParent =
    function() {

  this.titleLabel.set_text(this.model.get_title());

  if (this.model.showCloseButton) {
    this.titleButton.positioner.style.display = 'inline-block';
  } else {
    this.titleButton.positioner.style.display = 'none';
  }
};


/**
 * @param {Object} event The event that triggered this handler.
 */
org.apache.flex.html.staticControls.TitleBar.prototype.changeHandler =
    function(event) {
  if (event.type == 'titleChange') {
    this.titleLabel.set_text(this.model.get_title());
  }
  else if (event.type == 'htmlTitleChange') {
    this.titleLabel.set_text(this.model.get_htmlTitle());
  }
};


/**
 * @expose
 * @return {string} The title getter.
 */
org.apache.flex.html.staticControls.TitleBar.prototype.get_title =
    function() {
  return this.model.get_title();
};


/**
 * @expose
 * @param {string} value The title setter.
 */
org.apache.flex.html.staticControls.TitleBar.prototype.set_title =
    function(value) {
  this.model.set_title(value);
};


/**
 * @expose
 * @return {string} The showCloseButton getter.
 */
org.apache.flex.html.staticControls.TitleBar.prototype.get_showCloseButton =
    function() {
  return this.model.get_showCloseButton();
};


/**
 * @expose
 * @param {string} value The title setter.
 */
org.apache.flex.html.staticControls.TitleBar.prototype.set_showCloseButton =
    function(value) {
  this.model.set_showCloseButton(value);
};
