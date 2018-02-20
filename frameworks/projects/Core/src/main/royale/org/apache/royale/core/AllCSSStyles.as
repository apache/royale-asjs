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
package org.apache.royale.core
{
	import org.apache.royale.events.Event;
	import org.apache.royale.events.EventDispatcher;

    /**
     *  The AllCSSStyles class contains all CSS style supported in HTML.
     *  It is not advisable to use this class in production code because it will unnecessarily inflate your code size.
     *  Rather, you should copy the class and trim it down in your app to the specific styles you use.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     * 
     *  @royalesuppresspublicvarwarning
     */
	public class AllCSSStyles 
	{
        public var styleList:Object = {
            "additiveSymbols":1,
            "alignContent":1,
            "alignItems":1,
            "alignSelf":1,
            "all":1,
            "animation":1,
            "animationDelay":1,
            "animationDirection":1,
            "animationDuration":1,
            "animationFillMode":1,
            "animationIterationCount":1,
            "animationName":1,
            "animationPlayState":1,
            "animationTimingFunction":1,
            "backfaceVisibility":1,
            "background":1,
            "backgroundAttachment":1,
            "backgroundBlendMode":1,
            "backgroundClip":1,
            "backgroundColor":1,
            "backgroundImage":1,
            "backgroundOrigin":1,
            "backgroundPosition":1,
            "backgroundRepeat":1,
            "backgroundSize":1,
            "blockSize":1,
            "border":1,
            "borderBlockEnd":1,
            "borderBlockEndColor":1,
            "borderBlockEndStyle":1,
            "borderBlockEndWidth":1,
            "borderBlockStart":1,
            "borderBlockStartColor":1,
            "borderBlockStartStyle":1,
            "borderBlockStartWidth":1,
            "borderBottom":1,
            "borderBottomColor":1,
            "borderBottomLeftRadius":1,
            "borderBottomRightRadius":1,
            "borderBottomStyle":1,
            "borderBottomWidth":1,
            "borderCollapse":1,
            "borderColor":1,
            "borderImage":1,
            "borderImageOutset":1,
            "borderImageRepeat":1,
            "borderImageSlice":1,
            "borderImageSource":1,
            "borderImageWidth":1,
            "borderInlineEnd":1,
            "borderInlineEndColor":1,
            "borderInlineEndStyle":1,
            "borderInlineEndWidth":1,
            "borderInlineStart":1,
            "borderInlineStartColor":1,
            "borderInlineStartStyle":1,
            "borderInlineStartWidth":1,
            "borderLeft":1,
            "borderLeftColor":1,
            "borderLeftStyle":1,
            "borderLeftWidth":1,
            "borderRadius":1,
            "borderRight":1,
            "borderRightColor":1,
            "borderRightStyle":1,
            "borderRightWidth":1,
            "borderSpacing":1,
            "borderStyle":1,
            "borderTop":1,
            "borderTopColor":1,
            "borderTopLeftRadius":1,
            "borderTopRightRadius":1,
            "borderTopStyle":1,
            "borderTopWidth":1,
            "borderWidth":1,
            "bottom":1,
            "boxDecorationBreak":1,
            "boxShadow":1,
            "boxSizing":1,
            "breakAfter":1,
            "breakBefore":1,
            "breakInside":1,
            "captionSide":1,
            "caretColor":1,
            "clear":1,
            "clip":1,
            "clipPath":1,
            "color":1,
            "columnCount":1,
            "columnFill":1,
            "columnGap":1,
            "columnRule":1,
            "columnRuleColor":1,
            "columnRuleStyle":1,
            "columnRuleWidth":1,
            "columnSpan":1,
            "columnWidth":1,
            "columns":1,
            "content":1,
            "counter":1,
            "counterIncrement":1,
            "counterReset":1,
            "cursor":1,
            "direction":1,
            "display":1,
            "emptyCells":1,
            "fallback":1,
            "filter":1,
            "fitContent":1,
            "flex":1,
            "flexBasis":1,
            "flexDirection":1,
            "flexFlow":1,
            "flexGrow":1,
            "flexShrink":1,
            "flexWrap":1,
            "float":1,
            "font":1,
            "fontFamily":1,
            "fontFeatureSettings":1,
            "fontKerning":1,
            "fontLanguageOverride":1,
            "fontSize":1,
            "fontSizeAdjust":1,
            "fontStretch":1,
            "fontStyle":1,
            "fontSynthesis":1,
            "fontVariant":1,
            "fontVariantAlternates":1,
            "fontVariantCaps":1,
            "fontVariantEastAsian":1,
            "fontVariantLigatures":1,
            "fontVariantNumeric":1,
            "fontVariantPosition":1,
            "fontWeight":1,
            "grad":1,
            "grid":1,
            "gridArea":1,
            "gridAutoColumns":1,
            "gridAutoFlow":1,
            "gridAutoRows":1,
            "gridColumn":1,
            "gridColumnEnd":1,
            "gridColumnGap":1,
            "gridColumnStart":1,
            "gridGap":1,
            "gridRow":1,
            "gridRowEnd":1,
            "gridRowGap":1,
            "gridRowStart":1,
            "gridTemplate":1,
            "gridTemplateAreas":1,
            "gridTemplateColumns":1,
            "gridTemplateRows":1,
            "height":1,
            "hyphens":1,
            "imageOrientation":1,
            "imageRendering":1,
            "imageResolution":1,
            "imeMode":1,
            "inherit":1,
            "initial":1,
            "inlineSize":1,
            "isolation":1,
            "justifyContent":1,
            "left":1,
            "letterSpacing":1,
            "lineBreak":1,
            "lineHeight":1,
            "listStyle":1,
            "listStyleImage":1,
            "listStylePosition":1,
            "listStyleType":1,
            "margin":1,
            "marginBlockEnd":1,
            "marginBlockStart":1,
            "marginBottom":1,
            "marginInlineEnd":1,
            "marginInlineStart":1,
            "marginLeft":1,
            "marginRight":1,
            "marginTop":1,
            "mask":1,
            "maskClip":1,
            "maskComposite":1,
            "maskImage":1,
            "maskMode":1,
            "maskOrigin":1,
            "maskPosition":1,
            "maskRepeat":1,
            "maskSize":1,
            "maskType":1,
            "maxHeight":1,
            "maxWidth":1,
            "maxZoom":1,
            "minBlockSize":1,
            "minHeight":1,
            "minInlineSize":1,
            "minWidth":1,
            "minZoom":1,
            "mixBlendMode":1,
            "negative":1,
            "objectFit":1,
            "objectPosition":1,
            "offsetBlockEnd":1,
            "offsetBlockStart":1,
            "offsetInlineEnd":1,
            "offsetInlineStart":1,
            "opacity":1,
            "order":1,
            "orientation":1,
            "orphans":1,
            "outline":1,
            "outlineColor":1,
            "outlineOffset":1,
            "outlineStyle":1,
            "outlineWidth":1,
            "overflow":1,
            "overflowWrap":1,
            "overflowX":1,
            "overflowY":1,
            "pad":1,
            "padding":1,
            "paddingBlockEnd":1,
            "paddingBlockStart":1,
            "paddingBottom":1,
            "paddingInlineEnd":1,
            "paddingInlineStart":1,
            "paddingLeft":1,
            "paddingRight":1,
            "paddingTop":1,
            "pageBreakAfter":1,
            "pageBreakBefore":1,
            "pageBreakInside":1,
            "perspective":1,
            "perspectiveOrigin":1,
            "pointerEvents":1,
            "position":1,
            "prefix":1,
            "quotes":1,
            "range":1,
            "resize":1,
            "revert":1,
            "right":1,
            "rubyAlign":1,
            "rubyMerge":1,
            "rubyPosition":1,
            "scrollSnapCoordinate":1,
            "scrollSnapDestination":1,
            "scrollSnapType":1,
            "shapeImageThreshold":1,
            "shapeMargin":1,
            "shapeOutside":1,
            "speakAs":1,
            "src":1,
            "suffix":1,
            "tabSize":1,
            "tableLayout":1,
            "textAlign":1,
            "textAlignLast":1,
            "textCombineUpright":1,
            "textDecoration":1,
            "textDecorationColor":1,
            "textDecorationLine":1,
            "textDecorationStyle":1,
            "textEmphasis":1,
            "textEmphasisColor":1,
            "textEmphasisPosition":1,
            "textEmphasisStyle":1,
            "textIndent":1,
            "textOrientation":1,
            "textOverflow":1,
            "textRendering":1,
            "textShadow":1,
            "textTransform":1,
            "textUnderlinePosition":1,
            "top":1,
            "touchAction":1,
            "transform":1,
            "transformBox":1,
            "transformOrigin":1,
            "transformStyle":1,
            "transition":1,
            "transitionDelay":1,
            "transitionDuration":1,
            "transitionProperty":1,
            "transitionTimingFunction":1,
            "turn":1,
            "unicodeBidi":1,
            "unicodeRange":1,
            "unset":1,
            "userZoom":1,
            "verticalAlign":1,
            "visibility":1,
            "vmax":1,
            "vmin":1,
            "whiteSpace":1,
            "widows":1,
            "width":1,
            "willChange":1,
            "wordBreak":1,
            "wordSpacing":1,
            "wordWrap":1,
            "writingMode":1,
            "zIndex":1,
            "zoom":1
        };

        // it should be ok if these properties get renamed since they will be
        // set by name from MXML and read by name by the StylesImpl.  If AS
        // code tries to write to these objects then they will need 
        // protection from renaming
        public var additiveSymbols:*;
        public var alignContent:*;
        public var alignItems:*;
        public var alignSelf:*;
        public var all:*;
        public var animation:*;
        public var animationDelay:*;
        public var animationDirection:*;
        public var animationDuration:*;
        public var animationFillMode:*;
        public var animationIterationCount:*;
        public var animationName:*;
        public var animationPlayState:*;
        public var animationTimingFunction:*;
        public var backfaceVisibility:*;
        public var background:*;
        public var backgroundAttachment:*;
        public var backgroundBlendMode:*;
        public var backgroundClip:*;
        public var backgroundColor:*;
        public var backgroundImage:*;
        public var backgroundOrigin:*;
        public var backgroundPosition:*;
        public var backgroundRepeat:*;
        public var backgroundSize:*;
        public var blockSize:*;
        public var border:*;
        public var borderBlockEnd:*;
        public var borderBlockEndColor:*;
        public var borderBlockEndStyle:*;
        public var borderBlockEndWidth:*;
        public var borderBlockStart:*;
        public var borderBlockStartColor:*;
        public var borderBlockStartStyle:*;
        public var borderBlockStartWidth:*;
        public var borderBottom:*;
        public var borderBottomColor:*;
        public var borderBottomLeftRadius:*;
        public var borderBottomRightRadius:*;
        public var borderBottomStyle:*;
        public var borderBottomWidth:*;
        public var borderCollapse:*;
        public var borderColor:*;
        public var borderImage:*;
        public var borderImageOutset:*;
        public var borderImageRepeat:*;
        public var borderImageSlice:*;
        public var borderImageSource:*;
        public var borderImageWidth:*;
        public var borderInlineEnd:*;
        public var borderInlineEndColor:*;
        public var borderInlineEndStyle:*;
        public var borderInlineEndWidth:*;
        public var borderInlineStart:*;
        public var borderInlineStartColor:*;
        public var borderInlineStartStyle:*;
        public var borderInlineStartWidth:*;
        public var borderLeft:*;
        public var borderLeftColor:*;
        public var borderLeftStyle:*;
        public var borderLeftWidth:*;
        public var borderRadius:*;
        public var borderRight:*;
        public var borderRightColor:*;
        public var borderRightStyle:*;
        public var borderRightWidth:*;
        public var borderSpacing:*;
        public var borderStyle:*;
        public var borderTop:*;
        public var borderTopColor:*;
        public var borderTopLeftRadius:*;
        public var borderTopRightRadius:*;
        public var borderTopStyle:*;
        public var borderTopWidth:*;
        public var borderWidth:*;
        public var bottom:*;
        public var boxDecorationBreak:*;
        public var boxShadow:*;
        public var boxSizing:*;
        public var breakAfter:*;
        public var breakBefore:*;
        public var breakInside:*;
        public var captionSide:*;
        public var caretColor:*;
        public var clear:*;
        public var clip:*;
        public var clipPath:*;
        public var color:*;
        public var columnCount:*;
        public var columnFill:*;
        public var columnGap:*;
        public var columnRule:*;
        public var columnRuleColor:*;
        public var columnRuleStyle:*;
        public var columnRuleWidth:*;
        public var columnSpan:*;
        public var columnWidth:*;
        public var columns:*;
        public var content:*;
        public var counter:*;
        public var counterIncrement:*;
        public var counterReset:*;
        public var cursor:*;
        public var direction:*;
        public var display:*;
        public var emptyCells:*;
        public var fallback:*;
        public var filter:*;
        public var fitContent:*;
        public var flex:*;
        public var flexBasis:*;
        public var flexDirection:*;
        public var flexFlow:*;
        public var flexGrow:*;
        public var flexShrink:*;
        public var flexWrap:*;
        public var float:*;
        public var font:*;
        public var fontFamily:*;
        public var fontFeatureSettings:*;
        public var fontKerning:*;
        public var fontLanguageOverride:*;
        public var fontSize:*;
        public var fontSizeAdjust:*;
        public var fontStretch:*;
        public var fontStyle:*;
        public var fontSynthesis:*;
        public var fontVariant:*;
        public var fontVariantAlternates:*;
        public var fontVariantCaps:*;
        public var fontVariantEastAsian:*;
        public var fontVariantLigatures:*;
        public var fontVariantNumeric:*;
        public var fontVariantPosition:*;
        public var fontWeight:*;
        public var grad:*;
        public var grid:*;
        public var gridArea:*;
        public var gridAutoColumns:*;
        public var gridAutoFlow:*;
        public var gridAutoRows:*;
        public var gridColumn:*;
        public var gridColumnEnd:*;
        public var gridColumnGap:*;
        public var gridColumnStart:*;
        public var gridGap:*;
        public var gridRow:*;
        public var gridRowEnd:*;
        public var gridRowGap:*;
        public var gridRowStart:*;
        public var gridTemplate:*;
        public var gridTemplateAreas:*;
        public var gridTemplateColumns:*;
        public var gridTemplateRows:*;
        public var height:*;
        public var hyphens:*;
        public var imageOrientation:*;
        public var imageRendering:*;
        public var imageResolution:*;
        public var imeMode:*;
        public var inherit:*;
        public var initial:*;
        public var inlineSize:*;
        public var isolation:*;
        public var justifyContent:*;
        public var left:*;
        public var letterSpacing:*;
        public var lineBreak:*;
        public var lineHeight:*;
        public var listStyle:*;
        public var listStyleImage:*;
        public var listStylePosition:*;
        public var listStyleType:*;
        public var margin:*;
        public var marginBlockEnd:*;
        public var marginBlockStart:*;
        public var marginBottom:*;
        public var marginInlineEnd:*;
        public var marginInlineStart:*;
        public var marginLeft:*;
        public var marginRight:*;
        public var marginTop:*;
        public var mask:*;
        public var maskClip:*;
        public var maskComposite:*;
        public var maskImage:*;
        public var maskMode:*;
        public var maskOrigin:*;
        public var maskPosition:*;
        public var maskRepeat:*;
        public var maskSize:*;
        public var maskType:*;
        public var maxHeight:*;
        public var maxWidth:*;
        public var maxZoom:*;
        public var minBlockSize:*;
        public var minHeight:*;
        public var minInlineSize:*;
        public var minWidth:*;
        public var minZoom:*;
        public var mixBlendMode:*;
        public var negative:*;
        public var objectFit:*;
        public var objectPosition:*;
        public var offsetBlockEnd:*;
        public var offsetBlockStart:*;
        public var offsetInlineEnd:*;
        public var offsetInlineStart:*;
        public var opacity:*;
        public var order:*;
        public var orientation:*;
        public var orphans:*;
        public var outline:*;
        public var outlineColor:*;
        public var outlineOffset:*;
        public var outlineStyle:*;
        public var outlineWidth:*;
        public var overflow:*;
        public var overflowWrap:*;
        public var overflowX:*;
        public var overflowY:*;
        public var pad:*;
        public var padding:*;
        public var paddingBlockEnd:*;
        public var paddingBlockStart:*;
        public var paddingBottom:*;
        public var paddingInlineEnd:*;
        public var paddingInlineStart:*;
        public var paddingLeft:*;
        public var paddingRight:*;
        public var paddingTop:*;
        public var pageBreakAfter:*;
        public var pageBreakBefore:*;
        public var pageBreakInside:*;
        public var perspective:*;
        public var perspectiveOrigin:*;
        public var pointerEvents:*;
        public var position:*;
        public var prefix:*;
        public var quotes:*;
        public var range:*;
        public var resize:*;
        public var revert:*;
        public var right:*;
        public var rubyAlign:*;
        public var rubyMerge:*;
        public var rubyPosition:*;
        public var scrollSnapCoordinate:*;
        public var scrollSnapDestination:*;
        public var scrollSnapType:*;
        public var shapeImageThreshold:*;
        public var shapeMargin:*;
        public var shapeOutside:*;
        public var speakAs:*;
        public var src:*;
        public var suffix:*;
        public var tabSize:*;
        public var tableLayout:*;
        public var textAlign:*;
        public var textAlignLast:*;
        public var textCombineUpright:*;
        public var textDecoration:*;
        public var textDecorationColor:*;
        public var textDecorationLine:*;
        public var textDecorationStyle:*;
        public var textEmphasis:*;
        public var textEmphasisColor:*;
        public var textEmphasisPosition:*;
        public var textEmphasisStyle:*;
        public var textIndent:*;
        public var textOrientation:*;
        public var textOverflow:*;
        public var textRendering:*;
        public var textShadow:*;
        public var textTransform:*;
        public var textUnderlinePosition:*;
        public var top:*;
        public var touchAction:*;
        public var transform:*;
        public var transformBox:*;
        public var transformOrigin:*;
        public var transformStyle:*;
        public var transition:*;
        public var transitionDelay:*;
        public var transitionDuration:*;
        public var transitionProperty:*;
        public var transitionTimingFunction:*;
        public var turn:*;
        public var unicodeBidi:*;
        public var unicodeRange:*;
        public var unset:*;
        public var userZoom:*;
        public var verticalAlign:*;
        public var visibility:*;
        public var vmax:*;
        public var vmin:*;
        public var whiteSpace:*;
        public var widows:*;
        public var width:*;
        public var willChange:*;
        public var wordBreak:*;
        public var wordSpacing:*;
        public var wordWrap:*;
        public var writingMode:*;
        public var zIndex:*;
        public var zoom:*;
	}
}
