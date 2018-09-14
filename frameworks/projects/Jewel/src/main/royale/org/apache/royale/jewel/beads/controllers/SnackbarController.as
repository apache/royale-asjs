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
package org.apache.royale.jewel.beads.controllers
{
    import org.apache.royale.core.IBeadController;
    import org.apache.royale.core.IStrand;
    import org.apache.royale.events.Event;
    import org.apache.royale.jewel.Snackbar;
    import org.apache.royale.jewel.beads.models.SnackbarModel;
    import org.apache.royale.utils.Timer;

    /**
	 *  The SnackbarController class bead handles duration of the Snackbar
     *  How long to show the Snackbar for.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10.2
	 *  @playerversion AIR 2.6
	 *  @productversion Royale 0.9.4
	 */
	public class SnackbarController implements IBeadController
	{
		/**
		 *  constructor.
		 *  
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.9.4
		 */
		public function SnackbarController()
		{
		}
		
        /**
		 * Ensure only one snackbar is created.
		 */
		private static var _singletonInstance:Snackbar;

        /**
         *  IStrand
         *   
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.9.4
         */
		private var _strand:IStrand;

		/**
		 *  @copy org.apache.royale.core.IBead#strand
		 *  
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.9.4
		 */
		public function set strand(value:IStrand):void
		{
			_strand = value;
             // set duration = -1 to dismiss previous snackbar immediately
            if (_singletonInstance) _singletonInstance.duration = -1;

            _singletonInstance = (value as Snackbar);

            COMPILE::JS {
                // start the timer for dismiss
                durationChangeHandler(null);

                var model:SnackbarModel = _strand.getBeadByType(SnackbarModel) as SnackbarModel;
                model.addEventListener("durationChange", durationChangeHandler);
            }
		}

        /**
         *  Control how long to show the Snackbar base on duration.
         *  
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.9.4
         */
        private var _timer:Timer;

        /**
         *  Reset the timer for displaying when duration changed
         *  
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.9.4
         */
		COMPILE::JS
        private function durationChangeHandler(event:Event):void
        {
            if (_timer) {
				_timer.reset();
			}

            var model:SnackbarModel = _strand.getBeadByType(SnackbarModel) as SnackbarModel;
            if (model.duration < 0) {
                timerHandler(null);
			} else if (model.duration > 0) {
				if (_timer) {
					_timer.delay = model.duration;
				} else {
					_timer = new Timer(model.duration);
					_timer.addEventListener(Timer.TIMER, timerHandler);
				}
				_timer.start();
			}
        }

        /**
         *  Dismiss snackbar after duration matching.
         *  
	     *  @langversion 3.0
	     *  @playerversion Flash 10.2
	     *  @playerversion AIR 2.6
	     *  @productversion Royale 0.9.4
         */
        COMPILE::JS
        private function timerHandler(event:Event):void {
			(_strand as Snackbar).removeClass("open");
            _singletonInstance = null;
            if (_timer) {
                _timer.stop();
                _timer.removeAllListeners();
                _timer = null;
            }
			setTimeout(prepareForDismiss,  400);
            
        }

		private function prepareForDismiss():void
        {
			(_strand as Snackbar).dismiss();
		}
    }
}