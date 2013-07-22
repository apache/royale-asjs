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

goog.provide('org.apache.flex.binding.GenericBinding');
goog.require('org.apache.flex.binding.BindingBase');

/**
 * @constructor
 */
org.apache.flex.binding.GenericBinding = function() {
};
goog.inherits(org.apache.flex.binding.GenericBinding,
    org.apache.flex.binding.BindingBase);


/**
 * @expose
 * @type {Object}
 */
org.apache.flex.binding.GenericBinding.prototype.destinationData = null;

/**
 * @expose
 * @this {org.apache.flex.binding.GenericBinding}
 * @param {Object} value The strand (owner) of the bead.
 */
org.apache.flex.binding.GenericBinding.prototype.set_strand =
            function(value) {
  this.destination = value;

  var val = this.getValueFromSource();
  this.applyValue(val);
};

/**
 * @expose
 * @this {org.apache.flex.binding.GenericBinding}
 * @return {Object} The value from the source as specified.
 */
org.apache.flex.binding.GenericBinding.prototype.getValueFromSource =
            function() {
    if (typeof(this.source) == 'object' &&
        typeof(this.source.slice) == 'function')
    {
        var arr = this.source;
        var n = arr.length;
        var obj = this.document['get_' + arr[0]]();
        if (obj == null)
            return null;
        for (var i = 1; i < n; i++)
        {
            obj = obj['get_' + arr[i]]();
            if (obj == null)
                return null;
        }
        return obj;
    }
    else if (typeof(this.source) == 'function')
    {
        var fn = this.source;
        obj = fn.apply(this.document);
        return obj;
    }
    else if (typeof(this.source) == 'string')
    {
        obj = this.document['get_' + this.source]();
        return obj;
    }
    return null;
};

/**
 * @expose
 * @this {org.apache.flex.binding.GenericBinding}
 * @param {Object} value The value from the source as specified.
 */
org.apache.flex.binding.GenericBinding.prototype.applyValue =
        function(value)
{
    if (typeof(this.destinationData) == 'object')
    {
        var arr = this.destinationData;
        var n = arr.length;
        var obj = this.document['get_' + arr[0]]();
        if (obj == null)
            return;
        for (var i = 1; i < n - 1; i++)
        {
            obj = obj['get_' + arr[i]]();
            if (obj == null)
                return;
        }
        obj['set_' + arr[n - 1]](value);
    }
    else if (typeof(this.destinationData) == 'function')
    {
        this.destinationData.apply(this.document, [value]);
    }
};

/**
 * @expose
 * @this {org.apache.flex.binding.GenericBinding}
 * @param {Object} value The value from the source as specified.
 */
org.apache.flex.binding.GenericBinding.prototype.valueChanged =
        function(value)
{
    var val = this.getValueFromSource();
    this.applyValue(val);
};

