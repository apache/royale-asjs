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
	import flash.geom.Vector3D;
	
	import __AS3__.vec.Vector;
	
	/**
	 *  A CompoundTransform represents a 2D or 3D matrix transform.  A compound transform represents a matrix that can be queried or set either as a 2D matrix,
	 *  a 3D matrix, or as individual convenience transform properties such as x, y, scaleX, rotationZ, etc. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Royale 1.0.0
	 */
	public class CompoundTransform
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
		public function CompoundTransform()
		{
		}
		
		
		
		/**
		 * @private
		 * storage for transform properties. These values are concatenated together with the layout properties to
		 * form the actual computed matrix used to render the object.
		 */
		private var _rotationX:Number = 0;
		private var _rotationY:Number = 0;
		private var _rotationZ:Number = 0;
		private var _scaleX:Number = 1;
		private var _scaleY:Number = 1;
		private var _scaleZ:Number = 1;     
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _z:Number = 0;
		
		private var _transformX:Number = 0;
		private var _transformY:Number = 0;
		private var _transformZ:Number = 0;
		
		
		/**
		 * @private
		 * slots for the 2D and 3D matrix transforms.  Note that 
		 * these are only allocated and computed on demand -- many component instances will never use a 3D
		 * matrix, for example. 
		 */
		private var _matrix:Matrix;
		private var _matrix3D:Matrix3D;
		
		
		/**
		 * @private
		 * bit field flags for indicating which transforms are valid -- the layout properties, the matrices,
		 * and the 3D matrices.  Since developers can set any of the three programmatically, the last one set
		 * will always be valid, and the others will be invalid until validated on demand.
		 */
		private static const MATRIX_VALID:uint      = 0x20;
		private static const MATRIX3D_VALID:uint        = 0x40;
		private static const PROPERTIES_VALID:uint  = 0x80;
		
		
		/**
		 * @private
		 * flags for tracking whether the  transform is 3D. A transform is 3D if any of the 3D properties -- rotationX/Y, scaleZ, or z -- are set.
		 */
		private static const IS_3D:uint                 = 0x200;
		private static const M3D_FLAGS_VALID:uint           = 0x400;
		
		/**
		 * @private
		 * constants to indicate which form of a transform -- the properties, matrix, or matrix3D -- is
		 *  'the source of truth.'   
		 */
		public static const SOURCE_PROPERTIES:uint          = 1;
		/**
		 * @private
		 * constants to indicate which form of a transform -- the properties, matrix, or matrix3D -- is
		 *  'the source of truth.'   
		 */
		public static const SOURCE_MATRIX:uint          = 2;
		/**
		 * @private
		 * constants to indicate which form of a transform -- the properties, matrix, or matrix3D -- is
		 *  'the source of truth.'   
		 */
		public static const SOURCE_MATRIX3D:uint            = 3;
		
		/**
		 * @private
		 * indicates the 'source of truth' for the transform.  
		 */
		public var sourceOfTruth:uint = SOURCE_PROPERTIES;
		
		/**
		 * @private
		 * general storage for all of ur flags.  
		 */
		private var _flags:uint =  PROPERTIES_VALID;
		
		/**
		 * @private
		 * flags that get passed to the invalidate method indicating why the invalidation is happening.
		 */
		private static const INVALIDATE_FROM_NONE:uint =            0;                      
		private static const INVALIDATE_FROM_PROPERTY:uint =        4;                      
		private static const INVALIDATE_FROM_MATRIX:uint =          5;                      
		private static const INVALIDATE_FROM_MATRIX3D:uint =        6;                      
		
		/**
		 * @private
		 * static data used by utility methods below
		 */
		private static var decomposition:Vector.<Number> = new Vector.<Number>();
		decomposition.push(0);
		decomposition.push(0);
		decomposition.push(0);
		decomposition.push(0);
		decomposition.push(0);
		
		private static const RADIANS_PER_DEGREES:Number = Math.PI / 180;
		
		//----------------------------------------------------------------------------
		
		/**
		 *  The x value of the transform.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function set x(value:Number):void
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			if (value == _x)
				return;
			translateBy(value-_x,0,0);
			invalidate(INVALIDATE_FROM_PROPERTY, false /*affects3D*/);
		}
		/**
		 * @private
		 */
		public function get x():Number
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			return _x;
		}
		
		/**
		 *  The y value of the transform.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function set y(value:Number):void
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			if (value == _y)
				return;
			translateBy(0,value-_y,0);
			invalidate(INVALIDATE_FROM_PROPERTY, false /*affects3D*/);
		}
		
		/**
		 * @private
		 */
		public function get y():Number
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			return _y;
		}
		
		/**
		 *  The z value of the transform.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function set z(value:Number):void
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			if (value == _z)
				return;
			translateBy(0,0,value-_z);
			invalidate(INVALIDATE_FROM_PROPERTY, true /*affects3D*/);
		}
		
		/**
		 * @private
		 */
		public function get z():Number
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			return _z;
		}
		
		//------------------------------------------------------------------------------
		
		
		/**
		 *  The rotationX, in degrees, of the transform.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function set rotationX(value:Number):void
		{
			// clamp the rotation value between -180 and 180.  This is what 
			// the Flash player does, so let's mimic it here too.
			value = MatrixUtil.clampRotation(value);
			
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			if (value == _rotationX)
				return;
			_rotationX = value;
			invalidate(INVALIDATE_FROM_PROPERTY, true /*affects3D*/);
		}
		
		/**
		 * @private
		 */
		public function get rotationX():Number
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			return _rotationX;
		}
		
		/**
		 *  The rotationY, in degrees, of the transform.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function set rotationY(value:Number):void
		{
			// clamp the rotation value between -180 and 180.  This is what 
			// the Flash player does, so let's mimic it here too.
			value = MatrixUtil.clampRotation(value);
			
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			if (value == _rotationY)
				return;
			_rotationY = value;
			invalidate(INVALIDATE_FROM_PROPERTY, true /*affects3D*/);
		}
		
		/**
		 * @private
		 */
		public function get rotationY():Number
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			return _rotationY;
		}
		
		/**
		 *  The rotationZ, in degrees, of the transform.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function set rotationZ(value:Number):void
		{
			// clamp the rotation value between -180 and 180.  This is what 
			// the Flash player does, so let's mimic it here too.
			value = MatrixUtil.clampRotation(value);
			
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			if (value == _rotationZ)
				return;
			_rotationZ = value;
			invalidate(INVALIDATE_FROM_PROPERTY, false /*affects3D*/);
		}
		
		/**
		 * @private
		 */
		public function get rotationZ():Number
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			return _rotationZ;
		}
		
		//------------------------------------------------------------------------------
		
		
		/**
		 *  The scaleX of the transform.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function set scaleX(value:Number):void
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			if (value == _scaleX)
				return;
			_scaleX = value;
			invalidate(INVALIDATE_FROM_PROPERTY, false /*affects3D*/);
		}
		
		/**
		 * @private
		 */
		public function get scaleX():Number
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			return _scaleX;
		}
		
		/**
		 *  The scaleY of the transform.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function set scaleY(value:Number):void
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			if (value == _scaleY)
				return;
			_scaleY = value;
			invalidate(INVALIDATE_FROM_PROPERTY, false /*affects3D*/);
		}
		
		/**
		 * @private
		 */
		public function get scaleY():Number
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			return _scaleY;
		}
		
		
		/**
		 *  The scaleZ of the transform.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function set scaleZ(value:Number):void
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			if (value == _scaleZ)
				return;
			_scaleZ = value;
			invalidate(INVALIDATE_FROM_PROPERTY, true /*affects3D*/);
		}
		
		/**
		 * @private
		 */
		public function get scaleZ():Number
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			return _scaleZ;
		}
		
		
		/**
		 * @private
		 * returns true if the transform has 3D values.
		 */
		public function get is3D():Boolean
		{
			if ((_flags & M3D_FLAGS_VALID) == 0)
				update3DFlags();
			return ((_flags & IS_3D) != 0);
		}
		
		//------------------------------------------------------------------------------
		/**
		 *  The x value of the transform center. The transform center is kept fixed as rotation and scale are applied. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function set transformX(value:Number):void
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			if (value == _transformX)
				return;
			_transformX = value;
			invalidate(INVALIDATE_FROM_PROPERTY, true /*affects3D*/);
		}
		
		/**
		 * @private
		 */
		public function get transformX():Number
		{
			return _transformX;
		}
		
		//------------------------------------------------------------------------------
		/**
		 *  The y value of the tansform center. The transform center is kept fixed as rotation and scale are applied. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function set transformY(value:Number):void
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			if (value == _transformY)
				return;
			_transformY = value;
			invalidate(INVALIDATE_FROM_PROPERTY, true /*affects3D*/);
		}
		
		/**
		 * @private
		 */
		public function get transformY():Number
		{
			return _transformY;
		}
		//------------------------------------------------------------------------------
		/**
		 *  The z value of the tansform center. The transform center is kept fixed as rotation and scale are applied. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function set transformZ(value:Number):void
		{
			if ((_flags & PROPERTIES_VALID) == false) validatePropertiesFromMatrix();
			if (value == _transformZ)
				return;
			_transformZ = value;
			invalidate(INVALIDATE_FROM_PROPERTY, true /*affects3D*/);
		}
		
		/**
		 * @private
		 */
		public function get transformZ():Number
		{
			return _transformZ;
		}
		
		//------------------------------------------------------------------------------
		
		/**
		 * @private
		 * invalidates our various cached values.  Any change to the CompoundTransform object that affects
		 * the various transforms should call this function. 
		 * @param reason - the code indicating what changes to cause the invalidation.
		 * @param affects3D - a flag indicating whether the change affects the 2D/3D nature of the various transforms.
		 * @param dispatchChangeEvent - if true, the CompoundTransform will dispatch a change indicating that its underlying transforms
		 * have been modified. 
		 */
		private function invalidate(reason:uint, affects3D:Boolean):void
		{
			//race("invalidating: " + reason);
			switch(reason)
			{
				case INVALIDATE_FROM_PROPERTY:
					sourceOfTruth = SOURCE_PROPERTIES;
					_flags |= PROPERTIES_VALID;
					_flags &= ~MATRIX_VALID;
					_flags &= ~MATRIX3D_VALID;
					break;
				case INVALIDATE_FROM_MATRIX:
					sourceOfTruth = SOURCE_MATRIX;
					_flags |= MATRIX_VALID;
					_flags &= ~PROPERTIES_VALID;
					_flags &= ~MATRIX3D_VALID;
					break;
				case INVALIDATE_FROM_MATRIX3D:
					sourceOfTruth = SOURCE_MATRIX3D;
					_flags |= MATRIX3D_VALID;
					_flags &= ~PROPERTIES_VALID;
					_flags &= ~MATRIX_VALID;
					break;
			}                       
			if (affects3D)
				_flags &= ~M3D_FLAGS_VALID;
			
		}
		
		private static const EPSILON:Number = .001;
		/**
		 * @private
		 * updates the flags that indicate whether the layout, offset, and/or computed transforms are 3D in nature.  
		 * Since the user can set either the individual transform properties or the matrices directly, we compute these 
		 * flags based on what the current 'source of truth' is for each of these values.
		 */
		private function update3DFlags():void
		{           
			if ((_flags & M3D_FLAGS_VALID) == 0)
			{
				var matrixIs3D:Boolean = false;
				
				switch(sourceOfTruth)
				{
					case SOURCE_PROPERTIES:
						matrixIs3D = ( // note that rotationZ is the same as rotation, and not a 3D affecting                           
							(Math.abs(_scaleZ-1) > EPSILON) ||  // property.
							((Math.abs(_rotationX)+EPSILON)%360) > 2*EPSILON ||
							((Math.abs(_rotationY)+EPSILON)%360) > 2*EPSILON ||
							Math.abs(_z) > EPSILON
						);
						break;
					case SOURCE_MATRIX:
						matrixIs3D = false;
						break;
					case SOURCE_MATRIX3D:
						var rawData:Vector.<Number> = _matrix3D.rawData;                    
						matrixIs3D = (rawData[2] != 0 ||        // rotation y 
							rawData[6] != 0 ||      // rotation x
							rawData[8] !=0 ||       // rotation y
							rawData[10] != 1 ||     // scalez / rotation x / rotation y
							rawData[14] != 0);      // translation z
						break;                              
				}
				
				if (matrixIs3D)
					_flags |= IS_3D;
				else
					_flags &= ~IS_3D;
				
				_flags |= M3D_FLAGS_VALID;
			}
		}
		
		
		/** 
		 *  Applies the delta to the transform's translation component. Unlike setting the x, y, or z properties directly,
		 *  this method can be safely called without changing the transform's concept of 'the source of truth'.
		 * 
		 *  @param x The x value of the transform.
		 *  
		 *  @param y The y value of the transform.
		 *  
		 *  @param z The z value of the transform.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function translateBy(x:Number,y:Number,z:Number = 0):void
		{
			if (_flags & MATRIX_VALID)
			{
				_matrix.tx += x;
				_matrix.ty += y;
			}
			if (_flags & PROPERTIES_VALID)
			{
				_x += x;
				_y += y;
				_z += z;
			}
			if (_flags & MATRIX3D_VALID)
			{
				var data:Vector.<Number> = _matrix3D.rawData;
				data[12] += x;
				data[13] += y;
				data[14] += z;
				_matrix3D.rawData = data;           
			}   
			invalidate(INVALIDATE_FROM_NONE, z != 0 /*affects3D*/);
		}
		
		
		/**
		 *  The 2D matrix either set directly by the user, or composed by combining the transform center, scale, rotation
		 *  and translation, in that order.  
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function get matrix():Matrix
		{
			
			if (_flags & MATRIX_VALID)
				return _matrix;
			
			if ((_flags & PROPERTIES_VALID) == false)
				validatePropertiesFromMatrix();
			
			var m:Matrix = _matrix;
			if (m == null)
				m = _matrix = new Matrix();
			else
				m.identity();
			
			AdvancedLayoutFeatures.build2DMatrix(m,_transformX,_transformY,
				_scaleX,_scaleY,
				_rotationZ,
				_x,_y);   
			_flags |= MATRIX_VALID;
			return m;       
		}
		
		/**
		 * @private
		 */ 
		public function set matrix(v:Matrix):void
		{
			if (_matrix== null)
			{
				_matrix = v.clone();
			}
			else
			{
				_matrix.identity(); 
				_matrix.concat(v);          
			}
			
			// affects3D is true since setting matrix changes the transform to 2D
			invalidate(INVALIDATE_FROM_MATRIX, true /*affects3D*/);
		}
		
		/**
		 * @private
		 * decomposes the offset transform matrices down into the convenience offset properties. Note that this is not
		 * a bi-directional transformation -- it is possible to create a matrix that can't be fully represented in the
		 * convenience properties. This function will pull from the matrix or matrix3D values, depending on which was most
		 * recently set
		 */
		private function validatePropertiesFromMatrix():void
		{       
			if (sourceOfTruth == SOURCE_MATRIX3D)
			{
				var result:Vector.<Vector3D> = _matrix3D.decompose();
				_rotationX = result[1].x / RADIANS_PER_DEGREES;
				_rotationY = result[1].y / RADIANS_PER_DEGREES;
				_rotationZ = result[1].z / RADIANS_PER_DEGREES;
				_scaleX = result[2].x;
				_scaleY = result[2].y;
				_scaleZ = result[2].z;
				
				if (_transformX != 0 || _transformY != 0 || _transformZ != 0)
				{
					var postTransformTCenter:Vector3D = _matrix3D.transformVector(new Vector3D(_transformX,_transformY,_transformZ));
					_x = postTransformTCenter.x - _transformX;
					_y = postTransformTCenter.y - _transformY;
					_z = postTransformTCenter.z - _transformZ;
				}
				else
				{
					_x = result[0].x;
					_y = result[0].y;
					_z = result[0].z;
				}
			}                        
			else if (sourceOfTruth == SOURCE_MATRIX)
			{
				MatrixUtil.decomposeMatrix(decomposition,_matrix,_transformX,_transformY);
				_x = decomposition[0];
				_y = decomposition[1];
				_z = 0;
				_rotationX = 0;
				_rotationY = 0;
				_rotationZ = decomposition[2];
				_scaleX = decomposition[3];
				_scaleY = decomposition[4];
				_scaleZ = 1;
			}
			_flags |= PROPERTIES_VALID;
			
		}
		
		
		
		/**
		 *  The 3D matrix either set directly by the user, or composed by combining the transform center, scale, rotation
		 *  and translation, in that order. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Royale 1.0.0
		 */
		public function get matrix3D():Matrix3D
		{
			if (_flags & MATRIX3D_VALID)
				return _matrix3D;
			
			if ((_flags & PROPERTIES_VALID) == false)
				validatePropertiesFromMatrix();
			
			var m:Matrix3D = _matrix3D;
			if (m == null)
				m =  _matrix3D = new Matrix3D();
			else
				m.identity();
			
			AdvancedLayoutFeatures.build3DMatrix(m,transformX,transformY,transformZ,
				_scaleX,_scaleY,_scaleZ,
				_rotationX,_rotationY,_rotationZ,                       
				_x,_y,_z);
			_flags |= MATRIX3D_VALID;
			return m;
			
		}
		
		/**
		 * @private
		 */
		public function set matrix3D(v:Matrix3D):void
		{
			if (_matrix3D == null)
			{
				_matrix3D = v.clone();
			}
			else
			{
				_matrix3D.identity();
				if (v)
					_matrix3D.append(v);            
			}
			invalidate(INVALIDATE_FROM_MATRIX3D, true /*affects3D*/);
		}
		
	}
}
