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
package org.apache.royale.utils
{

	import org.apache.royale.core.IParent;
	import org.apache.royale.core.IUIBase;
	import org.apache.royale.geom.Matrix;
	import org.apache.royale.geom.Rectangle;
	import org.apache.royale.core.IRenderedObject;

	COMPILE::SWF
	{
		import flash.geom.Matrix;
		import flash.display.DisplayObjectContainer;
		import flash.display.DisplayObject;
	}
	
	COMPILE::JS 
	{
		import org.apache.royale.geom.Point;
		import org.apache.royale.core.ITransformHost;
	}
	/**
	 *  The SpriteUtils class is a collection of static functions that are useful
	 *  for geometric operations on visible objects.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.7
	 */
	public class DisplayUtils
	{

		/**
		 *  Gets the bounding box of an object relative to the screen ignoring any scrolling.
		 * 
		 *  @param obj The object to test.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
         *  @royaleignorecoercion HTMLElement
         *  @royaleignorecoercion ITransformHost
		 */
		public static function getScreenBoundingRect(obj:IUIBase, boundsBeforeTransform:Rectangle=null):Rectangle
		{
			COMPILE::SWF
			{
				return Rectangle.fromObject(obj.$displayObject.getBounds(obj.$displayObject.stage));
			}

			COMPILE::JS
			{
				var bounds:Rectangle = boundsBeforeTransform;
				if (bounds == null)
				{
					var r:Object = (obj.element as HTMLElement).getBoundingClientRect();
					bounds = new Rectangle(r.left, r.top, r.right - r.left, r.bottom - r.top);
				}
				bounds.x -= window.pageXOffset;
				bounds.y -= window.pageYOffset;
				if (obj.element is SVGElement)
				{
					var m:org.apache.royale.geom.Matrix = getTransormMatrix(obj);
					var tl:Point = m.transformPoint(bounds.topLeft);
					var tr:Point = m.transformPoint(new Point(bounds.right, bounds.top));
					var bl:Point = m.transformPoint(new Point(bounds.left, bounds.bottom));
					var br:Point = m.transformPoint(bounds.bottomRight);
					var leftX:Number = Math.min(tl.x, tr.x, bl.x, br.x);
					var topY:Number = Math.min(tl.y, tr.y, bl.y, br.y);
					var rightX:Number = Math.max(tl.x, tr.x, bl.x, br.x);
					var bottomY:Number = Math.max(tl.y, tr.y, bl.y, br.y);
					bounds.top = topY;
					bounds.left = leftX;
					bounds.bottom = bottomY;
					bounds.right = rightX;
				}
				return bounds;
			}
		}
		
		/**
		 *  Gets a composition all transform matrices applied to an IUIBase. Currently only works for SVG on JS side.
		 * 
		 *  @param obj The object to test.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 *  @royaleignorecoercion HTMLElement
		 *  @royaleignorecoercion org.apache.royale.core.ITransformHost
		 */
		public static function getTransormMatrix(obj:IUIBase):org.apache.royale.geom.Matrix
		{
			COMPILE::SWF
			{
				var m:flash.geom.Matrix = obj.$displayObject.transform.matrix;
				return new org.apache.royale.geom.Matrix(m.a, m.b, m.c, m.d, m.tx, m.ty);
			}
			COMPILE::JS
			{
				// currently only works for SVG elements
				var svgElement:Object = (obj as ITransformHost).transformElement;
				var sm:SVGMatrix = svgElement.getScreenCTM();
				return new org.apache.royale.geom.Matrix(sm.a,sm.b,sm.c,sm.d,sm.e,sm.f);
			}
			
		}

		/**
		 *  Evaluates the bounding box of two objects to see if thier bounding boxes overlap.
		 * 
		 *  @param obj1 The object to test.
		 *  @param obj2 The object to test against.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
         *  @royaleignorecoercion HTMLElement
		 */
		public static function objectsOverlap(obj1:IUIBase,obj2:IUIBase):Boolean
		{
			COMPILE::SWF
			{
				return obj1.$displayObject.hitTestObject(obj2.$displayObject);
			}

			COMPILE::JS
			{
				var r1:Object = (obj1.element as HTMLElement).getBoundingClientRect();
				var r2:Object = (obj2.element as HTMLElement).getBoundingClientRect();
				var bounds1:Rectangle = new Rectangle(r1.x, r1.y, r1.width, r1.height);
				var bounds2:Rectangle = new Rectangle(r2.x, r2.y, r2.width, r2.height);

				return bounds1.intersects(bounds2);
			}
		}

		/**
		 *  Evaluates the object to see if it overlaps or intersects with
		 *  the point specified by the x and y parameters.
		 *  The x and y parameters specify a point in the top level coordinate space,
		 *  not the container that contains the object being tested (unless parent is the top level).
		 * 
		 *  @param x The x coordinate to test against this object.
		 *  @param y The y coordinate to test against this object.
		 *  @param obj The object to test.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
         *  @royaleignorecoercion HTMLElement
		 */
		public static function hitTestPoint(x:Number, y:Number, obj:IUIBase):Boolean
		{
			COMPILE::SWF
			{
				return obj.$displayObject.hitTestPoint(x,y,true);
			}

			COMPILE::JS
			{
				var result:Array = examineElementsUnderPoint(x,y,obj.element as HTMLElement);
				return result.length > 0;
			}
		}
		COMPILE::JS
		private static function examineElementsUnderPoint(x:Number, y:Number,elem:Element=null):Array
		{
		    var element:Element;
		    var elements:Array = [];
		    var visibility:Array = [];
		    var found:Element;
		    while (true) {
		        element = document.elementFromPoint(x, y);
		        if (!element || element === document.documentElement) {
		            break;
		        }
		        elements[elements.length] = element;
				// work our way up the parent tree to find containing elements if applicable
				var parent:Element = element;
				while(parent)
				{
					if(elem && elem == parent)
					{
						found = parent;
						break;
					}
					parent = parent.parentElement;
				}
		        visibility[visibility.length] = element.style.visibility;
		        element.style.visibility = 'hidden'; // Temporarily hide the element (without changing the layout)
		    }
		    for (var i:int = 0; i < elements.length; i++) {
		        elements[i].style.visibility = visibility[i];
		    }
		    if(elem)
		    	return found ? [found] : [];

		    elements.reverse();
		    return elements;
		}

		/**
		 *  Determines if the potentialChild has the container somewhere in its parent hierarchy.
		 *
		 *  @param container The container to check
		 *  @param potentialChild The target to verify as part of the child tree below the container
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.0
		 *  @royaleignorecoercion org.apache.royale.core.IRenderedObject
		 *
		 */
		public static function containerContains(container:IParent, potentialChild:IUIBase):Boolean{
			COMPILE::SWF{
				return container is DisplayObjectContainer && potentialChild is DisplayObject && DisplayObjectContainer(container).contains(DisplayObject(potentialChild));
			}
			COMPILE::JS{
				return container is IRenderedObject && IRenderedObject(container).element.contains(potentialChild.element);
			}
		}

	}

}


