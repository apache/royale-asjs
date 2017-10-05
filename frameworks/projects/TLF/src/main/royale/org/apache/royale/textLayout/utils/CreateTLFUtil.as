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
package org.apache.royale.textLayout.utils
{
	import org.apache.royale.textLayout.debug.assert;
	import org.apache.royale.textLayout.formats.FormatValue;
	import org.apache.royale.textLayout.formats.ITextLayoutFormat;
	import org.apache.royale.textLayout.formats.TextLayoutFormat;
	import org.apache.royale.textLayout.property.Property;
	import org.apache.royale.textLayout.property.PropertyUtil;
	import org.apache.royale.utils.ObjectUtil;
	public class CreateTLFUtil
	{
		public static function createTLF(localStyles:ITextLayoutFormat, parentPrototype:TextLayoutFormat):TextLayoutFormat
		{
			var parentPrototypeUsable:Boolean = true;
			var hasStylesSet:Boolean = false;
			// the actual prototype to use
			var parentStylesPrototype:Object;
			// create a new stylesObject with a parentPrototype
			if (parentPrototype)
			{
				parentStylesPrototype = parentPrototype.getStyles();
				if (parentStylesPrototype.hasNonInheritedStyles !== undefined)
				{
					// its either a boolean or if its been used once an object that has the non-inheriting styles reset
					if (parentStylesPrototype.hasNonInheritedStyles === true)
					{
						// create a modified prototype and give it all default non-inherited values
						var noInheritParentStylesPrototype:Object = PropertyUtil.createObjectWithPrototype(parentStylesPrototype);
						TextLayoutFormat.resetModifiedNoninheritedStyles(noInheritParentStylesPrototype);
						// now save it in the parent for reuse
						parentStylesPrototype.hasNonInheritedStyles = noInheritParentStylesPrototype;
						parentStylesPrototype = noInheritParentStylesPrototype;
					}
					else
					{
						parentStylesPrototype = parentStylesPrototype.hasNonInheritedStyles;
					}
					parentPrototypeUsable = false;	// can't use it
				}
			}
			else
			{
				parentPrototype = TextLayoutFormat.defaultFormat as TextLayoutFormat;
				parentStylesPrototype = parentPrototype.getStyles();
			}

			var stylesObject:Object = PropertyUtil.createObjectWithPrototype(parentStylesPrototype);

			var key:String;
			var val:*;
			var prop:Property;
			// has nonInherited Styles that are *different* from the default
			var hasNonInheritedStyles:Boolean = false;

			// two cases depending on how localStyles are supplied
			if (localStyles != null)
			{
				var lvh:TextLayoutFormat = localStyles as TextLayoutFormat;
				if (lvh)
				{
					var coreStyles:Object = lvh.getStyles();

					for (key in coreStyles)
					{
						val = coreStyles[key];
						if (val == FormatValue.INHERIT)
						{
							if (parentPrototype)
							{
								prop = TextLayoutFormat.description[key];
								if (prop && !prop.inherited)
								{
									// actually do the inheritance - might have been wiped out above!
									val = parentPrototype[key];
									if (stylesObject[key] != val)
									{
										stylesObject[key] = val;
										hasNonInheritedStyles = true;
										hasStylesSet = true;
										// CONFIG::debug { assert(val != prop.defaultValue,"Unexpected non-inheritance"); }
									}
								}
							}
						}
						else
						{
							if (stylesObject[key] != val)
							{
								prop = TextLayoutFormat.description[key];
								if (prop && !prop.inherited)
								{
									// CONFIG::debug { assert(val != prop.defaultValue,"Unexpected non-inheritance"); }
									hasNonInheritedStyles = true;
								}
								stylesObject[key] = val;
								hasStylesSet = true;	// doesn't matter if inherited or not
							}
						}
					}
				}
				else
				{
					for each (prop in TextLayoutFormat.description)
					{
						key = prop.name;
						val = localStyles[key];
						if (val !== undefined)
						{
							if (val == FormatValue.INHERIT)
							{
								if (parentPrototype)
								{
									if (!prop.inherited)
									{
										// actually do the inheritance - might have been wiped out above!
										val = parentPrototype[key];
										if (stylesObject[key] != val)
										{
											stylesObject[key] = val;
											hasNonInheritedStyles = true;
											hasStylesSet = true;
											// CONFIG::debug { assert(val != prop.defaultValue,"Unexpected non-inheritance"); }
										}
									}
								}
							}
							else
							{
								if (stylesObject[key] != val)
								{
									if (!prop.inherited)
									{
										// CONFIG::debug { assert(val != prop.defaultValue,"Unexpected non-inheritance"); }
										hasNonInheritedStyles = true;
									}
									stylesObject[key] = val;
									hasStylesSet = true;	// doesn't matter if inherited or not
								}
							}
						}
					}
				}
			}

			var rslt:TextLayoutFormat;

			if (!hasStylesSet)
			{
				// nothing has changed from the parent so just reuse it
				CONFIG::debug{ assert(hasNonInheritedStyles == false, "stylesCount mismatch with hasNonInheritedStyles"); }
				if (parentPrototypeUsable)
					return parentPrototype;
				// we can use the parentStylesPrototype but not the parentPrototype
				rslt = new TextLayoutFormat();
				rslt.setStyles(stylesObject, true);
				return rslt;
			}

			if (hasNonInheritedStyles)
			{
				// if its not identical in stylesObject need to set it
				CONFIG::debug
				{
					assert(stylesObject.hasNonInheritedStyles !== hasNonInheritedStyles, "unexpected nonInheritedStyles"); }
				stylesObject.hasNonInheritedStyles = true;
				ObjectUtil.addNonEnumerableProperty(stylesObject,"hasNonInheritedStyles", true);
			}
			else if (stylesObject.hasNonInheritedStyles !== undefined)
			{
				ObjectUtil.addNonEnumerableProperty(stylesObject,"hasNonInheritedStyles", undefined);
			}

			rslt = new TextLayoutFormat();
			rslt.setStyles(stylesObject, false);
			return rslt;
		}
		
	}
}
