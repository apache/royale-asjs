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

goog.provide('org.apache.flex.html.accessories.NumericOnlyTextInputBead');



/**
 * @constructor
 */
org.apache.flex.html.accessories.NumericOnlyTextInputBead =
    function() {

  /**
   * @protected
   * @type {Object}
   */
  this.promptElement = null;
};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.html.accessories.NumericOnlyTextInputBead.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'NumericOnlyTextInputBead',
                qName: 'org.apache.flex.html.accessories.NumericOnlyTextInputBead' }] };


Object.defineProperties(org.apache.flex.html.accessories.NumericOnlyTextInputBead.prototype, {
    /** @export */
    strand: {
        /** @this {org.apache.flex.html.accessories.NumericOnlyTextInputBead} */
        set: function(value) {
            if (this.strand_ !== value) {
              this.strand_ = value;
              value.addEventListener('keypress', goog.bind(this.validateInput, this));
            }
        }
    }
});


/**
 * @export
 * @param {Object} event The input to validate?
 */
org.apache.flex.html.accessories.NumericOnlyTextInputBead.
    prototype.validateInput = function(event) {

  var code = event.charCode;

  // backspace or delete
  if (event.keyCode == 8 || event.keyCode == 46) return;

  // tab or return/enter
  if (event.keyCode == 9 || event.keyCode == 13) return;

  // left or right cursor arrow
  if (event.keyCode == 37 || event.keyCode == 39) return;

  var key = String.fromCharCode(code);

  var regex = /[0-9]|\./;
  if (!regex.test(key)) {
    event.returnValue = false;
    if (event.preventDefault) event.preventDefault();
    return;
  }
  var cursorStart = event.target.selectionStart;
  var cursorEnd = event.target.selectionEnd;
  var left = event.target.value.substring(0, cursorStart);
  var right = event.target.value.substr(cursorEnd);
  var complete = left + key + right;
  if (isNaN(complete)) {
    event.returnValue = false;
    if (event.preventDefault) event.preventDefault();
  }
};
