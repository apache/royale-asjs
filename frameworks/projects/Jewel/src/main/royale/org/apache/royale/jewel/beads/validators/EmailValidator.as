////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package org.apache.royale.jewel.beads.validators
{
	import org.apache.royale.events.Event;
	import org.apache.royale.jewel.supportClasses.textinput.TextInputBase;

	/**
	 *  The EmailValidator class is a specialty bead that can be used with
	 *  TextInput control.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class EmailValidator extends StringValidator
	{


		/**
		 * @todo:
		 *    iinvalidCharError="Your e-mail address contains invalid characters."
		 *    invalidDomainError= "The domain in your e-mail address is incorrectly formatted."
		 *    invalidIPDomainError="The IP domain in your e-mail address is incorrectly formatted."
		 *    invalidPeriodsInDomainError="The domain in your e-mail address has consecutive periods."
		 *    missingAtSignError="An at sign (&64;) is missing in your e-mail address."
		 *    missingPeriodInDomainError="The domain in your e-mail address is missing a period."
		 *    missingUsernameError="The username in your e-mail address is missing."
		 *    tooManyAtSignsError="Your e-mail address contains too many &64; characters."
		 */

		/**
		 *  @private
		 */
		private static const DISALLOWED_LOCALNAME_CHARS:String =
				"()<>,;:\\\"[] `~!#$%^&*={}|/?\t\n\r";
		/**
		 *  @private
		 */
		private static const DISALLOWED_DOMAIN_CHARS:String =
				"()<>,;:\\\"[] `~!#$%^&*+={}|/?'\t\n\r";


		/**
		 * Validate a given IP address
		 *
		 * If IP domain, then must follow [x.x.x.x] format
		 * or for IPv6, then follow [x:x:x:x:x:x:x:x] or [x::x:x:x] or some
		 * IPv4 hybrid, like [::x.x.x.x] or [0:00::192.168.0.1]
		 *
		 * @private
		 */
		private static function isValidIPAddress(ipAddr:String):Boolean
		{
			var ipArray:Array = [];
			var pos:int = 0;
			var newpos:int = 0;
			var item:Number;
			var n:int;
			var i:int;

			// if you have :, you're in IPv6 mode
			// if you have ., you're in IPv4 mode

			if (ipAddr.indexOf(":") != -1)
			{
				// IPv6

				// validate by splitting on the colons
				// to make it easier, since :: means zeros,
				// lets rid ourselves of these wildcards in the beginning
				// and then validate normally

				// get rid of unlimited zeros notation so we can parse better
				var hasUnlimitedZeros:Boolean = ipAddr.indexOf("::") != -1;
				if (hasUnlimitedZeros)
				{
					ipAddr = ipAddr.replace(/^::/, "");
					ipAddr = ipAddr.replace(/::/g, ":");
				}

				while (true)
				{
					newpos = ipAddr.indexOf(":", pos);
					if (newpos != -1)
					{
						ipArray.push(ipAddr.substring(pos,newpos));
					}
					else
					{
						ipArray.push(ipAddr.substring(pos));
						break;
					}
					pos = newpos + 1;
				}

				n = ipArray.length;

				const lastIsV4:Boolean = ipArray[n-1].indexOf(".") != -1;

				if (lastIsV4)
				{
					// if no wildcards, length must be 7
					// always, never more than 7
					if ((ipArray.length != 7 && !hasUnlimitedZeros) || (ipArray.length > 7))
						return false;

					for (i = 0; i < n; i++)
					{
						if (i == n-1)
						{
							// IPv4 part...
							return isValidIPAddress(ipArray[i]);
						}

						item = parseInt(ipArray[i], 16);

						if (item != 0)
							return false;
					}
				}
				else
				{

					// if no wildcards, length must be 8
					// always, never more than 8
					if ((ipArray.length != 8 && !hasUnlimitedZeros) || (ipArray.length > 8))
						return false;

					for (i = 0; i < n; i++)
					{
						item = parseInt(ipArray[i], 16);

						if (isNaN(item) || item < 0 || item > 0xFFFF || ipArray[i] == "")
							return false;
					}
				}

				return true;
			}

			if (ipAddr.indexOf(".") != -1)
			{
				// IPv4

				// validate by splling on the periods
				while (true)
				{
					newpos = ipAddr.indexOf(".", pos);
					if (newpos != -1)
					{
						ipArray.push(ipAddr.substring(pos,newpos));
					}
					else
					{
						ipArray.push(ipAddr.substring(pos));
						break;
					}
					pos = newpos + 1;
				}

				if (ipArray.length != 4)
					return false;

				n = ipArray.length;
				for (i = 0; i < n; i++)
				{
					item = Number(ipArray[i]);
					if (isNaN(item) || item < 0 || item > 255 || ipArray[i] == "")
						return false;
				}

				return true;
			}

			return false;
		}

		public static function validateEmail(value:Object):Array
		{
			var results:Array = [];

			// Validate the domain name
			// If IP domain, then must follow [x.x.x.x] format
			// Can not have continous periods.
			// Must have at least one period.
			// Must end in a top level domain name that has 2, 3, 4, or 6 characters.

			var emailStr:String = String(value);
			var username:String = "";
			var domain:String = "";
			var n:int;
			var i:int;

			// Find the @
			var ampPos:int = emailStr.indexOf("@");
			if (ampPos == -1)
			{
				results.push("missingAtSign");
				return results;
			}
			// Make sure there are no extra @s.
			else if (emailStr.indexOf("@", ampPos + 1) != -1)
			{
				results.push("tooManyAtSigns");
				return results;
			}

			// Separate the address into username and domain.
			username = emailStr.substring(0, ampPos);
			domain = emailStr.substring(ampPos + 1);

			// Validate username has no illegal characters
			// and has at least one character.
			var usernameLen:int = username.length;
			if (usernameLen == 0)
			{
				results.push("missingUsername");
				return results;
			}

			for (i = 0; i < usernameLen; i++)
			{
				if (DISALLOWED_LOCALNAME_CHARS.indexOf(username.charAt(i)) != -1)
				{
					results.push("invalidChar");
					return results;
				}
			}

			// name can't start with a dot
			if (username.charAt(0) == '.')
			{
				results.push("invalidChar");
				return results;
			}

			var domainLen:int = domain.length;

			//not in the original flex code:
			if (domainLen == 0)
			{
				results.push("missingDomain");
				return results;
			}

			// check for IP address
			if ((domain.charAt(0) == "[") && (domain.charAt(domainLen - 1) == "]"))
			{
				// Validate IP address
				if (!isValidIPAddress(domain.substring(1, domainLen - 1)))
				{
					results.push("invalidIPDomain");
					return results;
				}
			}
			else
			{
				// Must have at least one period
				var periodPos:int = domain.indexOf(".");
				var nextPeriodPos:int = 0;
				var lastDomain:String = "";

				if (periodPos == -1)
				{
					results.push("missingPeriodInDomain");
					return results;
				}

				while (true)
				{
					nextPeriodPos = domain.indexOf(".", periodPos + 1);
					if (nextPeriodPos == -1)
					{
						lastDomain = domain.substring(periodPos + 1);
						//not in the original flex code:
						if (lastDomain.length == 0) {
							results.push("invalidDomain");
							return results;
						}
						break;
					}
					else if (nextPeriodPos == periodPos + 1)
					{
						results.push("invalidPeriodsInDomain");
						return results;
					}
					periodPos = nextPeriodPos;
				}

				// Check that there are no illegal characters in the domain.
				for (i = 0; i < domainLen; i++)
				{
					if (DISALLOWED_DOMAIN_CHARS.indexOf(domain.charAt(i)) != -1)
					{
						results.push("invalidChar");
						return results;
					}
				}

				// Check that the character immediately after the @ is not a period or an hyphen.
				// And check that the character before the period is not an hyphen.
				if (domain.charAt(0) == "." || domain.charAt(0) == "-" || domain.charAt(periodPos - 1) == "-")
				{
					results.push("invalidDomain");
					return results;
				}
			}

			return results;
		}


		/**
		 *  constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function EmailValidator()
		{
			super();
		}


		private var _invalidEmailError:String = 'Email is not valid';

		/**
		 *  A generic description of any error that occurred when validating the email address
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get invalidEmailError():String{
			return _invalidEmailError;
		}

		public function set invalidEmailError(value:String):void{
			_invalidEmailError = value;
		}


		private var _disabled:Boolean = false;
		/**
		 *  If disabled, this validator always considers its target as 'valid'
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		public function get disabled():Boolean{
			return _disabled;
		}
		public function set disabled(value:Boolean):void{
			if (value != _disabled) {
				_disabled = value;
				if (value) {
					removeErrorTip(this);
				}
			}
		}


		/**
		 *  Override of the base class validate() method to validate a the host textinput as email.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
		override public function validate(event:Event = null):Boolean {
			//always return true if disabled:
			if (_disabled) return true;
			if (super.validate(event)) {
				var txt:TextInputBase = hostComponent as TextInputBase;
				var str:String = txt.text;
				//super.validate already checked 'required'
				//so only perform check here if the string has length
				const performCheck:Boolean = str.length > 0;
				if (performCheck) {
					const errors:Array = validateEmail(str);
					if (errors.length) {
						createErrorTip(invalidEmailError);
					} else {
						destroyErrorTip();
					}
				}

			}
			return !isError;
		}

	}
}
