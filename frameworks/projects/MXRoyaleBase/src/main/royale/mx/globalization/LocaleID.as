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

package mx.globalization
{

/**
 *  The LocaleID class provides methods for parsing and using locale ID names. 
 *  This class supports locale ID names that use the syntax defined by the 
 *  Unicode Technical Standard #35 
 *  (<a href="http://unicode.org/reports/tr35/">http://unicode.org/reports/tr35/</a>).
 *
 *  @langversion 3.0
 *  @playerversion Flash 10.1
 *  @playerversion AIR 2.0
 *  @productversion Royale 0.9.8
 */
public class LocaleID
{
	/**
	 *  Indicates that the user's default linguistic preferences should be used, as
	 *  specified in the user's operating system settings.  For example, such 
	 *  preferences are typically set using the "Control Panel" for Windows, or the
	 *  "System Preferences" in Mac OS X.
	 *
	 *  <p>Using the <code>LocaleID.DEFAULT</code> setting can result in the use of
	 *  a different locale ID name for different kinds of operations. For example,
	 *  one locale could be used for sorting and a different one for formatting.
	 *  This flexibility respects the user preferences, and the class behaves this 
	 *  way by design.</p>
	 *
	 *  <p>This locale identifier is not always the most appropriate one to use.
	 *  For applications running in the browser, the browser's preferred locale 
	 *  could be a better choice.  It is often a good idea to let the user alter 
	 *  the preferred locale ID name setting and preserve that preference in a 
	 *  user profile, cookie, or shared object.</p>
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public static const DEFAULT:String = "i-default";

	/**
	 *  The status of the most recent operation that this LocaleID object 
	 *  performed.  The <code>lastOperationStatus</code> property is set whenever 
	 *  the constructor or a method of this class is called or another property is
	 *  set. For the possible values see the description for each method.
	 *
	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public var lastOperationStatus:String;

	/**
	 *  Returns a slightly more "canonical" locale identifier.
	 *
	 *  <p>This method performs the following conversion to the locale ID name to 
	 *  give it a more canonical form.</p>
	 *
	 *  <ul>
	 *  <li>Proper casing is applied to all of the components.</li>
	 *  <li>Underscores are converted to dashes.</li>
	 *  </ul>
	 *
	 *  <p>No additional processing is performed. For example, aliases are not 
	 *  replaced, and no elements are added or removed.</p>
	 *
	 *  <p>When this method is called and it completes successfully, the 
	 *  <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one 
	 *  of the constants defined in the <code>LastOperationStatus</code> class.</p>
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public var name:String;

	/**
	 *  Constructs a new LocaleID object, given a locale name. The locale name
	 *  must conform to the syntax defined by the Unicode Technical Standard #35 
	 *  (<a href="http://unicode.org/reports/tr35/">http://unicode.org/reports/tr35/</a>).
	 *
	 *  <p>When the constructor completes successfully the 
	 *  <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>When the requested locale ID name is not available then the 
	 *  <code>lastOperationStatus</code> is set to one of the following:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.USING_FALLBACK_WARNING</code></li>
	 *  <li><code>LastOperationStatus.USING_DEFAULT_WARNING</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one 
	 *  of the constants defined in the LastOperationStatus class.</p> 
	 *
	 *  <p>For details on the warnings listed above and other possible values of 
	 *  the <code>lastOperationStatus</code> property see the descriptions in the 
	 *  <code>LastOperationStatus</code> class.</p>
	 *
	 *  @param name A locale ID name, which can also include an optional collation
	 *          string.  For example: <code>"en-US"</code> or 
	 *          <code>"de-DE&#64;collation=phonebook"</code>
	 *
	 *  @throws ArgumentError if the name is null.
	 *
	 *  @see #lastOperationStatus
	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public function LocaleID(name:String)
	{
		this.name = name;
	}
 	 	
	/**
	 *  Returns a list of acceptable locales based on a list of desired locales 
	 *  and a list of the locales that are currently available.
	 *
	 *  <p>The resulting list is sorted according in order of preference.</p>
	 *
	 *  <p>Here is a typical use case for this method:</p>
	 *
	 *  <ul>
	 *  <li>A user specifies a list of languages that she understands (stored in a
	 *  user profile, a browser setting, or a cookie).  The user lists the 
	 *  languages that she understands best first, so the order of the languages in
	 *  the list is relevant.  This list is the "want" list.</li>
	 *  <li>The application is localized into a number of different languages.  
	 *  This list is the "have" list.</li>
	 *  <li>The <code>determinePreferredLocales()</code> method returns an 
	 *  intersection of the two lists, sorted so that the user's preferred 
	 *  languages come first.</li>
	 *  </ul>
	 *
	 *  <p>If this feature is not supported on the current operating system, this 
	 *  method returns a null value.</p>
	 *
	 *  <p>When this method is called and it completes successfully, the 
	 *  <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one 
	 *  of the constants defined in the <code>LastOperationStatus</code> class.</p>
	 *
	 *  @param want A list of the user's preferred locales sorted in order of 
	 *          preference. 
	 *  @param have A list of locales available to the application. The order of 
	 *          this list is not important. 
	 *  @param keyword A keyword to use to help determine the best fit.
	 *
	 *  @return A subset of the available locales, sorted according to the user's 
	 *          preferences.
	 *
	 *  @see #lastOperationStatus
	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public function determinePreferredLocales(want:Vector.<String>, have:Vector.<String>, keyword:String = "userinterface"):Vector.<String>
	{
		return null;
	}

	/**
	 *  Returns an object containing all of the key and value pairs from the 
	 *  LocaleID object.
	 *
	 *  <p>The returned object is structured as a hash table or associative array,
	 *  where each property name represents a key and the value of the property is
	 *  value for that key. For example, the following code lists all of the keys 
	 *  and values obtained from the LocaleID object using the 
	 *  <code>getKeysAndValues()</code> method:</p>
	 *
	 *  <pre>
	 *  var myLocale:LocaleID = new LocaleID("fr-CA");
	 *  var localeData:Object = myLocale.getKeysAndValues();
	 *  for (var propertyName:String in localeData)
	 *  {
	 *    trace(propertyName + " = " + localeData[propertyName]);
	 *  }
	 *  </pre>
	 *
	 *  <p>When this method is called and it completes successfully, the 
	 *  <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one of
	 *  the constants defined in the <code>LastOperationStatus</code> class.</p>
	 *
	 *  @return An Object containing all the keys and values in the LocaleID 
	 *          object, structured as an associative array or hashtable. 
	 *
	 *  @see #lastOperationStatus
	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public function getKeysAndValues():Object
	{
		return null;
	}
 	 	
	/**
	 *  Returns the language code specified by the locale ID name.
	 *
	 *  <p>If the locale name cannot be properly parsed then the language code is
	 *  the same as the full locale name.</p>
	 *
	 *  <p>When this method is called and it completes successfully, the 
	 *  <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one of
	 *  the constants defined in the <code>LastOperationStatus</code> class.</p>
	 *
	 *  @return A two-character language code obtained by parsing the locale ID 
	 *          name.
	 *
	 *  @see #lastOperationStatus
	 *  @see LastOperationStatus	 
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public function getLanguage():String
	{
		return "";
	}
 	 	
	/**
	 *  Returns the region code specified by the locale ID name.
	 *
	 *  <p>This method returns an empty string if the region code cannot be parsed
	 *  or guessed This could occur if an unknown or incomplete locale ID name like
	 *  "xy" is used.  The region code is not validated against a fixed list. For 
	 *  example, the region code returned for a locale ID name of "xx-YY" is 
	 *  "YY".</p>
	 *
	 *  <p>When this method is called and it completes successfully, the 
	 *  <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>If the region is not part of the specified locale name, the most likely
	 *  region code for the locale is "guessed" and 
	 *  <code>lastOperationStatus</code> property is set to 
	 *  <code>LastOperationStatus.USING_FALLBACK_WARNING</code></p>
	 *
       *  <p>Otherwise the <code>lastOperationStatus</code> property is set to 
       *  one of the constants defined in the <code>LastOperationStatus</code> 
       *  class.</p>
	 *
	 *  @return A two-character region code, or an empty string if the region code
	 *          cannot be parsed or otherwise determined from the locale name.
	 *
 	 *  @see #lastOperationStatus
 	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public function getRegion():String
	{
		return "";
	}

	/**
	 *  Returns the script code specified by the locale ID name.
	 *
	 *  <p>This method returns an empty string if the script code cannot be parsed
	 *  or guessed This could occur if an unknown or incomplete locale ID name like
	 *  "xy" is used.  The script code is not validated against a fixed list. For 
	 *  example, the script code returned for a locale ID name of "xx-Abcd-YY" is 
	 *  "Abcd".</p>
	 *
	 *  <p>The region, as well as the language, can also affect the return value. 
	 *  For example, the script code for "mn-MN" (Mongolian-Mongolia) is "Cyrl" 
	 *  (Cyrillic), while the script code for "mn-CN" (Mongolian-China) is "Mong"
	 *  (Mongolian).</p>
	 *
	 *  <p>When this method is called and it completes successfully, the 
	 *  <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>If the script code is not part of the specified locale name, the most 
	 *  likely script code is "guessed" and <code>lastOperationStatus</code> 
	 *  property is set to 
	 *  <code>LastOperationStatus.USING_FALLBACK_WARNING</code>.</p>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one of
	 *  the constants defined in the <code>LastOperationStatus</code> class.</p>
	 *
	 *  @return A four-character script code, or an empty string if the script code
	 *          cannot be parsed or otherwise determined from the locale name. 
	 *
	 *  @see #lastOperationStatus
	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public function getScript():String
	{
		return "";
	}

	/**
	 *  Returns the language variant code specified by the locale ID name.
	 *
	 *  <p>This method returns an empty string if there is no language variant code
	 *  in the given locale ID name.  (No guessing is necessary because few locales
	 *  have or need a language variant.)</p>
	 *
	 *  <p>When this method is called and it completes successfully, the 
	 *  <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one of
	 *  the constants defined in the <code>LastOperationStatus</code> class.</p>
	 *
	 *  @return A language variant code, or an empty string if the locale ID name 
	 *          does not contain a language variant code. 
	 *
	 *  @see #lastOperationStatus
	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public function getVariant():String
	{
		return "";
	}

	/**
	 *  Specifies whether the text direction for the specified locale is right to 
	 *  left.
	 *
	 *  <p>The result can be used to determine the direction of the text in the 
	 *  Flash text engine, and to decide whether to mirror the user interface to 
	 *  support the current text direction.</p>
	 *
	 *  <p>When this method is called and it completes successfully, the
	 *  <code>lastOperationStatus</code> property is set to:</p>
	 *
	 *  <ul>
	 *  <li><code>LastOperationStatus.NO_ERROR</code></li>
	 *  </ul>
	 *
	 *  <p>Otherwise the <code>lastOperationStatus</code> property is set to one of
	 *  the constants defined in the <code>LastOperationStatus</code> class.</p>
	 *
	 *  @return <code>true</code> if the general text flows in a line of text 
	 *          should go from right to left; otherwise <code>false</code>; 
	 *
	 *  @see flashx.textLayout.formats.Direction
	 *  @see #lastOperationStatus
	 *  @see LastOperationStatus
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.1
	 *  @playerversion AIR 2.0
	 *  @productversion Royale 0.9.8
	 */
	public function isRightToLeft():Boolean
	{
		return false;
	}
}

}
