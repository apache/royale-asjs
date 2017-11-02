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
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.system.Capabilities;
	
	import org.apache.royale.graphics.utils.IAssetLayoutFeatures;
	
	
	/**
	 *  @private
	 *  Transform Offsets can be assigned to any Component or GraphicElement to modify the transform
	 *  of the object beyond where its parent layout places it.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 1.0.0
	 */
	public class AdvancedLayoutFeatures implements IAssetLayoutFeatures
	{
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
		 *  @productversion Royale 1.0.0
		 */
		public function AdvancedLayoutFeatures()
		{
			layout = new CompoundTransform();
		}
		
		
		
		/**
		 * @private
		 * a flag for use by the owning object indicating whether the owning object has a pending update
		 * to the computed matrix.  it is the owner's responsibility to set this flag.
		 */
		public var updatePending:Boolean = false;
		
		/**
		 * storage for the depth value. Layering is considered 'advanced' layout behavior, and not something
		 * that gets used by the majority of the components out there.  So if a component has a non-zero depth,
		 * it will allocate a AdvancedLayoutFeatures object and store the value here.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public var depth:Number = 0;
		
		/**
		 * @private
		 * slots for the various 2D and 3D matrices for layout, offset, and computed transforms.  Note that 
		 * these are only allocated and computed on demand -- many component instances will never use a 3D
		 * matrix, for example. 
		 */
		protected var _computedMatrix:Matrix;
		protected var _computedMatrix3D:Matrix3D;
		
		/**
		 * @private
		 * the layout visible transform as defined by the user and parent layout.
		 */
		protected var layout:CompoundTransform;
		
		/**
		 * @private
		 * offset values applied by the user
		 */
		private var _postLayoutTransformOffsets:TransformOffsets;
		
		/**
		 * @private
		 * bit field flags for indicating which transforms are valid -- the layout properties, the matrices,
		 * and the 3D matrices.  Since developers can set any of the three programmatically, the last one set
		 * will always be valid, and the others will be invalid until validated on demand.
		 */
		private static const COMPUTED_MATRIX_VALID:uint     = 0x1;
		private static const COMPUTED_MATRIX3D_VALID:uint   = 0x2;
		
		/**
		 * @private
		 * general storage for all of our flags.  
		 */
		private var _flags:uint = 0;
		
		/**
		 * @private
		 * static data used by utility methods below
		 */
		private static var reVT:Vector3D = new Vector3D(0,0,0);
		private static var reVR:Vector3D = new Vector3D(0,0,0);
		private static var reVS:Vector3D = new Vector3D(1,1,1);
		
		private static var reV:Vector.<Vector3D> = new Vector.<Vector3D>();
		reV.push(reVT);
		reV.push(reVR);
		reV.push(reVS);
		
		
		private static const RADIANS_PER_DEGREES:Number = Math.PI / 180;
		
		private static const ZERO_REPLACEMENT_IN_3D:Number = .00000000000001;
		
		private static var tempLocalPosition:Vector3D;
		
		/**
		 * @private
		 * a pointer to the function we use to transform vectors, to work around a bug
		 * in early versions of the flash player.
		 */
		private static var transformVector:Function = initTransformVectorFunction;
		
		/**
		 * @private
		 * an actionscript implementation to transform a vector by a matrix. Bugs in early versions of 
		 * flash 10's implementation of Matrix.transformVector force us to do it ourselves in actionscript. 
		 */
		private static function pre10_0_22_87_transformVector(m:Matrix3D,v:Vector3D):Vector3D
		{
			var r:Vector.<Number> = m.rawData;
			return new Vector3D(
				r[0] * v.x + r[4] * v.y + r[8] * v.z + r[12], 
				r[1] * v.x + r[5] * v.y + r[9] * v.z + r[13], 
				r[2] * v.x + r[6] * v.y + r[10] * v.z + r[14],
				1); 
		}
		
		/**
		 * @private
		 * a  function to transform vectors using the built in player API, if we're in a late enough player version
		 * that we won't run into bugs.s
		 */
		private static function nativeTransformVector(m:Matrix3D,v:Vector3D):Vector3D
		{
			return m.transformVector(v);
		}
		
		/**
		 * @private
		 * the first time someone calls transformVector, they'll get this function.  It checks the player version,
		 * and if decides which implementation to use based on whether a bug is present or not.
		 */
		private static function initTransformVectorFunction(m:Matrix3D,v:Vector3D):Vector3D
		{
			var canUseNative:Boolean = false;
			var version:Array = Capabilities.version.split(' ')[1].split(',');
			if (parseFloat(version[0]) > 10)
				canUseNative  = true;
			else if (parseFloat(version[1]) > 0)
				canUseNative  = true;
			else if (parseFloat(version[2]) > 22)
				canUseNative  = true;
			else if (parseFloat(version[3]) >= 87)
				canUseNative  = true;
			if (canUseNative)
				transformVector = nativeTransformVector;
			else
				transformVector = pre10_0_22_87_transformVector;
			
			return transformVector(m,v);
		}
		
		
		//------------------------------------------------------------------------------
		
		/**
		 * layout transform convenience property.  Represents the x value of the layout matrix used in layout and in 
		 * the computed transform.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function set layoutX(value:Number):void
		{
			layout.x = value;
			invalidate();
		}
		
		/**
		 * @private
		 */
		public function get layoutX():Number
		{
			return layout.x;
		}
		/**
		 * layout transform convenience property.  Represents the y value of the layout matrix used in layout and in 
		 * the computed transform.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function set layoutY(value:Number):void
		{
			layout.y = value;
			invalidate();
		}
		
		/**
		 * @private
		 */
		public function get layoutY():Number
		{
			return layout.y;
		}
		
		/**
		 * layout transform convenience property.  Represents the z value of the layout matrix used in layout and in 
		 * the computed transform.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function set layoutZ(value:Number):void
		{
			layout.z = value;
			invalidate();
		}
		
		/**
		 * @private
		 */
		public function get layoutZ():Number
		{
			return layout.z;
		}
		
		//----------------------------------
		//  layoutWidth
		//----------------------------------
		
		private var _layoutWidth:Number = 0;
		
		/**
		 *  Used by the mirroring transform.   See the mirror property.
		 *  @default 0
		 */
		public function get layoutWidth():Number
		{
			return _layoutWidth;
		}
		
		/**
		 *  @private
		 */
		public function set layoutWidth(value:Number):void
		{
			if (value == _layoutWidth)
				return;
			_layoutWidth = value;
			invalidate();
		}
		
		
		//------------------------------------------------------------------------------
		
		/**
		 * @private
		 * the x value of the point around which any rotation and scale is performed in both the layout and computed matrix.
		 */
		public function set transformX(value:Number):void
		{
			layout.transformX = value;
			invalidate();
		}
		/**
		 * @private
		 */
		public function get transformX():Number
		{
			return layout.transformX;
		}
		
		/**
		 * @private
		 * the y value of the point around which any rotation and scale is performed in both the layout and computed matrix.
		 */
		public function set transformY(value:Number):void
		{
			layout.transformY = value;
			invalidate();
		}
		
		/**
		 * @private
		 */
		public function get transformY():Number
		{
			return layout.transformY;
		}
		
		/**
		 * @private
		 * the z value of the point around which any rotation and scale is performed in both the layout and computed matrix.
		 */
		public function set transformZ(value:Number):void
		{
			layout.transformZ = value;  
			invalidate();
		}
		
		/**
		 * @private
		 */
		public function get transformZ():Number
		{
			return layout.transformZ;
		}
		
		//------------------------------------------------------------------------------
		
		
		/**
		 * layout transform convenience property.  Represents the rotation around the X axis of the layout matrix used in layout and in 
		 * the computed transform.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function set layoutRotationX(value:Number):void
		{
			layout.rotationX= value;
			invalidate();
		}
		
		/**
		 * @private
		 */
		public function get layoutRotationX():Number
		{
			return layout.rotationX;
		}
		
		/**
		 * layout transform convenience property.  Represents the rotation around the Y axis of the layout matrix used in layout and in 
		 * the computed transform.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function set layoutRotationY(value:Number):void
		{
			layout.rotationY= value;
			invalidate();
		}
		
		/**
		 * @private
		 */
		public function get layoutRotationY():Number
		{
			return layout.rotationY;
		}
		
		/**
		 * layout transform convenience property.  Represents the rotation around the Z axis of the layout matrix used in layout and in 
		 * the computed transform.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function set layoutRotationZ(value:Number):void
		{
			layout.rotationZ= value;
			invalidate();
		}
		
		/**
		 * @private
		 */
		public function get layoutRotationZ():Number
		{
			return layout.rotationZ;
		}
		
		//------------------------------------------------------------------------------
		
		
		/**
		 * layout transform convenience property.  Represents the scale along the X axis of the layout matrix used in layout and in 
		 * the computed transform.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function set layoutScaleX(value:Number):void
		{
			layout.scaleX = value;
			invalidate();
		}
		
		/**
		 * @private
		 */
		public function get layoutScaleX():Number
		{
			return layout.scaleX;
		}
		
		/**
		 * layout transform convenience property.  Represents the scale along the Y axis of the layout matrix used in layout and in 
		 * the computed transform.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function set layoutScaleY(value:Number):void
		{
			layout.scaleY= value;
			invalidate();
		}
		
		/**
		 * @private
		 */
		public function get layoutScaleY():Number
		{
			return layout.scaleY;
		}
		
		
		/**
		 * layout transform convenience property.  Represents the scale along the Z axis of the layout matrix used in layout and in 
		 * the computed transform.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function set layoutScaleZ(value:Number):void
		{
			layout.scaleZ= value;
			invalidate();
		}
		
		/**
		 * @private
		 */
		public function get layoutScaleZ():Number
		{
			return layout.scaleZ;
		}
		
		/**
		 * @private
		 * The 2D matrix used during layout calculations to determine the layout and size of the component and its parent and siblings.
		 * If the convenience properties are set, this matrix is built from those properties.  
		 * If the matrix is set directly, the convenience properties will be updated to values derived from this matrix.
		 * This matrix is used in the calculation of the computed transform if possible. Under certain circumstances, such as when 
		 * offsets are provided, the decomposed layout properties will be used instead.
		 */
		public function set layoutMatrix(value:Matrix):void
		{
			layout.matrix = value;
			invalidate();
		}
		
		
		/**
		 * @private
		 */
		public function get layoutMatrix():Matrix
		{
			return layout.matrix;
			
		}
		
		
		/**
		 * @private
		 * The 3D matrix used during layout calculations to determine the layout and size of the component and its parent and siblings.
		 * This matrix is only used by parents that respect 3D layoyut.
		 * If the convenience properties are set, this matrix is built from those properties.  
		 * If the matrix is set directly, the convenience properties will be updated to values derived from this matrix.
		 * This matrix is used in the calculation of the computed transform if possible. Under certain circumstances, such as when 
		 * offsets are provided, the decomposed layout properties will be used instead.
		 */
		public function set layoutMatrix3D(value:Matrix3D):void
		{
			layout.matrix3D = value;
			invalidate();
		}
		
		/**
		 * @private
		 */
		public function get layoutMatrix3D():Matrix3D
		{
			return layout.matrix3D;
		}
		
		/**
		 * true if the computed transform has 3D values.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function get is3D():Boolean
		{
			return (layout.is3D || (postLayoutTransformOffsets != null && postLayoutTransformOffsets.is3D));
		}
		
		/**
		 * true if the layout transform has 3D values.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function get layoutIs3D():Boolean
		{
			return layout.is3D;
		}
		
		//------------------------------------------------------------------------------
		
		/** offsets to the transform convenience properties that are applied when a component is rendered. If this 
		 * property is set, its values will be added to the layout transform properties to determine the true matrix used to render
		 * the component
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function set postLayoutTransformOffsets(value:TransformOffsets):void
		{
			if (_postLayoutTransformOffsets != null)
			{
				_postLayoutTransformOffsets.removeEventListener(Event.CHANGE,postLayoutTransformOffsetsChangedHandler);
				_postLayoutTransformOffsets.owner = null;
			}
			_postLayoutTransformOffsets = value;
			if (_postLayoutTransformOffsets != null)
			{
				_postLayoutTransformOffsets.addEventListener(Event.CHANGE,postLayoutTransformOffsetsChangedHandler);
				_postLayoutTransformOffsets.owner = this;
			}
			invalidate();       
		}
		
		public function get postLayoutTransformOffsets():TransformOffsets
		{
			return _postLayoutTransformOffsets;
		}
		
		private function postLayoutTransformOffsetsChangedHandler(e:Event):void
		{
			invalidate();       
		}
		
		//----------------------------------
		//  mirror
		//----------------------------------
		
		private var _mirror:Boolean = false;
		
		/**
		 *  If true the X axis is scaled by -1 and the x coordinate of the origin
		 *  is translated by the component's width.  
		 * 
		 *  The net effect of this "mirror" transform is to flip the direction 
		 *  that the X axis increases in without changing the layout element's 
		 *  location relative to the parent's origin.
		 * 
		 *  @default false
		 */
		public function get mirror():Boolean
		{
			return _mirror;
		}
		
		/**
		 *  @private
		 */
		public function set mirror(value:Boolean):void
		{
			_mirror = value;
			invalidate();
		}
		
		
		//----------------------------------
		//  stretchX
		//----------------------------------
		
		private var _stretchX:Number = 1;
		
		/**
		 *  The stretchY is the horizontal component of the stretch scale factor which
		 *  is applied before any other transformation property.
		 *  @default 1
		 */
		public function get stretchX():Number
		{
			return _stretchX;
		}
		
		/**
		 *  @private
		 */
		public function set stretchX(value:Number):void
		{
			if (value == _stretchX)
				return;         
			_stretchX = value;
			invalidate();
		}
		
		//----------------------------------
		//  stretchY
		//----------------------------------
		
		private var _stretchY:Number = 1;
		
		/**
		 *  The stretchY is the vertical component of the stretch scale factor which
		 *  is applied before any other transformation property.
		 *  @default 1
		 */
		public function get stretchY():Number
		{
			return _stretchY;
		}
		
		/**
		 *  @private
		 */
		public function set stretchY(value:Number):void
		{
			if (value == _stretchY)
				return;         
			_stretchY = value;
			invalidate();
		}
		
		//------------------------------------------------------------------------------
		
		/**
		 * @private
		 * invalidates our various cached values.  Any change to the AdvancedLayoutFeatures object that affects
		 * the various transforms should call this function.    
		 * @param reason - the code indicating what changes to cause the invalidation.
		 * @param affects3D - a flag indicating whether the change affects the 2D/3D nature of the various transforms.
		 * @param dispatchChangeEvent - if true, the AdvancedLayoutFeatures will dispatch a change indicating that its underlying transforms
		 * have been modified. 
		 */
		private function invalidate():void
		{                       
			_flags &= ~COMPUTED_MATRIX_VALID;
			_flags &= ~COMPUTED_MATRIX3D_VALID;
		}
		
		
		/**
		 * the computed matrix, calculated by combining the layout matrix and  and any offsets provided..
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function get computedMatrix():Matrix
		{
			if (_flags & COMPUTED_MATRIX_VALID)
				return _computedMatrix;
			
			if (!postLayoutTransformOffsets && !mirror && stretchX == 1 && stretchY == 1)
			{
				return layout.matrix;
			}           
			
			var m:Matrix = _computedMatrix;
			if (m == null)
				m = _computedMatrix = new Matrix();
			else
				m.identity();
			
			var tx:Number = layout.transformX;
			var ty:Number = layout.transformY;
			var sx:Number = layout.scaleX;
			var sy:Number = layout.scaleY;
			var rz:Number = layout.rotationZ;
			var x:Number = layout.x;
			var y:Number = layout.y;
			
			if (mirror)
			{
				sx *= -1;
				x += layoutWidth;
			}
			
			if (postLayoutTransformOffsets)
			{
				sx *= postLayoutTransformOffsets.scaleX;
				sy *= postLayoutTransformOffsets.scaleY;
				rz += postLayoutTransformOffsets.rotationZ;
				x += postLayoutTransformOffsets.x;
				y += postLayoutTransformOffsets.y;
			}
			
			if (stretchX != 1 || stretchY != 1)
				m.scale(stretchX, stretchY);
			build2DMatrix(m, tx, ty, sx, sy, rz, x, y);
			
			_flags |= COMPUTED_MATRIX_VALID;
			return m;
		}
		
		/**
		 * the computed 3D matrix, calculated by combining the 3D layout matrix and  and any offsets provided..
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function get computedMatrix3D():Matrix3D
		{
			if (_flags & COMPUTED_MATRIX3D_VALID)
				return _computedMatrix3D;
			
			
			if (!postLayoutTransformOffsets && !mirror && stretchX == 1 && stretchY == 1)
			{
				return layout.matrix3D;
			}
			
			var m:Matrix3D = _computedMatrix3D;
			if (m == null)
				m = _computedMatrix3D = new Matrix3D();
			else
				m.identity();
			
			var tx:Number = layout.transformX;
			var ty:Number = layout.transformY;
			var tz:Number = layout.transformZ;
			var sx:Number = layout.scaleX;
			var sy:Number = layout.scaleY;
			var sz:Number = layout.scaleZ;
			var rx:Number = layout.rotationX;
			var ry:Number = layout.rotationY;
			var rz:Number = layout.rotationZ;
			var x:Number = layout.x;
			var y:Number = layout.y;
			var z:Number = layout.z;
			
			if (mirror)
			{
				sx *= -1;
				x += layoutWidth;
			}
			
			if (postLayoutTransformOffsets)
			{
				sx *= postLayoutTransformOffsets.scaleX;
				sy *= postLayoutTransformOffsets.scaleY;
				sz *= postLayoutTransformOffsets.scaleZ;
				rx += postLayoutTransformOffsets.rotationX;
				ry += postLayoutTransformOffsets.rotationY;
				rz += postLayoutTransformOffsets.rotationZ;
				x += postLayoutTransformOffsets.x;
				y += postLayoutTransformOffsets.y;
				z += postLayoutTransformOffsets.z;
			}
			
			build3DMatrix(m, tx, ty, tz, sx, sy, sz, rx, ry, rz, x, y, z);
			// Always prepend last
			if (stretchX != 1 || stretchY != 1)
				m.prependScale(stretchX, stretchY, 1);  
			
			_flags |= COMPUTED_MATRIX3D_VALID;
			return m;           
		}
		
		
		/**
		 * @private
		 * convenience function for building a 2D matrix from the convenience properties 
		 */
		public static function build2DMatrix(m:Matrix,
											 tx:Number,ty:Number,
											 sx:Number,sy:Number,
											 rz:Number,
											 x:Number,y:Number):void
		{
			m.translate(-tx,-ty);
			m.scale(sx,sy);
			m.rotate(rz* RADIANS_PER_DEGREES);
			m.translate(x+tx,y+ty);         
		}
		
		
		/**
		 * @private
		 * convenience function for building a 3D matrix from the convenience properties 
		 */
		public static function build3DMatrix(m:Matrix3D,
											 tx:Number,ty:Number,tz:Number,
											 sx:Number,sy:Number,sz:Number,
											 rx:Number,ry:Number,rz:Number,
											 x:Number,y:Number,z:Number):void
		{
			reVR.x = rx * RADIANS_PER_DEGREES;
			reVR.y = ry * RADIANS_PER_DEGREES;
			reVR.z = rz * RADIANS_PER_DEGREES;
			m.recompose(reV);
			if (sx == 0)
				sx = ZERO_REPLACEMENT_IN_3D;
			if (sy == 0)
				sy = ZERO_REPLACEMENT_IN_3D;
			if (sz == 0)
				sz = ZERO_REPLACEMENT_IN_3D;
			m.prependScale(sx,sy,sz);
			m.prependTranslation(-tx,-ty,-tz);
			m.appendTranslation(tx+x,ty+y,tz+z);
		}                                   
		
		
		/**
		 * A utility method to transform a point specified in the local
		 * coordinates of this object to its location in the object's parent's 
		 * coordinates. The pre-layout and post-layout result will be set on 
		 * the <code>position</code> and <code>postLayoutPosition</code>
		 * parameters, if they are non-null.
		 * 
		 * @param propertyIs3D A boolean reflecting whether the calculation needs
		 * to take into account the 3D matrix of the object.
		 * @param localPoint The point to be transformed, specified in the
		 * local coordinates of the object.
		 * @position A Vector3D point that will hold the pre-layout
		 * result. If null, the parameter is ignored.
		 * @postLayoutPosition A Vector3D point that will hold the post-layout
		 * result. If null, the parameter is ignored.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Royale 1.0.0
		 */
		public function transformPointToParent(propertyIs3D:Boolean,
											   localPosition:Vector3D, position:Vector3D,
											   postLayoutPosition:Vector3D):void
		{
			var transformedV:Vector3D;
			var transformedP:Point;
			tempLocalPosition = 
				localPosition ?
				localPosition.clone() :
				new Vector3D();
			
			if (is3D || propertyIs3D) 
			{
				if (position != null)
				{
					transformedV = transformVector(layoutMatrix3D, tempLocalPosition); 
					position.x = transformedV.x;
					position.y = transformedV.y;
					position.z = transformedV.z;
				} 
				
				if (postLayoutPosition != null)
				{           
					// computedMatrix factor in stretchXY, so divide it out of position first
					tempLocalPosition.x /= stretchX;
					tempLocalPosition.y /= stretchY;
					transformedV = transformVector(computedMatrix3D, tempLocalPosition);
					postLayoutPosition.x = transformedV.x;
					postLayoutPosition.y = transformedV.y;
					postLayoutPosition.z = transformedV.z;
				}
			}
			else
			{
				var localP:Point = new Point(tempLocalPosition.x, 
					tempLocalPosition.y);
				if (position != null)
				{
					transformedP = layoutMatrix.transformPoint(localP);
					position.x = transformedP.x;
					position.y = transformedP.y;
					position.z = 0;
				}
				
				if (postLayoutPosition != null)
				{
					// computedMatrix factor in stretchXY, so divide it out of position first
					localP.x /= stretchX;
					localP.y /= stretchY;
					transformedP = computedMatrix.transformPoint(localP);
					postLayoutPosition.x = transformedP.x;
					postLayoutPosition.y = transformedP.y;
					postLayoutPosition.z = 0;
				}
			}
		}
		
		/**
		 * @private
		 * call when you've changed the inputs to the computed transform to make 
		 * any adjustments to keep a particular point fixed in parent coordinates.
		 */
		private function completeTransformCenterAdjustment(changeIs3D:Boolean, 
														   transformCenter:Vector3D, targetPosition:Vector3D,
														   targetPostLayoutPosition:Vector3D):void
		{
			// TODO (chaase): optimize for transformCenter == (0,0,0)
			if (is3D || changeIs3D)
			{
				if (targetPosition != null)
				{
					var adjustedLayoutCenterV:Vector3D = transformVector(layoutMatrix3D, transformCenter); 
					if (adjustedLayoutCenterV.equals(targetPosition) == false)
					{
						layout.translateBy(targetPosition.x - adjustedLayoutCenterV.x,
							targetPosition.y - adjustedLayoutCenterV.y, 
							targetPosition.z - adjustedLayoutCenterV.z);
						invalidate(); 
					}       
				}
				if (targetPostLayoutPosition != null && _postLayoutTransformOffsets != null)
				{
					// computedMatrix factor in stretchXY, so divide it out of transform center first
					var tmpPos:Vector3D = new Vector3D(transformCenter.x, transformCenter.y, transformCenter.z);
					tmpPos.x /= stretchX;
					tmpPos.y /= stretchY;
					var adjustedComputedCenterV:Vector3D = transformVector(computedMatrix3D, tmpPos);
					if (adjustedComputedCenterV.equals(targetPostLayoutPosition) == false)
					{
						postLayoutTransformOffsets.x +=targetPostLayoutPosition.x - adjustedComputedCenterV.x;
						postLayoutTransformOffsets.y += targetPostLayoutPosition.y - adjustedComputedCenterV.y;
						postLayoutTransformOffsets.z += targetPostLayoutPosition.z - adjustedComputedCenterV.z;
						invalidate(); 
					}       
				}
			}
			else
			{
				var transformCenterP:Point = new Point(transformCenter.x,transformCenter.y);
				if (targetPosition != null)
				{
					var currentPositionP:Point = layoutMatrix.transformPoint(transformCenterP);
					if (currentPositionP.x != targetPosition.x || 
						currentPositionP.y != targetPosition.y)
					{
						layout.translateBy(targetPosition.x - currentPositionP.x,
							targetPosition.y - currentPositionP.y, 0);
						invalidate(); 
					}       
				}
				
				if (targetPostLayoutPosition != null && _postLayoutTransformOffsets != null)
				{           
					// computedMatrix factor in stretchXY, so divide it out of transform center first
					transformCenterP.x /= stretchX;
					transformCenterP.y /= stretchY;
					var currentPostLayoutPosition:Point = 
						computedMatrix.transformPoint(transformCenterP);
					if (currentPostLayoutPosition.x != targetPostLayoutPosition.x || 
						currentPostLayoutPosition.y != targetPostLayoutPosition.y)
					{
						_postLayoutTransformOffsets.x += targetPostLayoutPosition.x - currentPostLayoutPosition.x;
						_postLayoutTransformOffsets.y += targetPostLayoutPosition.y - currentPostLayoutPosition.y;
						invalidate(); 
					}       
				}
			}
		}   
		
		private static var staticTranslation:Vector3D = new Vector3D();
		private static var staticOffsetTranslation:Vector3D = new Vector3D();
		
		/**
		 * A utility method to update the rotation and scale of the transform 
		 * while keeping a particular point, specified in the component's own 
		 * coordinate space, fixed in the parent's coordinate space.  This 
		 * function will assign the rotation and scale values provided, then 
		 * update the x/y/z properties as necessary to keep tx/ty/tz fixed.
		 * @param transformCenter the point, in the component's own coordinates, 
		 * to keep fixed relative to its parent.
		 * @param rotation the new values for the rotation of the transform
		 * @param scale the new values for the scale of the transform
		 * @param translation the new values for the translation of the transform
		 */
		public function transformAround(transformCenter:Vector3D,
										scale:Vector3D,
										rotation:Vector3D,
										transformCenterPosition:Vector3D,
										postLayoutScale:Vector3D = null,
										postLayoutRotation:Vector3D = null,
										postLayoutTransformCenterPosition:Vector3D = null):void
		{
			var is3D:Boolean = (scale != null && scale.z != 1) ||
				(rotation != null && ((rotation.x != 0 ) || (rotation.y != 0))) || 
				(transformCenterPosition != null && transformCenterPosition.z != 0) ||
				(postLayoutScale != null && postLayoutScale.z != 1) ||
				(postLayoutRotation != null && 
					(postLayoutRotation.x != 0 || postLayoutRotation.y != 0)) || 
				(postLayoutTransformCenterPosition != null && postLayoutTransformCenterPosition.z != 0);
			
			var needOffsets:Boolean = _postLayoutTransformOffsets == null && 
				(postLayoutScale != null || postLayoutRotation != null || 
					postLayoutTransformCenterPosition != null);
			if (needOffsets)
				_postLayoutTransformOffsets = new TransformOffsets();                                               
			
			// now if they gave us a non-trivial transform center, and didn't tell us where they want it, 
			// we need to calculate where it is so that we can make sure we keep it there.             
			if (transformCenter != null && 
				(transformCenterPosition == null || postLayoutTransformCenterPosition == null))
			{           
				transformPointToParent(is3D, transformCenter, staticTranslation,
					staticOffsetTranslation);
				if (postLayoutTransformCenterPosition == null && transformCenterPosition != null)
				{
					staticOffsetTranslation.x = transformCenterPosition.x + staticOffsetTranslation.x - staticTranslation.x;
					staticOffsetTranslation.y = transformCenterPosition.y + staticOffsetTranslation.y - staticTranslation.y;
					staticOffsetTranslation.z = transformCenterPosition.z + staticOffsetTranslation.z - staticTranslation.z;
				}
				
			}
			// if targetPosition/postLayoutTargetPosition is null here, it might be because the caller passed in
			// requested values, so we haven't calculated it yet.  So that means our target position is the values
			// they passed in.        
			var targetPosition:Vector3D = (transformCenterPosition == null)? staticTranslation:transformCenterPosition;
			var postLayoutTargetPosition:Vector3D = (postLayoutTransformCenterPosition == null)? staticOffsetTranslation:postLayoutTransformCenterPosition;
			
			// now update our transform values.     
			if (rotation != null)
			{
				if (!isNaN(rotation.x))
					layout.rotationX = rotation.x;
				if (!isNaN(rotation.y))
					layout.rotationY = rotation.y;
				if (!isNaN(rotation.z))
					layout.rotationZ = rotation.z;
			}
			if (scale != null)
			{           
				if (!isNaN(scale.x))
					layout.scaleX = scale.x;
				if (!isNaN(scale.y))
					layout.scaleY = scale.y;
				if (!isNaN(scale.z))
					layout.scaleZ = scale.z;
			}
			
			if (postLayoutRotation != null)
			{           
				_postLayoutTransformOffsets.rotationX = postLayoutRotation.x;
				_postLayoutTransformOffsets.rotationY = postLayoutRotation.y;
				_postLayoutTransformOffsets.rotationZ = postLayoutRotation.z;
			}
			if (postLayoutScale != null)
			{           
				_postLayoutTransformOffsets.scaleX = postLayoutScale.x;
				_postLayoutTransformOffsets.scaleY = postLayoutScale.y;
				_postLayoutTransformOffsets.scaleZ = postLayoutScale.z;
			}
			
			// if they didn't pass us a transform center, 
			// then we assume it's the origin. In that case, it's trivially easy
			// to make sure the origin is at a particular point...we simply set 
			// the transformCenterPosition portion of our transforms to that point. 
			if (transformCenter == null)
			{
				if (transformCenterPosition != null)
				{
					layout.x = transformCenterPosition.x;
					layout.y = transformCenterPosition.y;
					layout.z = transformCenterPosition.z;
				}
				if (postLayoutTransformCenterPosition != null)
				{
					_postLayoutTransformOffsets.x = postLayoutTransformCenterPosition.x - layout.x;
					_postLayoutTransformOffsets.y = postLayoutTransformCenterPosition.y - layout.y;
					_postLayoutTransformOffsets.z = postLayoutTransformCenterPosition.z - layout.z;
				}
			}
			invalidate();
			
			// if they did pass in a transform center, go do the adjustments necessary to keep it fixed in place.
			if (transformCenter != null)
				completeTransformCenterAdjustment(is3D, transformCenter, 
					targetPosition, postLayoutTargetPosition);
			
			
		}
		
	}
}

