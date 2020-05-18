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
	import org.apache.royale.utils.css.loadCSS;
	import org.apache.royale.utils.js.loadJavascript;
	import org.apache.royale.core.IRenderedObject;
	public class hljsFacade
	{
		private static var jsId:String = getJs();
		private static var cssId:String = getCss();
		private static var jsLoaded:Boolean;
		private static var cssLoaded:Boolean;
		private static var objectsToHighlight:Array;

		private static function getJs():String
		{
			loadJavascript("https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/highlight.min.js", jsLoadedHandler);
			return null;
		}

		private static function getCss():String
		{
			return loadCSS("https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/styles/atom-one-dark.min.css", cssLoadedHandler);
		}

		private static function doDeferredHighLights():void
		{
			if (!objectsToHighlight)
			{
				return;
			}
			while (objectsToHighlight.length > 0)
			{
				highlightBlock(objectsToHighlight.shift() as IRenderedObject);
			}
		}

		private static function jsLoadedHandler():void
		{
			jsLoaded = true;
			if (cssLoaded)
			{
				doDeferredHighLights();
			}
		}

		private static function cssLoadedHandler():void
		{
			cssLoaded = true;
			if (jsLoaded)
			{
				doDeferredHighLights();
			}
		}

		public static function highlightBlock(renderedObject:IRenderedObject):void
		{
			if (jsLoaded && cssLoaded)
			{
				COMPILE::JS
				{
					hljs.highlightBlock(renderedObject.element);
				}
			} else
			{
				if (!objectsToHighlight)
				{
					objectsToHighlight = [];
				}
				objectsToHighlight.push(renderedObject);
			}
		}
	}
}
