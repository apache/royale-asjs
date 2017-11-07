/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.royale.graphics.utils
{
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	
	
	/**
	 *  The IAssetLayoutFeatures interface defines the minimum properties and methods 
	 *  required for an Object to support advanced transforms in embedded assets.
	 *  
	 *  @see mx.core.AdvancedLayoutFeatures
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Royale 1.0.0.1
	 */
	public interface IAssetLayoutFeatures
	{
		
		/**
		 *  Layout transform convenience property.  Represents the x value of the layout matrix used in layout and in 
		 *  the computed transform.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 1.0.0.1
		 */
		function set layoutX(value:Number):void;
		
		/**
		 * @private
		 */
		function get layoutX():Number;
		
		/**
		 *  Layout transform convenience property.  Represents the y value of the layout matrix used in layout and in 
		 *  the computed transform.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 1.0.0.1
		 */
		function set layoutY(value:Number):void;
		
		/**
		 * @private
		 */
		function get layoutY():Number;
		
		/**
		 *  Layout transform convenience property.  Represents the z value of the layout matrix used in layout and in 
		 *  the computed transform.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 1.0.0.1
		 */
		function set layoutZ(value:Number):void;
		
		/**
		 * @private
		 */
		function get layoutZ():Number;
		
		/**
		 *  Used by the mirroring transform. See the mirror property.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 1.0.0.1
		 */
		function get layoutWidth():Number;
		
		/**
		 *  @private
		 */
		function set layoutWidth(value:Number):void;
		
		//------------------------------------------------------------------------------
		
		/**
		 *  The x value of the point around which any rotation and scale is performed in both the layout and computed matrix.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 1.0.0.1
		 */
		function set transformX(value:Number):void;
		/**
		 * @private
		 */
		function get transformX():Number;
		
		/**
		 *  The y value of the point around which any rotation and scale is performed in both the layout and computed matrix.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 1.0.0.1
		 */
		function set transformY(value:Number):void;
		
		/**
		 * @private
		 */
		function get transformY():Number;
		
		/**
		 *  The z value of the point around which any rotation and scale is performed in both the layout and computed matrix.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 1.0.0.1
		 */
		function set transformZ(value:Number):void;
		
		/**
		 * @private
		 */
		function get transformZ():Number;
		
		//------------------------------------------------------------------------------
		
		/**
		 *  Layout transform convenience property.  Represents the rotation around the X axis of the layout matrix used in layout and in 
		 *  the computed transform.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 1.0.0.1
		 */
		function set layoutRotationX(value:Number):void;
		
		/**
		 * @private
		 */
		function get layoutRotationX():Number;
		
		/**
		 *  Layout transform convenience property.  Represents the rotation around the Y axis of the layout matrix used in layout and in 
		 *  the computed transform.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 1.0.0.1
		 */
		function set layoutRotationY(value:Number):void;
		
		/**
		 * @private
		 */
		function get layoutRotationY():Number;
		
		/**
		 *  Layout transform convenience property.  Represents the rotation around the Z axis of the layout matrix used in layout and in 
		 *  the computed transform.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 1.0.0.1
		 */
		function set layoutRotationZ(value:Number):void;
		
		/**
		 * @private
		 */
		function get layoutRotationZ():Number;
		
		//------------------------------------------------------------------------------
		
		/**
		 *  Layout transform convenience property.  Represents the scale along the X axis of the layout matrix used in layout and in 
		 *  the computed transform.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 1.0.0.1
		 */
		function set layoutScaleX(value:Number):void;
		
		/**
		 * @private
		 */
		function get layoutScaleX():Number;
		
		/**
		 *  Layout transform convenience property.  Represents the scale along the Y axis of the layout matrix used in layout and in 
		 *  the computed transform.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 1.0.0.1
		 */
		function set layoutScaleY(value:Number):void;
		
		/**
		 * @private
		 */
		function get layoutScaleY():Number;
		
		/**
		 *  Layout transform convenience property.  Represents the scale along the Z axis of the layout matrix used in layout and in 
		 *  the computed transform.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 1.0.0.1
		 */
		function set layoutScaleZ(value:Number):void;
		
		/**
		 * @private
		 */
		function get layoutScaleZ():Number;
		
		/**
		 *  The 2D matrix used during layout calculations to determine the layout and size of the component and its parent and siblings.
		 *  
		 *   @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 1.0.0.1
		 */
		function set layoutMatrix(value:Matrix):void;
		
		/**
		 * @private
		 */
		function get layoutMatrix():Matrix;
		
		/**
		 *  The 3D matrix used during layout calculations to determine the layout and size of the component and its parent and siblings.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 1.0.0.1
		 */
		function set layoutMatrix3D(value:Matrix3D):void;
		
		/**
		 * @private
		 */
		function get layoutMatrix3D():Matrix3D;
		
		/**
		 *  True if the computed transform has 3D values.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 1.0.0.1
		 */
		function get is3D():Boolean;
		
		/**
		 *  True if the layout transform has 3D values.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 1.0.0.1
		 */
		function get layoutIs3D():Boolean;
		
		/**
		 *  If true the X axis is scaled by -1 and the x coordinate of the origin
		 *  is translated by the component's width.  
		 * 
		 *  The net effect of this "mirror" transform is to flip the direction 
		 *  that the X axis increases in without changing the layout element's 
		 *  location relative to the parent's origin.
		 * 
		 *  @default false
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 1.0.0.1
		 */
		function get mirror():Boolean;
		
		/**
		 *  @private
		 */
		function set mirror(value:Boolean):void;
		
		
		/**
		 *  The stretchY is the horizontal component of the stretch scale factor which
		 *  is applied before any other transformation property.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 1.0.0.1
		 */
		function get stretchX():Number;
		
		/**
		 *  @private
		 */
		function set stretchX(value:Number):void;
		
		/**
		 *  The stretchY is the vertical component of the stretch scale factor which
		 *  is applied before any other transformation property.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 1.0.0.1
		 */
		function get stretchY():Number;
		
		/**
		 *  @private
		 */
		function set stretchY(value:Number):void;
		
		//------------------------------------------------------------------------------
		
		/**
		 *  The computed matrix, calculated by combining the layout matrix and any offsets provided.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 1.0.0.1
		 */
		function get computedMatrix():Matrix;
		
		/**
		 *  The computed 3D matrix, calculated by combining the 3D layout matrix and any offsets provided.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 1.0.0.1
		 */
		function get computedMatrix3D():Matrix3D;
	}
}
