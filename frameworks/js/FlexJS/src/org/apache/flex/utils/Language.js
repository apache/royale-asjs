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

goog.provide('org.apache.flex.utils.Language');



/**
 * @constructor
 */
org.apache.flex.utils.Language = function() {
};


/**
 * as()
 *
 * @expose
 * @param {?} leftOperand The lefthand operand of the
 *                        binary as operator in AS3.
 * @param {?} rightOperand The righthand operand of the
 *                         binary operator in AS3.
 * @param {?=} opt_coercion The cast is a coercion,
 *                          throw expception if it fails.
 * @return {?} Returns the lefthand operand if it is of the
 *             type of the righthand operand, otherwise null.
 */
org.apache.flex.utils.Language.as = function(leftOperand, rightOperand, opt_coercion) {
  var error, itIs, message;

  opt_coercion = (opt_coercion !== undefined) ? opt_coercion : false;

  itIs = org.apache.flex.utils.Language.is(leftOperand, rightOperand);

  if (!itIs && opt_coercion) {
    message = 'Type Coercion failed';
    if (TypeError) {
      error = new TypeError(message);
    } else {
      error = new Error(message);
    }
    throw error;
  }

  return (itIs) ? leftOperand : null;
};


/**
 * int()
 *
 * @expose
 * @param {?} value The value to be cast.
 * @return {number}
 */
org.apache.flex.utils.Language._int = function(value) {
  return value >> 0;
};


/**
 * is()
 *
 * @expose
 * @param {?} leftOperand The lefthand operand of the
 *     binary as operator in AS3.
 * @param {?} rightOperand The righthand operand of the
 *     binary operator in AS3.
 * @return {boolean}
 */
org.apache.flex.utils.Language.is = function(leftOperand, rightOperand) {
  var checkInterfaces, superClass;

  // (erikdebruin) we intentionally DON'T do null checks on the
  //               [class].FLEXJS_CLASS_INFO property, as it MUST be
  //               declared for every FLEXJS JS (framework) class

  if (leftOperand && !rightOperand) {
    return false;
  }

  checkInterfaces = function(left) {
    var i, interfaces;

    interfaces = left.FLEXJS_CLASS_INFO.interfaces;
    for (i = interfaces.length - 1; i > -1; i--) {
      if (interfaces[i] === rightOperand) {
        return true;
      }

      if (interfaces[i].prototype.FLEXJS_CLASS_INFO.interfaces) {
        return checkInterfaces(new interfaces[i]());
      }
    }

    return false;
  };

  if ((rightOperand === String && typeof leftOperand === 'string') ||
      (leftOperand instanceof /** @type {Object} */(rightOperand))) {
    return true;
  }

  if (leftOperand.FLEXJS_CLASS_INFO.interfaces) {
    if (checkInterfaces(leftOperand)) {
      return true;
    }
  }

  superClass = leftOperand.constructor.superClass_;
  if (superClass) {
    while (superClass) {
      if (superClass.FLEXJS_CLASS_INFO.interfaces) {
        if (checkInterfaces(superClass)) {
          return true;
        }
      }
      superClass = superClass.constructor.superClass_;
    }
  }

  return false;
};


/**
 * trace()
 *
 * @expose
 * @param {string=} opt_value The message to be written to the console.
 */
org.apache.flex.utils.Language.trace = function(opt_value) {
  var theConsole;

  opt_value = (opt_value !== undefined) ? opt_value : '';

  theConsole = goog.global['console'];

  try {
    if (theConsole && theConsole.log) {
      theConsole.log(opt_value);
    }
  } catch (e) {
    // ignore; at least we tried ;-)
  }
};


/**
 * uint()
 *
 * @expose
 * @param {?} value The value to be cast.
 * @return {number}
 */
org.apache.flex.utils.Language.uint = function(value) {
  return value >>> 0;
};
