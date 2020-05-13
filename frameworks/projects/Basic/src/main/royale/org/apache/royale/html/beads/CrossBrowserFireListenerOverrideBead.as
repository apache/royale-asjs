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
package org.apache.royale.html.beads
{
    import org.apache.royale.core.IBead;
    import org.apache.royale.core.IStrand;
	import org.apache.royale.core.ElementWrapper;
    COMPILE::JS  
	{
        import goog.events;
        import goog.events.EventTarget;
        import goog.events.BrowserEvent;
        import org.apache.royale.events.IBrowserEvent;
        import org.apache.royale.events.utils.KeyboardEventConverter;
        import org.apache.royale.events.utils.MouseEventConverter;
	}
    /**
     *  Overrides default HTMLElementWrapper implementation to make sure events are converted on all browsers
	 *  including IE. 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.92
     */
	public class CrossBrowserFireListenerOverrideBead implements IBead
	{
        /**
         *  Constructor.
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.92
         */
		public function CrossBrowserFireListenerOverrideBead()
		{
			super();
		}
        
        /**
         *  @copy org.apache.royale.core.IBead#strand
         *  
         *  @langversion 3.0
         *  @playerversion Flash 10.2
         *  @playerversion AIR 2.6
         *  @productversion Royale 0.92
         */
        public function set strand(value:IStrand):void
        {
			COMPILE::JS 
			{
				goog.events.fireListener = CrossBrowserFireListenerOverrideBead.fireListenerOverride;
			}
        }    

		COMPILE::JS
		static protected function fireListenerOverride(listener:Object, eventObject:goog.events.BrowserEvent):Boolean
		{
            var e:IBrowserEvent;
            var nativeEvent:Object = eventObject.getBrowserEvent();
			var constructorName:String = nativeEvent.constructor.toString();
			if (constructorName.indexOf('KeyboardEvent') > -1)
			{
				e = KeyboardEventConverter.convert(nativeEvent,eventObject);
			} else if (constructorName.indexOf('MouseEvent') > -1)
			{
				e = MouseEventConverter.convert(nativeEvent,eventObject);
			} else
			{
				e = new org.apache.royale.events.BrowserEvent();
			}

			e.wrapEvent(eventObject);
			return ElementWrapper.googFireListener(listener, e);
		}
    }
}
