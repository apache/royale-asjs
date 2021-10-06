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

package mx.net
{
   import org.apache.royale.events.EventDispatcher;
   import org.apache.royale.file.beads.FileBrowserWithFilter;
   
	/**
	 *  Dispatched when the component has finished its construction
	 *  and has all initialization properties set.
	 *
	 *  <p>After the initialization phase, properties are processed, the component
	 *  is measured, laid out, and drawn, after which the
	 *  <code>creationComplete</code> event is dispatched.</p>
	 * 
	 *  @eventType = org.apache.royale.events.Event.CANCEL
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="cancel", type="org.apache.royale.events.Event")]
	
	/**
	 *  Dispatched when the component has finished its construction
	 *  and has all initialization properties set.
	 *
	 *  <p>After the initialization phase, properties are processed, the component
	 *  is measured, laid out, and drawn, after which the
	 *  <code>creationComplete</code> event is dispatched.</p>
	 * 
	 *  @eventType = org.apache.royale.events.Event.SELECT
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	[Event(name="select", type="org.apache.royale.events.Event")]

   public class FileReferenceList extends EventDispatcher
   {
		
	  private var _browser:FileBrowserWithFilter;
	  private var _fileList:Array;

      public function FileReferenceList()
      {
		  super();
		  _browser = new FileBrowserWithFilter();
	
	  }
	  
	 public function get fileList():Array {
		return _fileList;
	 }
	
     public function browse(typeFilter:Array = null):Boolean
      {
         var allFilters:Array = [];
         if (typeFilter)
		 {
			for (var i:int = 0; i < typeFilter.length; i++)
			{
				var fileFilter:FileFilter = typeFilter[i] as FileFilter;
				var filters:Array = fileFilter.extension.split(";");
				for (var j:int = 0; j < filters.length; j++)
				{
					var filter:String = filters[j];
					if (filter.charAt(0) == '*')
					{
						filter = filter.substring(1);
						filters[j] = filter;
					}
				}
				allFilters = allFilters.concat(filters);
			}
			_browser.filter = allFilters.join(",");
		 }
		 _browser.browse();
         return true;
      }
      

   }

            

}
