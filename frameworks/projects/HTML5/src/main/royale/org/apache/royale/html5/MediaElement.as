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
package org.apache.royale.html5
{

	import org.apache.royale.core.StyledUIBase;



	//--------------------------------------
    //  Events
    //--------------------------------------

	/**
     *  Dispatched when the resource was not fully loaded,
	 *  but not as the result of an error.
     *
     *  @langversion 3.0
     *  @playerversion Flash 0.0
     *  @playerversion AIR 0.0
     *  @productversion Royale 0.0
     */
	[Event(name="abort", type="org.apache.royale.events.Event")]
    
	/**
     *  Dispatched when the user agent can play the media, but 
	 *  estimates that not enough data has been loaded
	 *  to play the media up to its end without having to stop
	 *  for further buffering of content
     *
     *  @langversion 3.0
     *  @playerversion Flash 0.0
     *  @playerversion AIR 0.0
     *  @productversion Royale 0.0
     */
	[Event(name="canplay", type="org.apache.royale.events.Event")]

	/**
     *  Dispatched when the user agent can play the media, and estimates
	 *  that enough data has been loaded to play the media up to its end
	 *  without having to stop for further buffering of content.
     *
     *  @langversion 3.0
     *  @playerversion Flash 0.0
     *  @playerversion AIR 0.0
     *  @productversion Royale 0.0
     */
	[Event(name="canplaythrough", type="org.apache.royale.events.Event")]

	/**
     *  Dispatched when the duration property has been updated.
     *
     *  @langversion 3.0
     *  @playerversion Flash 0.0
     *  @playerversion AIR 0.0
     *  @productversion Royale 0.0
     */
	[Event(name="durationchange", type="org.apache.royale.events.Event")]

	/**
     *  Dispatched when the media has become empty; for example, when the
	 *  media has already been loaded (or partially loaded), and the
	 *  MediaElement.load() method is called to reload it
     *
     *  @langversion 3.0
     *  @playerversion Flash 0.0
     *  @playerversion AIR 0.0
     *  @productversion Royale 0.0
     */
	[Event(name="emptied", type="org.apache.royale.events.Event")]

	/**
     *  Dispatched when playback stops when end of the media (<audio> or <video>)
	 *  is reached or because no further data is available.
     *
     *  @langversion 3.0
     *  @playerversion Flash 0.0
     *  @playerversion AIR 0.0
     *  @productversion Royale 0.0
     */
	[Event(name="ended", type="org.apache.royale.events.Event")]

	/**
     *  Dispatched when the resource could not be loaded due to an error.
     *
     *  @langversion 3.0
     *  @playerversion Flash 0.0
     *  @playerversion AIR 0.0
     *  @productversion Royale 0.0
     */
    [Event(name="error", type="org.apache.royale.events.Event")]
	
	/**
     *  Dispatched when the metadata has been loaded
     *
     *  @langversion 3.0
     *  @playerversion Flash 0.0
     *  @playerversion AIR 0.0
     *  @productversion Royale 0.0
     */
	[Event(name="loadeddata", type="org.apache.royale.events.Event")]

	/**
     *  Dispatched when the metadata has been loaded
     *
     *  @langversion 3.0
     *  @playerversion Flash 0.0
     *  @playerversion AIR 0.0
     *  @productversion Royale 0.0
     */
	[Event(name="loadedmetadata", type="org.apache.royale.events.Event")]

	/**
     *  Dispatched when the browser has started to load a resource.
     *
     *  @langversion 3.0
     *  @playerversion Flash 0.0
     *  @playerversion AIR 0.0
     *  @productversion Royale 0.0
     */
	[Event(name="loadstart", type="org.apache.royale.events.Event")]


	/**
     *  Dispatched when a request to pause play is handled and the activity
	 *  has entered its paused state, most commonly occurring when the media's
	 *  pause() method is called.
     *
     *  @langversion 3.0
     *  @playerversion Flash 0.0
     *  @playerversion AIR 0.0
     *  @productversion Royale 0.0
     */
	[Event(name="pause", type="org.apache.royale.events.Event")]

	/**
     *  Dispatched when the paused property is changed from true to false,
	 *  as a result of the play() method, or the autoplay attribute
     *
     *  @langversion 3.0
     *  @playerversion Flash 0.0
     *  @playerversion AIR 0.0
     *  @productversion Royale 0.0
     */
	[Event(name="play", type="org.apache.royale.events.Event")]

	/**
     *  Dispatched when playback is ready to start after having been
	 *  paused or delayed due to lack of data
     *
     *  @langversion 3.0
     *  @playerversion Flash 0.0
     *  @playerversion AIR 0.0
     *  @productversion Royale 0.0
     */
	[Event(name="playing", type="org.apache.royale.events.Event")]

	/**
     *  Dispatched periodically as the browser loads a resource.
     *
     *  @langversion 3.0
     *  @playerversion Flash 0.0
     *  @playerversion AIR 0.0
     *  @productversion Royale 0.0
     */
	[Event(name="progress", type="org.apache.royale.events.Event")]

	/**
     *  Dispatched when the playback rate has changed.
     *
     *  @langversion 3.0
     *  @playerversion Flash 0.0
     *  @playerversion AIR 0.0
     *  @productversion Royale 0.0
     */
	[Event(name="ratechange", type="org.apache.royale.events.Event")]

	/**
     *  Dispatched when a seek operation completes
     *
     *  @langversion 3.0
     *  @playerversion Flash 0.0
     *  @playerversion AIR 0.0
     *  @productversion Royale 0.0
     */
	[Event(name="seeked", type="org.apache.royale.events.Event")]

	/**
     *  Dispatched when a seek operation begins.
     *
     *  @langversion 3.0
     *  @playerversion Flash 0.0
     *  @playerversion AIR 0.0
     *  @productversion Royale 0.0
     */
	[Event(name="seeking", type="org.apache.royale.events.Event")]

	/**
     *  Dispatched when the user agent is trying to fetch media data,
	 *  but data is unexpectedly not forthcoming.
     *
     *  @langversion 3.0
     *  @playerversion Flash 0.0
     *  @playerversion AIR 0.0
     *  @productversion Royale 0.0
     */
	[Event(name="stalled", type="org.apache.royale.events.Event")]

	/**
     *  Dispatched when the media data loading has been suspended.
     *
     *  @langversion 3.0
     *  @playerversion Flash 0.0
     *  @playerversion AIR 0.0
     *  @productversion Royale 0.0
     */
	[Event(name="suspend", type="org.apache.royale.events.Event")]

	/**
     *  Dispatched when the time indicated by the currentTime property has been updated.
     *
     *  @langversion 3.0
     *  @playerversion Flash 0.0
     *  @playerversion AIR 0.0
     *  @productversion Royale 0.0
     */
	[Event(name="timeupdate", type="org.apache.royale.events.Event")]

	/**
     *  Dispatched when the volume has changed.
     *
     *  @langversion 3.0
     *  @playerversion Flash 0.0
     *  @playerversion AIR 0.0
     *  @productversion Royale 0.0
     */
	[Event(name="volumechange", type="org.apache.royale.events.Event")]

	/**
     *  Dispatched when playback has stopped because of a temporary lack of data.
     *
     *  @langversion 3.0
     *  @playerversion Flash 0.0
     *  @playerversion AIR 0.0
     *  @productversion Royale 0.0
     */
	[Event(name="waiting", type="org.apache.royale.events.Event")]

    



	/**
     *  The MediaElement class adds the properties
	 *  and methods needed to support basic media-related capabilities that
	 *  are common to audio and video.
     *
     *  @langversion 3.0
     *  @playerversion Flash 0.0
     *  @playerversion AIR 0.0
     *  @productversion Royale 0.0
     */
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
		 *  indicate whether playback should automatically begin as
		 *  soon as enough media is available to do so without interruption. 
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
		public function get autoplay():Boolean
		{
	        COMPILE::JS{return (element as HTMLMediaElement).autoplay;}

			COMPILE::SWF{return false;}
		}

		/**
		 *  A boolean value which is true if the media element will begin playback as
		 *  soon as enough content has loaded to allow it to do so without interruption. 
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
		public function set autoplay(value:Boolean):void
		{
	    	COMPILE::JS{(element as HTMLMediaElement).autoplay = value;}
		}


		/**
		 *  return a TimeRanges object that represents the ranges of the media resource,
		 *  if any, that the user agent has buffered at the moment the buffered property is accessed.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
		COMPILE::JS
		public function get buffered():TimeRanges
		{	
			return (element as HTMLMediaElement).buffered;
		}



		/**
		 *  eflects the controls attribute, which controls whether user interface
		 *  controls for playing the media item will be displayed.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
		public function get controls():Boolean
		{
	        COMPILE::JS{return (element as HTMLMediaElement).controls;}

			COMPILE::SWF{return false;}
		}

		/**
		 *  A value of true means controls will be displayed. 
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
		public function set controls(value:Boolean):void
		{
	    	COMPILE::JS{(element as HTMLMediaElement).controls = value;}
		}


/*
		public function get controlsList():DOMTokenList
		{
			return (element as HTMLMediaElement).controlsList;
		}
*/

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

		/**
		 *  return the current source
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
		public function get currentSrc():String
		{
	        COMPILE::JS{return (element as HTMLMediaElement).currentSrc;}

	        COMPILE::SWF{return null;}
		}


		/**
		 *  specifies the current playback time in seconds. 
		 *  If the media is not yet playing, the value of currentTime
		 *  indicates the time position within the media at which playback
		 *  will begin once the play() method is called 
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
		public function get currentTime():Number
		{
	        COMPILE::JS{return (element as HTMLMediaElement).currentTime;}

	        COMPILE::SWF{return null;}
		}


		/**
		 *  Changing the value of currentTime seeks the media to the new time. 
		 *  value indicate the current playback time in seconds.  
		 *  Setting currentTime to a new value seeks the media to the given time, if the media is available.
		 *  The length of the media in seconds can be determined using the duration property. 
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
		public function set currentTime(value:Number):void
		{
	        COMPILE::JS{(element as HTMLMediaElement).currentTime = value;}
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

		/**
		 *  indicates the default playback rate for the media. 
		 *  1.0 is "normal speed,"
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
		public function get defaultPlaybackRate():Number
		{
	        COMPILE::JS{return (element as HTMLMediaElement).defaultPlaybackRate;}

	        COMPILE::SWF{return null;}
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

		/**
		 *  indicates the length of the element's media in seconds. 
		 *  If no media data is available, the value NaN is returned.
		 *  If the element's media doesn't have a known duration—such
		 *  as for live media streams—the value of duration is +Infinity 
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
		public function get duration():Number
		{
	        COMPILE::JS{return (element as HTMLMediaElement).duration;}

	        COMPILE::SWF{return null;}
		}

		/**
		 *  indicates whether the media element has ended playback. 
		 *  return true if the media contained in the element has finished playing. 
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
		public function get ended():Boolean
		{
	        COMPILE::JS{return (element as HTMLMediaElement).ended;}

	        COMPILE::SWF{return null;}
		}

		/**
		 *  MediaError object for the most recent error, or null if there has not been an error.
		 *  When an error event is received by the element, you can determine details about
		 *  what happened by examining this object. 
		 * 
		 *  A MediaError object describing the most recent error to occur
		 *  on the media element or null if no errors have occurred.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
		COMPILE::JS
		public function get error():MediaError
		{
	        return (element as HTMLMediaElement).error;
		}

		/**
		 *  return whether the media element should start over when it reaches the end 
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
		public function get loop():Boolean
		{
	        COMPILE::JS{return (element as HTMLMediaElement).loop;}

	        COMPILE::SWF{return null;}
		}

		/**
		 *  controls whether the media element should start over when it reaches the end  
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
		public function set loop(value:Boolean):void
		{
	    	COMPILE::JS{(element as HTMLMediaElement).loop = value;}
		}

        
		/**
		 *  indicates whether the media element muted. 
		 *  true means muted and false means not muted 
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
		public function get muted():Boolean
		{
			COMPILE::JS{return (element as HTMLMediaElement).muted;}

	        COMPILE::SWF{return null;}
		}
        
		/**
		 *  set or unset mute 
		 *  true means mute and false means not mute 
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
		public function set muted(value:Boolean):void
		{
	        COMPILE::JS{(element as HTMLMediaElement).muted = value;}
		}

		/**
		 *  indicates the current state of the fetching of media over the network. 
		 *  Possible values are:
		 * 
		 *  0: NETWORK_EMPTY. There is no data yet. Also, readyState is HAVE_NOTHING.
		 *	1: NETWORK_IDLE. MediaElement is active and has selected a resource, but is not using the network.
		 *	2: NETWORK_LOADING. downloading MediaElement data is downloading.
		 *	3: NETWORK_NO_SOURCE. No MediaElement src found.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
        static public const NETWORK_EMPTY:int = 0;
		static public const NETWORK_IDLE:int = 1;
		static public const NETWORK_LOADING:int = 2;
		static public const NETWORK_NO_SOURCE:int = 3;

		public function get networkState():uint{
    	    COMPILE::JS{return (element as HTMLMediaElement).networkState;}

    	    COMPILE::SWF{return null;}
		}

		/**
		 *  property tells whether the media element is paused.  
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
		public function get paused():Boolean
		{
			COMPILE::JS{return (element as HTMLMediaElement).paused;}

    	    COMPILE::SWF{return null;}
		}

		/**
		 *  1.0 is "normal speed," values lower than 1.0 make the media play slower than
		 *  normal, higher values make it play faster.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
		public function get playbackRate():Number{
	        COMPILE::JS{return (element as HTMLMediaElement).playbackRate;}

    	    COMPILE::SWF{return null;}
		}

		/**
		 *  sets the rate at which the media is being played back. This is used
		 *  to implement user controls for fast forward, slow motion, and so forth.
		 *  The normal playback rate is multiplied by this value to obtain the current
		 *  rate, so a value of 1.0 indicates normal speed. 
		 * 
		 *  If playbackRate is negative, the media is not played backwards.
		 * 
		 *  The audio is muted when the fast forward or slow motion is outside
		 *  a useful range (for example, Gecko mutes the sound outside the range 0.25 to 4.0)
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
		public function set playbackRate(value:Number):void{
			COMPILE::JS{(element as HTMLMediaElement).playbackRate = value;}
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

		/**
		 *  indicates the readiness state of the media. 
		 *  Possible values are:
		 * 
		 *  0 -> HAVE_NOTHING (No information is available about the media resource.)
		 *  1 -> HAVE_METADATA (Enough of the media resource has been retrieved that the metadata attributes are initialized. Seeking will no longer raise an exception. )
		 *  2 -> HAVE_CURRENT_DATA (Data is available for the current playback position, but not enough to actually play more than one frame.)
		 *  3 -> HAVE_FUTURE_DATA (Data for the current playback position as well as for at least a little bit of time into the future is available (in other words, at least two frames of video, for example).)
		 *  4 -> HAVE_ENOUGH_DATA (Enough data is available—and the download rate is high enough—that the media can be played through to the end without interruption. )
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
		public function get readyState():uint 
		{
	        COMPILE::JS{return (element as HTMLMediaElement).readyState;}

    	    COMPILE::SWF{return null;}
		}

		/**
		 *  returns a TimeRanges object that represents the ranges of the media resource,
		 *  if any, that the user agent is able to seek to at the time seekable property is accessed. 
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
		COMPILE::JS
		public function get seekable():TimeRanges 
		{
	        return (element as HTMLMediaElement).seekable;
		}

		/**
		 *  returns a DOMString that is the unique ID of the audio device delivering output. 
		 *  If it is using the user agent default, it returns an empty string. 
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
		public function get sinkId():String 
		{
	        COMPILE::JS{return (element as HTMLMediaElement).sinkId;}

    	    COMPILE::SWF{return null;}
		}
        
		/**
		 *  reflects the value of the media element's src attribute, which indicates the URL of a media resource to use in the element. 
		 *  The best way to know the URL of the media resource currently in active use in this element is to look at the value
		 *  of the currentSrc attribute, which also takes into account selection of a best or preferred media resource from
		 *  a list provided in an HTMLSourceElement (which represents a <source> element).
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
		public function get src():String
		{
	        COMPILE::JS{return (element as HTMLMediaElement).src;}

    	    COMPILE::SWF{return null;}
		}
        
		/**
		 *  set source.  TODO see use of <sources>
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
		public function set src(value:String):void
		{
	        COMPILE::JS{(element as HTMLMediaElement).src = value;}
		}

		/**
		 *  returns a TextTrackList object listing all of the TextTrack objects representing
		 *  the media element's text tracks, in the same order as in the list of text tracks.  
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
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

		/**
		 *  value between 0 and 1, where 0 is effectively muted and
		 *  1 is the loudest possible value.  
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
        public function get volume():Number
		{
	        COMPILE::JS{return (element as HTMLMediaElement).volume;}

    	    COMPILE::SWF{return null;}
		}

		/**
		 *  value must fall between 0 and 1, where 0 is effectively muted and
		 *  1 is the loudest possible value. 
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
		public function set volume(value:Number):void
		{
	        COMPILE::JS{(element as HTMLMediaElement).volume = value;}
		}

		/**
		 *  reports how likely it is that the current browser will be able
		 *  to play media of a given MIME type
		 *
		 *  Return value :
		 * 	A string indicating how likely it is that the media can be played.
		 * 
		 *  The string will be one of the following values:
		 * 
		 *  probably
		 *  Media of the type indicated by the mediaType parameter is probably
		 *  playable on this device.
		 * 
		 *  maybe
		 *  Not enough information is available to determine for sure whether or not
		 *  the media will play until playback is actually attempted.
		 * 
		 *  "" (empty string)
		 *  Media of the given type definitely can't be played on the current device.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
        public function canPlayType(mediaType:String):String {
	        COMPILE::JS{return (element as HTMLMediaElement).canPlayType(mediaType);}

	   	    COMPILE::SWF{return null;}
        }

		/**
		 *  resets the media element to its initial state and begins the process
		 *  of selecting a media source and loading the media in preparation for
		 *  playback to begin at the beginning.  
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
		public function load():void
		{
	        COMPILE::JS{(element as HTMLMediaElement).load();}
		}

		/**
		 *  pause playback of the media, if the media is already in a paused state this method will have no effect. 
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
		public function pause():void
		{
			COMPILE::JS{(element as HTMLMediaElement).pause();}
		}

		/**
		 *  attempts to begin playback of the media. May be block by browser policy if not called in a user gesture event
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 0.0
		 *  @playerversion AIR 0.0
		 *  @productversion Royale 0.0
		 */
		public function play():void
		{  /*TODO check for return value*/
	        COMPILE::JS{(element as HTMLMediaElement).play();}
		}



    }

}
