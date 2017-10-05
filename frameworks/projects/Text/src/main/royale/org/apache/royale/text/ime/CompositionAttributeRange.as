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
package org.apache.royale.text.ime
{

//
// CompositionAttributeRange
//

/**
* The CompositionAttributeRange class represents a range of composition attributes for use with IME events. 
* For example, when editing text in the IME, the text is divided by the IME into composition ranges.
* These composition ranges are flagged as selected (i.e. currently being lengthened, shortened, or edited),
* and/or converted (i.e. they have made one pass through the IME dictionary lookup already).
*
* <p>By convention, the client should adorn these composition ranges with underlining or hiliting according to
* the flags.</p>
*
* <p>For example:</p>
* <listing>
*      !converted              = thick gray underline (raw text)
*      !selected &#38;&#38; converted  = thin black underline
*       selected &#38;&#38; converted  = thick black underline
* </listing>
* @playerversion Flash 10.1
 * @playerversion AIR 1.5
* @langversion 3.0
*/
public final class CompositionAttributeRange
{
	/**
	 * The relative start from the beginning of the inline edit session
	 * i.e. 0 = the start of the text the IME can see (there may be text 
	 * before that in the edit field)
	 * 
	 * @helpid 
	 * 
	 * @playerversion Flash 10.1
	 * @langversion 3.0
	 * 
	*/
	public var relativeStart:int;

	/**
	 * The relative end of the composition clause, relative to the beginning
	 * of the inline edit session.
	 * i.e. 0 = the start of the text the IME can see (there may be text 
	 * before that in the edit field)
	 * 
	 * @helpid 
	 * 
	 * @playerversion Flash 10.1
	 * @langversion 3.0
	 * 
	*/
	public var relativeEnd:int;

	/**
	 * The selected flag, meaning this composition clause is active and 
	 * being lengthened or shortened or edited with the IME, and the neighboring
	 * clauses are not.
	 * 
	 * @helpid 
	 * 
	 * @playerversion Flash 10.1
	 * @langversion 3.0
	 * 
	*/
	public var selected:Boolean;

	/**
	 * The converted flag, meaning this clause has been processed by the IME
	 * and is awaiting acceptance/confirmation by the user
	 * 
	 * @helpid 
	 * 
	 * @playerversion Flash 10.1
	 * @langversion 3.0
	 * 
	*/
	public var converted:Boolean;

	// Constructor
	/**
	 * Creates a CompositionAttributeRange object.
	 *
	 * @playerversion Flash 10.1
	 * @langversion 3.0
	 * 
	 * @param relativeStart  The zero based index of the first character included in the character range.
	 * @param relativeEnd  The zero based index of the last character included in the character range.
	 * @param selected  The selected flag
	 * @param converted  The converted flag
	 *
	 * @tiptext Constructor for CompositionAttributeRange objects.
	 */	
	public function CompositionAttributeRange(relativeStart:int, relativeEnd:int, selected:Boolean, converted:Boolean)
	{
		this.relativeStart = relativeStart;
		this.relativeEnd = relativeEnd;
		this.selected = selected;
		this.converted = converted;
	}
} // end of class
} // end of package
