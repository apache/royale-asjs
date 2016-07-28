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
package org.apache.flex.utils
{
	import org.apache.flex.core.IUIBase;
	import org.apache.flex.geom.Rectangle
	/**
	 *  The SpriteUtils class is a collection of static functions that are useful
	 *  for geometric operations on visible objects.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion FlexJS 0.7
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
		 *  @productversion FlexJS 0.0
         *  @flexjsignorecoercion HTMLElement
		 */
		public static function getScreenBoundingRect(obj:IUIBase):Rectangle
		{
			COMPILE::SWF
			{
				return Rectangle.fromObject(obj.$displayObject.getBounds(obj.$displayObject.stage));
			}

			COMPILE::JS
			{
				var r:Object = obj.element.getBoundingClientRect();
				var bounds:Rectangle = new Rectangle(r.x, r.y, r.width, r.height);
				bounds.x -= window.pageXOffset;
				bounds.y -= window.pageYOffset;
				return bounds;
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
		 *  @productversion FlexJS 0.0
         *  @flexjsignorecoercion HTMLElement
		 */
		public static function objectsOverlap(obj1:IUIBase,obj2:IUIBase):Boolean
		{
			COMPILE::SWF
			{
				return obj1.$displayObject.hitTestObject(obj2.$displayObject);
			}

			COMPILE::JS
			{
				var r1:Object = obj1.element.getBoundingClientRect();
				var r2:Object = obj2.element.getBoundingClientRect();
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
		 *  @productversion FlexJS 0.0
         *  @flexjsignorecoercion HTMLElement
		 */
		public static function hitTestPoint(x:Number, y:Number, obj:IUIBase):Boolean
		{
			COMPILE::SWF
			{
				return obj.$displayObject.hitTestPoint(x,y,true);
			}

			COMPILE::JS
			{
				var result:Array = examineElementsUnderPoint(x,y,obj.element);
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
		        if(elem && elem == element)
		        {
		        	found = element;
		        	break;
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

	}

}


