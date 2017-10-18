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
package org.apache.royale.textLayout.compose
{	
	import org.apache.royale.text.engine.ITextLine;
	import org.apache.royale.utils.ObjectMap;
	
	// CONFIG::debug { import org.apache.royale.textLayout.debug.assert; }

	

	
	
	/** 
	 * The TextLineRecycler class provides support for recycling of TextLines.  Some player versions support a recreateTextLine.  Passing TextLines
	 * to the recycler makes them available for reuse.  This improves Player performance.
	 *
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @langversion 3.0
	 */ 
	public class TextLineRecycler
	{
		static private const _textLineRecyclerCanBeEnabled:Boolean = true;
		static private var _textLineRecyclerEnabled:Boolean = _textLineRecyclerCanBeEnabled;
		
		/** Controls if the TLF recycler enabled.   It can only be enabled in 10.1 or later players.
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */
		static public function get textLineRecyclerEnabled():Boolean
		{ return _textLineRecyclerEnabled; }
		static public function set textLineRecyclerEnabled(value:Boolean):void
		{ _textLineRecyclerEnabled = value ? _textLineRecyclerCanBeEnabled : false; }
		
		// manage a cache of ITextLine's that can be reused
		// This version uses a dictionary that holds the TextLines as weak references
		static private var _reusableLineCache:ObjectMap;
		static public function get reusableLineCache():ObjectMap
		{
			if(_reusableLineCache == null)
				_reusableLineCache = new ObjectMap(true);
			return _reusableLineCache;
		}
		static public function set reusableLineCache(value:ObjectMap):void
		{
			_reusableLineCache = value;
		}
		
		/**
		 * Add a ITextLine to the pool for reuse. TextLines for reuse should have null userData and null parent. 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */

		static public function addLineForReuse(textLine:ITextLine):void
		{
//TODO make this work...
			return;
			// CONFIG::debug { assert(textLine.parent == null && textLine.userData == null && (textLine.validity == "invalid" || textLine.validity == "static"),"textLine not ready for reuse"); }
			// if (_textLineRecyclerEnabled)
			// {
			// 	CONFIG::debug 
			// 	{
			// 		for each (var line:ITextLine in reusableLineCache)
			// 		{
			// 			 assert(line != textLine,"READDING LINE TO CACHE");
			// 		}
			// 	}
			// 	CONFIG::debug { cacheTotal++; }
			// 	reusableLineCache[textLine] = null;
			// }
		} 
		CONFIG::debug
		{
			/** @private */
			static public var cacheTotal:int = 0;
			/** @private */
			static public var fetchTotal:int = 0;
			/** @private */
			static public var hitTotal:int = 0;		
			
			static private function recordFetch(hit:int):void
			{
				fetchTotal++;
				hitTotal += hit;
				
				/*if ((fetchTotal%100) == 0)
					trace(fetchTotal,hitTotal,cacheTotal);*/
			}
		}
		
		/**
		 * Return a ITextLine from the pool for reuse. 
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @langversion 3.0
		 */

		static public function getLineForReuse():ITextLine
		{
//TODO make this work
			// if (_textLineRecyclerEnabled)
			// {
			// 	for (var obj:Object in reusableLineCache)
			// 	{
			// 		// remove from the cache
			// 		delete reusableLineCache[obj];
			// 		CONFIG::debug { assert(reusableLineCache[obj] === undefined,"Bad delete"); }
			// 		CONFIG::debug { recordFetch(1); }
			// 		return obj as ITextLine;
			// 	}
			// 	CONFIG::debug { recordFetch(0); }
			// }
			return null;
		}
		
		/** @private empty the reusableLineCache */
		static public function emptyReusableLineCache():void
		{
			reusableLineCache = new ObjectMap(true);
		}
	}
}
