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
package org.apache.royale.media
{
	import org.apache.royale.core.StyledUIBase;
	import org.apache.royale.events.Event;



    
    [Event(name="error", type="org.apache.royale.events.Event")]

	[Event(name="abort", type="org.apache.royale.events.Event")]
	[Event(name="canplay", type="org.apache.royale.events.Event")]
	[Event(name="canplaythrough", type="org.apache.royale.events.Event")]
	[Event(name="durationchange", type="org.apache.royale.events.Event")]
	[Event(name="emptied", type="org.apache.royale.events.Event")]
	[Event(name="ended", type="org.apache.royale.events.Event")]
	[Event(name="loadeddata", type="org.apache.royale.events.Event")]
	[Event(name="loadedmetadata", type="org.apache.royale.events.Event")]
	[Event(name="loadstart", type="org.apache.royale.events.Event")]
	[Event(name="pause", type="org.apache.royale.events.Event")]
	[Event(name="play", type="org.apache.royale.events.Event")]
	[Event(name="playing", type="org.apache.royale.events.Event")]
	[Event(name="progress", type="org.apache.royale.events.Event")]
	[Event(name="ratechange", type="org.apache.royale.events.Event")]
	[Event(name="seeked", type="org.apache.royale.events.Event")]
	[Event(name="seeking", type="org.apache.royale.events.Event")]
	[Event(name="stalled", type="org.apache.royale.events.Event")]
	[Event(name="suspend", type="org.apache.royale.events.Event")]
	[Event(name="timeupdate", type="org.apache.royale.events.Event")]
	[Event(name="volumechange", type="org.apache.royale.events.Event")]
	[Event(name="waiting", type="org.apache.royale.events.Event")]

    
    public class MediaElement extends StyledUIBase
    {
        public function MediaElement()
        {
            super();
        }


       /* COMPILE::JS
        public function get audioTracks():AudioTrackList
        {
           return (element as HTMLMediaElement).audioTracks;
        }

        
        COMPILE::JS
        public function set audioTracks(value:AudioTrackList):void
        {
			(element as HTMLMediaElement).audioTracks = value;
        }*/

		
		/**
		 *  indicate whether playback should automatically begin as soon as enough media 
		 * 	is available to do so without interruption. 
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10.2
		 *  @playerversion AIR 2.6
		 *  @productversion Royale 0.9.4
		 */
        COMPILE::JS
		public function get autoplay():Boolean
		{
			return (element as HTMLMediaElement).autoplay;
		}

    	COMPILE::JS
		public function set autoplay(value:Boolean):void
		{
			(element as HTMLMediaElement).autoplay = value;
		}


		COMPILE::JS
		public function get buffered():TimeRanges
		{	/* TimeRanges object */
			return (element as HTMLMediaElement).buffered;
		}



        COMPILE::JS
		public function get controls():Boolean
		{
			return (element as HTMLMediaElement).controls;
		}

    	COMPILE::JS
		public function set controls(value:Boolean):void
		{
			(element as HTMLMediaElement).controls = value;
		}


        COMPILE::JS
		public function get controlsList():Array
		{
			return new Array();
		}

        /*COMPILE::JS
		public function get crossOrigin():String
		{
			return (element as HTMLMediaElement).crossOrigin;
		}

    	COMPILE::JS
		public function set crossOrigin(value:String):void
		{
			(element as HTMLMediaElement).controls = crossOrigin;
		}*/

        COMPILE::JS
		public function get currentSrc():String
		{
			return (element as HTMLMediaElement).currentSrc;
		}


        COMPILE::JS
		public function get currentTime():Number
		{
			return (element as HTMLMediaElement).currentTime;
		}


        COMPILE::JS
		public function set currentTime(value:Number):void
		{
			(element as HTMLMediaElement).currentTime = value;
		}

       /*COMPILE::JS
		public function get defaultMuted():Boolean
		{
			return (element as HTMLMediaElement).defaultMuted;
		}

    	COMPILE::JS
		public function set defaultMuted(value:Boolean):void
		{
			(element as HTMLMediaElement).defaultMuted = value;
		}*/

        COMPILE::JS
		public function get defaultPlaybackRate():Number
		{
			return (element as HTMLMediaElement).defaultPlaybackRate;
		}

        /*COMPILE::JS
		public function set defaultPlaybackRate(value:Number):void
		{
			(element as HTMLMediaElement).defaultPlaybackRate = value;
		}

        COMPILE::JS
		public function get disableRemotePlayback():Boolean
		{
			return (element as HTMLMediaElement).disableRemotePlayback;
		}

    	COMPILE::JS
		public function set disableRemotePlayback(value:Boolean):void
		{
			(element as HTMLMediaElement).disableRemotePlayback = value;
		}*/

        COMPILE::JS
		public function get duration():Number
		{
			return (element as HTMLMediaElement).duration;
		}

        COMPILE::JS
		public function get ended():Boolean
		{
			return (element as HTMLMediaElement).ended;
		}

        COMPILE::JS
		public function get error():MediaError
		{
			return (element as HTMLMediaElement).error;
		}

        COMPILE::JS
		public function get loop():Boolean
		{
			return (element as HTMLMediaElement).loop;
		}

    	COMPILE::JS
		public function set loop(value:Boolean):void
		{
			(element as HTMLMediaElement).loop = value;
		}

        
		COMPILE::JS
		public function get muted():Boolean
		{
			return (element as HTMLMediaElement).muted;
		}
        
        COMPILE::JS
		public function set muted(value:Boolean):void
		{
			(element as HTMLMediaElement).muted = value;
		}

        static public const NETWORK_EMPTY:int = 0;
		static public const NETWORK_IDLE:int = 1;
		static public const NETWORK_LOADING:int = 2;
		static public const NETWORK_NO_SOURCE:int = 3;
		COMPILE::JS
		public function get networkState():int{
			return (element as HTMLMediaElement).networkState;
		}

		COMPILE::JS
		public function get paused():Boolean
		{
			return (element as HTMLMediaElement).paused;
		}

        COMPILE::JS
		public function get playbackRate():Number{
			return (element as HTMLMediaElement).playbackRate;
		}

		COMPILE::JS
		public function set playbackRate(value:Number):void{
			(element as HTMLMediaElement).playbackRate = value;
		}

        /*COMPILE::JS
		public function get preservesPitch():Boolean
		{
			return (element as HTMLMediaElement).preservesPitch;
		}
        
        COMPILE::JS
		public function set preservesPitch(value:Boolean):void
		{
			(element as HTMLMediaElement).preservesPitch = value;
		}*/

        COMPILE::JS
		public function get readyState():uint 
		{
			return (element as HTMLMediaElement).readyState;
		}

        COMPILE::JS
		public function get seekable():TimeRanges 
		{
			return (element as HTMLMediaElement).seekable;
		}

        COMPILE::JS
		public function get sinkId():String 
		{
			return (element as HTMLMediaElement).sinkId;
		}
        
        COMPILE::JS
		public function get src():String
		{
			return (element as HTMLMediaElement).src;
		}
        
        COMPILE::JS
		public function set src(value:String):void
		{
			(element as HTMLMediaElement).src = value;
		}

        COMPILE::JS
		public function get textTracks():TextTrackList
		{ 
			return (element as HTMLMediaElement).textTracks;
		}

        /*COMPILE::JS
		public function get videoTracks():VideoTrackList
		{ 
			return (element as HTMLMediaElement).videoTracks;
		}*/

        COMPILE::JS
        public function get volume():Number
		{
			return (element as HTMLMediaElement).volume;
		}

        COMPILE::JS
		public function set volume(value:Number):void
		{
			(element as HTMLMediaElement).volume = value;
		}

        COMPILE::JS
        public function canPlayType(mediaType:String):String {
			return (element as HTMLMediaElement).canPlayType(mediaType);
        }

        COMPILE::JS
		public function load():void
		{
			(element as HTMLMediaElement).load();
		}

		COMPILE::JS
		public function pause():void
		{
			(element as HTMLMediaElement).pause();
		}

        COMPILE::JS
		public function play():void
		{
			(element as HTMLMediaElement).play();
		}



    }

}
