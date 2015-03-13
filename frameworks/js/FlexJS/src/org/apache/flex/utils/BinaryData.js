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

goog.provide('org_apache_flex_utils_BinaryData');



/**
 * @constructor
 */
org_apache_flex_utils_BinaryData = function() {

  /**
   * @private
   * @type {ArrayBuffer}
   */
  this.data_ = new ArrayBuffer();

  /**
   * @private
   * @type {number}
   */
  this.position_ = 0;

};


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org_apache_flex_utils_BinaryData.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'BinaryData',
                qName: 'org_apache_flex_utils_BinaryData'}] };


Object.defineProperties(org_apache_flex_utils_BinaryData.prototype, {
    'data': {
        get: function() {
            return this.data_;
        }
    },
    'position': {
        get: function() {
            return this.position_;
        },
        set: function(value) {
            this.position_ = value;
        }
    },
    'length': {
        get: function() {
            return this.data_.byteLength;
        }
    },
    'bytesAvailable': {
        get: function() {
            return this.data_.byteLength - this.position_;
        }
    }
});


/**
 * @expose
 * @param {number} b The byte to write.
 */
org_apache_flex_utils_BinaryData.prototype.writeByte = function(b) {
  var view;

  this.growBuffer(1);

  view = new Int8Array(this.data_, this.position_, 1);
  view[0] = b;
  this.position_++;
};


/**
 * @expose
 * @param {number} s The 16-bit integer to write.
 */
org_apache_flex_utils_BinaryData.prototype.writeShort = function(s) {
  var view;

  this.growBuffer(2);

  view = new Int16Array(this.data_, this.position_, 1);
  view[0] = s;
  this.position_ += 2;
};


/**
 * @expose
 * @param {number} num The 32-bit integer to write.
 */
org_apache_flex_utils_BinaryData.prototype.writeInt = function(num) {
  var view;

  this.growBuffer(4);

  view = new Int32Array(this.data_, this.position_, 1);
  view[0] = num;
  this.position_ += 4;
};


/**
 * @expose
 * @param {number} num The 32-bit unsigned integer to write.
 */
org_apache_flex_utils_BinaryData.prototype.writeUnsignedInt =
    function(num) {
  var view;

  this.growBuffer(4);

  view = new Uint32Array(this.data_, this.position_, 1);
  view[0] = num;
  this.position_ += 4;
};


/**
 * @expose
 * @return {number} The byte that was read.
 */
org_apache_flex_utils_BinaryData.prototype.readByte = function() {
  var view;

  view = new Int8Array(this.data_, this.position_, 1);
  this.position_++;
  return view[0];
};


/**
 * @expose
 * @return {number} The 16-bit integer that was read.
 */
org_apache_flex_utils_BinaryData.prototype.readShort = function() {
  var view;

  view = new Int16Array(this.data_, this.position_, 1);
  this.position_ += 2;
  return view[0];
};


/**
 * @expose
 * @return {number} The 32-bit integer that was read.
 */
org_apache_flex_utils_BinaryData.prototype.readInteger = function() {
  var view;

  view = new Int32Array(this.data_, this.position_, 1);
  this.position_ += 4;
  return view[0];
};


/**
 * @expose
 * @return {number} The 32-bit unsigned integer that was read.
 */
org_apache_flex_utils_BinaryData.prototype.readUnsignedInteger =
    function() {
  var view;

  view = new Uint32Array(this.data_, this.position_, 1);
  this.position_ += 4;
  return view[0];
};


/**
 * @expose
 * @param {number} extra The number of bytes to add to the buffer.
 */
org_apache_flex_utils_BinaryData.prototype.growBuffer = function(extra) {
  var newBuffer, newView, view, i, n;

  if (this.position_ >= this.data_.byteLength)
  {
    n = this.data_.byteLength;
    newBuffer = new ArrayBuffer(n + extra);
    newView = new Int8Array(newBuffer, 0, n);
    view = new Int8Array(this.data_, 0, n);
    for (i = 0; i < n; i++)
    {
      newView[i] = view[i];
    }
    this.data_ = newBuffer;
  }
};





