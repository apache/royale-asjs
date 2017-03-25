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
		import org.apache.flex.text.html.TextLine; TextLine;
		import org.apache.flex.text.html.TextBlock; TextBlock;
		import org.apache.flex.text.html.HTMLTextFactory; HTMLTextFactory;

		import org.apache.flex.text.engine.BreakOpportunity;BreakOpportunity;
		import org.apache.flex.text.engine.CFFHinting;CFFHinting;
		import org.apache.flex.text.engine.ContentElement;ContentElement;
		import org.apache.flex.text.engine.Constants;Constants;
		import org.apache.flex.text.engine.DigitCase;DigitCase;
		import org.apache.flex.text.engine.DigitWidth;DigitWidth;
		import org.apache.flex.text.engine.EastAsianJustifier;EastAsianJustifier;
		import org.apache.flex.text.engine.ElementFormat;ElementFormat;
		import org.apache.flex.text.engine.Fonts;Fonts;
		import org.apache.flex.text.engine.FontDescription;FontDescription;
		import org.apache.flex.text.engine.FontLookup;FontLookup;
		import org.apache.flex.text.engine.FontMetrics;FontMetrics;
		import org.apache.flex.text.engine.FontPosture;FontPosture;
		import org.apache.flex.text.engine.FontWeight;FontWeight;
		import org.apache.flex.text.engine.GraphicElement;GraphicElement;
		import org.apache.flex.text.engine.GroupElement;GroupElement;
		import org.apache.flex.text.engine.GlyphMetrics; GlyphMetrics;
		import org.apache.flex.text.engine.ITextBlock;ITextBlock;
		import org.apache.flex.text.engine.ITextLine;ITextLine;
		import org.apache.flex.text.engine.JustificationStyle;JustificationStyle;
		import org.apache.flex.text.engine.Kerning;Kerning;
		import org.apache.flex.text.engine.LigatureLevel;LigatureLevel;
		import org.apache.flex.text.engine.LineJustification;LineJustification;
		import org.apache.flex.text.engine.RenderingMode;RenderingMode;
		import org.apache.flex.text.engine.SpaceJustifier;SpaceJustifier;
		import org.apache.flex.text.engine.TabAlignment;TabAlignment;
		import org.apache.flex.text.engine.TabStop;TabStop;
		import org.apache.flex.text.engine.TextBaseline;TextBaseline;
		import org.apache.flex.text.engine.TextElement;TextElement;
		import org.apache.flex.text.engine.TextJustifier;TextJustifier;
		import org.apache.flex.text.engine.TextLineCreationResult;TextLineCreationResult;
		import org.apache.flex.text.engine.TextLineMirrorRegion;TextLineMirrorRegion;
		import org.apache.flex.text.engine.TextLineValidity;TextLineValidity;
		import org.apache.flex.text.engine.TextRotation; TextRotation;
		import org.apache.flex.text.engine.TypographicCase; TypographicCase;
		import org.apache.flex.text.events.IMEEvent; IMEEvent;
		import org.apache.flex.text.events.TextEvent; TextEvent;
		import org.apache.flex.text.engine.TextEngine;TextEngine;

		import org.apache.flex.text.ime.IME; IME;
		import org.apache.flex.text.ime.IIMEClient; IIMEClient;
		import org.apache.flex.text.ime.IIMESupport; IIMESupport;
		import org.apache.flex.text.ime.IMEConversionMode; IMEConversionMode;
		import org.apache.flex.text.ime.CompositionAttributeRange; CompositionAttributeRange;
	}
}