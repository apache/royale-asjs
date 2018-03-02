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
    import org.apache.royale.core.IUIBase;
    import org.apache.royale.core.styles.BorderStyles;
    import org.apache.royale.core.layout.EdgeData;
    import org.apache.royale.core.layout.LayoutData;
    import org.apache.royale.core.layout.MarginData;
    
    /**
     *  The IBorderPaddingMarginValuesImpl abstracts how to get
     *  data on the border, padding and margin of a component.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
    public interface IBorderPaddingMarginValuesImpl extends IValuesImpl
	{
        /**
         *  Return the styles needed to determine how to draw the border
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function getBorderStyles(thisObject:IUIBase, state:String = null):BorderStyles;
        
        /**
         *  Return a rectangle that contains the width of the border sides.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function getBorderMetrics(thisObject:IUIBase, state:String = null):EdgeData;
        
        /**
         *  Return a rectangle that contains the width of the padding sides.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function getPaddingMetrics(thisObject:IUIBase, hostWidth:Number = NaN, hostHeight:Number = NaN, state:String = null):EdgeData;
        
        /**
         *  Return a rectangle that contains the width of the border sides
         *  along with the padding.  The space left should be client area.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function getBorderAndPaddingMetrics(thisObject:IUIBase, hostWidth:Number = NaN, hostHeight:Number = NaN, state:String = null):EdgeData;
        
        /**
         *  Return a MarginData that contains the margins for the object.
         *  MarginData is more than just a rectangle as it needs to account
         *  for values like "auto".
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function getMargins(thisObject:IUIBase, hostWidth:Number = NaN, hostHeight:Number = NaN, state:String = null):MarginData;
        
        /**
         *  Return a LayoutData that contains the margins, border and padding for the object.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function getPositions(thisObject:IUIBase, hostWidth:Number = NaN, hostHeight:Number = NaN, state:String = null):EdgeData;
        
        /**
         *  Return a LayoutData that contains the margins, border and padding for the object.
         * 
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function getBorderPaddingAndMargins(thisObject:IUIBase, hostWidth:Number = NaN, hostHeight:Number = NaN, state:String = null):LayoutData;
    }
}
