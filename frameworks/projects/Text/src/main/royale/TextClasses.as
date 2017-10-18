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
package
{
	/**
	*  @private
	*  This class is used to link additional classes into Text.swc
	*  beyond those that are found by dependency analysis starting
	*  from the classes specified in manifest.xml.
	*/
	internal class TextClasses
	{
		import org.apache.royale.text.html.TextLine; TextLine;
		import org.apache.royale.text.html.TextBlock; TextBlock;
		import org.apache.royale.text.html.HTMLTextFactory; HTMLTextFactory;

		import org.apache.royale.text.engine.BreakOpportunity;BreakOpportunity;
		import org.apache.royale.text.engine.CFFHinting;CFFHinting;
		import org.apache.royale.text.engine.ContentElement;ContentElement;
		import org.apache.royale.text.engine.Constants;Constants;
		import org.apache.royale.text.engine.DigitCase;DigitCase;
		import org.apache.royale.text.engine.DigitWidth;DigitWidth;
		import org.apache.royale.text.engine.EastAsianJustifier;EastAsianJustifier;
		import org.apache.royale.text.engine.ElementFormat;ElementFormat;
		import org.apache.royale.text.engine.Fonts;Fonts;
		import org.apache.royale.text.engine.FontDescription;FontDescription;
		import org.apache.royale.text.engine.FontLookup;FontLookup;
		import org.apache.royale.text.engine.FontMetrics;FontMetrics;
		import org.apache.royale.text.engine.FontPosture;FontPosture;
		import org.apache.royale.text.engine.FontWeight;FontWeight;
		import org.apache.royale.text.engine.GraphicElement;GraphicElement;
		import org.apache.royale.text.engine.GroupElement;GroupElement;
		import org.apache.royale.text.engine.GlyphMetrics; GlyphMetrics;
		import org.apache.royale.text.engine.ITextBlock;ITextBlock;
		import org.apache.royale.text.engine.ITextLine;ITextLine;
		import org.apache.royale.text.engine.JustificationStyle;JustificationStyle;
		import org.apache.royale.text.engine.Kerning;Kerning;
		import org.apache.royale.text.engine.LigatureLevel;LigatureLevel;
		import org.apache.royale.text.engine.LineJustification;LineJustification;
		import org.apache.royale.text.engine.RenderingMode;RenderingMode;
		import org.apache.royale.text.engine.SpaceJustifier;SpaceJustifier;
		import org.apache.royale.text.engine.TabAlignment;TabAlignment;
		import org.apache.royale.text.engine.TabStop;TabStop;
		import org.apache.royale.text.engine.TextBaseline;TextBaseline;
		import org.apache.royale.text.engine.TextElement;TextElement;
		import org.apache.royale.text.engine.TextJustifier;TextJustifier;
		import org.apache.royale.text.engine.TextLineCreationResult;TextLineCreationResult;
		import org.apache.royale.text.engine.TextLineMirrorRegion;TextLineMirrorRegion;
		import org.apache.royale.text.engine.TextLineValidity;TextLineValidity;
		import org.apache.royale.text.engine.TextRotation; TextRotation;
		import org.apache.royale.text.engine.TypographicCase; TypographicCase;
		import org.apache.royale.text.events.IMEEvent; IMEEvent;
		import org.apache.royale.text.events.TextEvent; TextEvent;
		import org.apache.royale.text.engine.TextEngine;TextEngine;

		import org.apache.royale.text.ime.IME; IME;
		import org.apache.royale.text.ime.IIMEClient; IIMEClient;
		import org.apache.royale.text.ime.IIMESupport; IIMESupport;
		import org.apache.royale.text.ime.IMEConversionMode; IMEConversionMode;
		import org.apache.royale.text.ime.CompositionAttributeRange; CompositionAttributeRange;
	}
}
