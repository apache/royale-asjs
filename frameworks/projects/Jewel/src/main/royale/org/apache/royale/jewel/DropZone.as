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
package org.apache.royale.jewel
{
    import org.apache.royale.events.Event;
    import org.apache.royale.jewel.Group;
    import org.apache.royale.jewel.beads.models.DroppedModel;
    import org.apache.royale.jewel.events.DroppedEvent;
    import org.apache.royale.utils.Base64;
	COMPILE::JS
	{
		import org.apache.royale.core.WrappedHTMLElement;
	}

	/**
	 *  Dispatched When the wizard reach to this page
	 *
     *  @toplevel
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.6
	 */
	[Event(name="dropped", type="org.apache.royale.jewel.events.DroppedEvent")]

	/**
	 *  The DropZone class defines an area on the screen into a which
     *  an object can be dragged and dropped to accomplish a task
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.10
	 */
    public class DropZone extends Group
    {
		public function DropZone()
        {
			super();
		}

		private function elementDragged(event:Event):void
        {
			event.preventDefault();
		}

		private function dropped(event:Event):void
        {  
			event.preventDefault();

            COMPILE::JS
            {
                var fileList:FileList = event['dataTransfer'].files;
                var data:Array = [];

                for (var i:int = 0; i < fileList.length; i++)
                {
                    var reader:FileReader = new FileReader();
                    reader['fileName'] = fileList[i].name;
                    reader.addEventListener('load', function(e:Event):void
                    {
                        data.push(new DroppedModel(e.target['fileName'], Base64.decode(btoa(e.target['result']))));

                        if (data.length == fileList.length)
                            dispatchEvent(new DroppedEvent(DroppedEvent.DROPPED, data));
                    });
                    reader.readAsBinaryString(fileList[i]);
                }
            }
		}

        COMPILE::JS
        override protected function createElement():WrappedHTMLElement
        {
            super.createElement();
            element.setAttribute('role', 'region'); 
            element.tabIndex = 0;
            element.addEventListener('dragenter', elementDragged);
            element.addEventListener('dragover', elementDragged);
            element.addEventListener('drop', dropped);
            return element;
        }
    }
}