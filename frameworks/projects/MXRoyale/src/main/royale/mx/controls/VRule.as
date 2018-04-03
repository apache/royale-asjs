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

package mx.controls
{

import flash.display.Graphics;
import mx.core.UIComponent;

//--------------------------------------
//  Styles
//--------------------------------------

/**
 *  The shadow color of the line. 
 *  <ul>
 *    <li>If <code>strokeWidth</code> is 1, shadowColor
 *    does nothing.</li>
 *    <li>If <code>strokeWidth is 2</code> shadowColor is
 *    the color of the right line.</li>
 *    <li>If <code>strokeWidth</code> is greater than 2, shadowColor
 *    is the color of the bottom and right edges of the rectangle.</li>
 *  </ul>
 *  
 *  @default 0xEEEEEE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="shadowColor", type="uint", format="Color", inherit="yes")]

/**
 *  The color of the line. 
 *  <ul>
 *    <li>If <code>strokeWidth</code> is 1, strokeColor is
 *    the color of the entire line.</li>
 *    <li>If <code>strokeWidth</code> is 2, strokeColor is 
 *    the color of the left line.</li>
 *    <li>If <code>strokeWidth</code> is greater than 2, strokeColor is
 *    the color of the top and left edges of the rectangle.</li>
 *  </ul>
 *  
 *  @default 0xC4CCCC
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="strokeColor", type="uint", format="Color", inherit="yes")]

/**
 *  The thickness of the rule in pixels. 
 *  <ul>
 *    <li>If <code>strokeWidth</code> is 1, 
 *    the rule is a 1-pixel-wide line.</li>
 *    <li>If <code>strokeWidth</code> is 2,
 *    the rule is two adjacent 1-pixel-wide vertical lines.</li>
 *    <li>If <code>strokeWidth</code> is greater than 2,
 *    the rule is a hollow rectangle with 1-pixel-wide edges.</li>
 *  </ul>
 *  
 *  @default 2
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="strokeWidth", type="Number", format="Length", inherit="yes")]
    // Note: stroke-width is inheriting in SVG,
    // although border-width is not inheriting in CSS

//--------------------------------------
//  Other metadata
//--------------------------------------

[IconFile("VRule.png")]

[Alternative(replacement="spark.primitives.Line", since="4.0")]

/**
 *  The VRule control creates a single vertical line.
 *  You typically use this control to create a dividing line
 *  within a container.
 *
 *  <p>The HRule control has the following default properties:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>The default height is 100 pixels, default width is 2 pixels. By default, the VRule control is not resizable; set width and height to percentage values to enable resizing.</td>
 *        </tr>
 *        <tr>
 *           <td>strokeWidth</td>
 *           <td>2 pixels.</td>
 *        </tr>
 *        <tr>
 *           <td>strokeColor</td>
 *           <td>0xC4CCCC.</td>
 *        </tr>
 *        <tr>
 *           <td>shadowColor</td>
 *           <td>0xEEEEEE.</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *  
 *  <p>The <code>&lt;mx:VRule&gt;</code> tag inherits all of the tag attributes
 *  of its superclass, and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;mx:VRule
 *    <strong>Styles</strong>
 *    strokeColor="0xC4CCCC"
 *    shadowColor="0xEEEEEE"
 *    strokeWidth="2"
 *  /&gt;
 *  </pre>
 *  
 *  @includeExample examples/SimpleVRule.mxml
 *  
 *  @see mx.controls.HRule
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
public class VRule extends UIComponent
{
    include "../core/Version.as";

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    private static const DEFAULT_PREFERRED_HEIGHT:Number = 100;

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    public function VRule()
    {
        super();
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
     *  @private
     */
    override protected function measure():void
    {
        super.measure();

        measuredWidth = getStyle("strokeWidth");
        measuredHeight = DEFAULT_PREFERRED_HEIGHT;
    }

    /**
     *  @private
     *  The appearance of our vertical rule is inspired by
     *  the leading browser's rendering of HTML's <VR>.
     *
     *  The only reliable way to draw the 1-pixel lines that are
     *  the borders of the vertical rule is by filling rectangles!
     *  Otherwise, very short lines become antialised, probably because
     *  the Player is trying to render an endcap.
     */
    override protected function updateDisplayList(unscaledWidth:Number,
                                                  unscaledHeight:Number):void
    {
        super.updateDisplayList(unscaledWidth, unscaledHeight);

        var g:Graphics = graphics;
        g.clear();

        // Look up the style properties
        var strokeColor:Number = getStyle("strokeColor");
        var shadowColor:Number = getStyle("shadowColor");
        var strokeWidth:Number = getStyle("strokeWidth");

        // The thickness of the stroke shouldn't be greater than
        // the unscaledWidth of the bounding rectangle.
        if (strokeWidth > unscaledWidth)
            strokeWidth = unscaledWidth;

        // The vertical rule extends from the top edge
        // to the bottom edge of the bounding rectangle and
        // is horizontally centered within the bounding rectangle.
        var left:Number = (unscaledWidth - strokeWidth) / 2;
        var top:Number = 0;
        var right:Number = left + strokeWidth;
        var bottom:Number = unscaledHeight;

        if (strokeWidth == 1)
        {
            // *
            // *
            // *
            // *
            // *
            // *
            // *

            g.beginFill(strokeColor);
            g.drawRect(left, top, right-left, unscaledHeight);
            g.endFill();
        }
        else if (strokeWidth == 2)
        {
            // *o
            // *o
            // *o
            // *o
            // *o
            // *o
            // *o

            g.beginFill(strokeColor);
            g.drawRect(left, top, 1, unscaledHeight);
            g.endFill();

            g.beginFill(shadowColor);
            g.drawRect(right - 1, top, 1, unscaledHeight);
            g.endFill();
        }
        else if (strokeWidth > 2)
        {
            // **o
            // * o
            // * o
            // * o
            // * o
            // * o
            // ooo

            g.beginFill(strokeColor);
            g.drawRect(left, top, right - left - 1, 1);
            g.endFill();

            g.beginFill(shadowColor);
            g.drawRect(right - 1, top, 1, unscaledHeight - 1);
            g.drawRect(left, bottom - 1, right - left, 1);
            g.endFill();

            g.beginFill(strokeColor);
            g.drawRect(left, top + 1, 1, unscaledHeight - 2);
            g.endFill();
        }
    }
}

}
