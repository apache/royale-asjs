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
package mx.controls.beads
{
    import org.apache.royale.core.IAlertModel;
    import org.apache.royale.core.IParent;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.UIBase;
    import org.apache.royale.html.TitleBar;
    import org.apache.royale.html.beads.AlertView;
	
    /**
     *  The AlertView class.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.0
     */
	public class AlertView extends org.apache.royale.html.beads.AlertView
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.0
         */
		public function AlertView()
		{
        }

        override public function set strand(value:IStrand):void
        {
            super.strand = value;
            // MX Alert always has title bar
            if (!alertModel.title)
            {
                titleBar = new TitleBar();
                titleBar.height = 25;
                titleBar.title = alertModel.title;
                IParent(_strand).addElementAt(titleBar, 0);
            }            
        }
        
        /**
         * The content area of the panel.
         *
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.8
         *  @royaleignorecoercion org.apache.royale.core.UIBase
         */
        public function get contentArea():UIBase
        {
            return _strand as UIBase;
        }
		
	}
}
