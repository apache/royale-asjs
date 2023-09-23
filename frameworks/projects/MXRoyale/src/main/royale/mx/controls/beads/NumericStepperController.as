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
    import org.apache.royale.core.IStrand;
    import org.apache.royale.core.IDeferredModel;
    import org.apache.royale.core.IBeadController;
    import org.apache.royale.events.IEventDispatcher;
    import mx.events.FlexEvent;
    import org.apache.royale.events.Event;
	
    /**
     *  The NumericStepperController class takes control of some lifecycle issues.
     * 	Specifically, it makes sure the model is notified when content is ready so values
     *  can be initialized in the right order.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10.2
     *  @playerversion AIR 2.6
     *  @productversion Royale 0.9.10
     * 
     *  @royaleignorecoercion mx.core.UIComponent
     */
	public class NumericStepperController implements IBeadController
	{
		public function set strand(value:IStrand):void
		{
			(value as IEventDispatcher).addEventListener(FlexEvent.INITIALIZE, strandInitialized)
		}

		protected function strandInitialized(event:FlexEvent):void
		{
			var model:IDeferredModel = (event.target as IStrand).getBeadByType(IDeferredModel) as IDeferredModel;
            (event.target as IEventDispatcher).dispatchEvent(new Event("deferredModelInitializing"));
			model.deferred = false;
            (event.target as IEventDispatcher).dispatchEvent(new Event("deferredModelInitialized"));
		}
	}
}

