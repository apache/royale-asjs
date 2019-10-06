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
    import org.apache.royale.jewel.supportClasses.validators.CreditCardValidatorCardType;

    import org.apache.royale.core.IPopUpHost;
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.events.Event;
    import org.apache.royale.utils.UIUtils;

	public class CreditCardValidator extends StringValidator 
	{
		private static const DECIMAL_DIGITS:String = "0123456789";
		
		private static const MISSING_CARD_TYPE:String = "The value being validated doesn't contain a cardType property.";
		private static const MISSING_CARD_NUMBER:String = "The value being validated doesn't contain a cardNumber property.";
		private static const CNS_ATTRIBUTE:String = "The cardNumberSource attribute, '{0}', can not be of type String.";
		private static const CTS_ATTRIBUTE:String = "The cardTypeSource attribute, '{0}', can not be of type String.";
		
		private static const INVALID_FORMAT_CHARS:String = "The allowedFormatChars parameter is invalid. It cannot contain any digits.";
	
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
	
		/**
		 * Constructor.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion Royale 0.9.6
		 */
		public function CreditCardValidator()
		{
			super();
		}

	    /**
		 *  @private
		 *  Storage for the allowedFormatChars property.
		 */
		private var _allowedFormatChars:String = " -";

		/** 
		 *  The set of formatting characters allowed in the
		 *  <code>cardNumber</code> field.
		 *
		 *  @default " -" (space and dash)
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion Royale 0.9.6
		 */
		public function get allowedFormatChars():String
		{
			return _allowedFormatChars;
		}
	
	    /**
		 *  @private
		 */
		public function set allowedFormatChars(value:String):void
		{
			if (value != null)
			{
				var n:int = value.length;
				for (var i:int = 0; i < n; i++)
				{
					if (DECIMAL_DIGITS.indexOf(value.charAt(i)) != -1)
					{
						value = " -";
					}
				}
			}

			_allowedFormatChars = value;
		}
		
	    /**
		 *  @private
		 *  Storage for the invalidCharError property.
		 */
		private var _invalidCharError:String = "Invalid characters in your credit card number. (Enter numbers only.)";
	
		/** 
		 *  Error message when the <code>cardNumber</code> field contains invalid characters.
		 *
		 *  @default "Invalid characters in your credit card number. (Enter numbers only.)"
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion Royale 0.9.6
		 */
		public function get invalidCharError():String
		{
			return _invalidCharError;
		}
	
		/**
		 *  @private
		 */
		public function set invalidCharError(value:String):void
		{
			_invalidCharError = value;
		}

	    /**
		 *  @private
		 *  Storage for the invalidNumberError property.
		 */
		private var _invalidNumberError:String = "The credit card number is invalid.";

		
		/** 
		 *  Error message when the credit card number is invalid.
		 *
		 *  @default "The credit card number is invalid."
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion Royale 0.9.6
		 */
		public function get invalidNumberError():String
		{
			return _invalidNumberError;
		}
	
		/**
		 *  @private
		 */
		public function set invalidNumberError(value:String):void
		{
			_invalidNumberError = value;
		}
	
	    /**
		 *  @private
		 *  Storage for the noNumError property.
		 */
		private var _noNumError:String = "No credit card number is specified.";
		
		/** 
		 *  Error message when the <code>cardNumber</code> field is empty.
		 *
		 *  @default "No credit card number is specified."
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion Royale 0.9.6
		 */
		public function get noNumError():String
		{
			return _noNumError;
		}
	
		/**
		 *  @private
		 */
		public function set noNumError(value:String):void
		{
			_noNumError = value;
		}
		
	    /**
		 *  @private
		 *  Storage for the noTypeError property.
		 */
		private var _noTypeError:String = "No credit card type is specified or the type is not valid.";
		
		/** 
		 *  Error message when the <code>cardType</code> field is blank.
		 *
		 *  @default "No credit card type is specified or the type is not valid."
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion Royale 0.9.6
		 */
		public function get noTypeError():String
		{
			return _noTypeError;
		}
	
		/**
		 *  @private
		 */
		public function set noTypeError(value:String):void
		{
			_noTypeError = value;
		}
	
		//----------------------------------
		//  wrongLengthError
		//----------------------------------
	
	    /**
		 *  @private
		 *  Storage for the wrongLengthError property.
		 */
		private var _wrongLengthError:String = "Your credit card number contains the wrong number of digits.";
		
		/**
		 *  Error message when the <code>cardNumber</code> field contains the wrong
		 *  number of digits for the specified credit card type.
		 *
		 *  @default "Your credit card number contains the wrong number of digits." 
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion Royale 0.9.6
		 */
		public function get wrongLengthError():String
		{
			return _wrongLengthError;
		}
	
		/**
		 *  @private
		 */
		public function set wrongLengthError(value:String):void
		{
			_wrongLengthError = value;
		}
		
		//----------------------------------
		//  wrongTypeError
		//----------------------------------
	
	    /**
		 *  @private
		 *  Storage for the wrongTypeError property.
		 */
		private var _wrongTypeError:String = "Incorrect card type is specified.";

		/** 
		 *  Error message the <code>cardType</code> field contains an invalid credit card type. 
		 *  You should use the predefined constants for the <code>cardType</code> field:
		 *  <code>CreditCardValidatorCardType.MASTER_CARD</code>,
		 *  <code>CreditCardValidatorCardType.VISA</code>, 
		 *  <code>CreditCardValidatorCardType.AMERICAN_EXPRESS</code>,
		 *  <code>CreditCardValidatorCardType.DISCOVER</code>, or 
		 *  <code>CreditCardValidatorCardType.DINERS_CLUB</code>.
		 *
		 *  @default "Incorrect card type is specified."
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion Royale 0.9.6
		 */
		public function get wrongTypeError():String
		{
			return _wrongTypeError;
		}
	
		/**
		 *  @private
		 */
		public function set wrongTypeError(value:String):void
		{
			_wrongTypeError = value;
		}
	
		/**
		 *  Name of the card type property to validate. 
		 *  This attribute is optional, but if you specify the
		 *  <code>cardTypeSource</code> property,
		 *  you should also set this property.
		 *
	     *  <p>In MXML, valid values are:</p>
	     *  <ul>
	     *    <li><code>"American Express"</code></li>
	     *    <li><code>"Diners Club"</code></li>
	     *    <li><code>"Discover"</code></li>
	     *    <li><code>"MasterCard"</code></li>
	     *    <li><code>"Visa"</code></li>
	     *  </ul>
		 *
		 *  <p>In ActionScript, you can use the following constants to set this property:</p>
		 *  <p><code>CreditCardValidatorCardType.AMERICAN_EXPRESS</code>, 
		 *  <code>CreditCardValidatorCardType.DINERS_CLUB</code>,
		 *  <code>CreditCardValidatorCardType.DISCOVER</code>, 
		 *  <code>CreditCardValidatorCardType.MASTER_CARD</code>, and 
		 *  <code>CreditCardValidatorCardType.VISA</code>.</p>
		 *
		 *  @see mx.validators.CreditCardValidatorCardType
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion Royale 0.9.6
		 */
		private var _cardTypeProperty:String;

		public function get cardTypeProperty():String
		{
			return _cardTypeProperty;
		}

		public function set cardTypeProperty(value:String):void
		{
			_cardTypeProperty = value;
		}
		
		/**
		 *  @private
		 *  Storage for the cardTypeSource property.
		 */
		private var _cardTypeSource:Object;
		
		/** 
		 *  Object that contains the value of the card type field.
		 *  If you specify a value for this property, you must also specify
		 *  a value for the <code>cardTypeProperty</code> property. 
		 *  Do not use this property if you set the <code>source</code> 
		 *  and <code>property</code> properties. 
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion Royale 0.9.6
		 */
		public function get cardTypeSource():Object
		{
			return _cardTypeSource;
		}
		
		/**
		 *  @private
		 */
		public function set cardTypeSource(value:Object):void
		{
			if (_cardTypeSource == value)
				return;
	
			_cardTypeSource = value;
			
			//Add default event handler for cardTypeSource
			triggerCardTypeEvent = Event.CHANGE;
		}
		
		private var _triggerCardTypeEvent:String;
		
		/**
		 * Specifies the event that triggers the validation.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion Royale 0.9.6
		 */
		[Bindable(event="triggerCardTypeEventChanged")]
		public function get triggerCardTypeEvent():String
		{
			return _triggerCardTypeEvent;
		}

		public function set triggerCardTypeEvent(value:String):void
		{
			if (triggerCardTypeEvent != value)
			{
				if(cardTypeSource)
				{
					if(triggerCardTypeEvent)
					{
						cardTypeSource.removeEventListener(triggerEvent, validate);
					}

					if(value)
					{
						cardTypeSource.addEventListener(value, validate);
					}
				}

				_triggerCardTypeEvent = value;
				if(hostComponent != null)
				{
					hostComponent.dispatchEvent(new Event("triggerCardTypeEventChanged"));
				}
			}
		}
		
		/**
		 *  Override of the base class validate() method to validate a the host textinput as email.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion Royale 0.9.6
		 */
		override public function validate(event:Event = null):Boolean 
		{
			//always return true if disabled:
			if (super.validate(event)) 
			{
				var value:Object = getValueFromSource();
				var errors:String = validateCreditCard(value);
				if (errors) 
				{
					createErrorTip(errors);
				} 
				else 
				{
					var host:IPopUpHost = UIUtils.findPopUpHost(hostComponent);
					(host as IUIBase).dispatchEvent(new Event("cleanValidationErrors"));
				}

			}
			return !isError;
		}

		/**
		 *  Convenience method for calling a validator.
		 *  Each of the standard Flex validators has a similar convenience method.
		 *
		 *  @param validator The CreditCardValidator instance.
		 *
		 *  @param value A field to validate, which must contain
		 *  the following fields:
		 *  <ul>
		 *    <li><code>cardType</code> - Specifies the type of credit card being validated. 
		 *    Use the static constants
		 *    <code>CreditCardValidatorCardType.MASTER_CARD</code>, 
		 *    <code>CreditCardValidatorCardType.VISA</code>,
		 *    <code>CreditCardValidatorCardType.AMERICAN_EXPRESS</code>,
		 *    <code>CreditCardValidatorCardType.DISCOVER</code>, or
		 *    <code>CreditCardValidatorCardType.DINERS_CLUB</code>.</li>
		 *    <li><code>cardNumber</code> - Specifies the number of the card
		 *    being validated.</li></ul>
		 *
		 *  @param baseField Text representation of the subfield
		 *  specified in the value parameter. 
		 *  For example, if the <code>value</code> parameter
		 *  specifies value.date, the <code>baseField</code> value is "date".
		 *
		 *  @return An Array of ValidationResult objects, with one ValidationResult 
		 *  object for each field examined by the validator. 
		 *
		 *  @see mx.validators.ValidationResult
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10.2
		 * @playerversion AIR 2.6
		 * @productversion Royale 0.9.6
		 */
		private function validateCreditCard(value:Object):String
		{
			// Resource-backed properties of the validator.
			var allowedFormatChars:String = this.allowedFormatChars;

			var valid:String = DECIMAL_DIGITS + allowedFormatChars;
			var cardType:String = value ? value.cardType : null;
			var cardNum:String = value ? value.cardNumber : null;
			var digitsOnlyCardNum:String = "";

			var n:int;
			var i:int;
			
			if (!cardType)
			{
				return MISSING_CARD_TYPE;
			}			
			
			if (!cardNum)
			{
				return MISSING_CARD_NUMBER;
			}
			
	        if (this.required > 1)
	        {
	            if (cardType.length == 0)
	            {
					return this.requiredFieldError;
	            }
	
	            if (!cardNum)
	            {
					return this.requiredFieldError;
	            }
	        }
			
			n = allowedFormatChars.length;
			for (i = 0; i < n; i++)
			{
				if (DECIMAL_DIGITS.indexOf(allowedFormatChars.charAt(i)) != -1)
				{
					return INVALID_FORMAT_CHARS;
				}
			}
			
			if (!cardType)
			{
				return this.noTypeError;
			}
			else if (cardType != CreditCardValidatorCardType.MASTER_CARD &&
					 cardType != CreditCardValidatorCardType.VISA &&
					 cardType != CreditCardValidatorCardType.AMERICAN_EXPRESS &&
					 cardType != CreditCardValidatorCardType.DISCOVER &&
					 cardType != CreditCardValidatorCardType.DINERS_CLUB)
			{
				return this.wrongTypeError;
			}
	
			if (!cardNum)
			{
				return this.noNumError;
			}
	
			if (cardNum)
			{
				n = cardNum.length;
				for (i = 0; i < n; i++)
				{
					var temp:String = "" + cardNum.substring(i, i + 1);
					if (valid.indexOf(temp) == -1)
					{
						return this.invalidCharError;
					}
					
					if (DECIMAL_DIGITS.indexOf(temp) != -1)
					{
						digitsOnlyCardNum += temp;
					}
				}
			}
			
			var cardNumLen:int = digitsOnlyCardNum.toString().length;
			var correctLen:Number = -1;
			var correctLen2:Number = -1;
			var correctPrefixArray:Array = [];
			
			// diner club cards with a beginning digit of 5 need to be treated as
			// master cards. Go to the following link for more info.
			// http://www.globalpaymentsinc.com/myglobal/industry_initiatives/mc-dc-canada.html
			if (cardType == CreditCardValidatorCardType.DINERS_CLUB &&
				digitsOnlyCardNum.charAt(0) == "5")
			{
				cardType = CreditCardValidatorCardType.MASTER_CARD;
			}
			
			switch (cardType)
			{
				case CreditCardValidatorCardType.MASTER_CARD:
				{
					correctLen = 16;
					correctPrefixArray.push("51");
					correctPrefixArray.push("52");
					correctPrefixArray.push("53");
					correctPrefixArray.push("54");
					correctPrefixArray.push("55");
					break;
				}
				case CreditCardValidatorCardType.VISA:
				{
					correctLen = 13;
					correctLen2 = 16;
					correctPrefixArray.push("4");
					break;
				}
				case CreditCardValidatorCardType.AMERICAN_EXPRESS:
				{
					correctLen = 15;
					correctPrefixArray.push("34");
					correctPrefixArray.push("37");
					break;
				}
				case CreditCardValidatorCardType.DISCOVER:
				{
					correctLen = 16;
					correctPrefixArray.push("6011");
					break;
				}
				case CreditCardValidatorCardType.DINERS_CLUB:
				{
					correctLen = 14;
					correctPrefixArray.push("300");
					correctPrefixArray.push("301");
					correctPrefixArray.push("302");
					correctPrefixArray.push("303");
					correctPrefixArray.push("304");
					correctPrefixArray.push("305");
					correctPrefixArray.push("36");
					correctPrefixArray.push("38");
					break;
				}
				default:
				{
					return this.wrongTypeError;
				}
			}
	
			if ((cardNumLen != correctLen) && (cardNumLen != correctLen2)) 
			{ 
				return this.wrongLengthError;
			}
	
			// Validate the prefix
			var foundPrefix:Boolean = false;
			for (i = correctPrefixArray.length - 1; i >= 0; i--)
			{
				if (digitsOnlyCardNum.indexOf(correctPrefixArray[i]) == 0)
				{
					foundPrefix = true;
					break;
				}
			}
	
			if (!foundPrefix)
			{
				return this.invalidNumberError;
			}
	
			// Implement Luhn formula testing of this.cardNumber
			var doubledigit:Boolean = false;
			var checkdigit:int = 0;
			var tempdigit:int;
			for (i = cardNumLen - 1; i >= 0; i--)
			{
				tempdigit = Number(digitsOnlyCardNum.charAt(i));
				if (doubledigit)
				{
					tempdigit *= 2;
					checkdigit += (tempdigit % 10);
					if ((tempdigit / 10) >= 1.0)
						checkdigit++;
					doubledigit = false;
				}
				else
				{
					checkdigit = checkdigit + tempdigit;
					doubledigit = true;
				}
			}
	
			if ((checkdigit % 10) != 0)
			{
				return this.invalidNumberError;
			}
	
			return null;
		}
		
		/**
		 *  @private
		 *  Grabs the data for the validator from two different sources
		 */
		private function getValueFromSource():Object
		{
			var value:Object = {};
			
			if (cardTypeSource && cardTypeProperty)
			{
				value.cardType = cardTypeSource[cardTypeProperty];
			}
			
			value.cardNumber = hostComponent["text"];
			
			return value;
		}
	}
}