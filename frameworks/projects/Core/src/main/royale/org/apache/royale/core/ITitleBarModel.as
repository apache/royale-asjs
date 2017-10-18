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
    /**
     *  The ITitleBarModel interface describes the minimum set of properties
     *  available to control that displays a title bar.  More sophisticated controls
     *  often have models that extend ITitleBarModel.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public interface ITitleBarModel extends IBeadModel
	{
        [Bindable("titleChange")]
        /**
         *  The title of the TitleBar.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function get title():String;
        function set title(value:String):void;
        
        [Bindable("htmlTitleChange")]
        /**
         *  The title of the TitleBar as HTML.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
        function get htmlTitle():String;
        function set htmlTitle(value:String):void;
        
        // TODO: Consider making this a bead instead.
        // Boolean flags should often be replaced by beads.
        // A different bead would add min/max/restore buttons.
        [Bindable("showCloseButtonChange")]
        /**
         *  <code>true</code> if a close button
         *  should also be in the title bar.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		function get showCloseButton():Boolean;
		function set showCloseButton(value:Boolean):void;
	}
}
