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

package spark.components
{

import mx.core.UIComponent;
//import org.apache.royale.events.Event;
//import org.apache.royale.geom.Point;
//import org.apache.royale.geom.Rectangle;
//import flash.media.Video;

//import mx.core.IUIComponent;
//import mx.core.IVisualElement;
//import mx.core.mx_internal;
//import mx.events.FlexEvent;
//import mx.events.PropertyChangeEvent;
//import mx.resources.IResourceManager;
//import mx.resources.ResourceManager;


//import org.osmf.containers.MediaContainer;
//import org.osmf.elements.VideoElement;
//import org.osmf.events.AudioEvent;
//import org.osmf.events.DisplayObjectEvent;
//import org.osmf.events.LoadEvent;
//import org.osmf.events.MediaPlayerCapabilityChangeEvent;
//import org.osmf.events.MediaPlayerStateChangeEvent;
//import org.osmf.events.SeekEvent;
//import org.osmf.events.TimeEvent;
//import org.osmf.layout.HorizontalAlign;
//import org.osmf.layout.LayoutMetadata;
//import org.osmf.layout.ScaleMode;
//import org.osmf.layout.VerticalAlign;
//import org.osmf.media.DefaultMediaFactory;
//import org.osmf.media.MediaElement;
//import org.osmf.media.MediaFactory;
//import org.osmf.media.MediaFactoryItem;
//import org.osmf.media.MediaPlayer;
//import org.osmf.media.MediaPlayerState;
//import org.osmf.media.MediaResourceBase;
//import org.osmf.media.URLResource;
//import org.osmf.media.MediaType;
//import org.osmf.net.NetLoader;
//import org.osmf.net.DynamicStreamingItem;
//import org.osmf.net.rtmpstreaming.RTMPDynamicStreamingNetLoader;
//import org.osmf.net.DynamicStreamingResource;
//import org.osmf.net.FMSURL;
//import org.osmf.utils.OSMFStrings;
//import org.osmf.utils.URL;

//import spark.components.mediaClasses.DynamicStreamingVideoItem;
//import spark.components.mediaClasses.DynamicStreamingVideoSource;
//import spark.primitives.BitmapImage;

use namespace mx_internal;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Dispatched when the data is received as a download operation progresses.
 *  This event is only dispatched when playing a video by downloading it 
 *  directly from a server, typically by issuing an HTTP request.
 *  It is not displatched when playing a video from a special media server, 
 *  such as Flash Media Server.
 * 
 *  <p>This event may not be dispatched when the source is set to null or a playback
 *  error occurs.</p>
 *
 *  @eventType org.osmf.events.LoadEvent.BYTES_LOADED_CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.0
 *  @productversion Flex 4
 */
[Event(name="bytesLoadedChange",type="org.osmf.events.LoadEvent")]

/**
 *  Dispatched when the playhead reaches the duration for playable media.
 * 
 *  @eventType org.osmf.events.TimeEvent.COMPLETE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.0
 *  @productversion Flex 4
 */  
[Event(name="complete", type="org.osmf.events.TimeEvent")]

/**
 *  Dispatched when the <code>currentTime</code> property of the MediaPlayer has changed.
 * 
 *  <p>This event may not be dispatched when the source is set to null or a playback
 *  error occurs.</p>
 *
 *  @eventType org.osmf.events.TimeEvent.CURRENT_TIME_CHANGE
 *
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.0
 *  @productversion Flex 4
 */
[Event(name="currentTimeChange",type="org.osmf.events.TimeEvent")]

/**
 *  Dispatched when the <code>duration</code> property of the media has changed.
 * 
 *  <p>This event may not be dispatched when the source is set to null or a playback
 *  error occurs.</p>
 * 
 *  @eventType org.osmf.events.TimeEvent.DURATION_CHANGE
 * 
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.0
 *  @productversion Flex 4
 */
[Event(name="durationChange", type="org.osmf.events.TimeEvent")]

/**
 *  Dispatched when the MediaPlayer's state has changed.
 * 
 *  @eventType org.osmf.events.MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.0
 *  @productversion Flex 4
 */ 
[Event(name="mediaPlayerStateChange", type="org.osmf.events.MediaPlayerStateChangeEvent")]

//--------------------------------------
//  Other metadata
//--------------------------------------

[DefaultProperty("source")]

[ResourceBundle("osmf")]

[IconFile("VideoDisplay.png")]

/**
 * Because this component does not define a skin for the mobile theme, Adobe
 * recommends that you not use it in a mobile application. Alternatively, you
 * can define your own mobile skin for the component. For more information,
 * see <a href="http://help.adobe.com/en_US/Flex/4.0/UsingSDK/WS53116913-F952-4b21-831F-9DE85B647C8A.html">Spark Skinning</a>.
 */
[DiscouragedForProfile("mobileDevice")]

/**
 *  The VideoDisplay class is chromeless video player that supports
 *  progressive download, multi-bitrate, and streaming video.
 * 
 *  <p><code>VideoDisplay</code> is the chromeless version that does not support skinning.
 *  It is useful when you do not want the user to interact with the control.</p>
 * 
 *  <p><code>VideoPlayer</code> is the skinnable version.</p>
 *
 *  <p>The VideoDisplay control has the following default characteristics:</p>
 *     <table class="innertable">
 *        <tr>
 *           <th>Characteristic</th>
 *           <th>Description</th>
 *        </tr>
 *        <tr>
 *           <td>Default size</td>
 *           <td>0 pixels wide by 0 pixels high with no content, 
 *             and the width and height of the video with content</td>
 *        </tr>
 *        <tr>
 *           <td>Minimum size</td>
 *           <td>0</td>
 *        </tr>
 *        <tr>
 *           <td>Maximum size</td>
 *           <td>10000 pixels wide and 10000 pixels high</td>
 *        </tr>
 *     </table>
 *
 *  @mxml
 *
 *  <p>The <code>&lt;s:VideoDisplay&gt;</code> tag inherits all of the tag 
 *  attributes of its superclass and adds the following tag attributes:</p>
 *
 *  <pre>
 *  &lt;s:VideoDisplay 
 *    <strong>Properties</strong>
 *    autoDisplayFirstFrame="true"
 *    autoPlay="true"
 *    autoRewind="true"
 *    loop="false"
 *    muted="false"
 *    pauseWhenHidden="true"
 *    scaleMode="letterbox"
 *    source=""
 *    volume="1"
 *  
 *    <strong>Events</strong>
 *    bytesLoadedChange="<i>No default</i>"
 *    complete="<i>No default</i>"
 *    currentTimeChange="<i>No default</i>"
 *    durationChange="<i>No default</i>"
 *    mediaPlayerStateChange="<i>No default</i>"
 *  
 *  /&gt;
 *  </pre>
 *
 *  @see spark.components.VideoPlayer
 *
 *  @includeExample examples/VideoDisplayExample.mxml
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion Flex 4
 */
public class VideoDisplay extends UIComponent
{
    //include "../core/Version.as";
    
    //--------------------------------------------------------------------------
    //
    //  Class methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  Set as the OSMF.resourceBundleFunction and used to look up
     *  strings so the OSMF RTEs are localized in Flex.
     */
    //private static function getResourceString(resourceName:String,
                                              //args:Array = null):String
    //{
        //var resourceManager:IResourceManager = ResourceManager.getInstance();
        //return resourceManager.getString("osmf", resourceName, args);
    //}
    
    /**
     * Copied from OSMF ScaleModeUtils.getScaledSize. ScaleModeUtils became
     * an internal OSMF class in OSMF 1.0 so it is copied here.
     * 
     * Calculates the scaled size based on the scaling algorithm.  
     * The available width and height are the width and height of the container.
     * The intrinsic width and height are the width and height of the content.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion OSMF 1.0
     */ 
    //private static function getScaledSize
        //( scaleMode:String
          //, availableWidth:Number, availableHeight:Number
            //, intrinsicWidth:Number, intrinsicHeight:Number
        //):Point
    //{
        //var result:Point;
        //
        //switch (scaleMode)
        //{
            //case ScaleMode.ZOOM:
            //case ScaleMode.LETTERBOX:
                //
                //var availableRatio:Number
                //= availableWidth
                /// availableHeight;
                //
                //var componentRatio:Number 
                //= (intrinsicWidth || availableWidth)
                /// (intrinsicHeight || availableHeight);
                //
                //if  (   (scaleMode == ScaleMode.ZOOM && componentRatio < availableRatio) 
                    //||  (scaleMode == ScaleMode.LETTERBOX && componentRatio > availableRatio)
                //)
                //{
                    //result 
                    //= new Point
                        //( availableWidth
                            //, availableWidth / componentRatio
                        //);
                //}
                //else
                //{
                    //result
                    //= new Point
                        //( availableHeight * componentRatio
                            //, availableHeight
                        //);
                //}
                //
                //break;
            //
            //case ScaleMode.STRETCH:
                //
                //result 
                //= new Point
                //( availableWidth
                    //, availableHeight
                //);
                //break;
            //
            //case ScaleMode.NONE:
                //
                //result
                //= new Point
                //( intrinsicWidth    || availableWidth
                    //, intrinsicHeight   || availableHeight
                //);
                //
                //break;
        //}
        
        //return result;
    //}
    
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor.
     *   
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function VideoDisplay()
    {
        super();
        
        // create the underlying MediaPlayer class first.
        //createUnderlyingVideoPlayer();
        
        // added and removed event listeners to see whether we should
        // start or stop the video
        //addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        //addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
        
        // Set the OSMF hook used for localizing runtime error messages.
        // OSMF itself has English-only messages,
        // but higher layers like Flex can provide localized versions.
        //OSMFStrings.resourceStringFunction = getResourceString;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  This is the underlying VideoPlayer object. At some point in the 
     *  future, we may change to a new implementation.
     */
    //mx_internal var videoPlayer:MediaPlayer;
    
    /**
     *  @private
     *  This is the underlying container used to display
     *  the underlying videoPlayer.
     */
    //mx_internal var videoContainer:MediaContainer;
      
    /**
     *  @private
     *  How the correct media elements are created based on the url of
     *  the resource.
     */
    //mx_internal var mediaFactory:MediaFactory;
      
    /**
     *  @private
     *  Whether the video is on the display list or not
     */
    //private var _isOnDisplayList:Boolean = false;
    
    /**
     *  @private
     *  Whether the we should play the video when the video 
     *  becomes playable again (visible, on display list, and enabled).
     *  This starts out as true, but when we pause the video is changePlayback(), 
     *  we set it to false.  Also, when a user action occurs, like pause() or play()
     *  or stop() is called, we set it to false as well.
     */
    //private var playTheVideoOnVisible:Boolean = true;
    
    /**
     *  @private
     */
    //private var effectiveVisibility:Boolean = false;
    
    /**
     *  @private
     */
    //private var effectiveVisibilityChanged:Boolean = false;
        
    /**
     *  @private
     */
    //private var effectiveEnabled:Boolean = false;
    
    /**
     *  @private
     */
    //private var effectiveEnabledChanged:Boolean = false;
    
    /**
     *  @private
     *  We do different things in the source setter based on if we 
     *  are initialized or not.
     */
    //private var initializedOnce:Boolean = false;
    
    /**
     *  @private
     *  Keeps track of the muted property while loading up a 
     *  video because of autoDisplayFirstFrame.
     */
    //private var beforeLoadMuted:Boolean;
    
    /**
     *  @private
     *  Keeps track whether we are loading up the
     *  video because of autoDisplayFirstFrame.
     * 
     *  <p>In this case we are in "state1" of loading, 
     *  which means we are waiting for the READY 
     *  MediaPlayerStateChangeEvent and haven't done anything yet.</p>
     */
    //private var inLoadingState1:Boolean;
    
    /**
     *  @private
     *  Keeps track whether we are loading up the
     *  video because of autoDisplayFirstFrame.
     * 
     *  <p>In this case we are in "state2" of loading, 
     *  which means have set videoPlayer.displayObject.visible=false  
     *  and videoPlayer.muted=true.  We've also called play() and are 
     *  waiting for the DimensionChangeEvent.</p>
     * 
     *  <p>Note: At this point, inLoadingState1 = true as well.</p>
     */
    //private var inLoadingState2:Boolean;
    
    /**
     *  @private
     *  Keeps track whether we are loading up the
     *  video because of autoDisplayFirstFrame.
     * 
     *  <p>In this case we are in "state3" of loading, 
     *  which means have received the DimensionChangeEvent and have called 
     *  pause() and seek(0).  We are currently waiting for the 
     *  SEEK_END event, at which point we will be completely loaded up.</p>
     * 
     *  <p>Note: At this point, inLoadingState1 = inLoadingState2 = true.</p>
     */
    //private var inLoadingState3:Boolean;
    
    /**
     *  @private
     * 
     *  Old value of videoPlayer.currentTimeUpdateInterval. We store the old 
     *  value when we are taken off the stage and pauseWhenHidden is true 
     *  (removedFromStageHandler). We restore the old value when we are added
     *  to the stage (addedToStageHandler). The value is used in setupSource()
     *  to turn the timers back on if they were disabled. The value if also used
     *  to check if we should turn off the timers in videoPlayer_seekChangeHandler
     *  and videoPlayer_currentTimeChangeHandler.
     *  This is done to keep this component from being pinned in memory by the timer 
     *  associated the currentTimeUpdateInterval property.
     */
    //private var oldCurrentTimeUpdateInterval:Number = NaN;
    
    /**
     *  @private
     * 
     *  Old value of videoPlayer.bytesLoadedUpdateInterval. We store the old 
     *  value when we are taken off the stage and pauseWhenHidden is true 
     *  (removedFromStageHandler). We restore the old value when we are added
     *  to the stage (addedToStageHandler). The value is used in setupSource()
     *  to turn the timers back on if they were disabled. The value if also used
     *  to check if we should turn off the timers in videoPlayer_seekChangeHandler
     *  and videoPlayer_currentTimeChangeHandler.
     *  This is done to keep this component from being pinned in memory by the timer 
     *  associated the bytesLoadedUpdateInterval property.
     */
    //private var oldBytesLoadedUpdateInterval:Number = NaN;
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    //----------------------------------
    //  autoDisplayFirstFrame
    //----------------------------------
    
    /**
     *  @private
     */
    //private var _autoDisplayFirstFrame:Boolean = true;
        
    [Inspectable(category="General", defaultValue="true")]
    
    /**
     *  If <code>autoPlay = false</code>, then 
     *  <code>autoDisplayFirstFrame</code> controls whether the video 
     *  is loaded when the <code>source</code> is set.  
     *  If <code>autoDisplayFirstFrame</code>
     *  is set to <code>true</code>, then the first frame of the video is 
     *  loaded and the video is sized correctly.  
     *  If <code>autoDisplayFirstFrame</code> is set to <code>false</code>, then no 
     *  connection to the source is made, the first frame is not shown, 
     *  and the video's size is not determined until someone tries to play
     *  the video.
     * 
     *  <p>If <code>autoPlay = true</code>, then this flag is ignored.</p>
     *  
     *  @default true
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get autoDisplayFirstFrame():Boolean
    {
        //return _autoDisplayFirstFrame;
	return false;
    }
    
    /**
     * @private
     */
    public function set autoDisplayFirstFrame(value:Boolean):void
    {
        //_autoDisplayFirstFrame = value;
    }
    
    //----------------------------------
    //  autoPlay
    //----------------------------------
    
    /**
     * @private
     */
    //private var _autoPlay:Boolean = true;
    
    [Inspectable(category="General", defaultValue="true")]
    
    /**
     *  Specifies whether the video starts playing immediately when the
     *  <code>source</code> property is set.
     *  If <code>true</code>, the video file immediately begins to buffer and
     *  play.
     *
     *  <p>Even if <code>autoPlay</code> is set to <code>false</code>, Flex
     *  starts loading the video after the <code>initialize()</code> method is
     *  called.
     *  For Flash Media Server, this means creating the stream and loading
     *  the first frame to display.
     *  In the case of an HTTP download, Flex starts downloading the stream
     *  and shows the first frame.</p>
     * 
     *  <p>If <code>playWhenHidden</code> is set to <code>false</code>, then 
     *  <code>autoPlay</code> also affects what happens when the video 
     *  comes back on stage and is enabled and visible.</p>
     *  
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get autoPlay():Boolean
    {
        //return _autoPlay;
	return false;
    }
    
    /**
     * @private (setter)
     */
    public function set autoPlay(value:Boolean):void
    {
        //if (autoPlay == value)
            //return;
        //
        //_autoPlay = value;
        //
        //// call changePlayback() but don't immediately play or pause
        //// based on this change to autoPlay
        //changePlayback(false, false);
    }
    
    //----------------------------------
    //  autoRewind
    //----------------------------------
    
    [Inspectable(category="General", defaultValue="true")]
    
    /**
     *  Specifies whether the FLV file should rewind to the first frame
     *  when play stops, either by calling the <code>stop()</code> method or by
     *  reaching the end of the stream.
     *
     *  <p>This property has no effect for live streaming video.</p>
     *
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get autoRewind():Boolean
    {
        //return videoPlayer.autoRewind;
	return false;
    }
    
    public function set autoRewind(value:Boolean):void
    {
        //videoPlayer.autoRewind = value;
    }
    
    //----------------------------------
    //  bytesLoaded
    //----------------------------------
    
    [Inspectable(Category="General", defaultValue="0")]
    [Bindable("bytesLoadedChange")]
    [Bindable("mediaPlayerStateChange")]
    
    /**
     *  The number of bytes of data that have been downloaded into the application.
     *
     *  @return The number of bytes of data that have been downloaded into the application.
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get bytesLoaded():Number
    {
        //return videoPlayer.bytesLoaded;
	return NaN;
    }
    
    //----------------------------------
    //  bytesTotal
    //----------------------------------
    
    [Inspectable(Category="General", defaultValue="0")]
    [Bindable("mediaPlayerStateChange")]
    
    /**
     *  The total size in bytes of the data being downloaded into the application.
     *
     *  @return The total size in bytes of the data being downloaded into the application.
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get bytesTotal():Number
    {
        //return videoPlayer.bytesTotal;
	return NaN;
    }
    
    //----------------------------------
    //  currentTime
    //----------------------------------
    
    [Inspectable(Category="General", defaultValue="0")]
    [Bindable("currentTimeChange")]
    [Bindable("mediaPlayerStateChange")]
    
    /**
     *  Current time of the playhead, measured in seconds, 
     *  since the video starting playing. 
     *
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get currentTime():Number
    {
        //return videoPlayer.currentTime;
	return NaN;
    }
    
    //----------------------------------
    //  duration
    //----------------------------------
    
    [Inspectable(Category="General", defaultValue="0")]
    [Bindable("durationChange")]
    [Bindable("mediaPlayerStateChange")]
    
    /**
     *  Duration of the video's playback, in seconds
     *
     *  @return The total running time of the video in seconds
     *  @default 0
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get duration():Number
    {
        //return videoPlayer.duration;
	return NaN;
    }
    
    //----------------------------------
    //  loop
    //----------------------------------
    
    [Inspectable(Category="General", defaultValue="false")]
    
    /**
     *  Indicates whether the media should play again after playback has completed. 
     *  The <code>loop</code> property takes precedence over the <code>autoRewind</code>
     *  property, so if loop is set to <code>true</code>, the <code>autoRewind</code> 
     *  property is ignored. 
     *
     *  @default false
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get loop():Boolean
    {
        //return videoPlayer.loop;
	return false;
    }
    
    /**
     *  @private
     */
    public function set loop(value:Boolean):void
    {
        //if (loop == value)
            //return;
        //
        //videoPlayer.loop = value;
    }
    
    //----------------------------------
    //  mediaPlayerState
    //----------------------------------
    
    [Inspectable(category="General", defaultValue="uninitialized")]
    [Bindable("mediaPlayerStateChange")]
    
    /**
     *  The current state of the video.  See 
     *  org.osmf.media.MediaPlayerState for available values.
     *  
     *  @default uninitialized
     * 
     *  @see org.osmf.media.MediaPlayerState
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get mediaPlayerState():String
    {
        //return videoPlayer.state;
	return null;
    }
    
    //----------------------------------
    //  muted
    //----------------------------------
    
    [Inspectable(category="General", defaultValue="false")]
    [Bindable("volumeChanged")]
    
    /**
     *  Set to <code>true</code> to mute the video, <code>false</code> 
     *  to unmute the video.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get muted():Boolean
    {
        //// if inLoadingState2, we've got to 
        //// fake the muted value
        //if (inLoadingState2)
            //return beforeLoadMuted;
        //
        //return videoPlayer.muted;
	return false;
    }
    
    /**
     *  @private
     */
    public function set muted(value:Boolean):void
    {
        //if (muted == value)
            //return;
        //
        //// if inLoadingState2, don't change muted...just fake it
        //if (inLoadingState2)
        //{
            //beforeLoadMuted = value;
            //return;
        //}
        //
        //videoPlayer.muted = value;
    }
    
    //----------------------------------
    //  pauseWhenHidden
    //----------------------------------
    
    /**
     *  @private
     *  Storage variable for pauseWhenHidden
     */
    //private var _pauseWhenHidden:Boolean = true;
    
    [Inspectable(category="General", defaultValue="true")]
    
    /**
     *  Controls whether the video continues to play when it is
     *  "hidden".  The video is "hidden" when either <code>visible</code>
     *  is set to <code>false</code> on it or one of its ancestors,  
     *  or when the video is taken off 
     *  of the display list.  If set to <code>true</code>, the video 
     *  pauses playback until the video is visible again.  If set to 
     *  <code>false</code> the video continues to play when it is hidden.
     * 
     *  <p>If the video is disabled (or one of the video's parents are 
     *  disabled), the video pauses as well, but when it is re-enabled, 
     *  the video does not play again.  This behavior is not controlled through 
     *  <code>pauseWhenHidden</code>; it is defined in the VideoDisplay component.</p>
     * 
     *  @default true
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get pauseWhenHidden():Boolean
    {
        //return _pauseWhenHidden;
	return false;
    }
    
    /**
     *  @private
     */
    public function set pauseWhenHidden(value:Boolean):void
    {
        //if (_pauseWhenHidden == value)
            //return;
        //
        //_pauseWhenHidden = value;
        //
        //if (_pauseWhenHidden)
        //{
            //addVisibilityListeners();
            //computeEffectiveVisibilityAndEnabled();
        //}
        //else
        //{
            //removeVisibilityListeners();
        //}
        //
        //// call changePlayback().  If we're invisible or off the stage, 
        //// setting this to true can pause the video.  However, setting it 
        //// to false should have no immediate impact.
        //changePlayback(value, false);
    }
    
    //----------------------------------
    //  playing
    //----------------------------------
    
    [Inspectable(category="General")]
    [Bindable("mediaPlayerStateChange")]
    
    /**
     *  Contains <code>true</code> if the video is playing or is attempting to play.
     *  
     *  <p>The video may not be currently playing, as it may be seeking 
     *  or buffering, but the video is attempting to play.</p> 
     *
     *  @see #play()
     *  @see #pause()
     *  @see #stop()
     *  @see #autoPlay
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get playing():Boolean
    {
        //return videoPlayer.playing;
	return null;
    }
    
    //----------------------------------
    //  scaleMode
    //----------------------------------
    
    /**
     *  @private
     */
    //private var _scaleMode:String = ScaleMode.LETTERBOX;
    
    [Inspectable(Category="General", enumeration="none,stretch,letterbox,zoom", defaultValue="letterbox")]
    
    /**
     *  The <code>scaleMode</code> property describes different ways of 
     *  sizing the video content.  
     *  You can set <code>scaleMode</code> to 
     *  <code>"none"</code>, <code>"stretch"</code>, 
     *  <code>"letterbox"</code>, or <code>"zoom"</code>.
     * 
     *  <p>If no width, height, or constraints are specified on the component, 
     *  this property has no effect.</p>
     *
     *  @default "letterbox"
     *
     *  @see org.osmf.display.ScaleMode
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get scaleMode():String
    {
        //return _scaleMode;
	return null;
    }
    
    /**
     *  @private
     */
    public function set scaleMode(value:String):void
    {
        //if (scaleMode == value)
            //return;
        //
        //switch(value)
        //{
            //case ScaleMode.NONE:
                //_scaleMode = ScaleMode.NONE;
                //break;
            //case ScaleMode.STRETCH:
                //_scaleMode = ScaleMode.STRETCH;
                //break;
            //case ScaleMode.LETTERBOX:
                //_scaleMode = ScaleMode.LETTERBOX;
                //break;
            //case ScaleMode.ZOOM:
                //_scaleMode = ScaleMode.ZOOM;
                //break;
            //default:
                //_scaleMode = ScaleMode.LETTERBOX;
                //break;
        //}
        //
        //// set scaleMode on the videoElement object
        //if (videoPlayer.media)
        //{
            //var layout:LayoutMetadata = videoPlayer.media.
                                //getMetadata(LayoutMetadata.LAYOUT_NAMESPACE) as LayoutMetadata;
            //if (layout)
                //layout.scaleMode = _scaleMode;
        //}
        //
        //invalidateSize();
        //invalidateDisplayList();
    }
    
    //----------------------------------
    //  source
    //----------------------------------
    
    //private var _source:Object;
    //private var sourceChanged:Boolean;
        
    [Inspectable(category="General", defaultValue="null")]
    [Bindable("sourceChanged")]
    
    /**
     *  The video source.
     * 
     *  <p>For progressive download, the source is just a path or URL pointing 
     *  to the video file to play.</p>
     * 
     *  <p>For streaming (recorded streaming, live streaming, 
     *  or multi-bitrate streaming), the source property is a 
     *  DynamicStreamingVideoSource object.  If you just want to play 
     *  a recorded or live streaming video with no multi-bitrate support, 
     *  you can just pass in a String URL pointing to the video 
     *  stream.  However, if you do this, the streamType is assumed to be "any," 
     *  and you don't have as much control over the streaming as you would if 
     *  you used the DynamicStreamingVideoSource object.</p>
     * 
     *  <p>Note: Setting the source on a MediaPlayerStateChangeEvent.LOADING or a 
     *  MediaPlayerStateChangeEvent.READY is not recommended if the source was 
     *  previously set.  This could cause an infinite loop or an RTE.  
     *  If you must do an operation like that, wait an additional frame to 
     *  set the source.</p>
     *
     *  @see spark.components.mediaClasses.DynamicStreamingVideoSource
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get source():Object
    {
        //return _source;
	return null;
    }
    
    /**
     * @private (setter)
     */
    public function set source(value:Object):void
    {
        //_source = value;
        //
        //// if we haven't initialized, let's wait to set up the 
        //// source in commitProperties() as it is dependent on other 
        //// properties, like autoPlay and enabled, and those may not 
        //// be set yet, especially if they are set via MXML.
        //// Otherwise, if we have initialized, let's just set up the 
        //// source immediately.  This way people can change the source 
        //// and immediately call methods like seek().
        //if (!initializedOnce)
        //{
            //sourceChanged = true;
            //invalidateProperties();
        //}
        //else
        //{
            //setUpSource();
        //}
        //
        //dispatchEvent(new Event("sourceChanged"));
    }
    
    //----------------------------------
    //  thumbnailSource
    //----------------------------------
    
    /**
     *  @private
     */
    //private var _thumbnailSource:Object;
    
    /**
     *  @private
     *  Group that holds the BitmapImage for the thumbnail
     */
    //private var thumbnailGroup:Group;
    
    /**
     *  @private
     *  BitmapImage for the thumbnail
     */
    //private var thumbnailBitmapImage:BitmapImage;
    
    [Inspectable(Category="General")]
    
    /**
     *  @private
     *  Thumbnail source is an internal property used to replace the video with a thumbnail.
     *  This is for places where we just want to load in a placeholder object for the video 
     *  and don't want to incur the extra load-time or memory of loading up the video.
     * 
     *  <p>Thumbnail source can take any valid source that can be passed in to 
     *  <code>spark.primitivies.BitmapImage#source</code>.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    mx_internal function get thumbnailSource():Object
    {
        //return _thumbnailSource;
	return null;
    }
    
    /**
     *  @private
     */
    mx_internal function set thumbnailSource(value:Object):void
    {
        //if (_thumbnailSource == value)
            //return;
        //
        //_thumbnailSource = value;
        //
        //// if we haven't initialized, let's wait to set up the 
        //// source in commitProperties() as it is dependent on other 
        //// properties, like autoPlay and enabled, and those may not 
        //// be set yet, especially if they are set via MXML.
        //// Otherwise, if we have initialized, let's just set up the 
        //// source immediately.  This way people can change the source 
        //// and immediately call methods like seek().
        //if (!initializedOnce)
        //{
            //sourceChanged = true;
            //invalidateProperties();
        //}
        //else
        //{
            //setUpThumbnailSource();
        //}
    }
    
    /**
     *  @private
     *  Sets up the thumbnail source for use.
     */
    //private function setUpThumbnailSource():void
    //{
        //if (thumbnailSource)
        //{            
            //// create thumbnail group if there isn't one
            //if (!thumbnailGroup)
            //{
                //thumbnailBitmapImage = new BitmapImage();
                //thumbnailBitmapImage.includeInLayout = false;
                //
                //thumbnailGroup = new Group();
                //// add thumbnailGroup to the display list first in case
                //// bitmap needs to check its layoutDirection.
                //addChild(thumbnailGroup);
                //thumbnailGroup.clipAndEnableScrolling = true;
                //thumbnailGroup.addElement(thumbnailBitmapImage);
            //}
            //
            //// if thumbnailGroup isn't on the display list, then add it.
            //if (!this.contains(thumbnailGroup))
                //addChild(thumbnailGroup);
            //
            //thumbnailBitmapImage.source = thumbnailSource;
            //invalidateSize();
            //invalidateDisplayList();
        //}
        //else
        //{
            //if (thumbnailGroup)
            //{
                //// null out the source and remove the thumbnail group
                //if (thumbnailBitmapImage)
                    //thumbnailBitmapImage.source = null;
                //if (this.contains(thumbnailGroup))
                    //removeChild(thumbnailGroup);
                //invalidateSize();
            //}
        //}
    //}
    
    //----------------------------------
    //  videoObject
    //----------------------------------
    
    [Inspectable(category="General", defaultValue="null")]
    
    /**
     *  The underlying flash player <code>flash.media.Video</code> object.
     * 
     *  <p>If the source is <code>null</code>, then there may be no 
     *  underlying <code>flash.media.Video object</code> yet.  In that 
     *  case, <code>videoObject</code> returns <code>null</code>.</p>
     * 
     *  @default null
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get videoObject():Video
    {
        //return videoPlayer.displayObject as Video;
	return null;
    }
    
    //----------------------------------
    //  volume
    //----------------------------------
    
    [Inspectable(category="General", defaultValue="1.0", minValue="0.0", maxValue="1.0")]
    [Bindable("volumeChanged")]
    
    /**
     *  The volume level, specified as a value between 0 and 1.
     * 
     *  @default 1
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function get volume():Number
    {
        //return videoPlayer.volume;
	return null;
    }
    
    /**
     *  @private
     */
    public function set volume(value:Number):void
    {
        //if (volume == value)
            //return;
        //
        //videoPlayer.volume = value;
    }
    
    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    //override protected function commitProperties():void
    //{
        //super.commitProperties();
        //
        //initializedOnce = true;
        //
        //if (effectiveVisibilityChanged || effectiveEnabledChanged)
        //{
            //// if either visibility of enabled changed, re-compute them here
            //computeEffectiveVisibilityAndEnabled();
            //
            //// if visibility changed and we care about it, we can 
            //// cause a play or a pause depending on our visibility
            //var causePause:Boolean = false;
            //var causePlay:Boolean = false;
            //if (effectiveVisibilityChanged && pauseWhenHidden)
            //{
                //causePause = !effectiveVisibility;
                //causePlay = effectiveVisibility;
            //}
            //
            //// if enabled changed, we can only cause a pause.  
            //// Re-enabling a component doesn't cause a play.
            //if (effectiveEnabledChanged)
            //{
                //if (!effectiveEnabled)
                    //causePause = true;
            //}
            //
            //changePlayback(causePause, causePlay);
            //
            //effectiveVisibilityChanged = false;
            //effectiveEnabledChanged = false;
        //}
        //
        //if (sourceChanged)
        //{
            //sourceChanged = false;
            //
            //if (thumbnailSource)
                //setUpThumbnailSource();
            //else
                //setUpSource();
        //}
    //}
    
    /**
     *  @private
     */
    //override protected function measure() : void
    //{
        //super.measure();
        //
        //var intrinsicWidth:Number;
        //var intrinsicHeight:Number;
        //
        //// if showing the thumbnail, just use the thumbnail's size
        //if (thumbnailSource && thumbnailGroup)
        //{
            //intrinsicWidth = thumbnailBitmapImage.getPreferredBoundsWidth();
            //intrinsicHeight = thumbnailBitmapImage.getPreferredBoundsHeight();
        //}
        //else
        //{
            //// If there is no media the width/height will be NaN.
            //// Convert it to zero for our purposes.
            //intrinsicWidth = videoPlayer.mediaWidth;
            //if (isNaN(intrinsicWidth))
                //intrinsicWidth = 0;
//
            //intrinsicHeight = videoPlayer.mediaHeight;
            //if (isNaN(intrinsicHeight))
                //intrinsicHeight = 0;
        //}
//
        //measuredWidth = intrinsicWidth;
        //measuredHeight = intrinsicHeight;
        //
        //// Determine whether 'width' and 'height' have been set.
        //var bExplicitWidth:Boolean = !isNaN(explicitWidth);
        //var bExplicitHeight:Boolean = !isNaN(explicitHeight);
//
        //// If only one has been set, calculate the other based on aspect ratio.
        //if (bExplicitWidth && !bExplicitHeight && intrinsicWidth > 0)
            //measuredHeight = explicitWidth * intrinsicHeight / intrinsicWidth;
        //else if (bExplicitHeight && !bExplicitWidth && intrinsicHeight > 0)
            //measuredWidth = explicitHeight * intrinsicWidth / intrinsicHeight;
    //}
    
    /**
     *  @private
     */
    //override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
    //{
        //super.updateDisplayList(unscaledWidth, unscaledHeight);
        //
        //// if just showing the thumbnail, push this width/height in to the thumbnail
        //// otherwise we'll push it in to the video object
        //if (thumbnailSource && thumbnailGroup)
        //{
            //// get what the size of our image should be
            //var newSize:Point = getScaledSize(scaleMode, unscaledWidth, unscaledHeight, 
                //thumbnailBitmapImage.getPreferredBoundsWidth(), thumbnailBitmapImage.getPreferredBoundsHeight());
            //
            //// set the thumbnailGroup to be the size of the component.
            //// set the bitmap image to be the size it should be according to OSMF
            //thumbnailGroup.setLayoutBoundsSize(unscaledWidth, unscaledHeight);
            //thumbnailBitmapImage.setLayoutBoundsSize(newSize.x, newSize.y);
            //
            //// center the thumnail image within the thumbnail group.
            //// if it's too big to fit, the thumbnail group will crop it
            //thumbnailBitmapImage.x = (unscaledWidth - newSize.x)/2;
            //thumbnailBitmapImage.y = (unscaledHeight - newSize.y)/2;
            //
            //return;
        //}
        //
        //videoContainer.width = Math.floor(unscaledWidth);
        //videoContainer.height = Math.floor(unscaledHeight);
//
        //// need to validate the gateway immediately--otherwise we may run out of synch
        //// as they may wait a frame by default before validating (see SDK-24880)
        //videoContainer.validateNow();
    //}
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Pauses playback without moving the playhead. 
     *  If playback is already is paused or is stopped, this method has no
     *  effect.  
     *
     *  <p>To start playback again, call the <code>play()</code> method.</p>
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function pause():void
    {
        //// check to see if we can call methods on the video player object yet
        //if (!videoPlayerResponsive())
            //return;
        //
        //playTheVideoOnVisible = false;
        //
        //// if we're loading up, then we will pause automatically, so let's 
        //// not interrupt this process
        //// if inLoadingState1 && pausable, then let loading state handle it
        //// if inLoadingState1 && !pausable, then let the loading state handle it
        //// if !inLoadingState1 && pausable, then just pause
        //// if !inLoadingState1 && !pausable, then load (if needed to show first frame)
        //if (!inLoadingState1 && videoPlayer.canPause)
            //videoPlayer.pause();
        //else if (!videoPlayer.canPause && autoDisplayFirstFrame)
            //load();
    }
    
    /**
     *  Causes the video to play.  Can be called while the video is
     *  paused, stopped, or while the video is already playing.
     * 
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function play():void
    {
        //// check to see if we can call methods on the video player object yet
        //if (!videoPlayerResponsive())
            //return;
        //
        //playTheVideoOnVisible = false;
        //
        //// if we're loading up, use a special method to cancel the load
        //// and to start playing again.  Otherwise, go ahead and play
        //if (inLoadingState1)
            //cancelLoadAndPlay();
        //else if (videoPlayer.canPlay)
            //videoPlayer.play();
    }
    
    /**
     *  Seeks to given time in the video. If the video is playing,
     *  continue playing from that point. If the video is paused, seek to
     *  that point and remain paused. If the video is stopped, seek to
     *  that point and enters paused state. 
     *  This method has no effect with live video streams.
     *
     *  <p>If time is less than 0 or NaN, throws exception. If time
     *  is past the end of the stream, or past the amount of file
     *  downloaded so far, then attempts to seek and, if it fails, it then recovers.</p>
     * 
     *  <p>The <code>currentTime</code> property might not have the expected value 
     *  immediately after you call <code>seek()</code>. 
     *  For a progressive download,
     *  you can seek only to a keyframe; therefore, a seek takes you to the 
     *  time of the first keyframe after the specified time.</p>
     *  
     *  <p><strong>Note</strong>: When streaming, a seek always goes to the precise specified 
     *  time even if the source FLV file doesn't have a keyframe there.</p>
     *
     *  <p>Seeking is asynchronous, so if you call the <code>seek()</code> method, 
     *  <code>currentTime</code> does not update immediately. </p>
     *
     *  @param time The seek time, in seconds.
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function seek(time:Number):void
    {
        //// check to see if we can call methods on the video player object yet
        //if (!videoPlayerResponsive())
            //return;
        //
        //// TODO (rfrishbe): could handle what to do if this gets called when loading() better.
        //// Need to store where we want to seek to.
        //if (videoPlayer.canSeek)
            //videoPlayer.seek(time);
    }
    
    /**
     *  Stops video playback.  If <code>autoRewind</code> is set to
     *  <code>true</code>, rewinds to first frame.  If video is already
     *  stopped, has no effect.  To start playback again, call
     *  <code>play()</code>.
     *
     *  @see #autoRewind
     *  @see #play()
     *  
     *  @langversion 3.0
     *  @playerversion Flash 10
     *  @playerversion AIR 1.5
     *  @productversion Flex 4
     */
    public function stop():void
    {
        //// check to see if we can call methods on the video player object yet
        //if (!videoPlayerResponsive())
            //return;
        //
        //playTheVideoOnVisible = false;
        //
        //// if we're loading up, then we will stop automatically, so let's 
        //// not interrupt this process
        //// if inLoadingState1 && pausable, then let loading state handle it
        //// if inLoadingState1 && !pausable, then let the loading state handle it
        //// if !inLoadingState1 && pausable, then just pause
        //// if !inLoadingState1 && !pausable, then load (if needed to show first frame)
        //if (!inLoadingState1 && videoPlayer.canPause)
            //videoPlayer.stop();
        //else if (!videoPlayer.canPause && autoDisplayFirstFrame)
            //load();
    }
    
    //--------------------------------------------------------------------------
    //
    //  Private Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  If the video player is responsive, then methods can be called on the underlying 
     *  video player.
     */
    //private function videoPlayerResponsive():Boolean
    //{
        //// can't call any methods before we've initialized
        //if (!initializedOnce)
            //return false;
        //
        //// if displaying a thumbnail, no methods can be called b/c there's no video 
        //// loaded up
        //if (thumbnailSource)
            //return false;
        //
        //// if the video player's in a bad state, we can't do anything
        //if (videoPlayer.state == MediaPlayerState.PLAYBACK_ERROR || 
            //videoPlayer.state == MediaPlayerState.UNINITIALIZED || 
            //videoPlayer.state == MediaPlayerState.LOADING)
        //{
            //return false;
        //}
        //
        //// if no source, return false as well
        //if (!source)
            //return false;
        //
        //// otherwise, we are in a good state and have a source, so let's go
        //return true;
    //}
    
    /**
     *  @private
     */
    //private function createUnderlyingVideoPlayer():void
    //{
        //// create new video player
        //videoPlayer = new MediaPlayer();
        //videoContainer = new MediaContainer();
        //videoContainer.clipChildren = true;
        //
        //mediaFactory = new DefaultMediaFactory();
        //
        //// remove unsupport media types
        //var unsupportedMediaTypes:Array = ["org.osmf.elements.video.dvr.dvrcast",
                                           //"org.osmf.elements.image", 
                                           //"org.osmf.elements.swf"];
        //
        //for each (var mediaType:String in unsupportedMediaTypes)
        //{
            //var mediaFactoryItem:MediaFactoryItem = mediaFactory.getItemById(mediaType);
            //if (mediaFactoryItem)
                //mediaFactory.removeItem(mediaFactoryItem);
        //}
//
        //// internal events
        //videoPlayer.addEventListener(DisplayObjectEvent.MEDIA_SIZE_CHANGE, videoPlayer_mediaSizeChangeHandler);
        //videoPlayer.addEventListener(AudioEvent.VOLUME_CHANGE, videoPlayer_volumeChangeHandler);
        //videoPlayer.addEventListener(AudioEvent.MUTED_CHANGE, videoPlayer_mutedChangeHandler);
        //
        //// public events
        //videoPlayer.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, videoPlayer_mediaPlayerStateChangeHandler);
        //videoPlayer.addEventListener(TimeEvent.CURRENT_TIME_CHANGE, dispatchEvent);
        //videoPlayer.addEventListener(LoadEvent.BYTES_LOADED_CHANGE, dispatchEvent);
        //videoPlayer.addEventListener(TimeEvent.DURATION_CHANGE, videoPlayer_durationChangeHandler);
        //videoPlayer.addEventListener(TimeEvent.COMPLETE, dispatchEvent);
        //
        //addChild(videoContainer);
    //}
    
    /**
     *  @private
     *  Sets up the source for use.
     */
    //private function setUpSource():void
    //{
        //// clean up any listeners from the old source, especially if we 
        //// are in the processing of loading that video file up
        //cleanUpSource()
        //
        //// if was playing a previous video, let's remove it now
        //if (videoPlayer.media && videoContainer.containsMediaElement(videoPlayer.media))
        //{
            //videoContainer.removeMediaElement(videoPlayer.media);
        //}
        //
        //var videoElement:org.osmf.media.MediaElement = null;
        //
        //// check for 4 cases: streaming video, progressive download, 
        //// an IMediaResource, or a VideoElement.  
        //// The latter 2 are undocumented but allowed for flexibility until we 
        //// can support OSMF better after they ship OSMF 1.0.  At that point, support 
        //// for a source as an IMediaResource or a VideoElement may be removed.
        //if (source is DynamicStreamingVideoSource)
        //{
            //// the streaming video case.
            //// build up a DynamicStreamingResource to pass in to OSMF
            //var streamingSource:DynamicStreamingVideoSource = source as DynamicStreamingVideoSource;
            //var dsr:DynamicStreamingResource;
            //
            //// check for two cases for host: String and URL.
            //// Technically, we only support URL, but we secretly allow 
            //// them to send in an OSMF URL or FMSURL here to help resolve any ambiguity
            //// around serverName vs. streamName.
            //if (streamingSource.host is String)
            //{
                //dsr = new DynamicStreamingResource(streamingSource.host as String, 
                                                   //streamingSource.streamType);
            //}
            //else if (streamingSource.host is URL)
            //{
                //dsr = new DynamicStreamingResource(URL(streamingSource.host).host, 
                                                   //streamingSource.streamType);
            //}       
            //
            //if (dsr)
            //{
                //var n:int = streamingSource.streamItems.length;
                //var item:DynamicStreamingVideoItem;
                //var dsi:DynamicStreamingItem;
                //var streamItems:Vector.<DynamicStreamingItem> = new Vector.<DynamicStreamingItem>(n);
                //
                //for (var i:int = 0; i < n; i++)
                //{
                    //item = streamingSource.streamItems[i];
                    //dsi = new DynamicStreamingItem(item.streamName, item.bitrate);
                    //streamItems[i] = dsi;
                //}
                //dsr.streamItems = streamItems;
                //
                //dsr.initialIndex = streamingSource.initialIndex;
                //
                //// add video type metadata so if the URL is ambiguous, OSMF will 
                //// know what type of file we're trying to connect to
                //dsr.mediaType = MediaType.VIDEO;
                //
                //videoElement = new org.osmf.elements.VideoElement(dsr, new RTMPDynamicStreamingNetLoader());
            //}
        //}
        //else if (source is String && source != "")
        //{
            //var urlResource:URLResource = new URLResource(source as String);
            //videoElement = mediaFactory.createMediaElement(urlResource);
            //
            //// If the url could not be resolved to a media element then try 
            //// telling osmf the media is a video and try again.
            //// We do not specify the media type as video the first time,
            //// so we can have the chance to play audio.
            //if (videoElement == null)
            //{
                //urlResource.mediaType = MediaType.VIDEO;
                //videoElement = mediaFactory.createMediaElement(urlResource);                
            //}
        //}
        //else if (source is MediaResourceBase)
        //{
            //videoElement = mediaFactory.createMediaElement(MediaResourceBase(source));
        //}
        //else if (source is org.osmf.elements.VideoElement)
        //{
            //videoElement = source as org.osmf.elements.VideoElement;
        //}
        //
        //// reset the visibilityPausedTheVideo flag
        //playTheVideoOnVisible = true;
        //// set up videoPlayer.autoPlay based on whether this.autoPlay is 
        //// set and whether we are visible and the other typical conditions.
        //changePlayback(false, false);
        //
        //// if we're not going to autoPlay (or couldn't autoPlay because 
        //// we're hidden or for some other reason), but we need to seek 
        //// to the first frame, then we have to do this on our own 
        //// by using our load() method.
        //if (videoElement && (!autoPlay || !shouldBePlaying) && autoDisplayFirstFrame)
            //load();
        //
        //// set videoPlayer's element to the newly constructed VideoElement
        //// set the newly constructed videoElement's gateway to be the videoGateway
        //videoPlayer.media = videoElement;
        //
        //if (videoElement)
        //{
            //// If we are loading a video, make sure the timers are restored in case
            //// they had been disabled. The timers will be disabled again if we are 
            //// only loading the first frame.
            //if (!isNaN(oldCurrentTimeUpdateInterval))
            //{
                //videoPlayer.currentTimeUpdateInterval = oldCurrentTimeUpdateInterval;
                //videoPlayer.bytesLoadedUpdateInterval = oldBytesLoadedUpdateInterval;
            //}
//
            //if (videoElement.getMetadata(LayoutMetadata.LAYOUT_NAMESPACE) == null)
            //{
                //var layout:LayoutMetadata = new LayoutMetadata();
                //layout.scaleMode = scaleMode;
                //layout.verticalAlign = VerticalAlign.MIDDLE;
                //layout.horizontalAlign = HorizontalAlign.CENTER;
                //layout.percentWidth = 100;
                //layout.percentHeight = 100;
                //videoElement.addMetadata(LayoutMetadata.LAYOUT_NAMESPACE, layout);
            //}               
//
            //if (videoElement && !videoContainer.containsMediaElement(videoElement) )
            //{
                //videoContainer.addMediaElement(videoElement);
            //}               
        //}
        //else
        //{
            //// if our source is null, let's invalidateSize() here.
            //// if it's a bad source, we'll get a playbackError and invalidate
            //// the size down there.  If it's a good source, we'll get a 
            //// dimensionChange event and invalidate the size in there.
            //invalidateSize();
        //}
    //}
    
    /**
     *  @private
     *  Our own internal load() method to handle the case 
     *  where autoPlay = false and autoDisplayFirstFrame = true 
     *  so that we can load up the video, figure out its size, 
     *  and show the first frame
     */
    //private function load():void
    //{
        //inLoadingState1 = true;
        //
        //// wait until we can mute, play(), pause(), and seek() before doing anything.
        //// We should be able to do all of these operations on the READY state change event.
        //videoPlayer.addEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, videoPlayer_mediaPlayerStateChangeHandlerForLoading);
    //}
    
    //--------------------------------------------------------------------------
    //
    //  pauseWhenHidden: Event handlers and Private Methods
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     *  Whether the video should be playing based on enabled, 
     *  pauseWhenHidden, whether it's on the display list, and its
     *  effective visibility.
     */
    //private function get shouldBePlaying():Boolean
    //{
        //// if disabled, return false
        //if (!effectiveEnabled)
            //return false;
        //
        //// if we want to look at visibility, check to 
        //// see if we are on the display list and check out 
        //// effectiveVisibility (which looks up our parent chain 
        //// to make sure us and all of our ancestors are visible)
        //if (pauseWhenHidden)
        //{
            //if (!_isOnDisplayList)
                //return false;
            //
            //if (!effectiveVisibility)
                //return false;
        //}
        //
        //return true;
    //}
    
    /**
     *  @private
     *  This method will pause or play the video by looking at the state of 
     *  the component and determining whether it should play or pause.  This 
     *  method gets called when an important event occurs, such as 
     *  the component being added/removed from the stage, the component's 
     *  effective visibility changing, or when autoPlay is set.  
     * 
     *  <p>Only certain events are "action events" which can cause the video 
     *  to pause or play immediately.  For example, when autoPlay is set to 
     *  true/false, that shouldn't cause any immediate action, but changePlayback()
     *  is still called so that autoPlay can be set on the underlying media player.</p>
     * 
     *  <p>Actions that can pause the video are:
     *  <ul>
     *      <li>Changes in effective enablement</li>
     *      <li>Changes in effective visibility</li>
     *      <li>Changes in staging (added or removed from display list)</li>
     *      <li>Setting pauseWhenHidden = true</li>
     *  </ul></p>
     * 
     *  <p>Actions that can play the video are:
     *  <ul>
     *      <li>Changes in effective visibility</li>
     *      <li>Changes in staging (added or removed from display list)</li>
     *  </ul></p>
     * 
     *  @param causePause Whether this action can cause a currently playing video to pause
     *  @param causePlay Whether this action can cause a currently paused video to play
     */
    //private function changePlayback(causePause:Boolean, causePlay:Boolean):void
    //{
        //// if we shouldn't be playing, we pause the video.
        //// if we come back up and should be playing, we will
        //// start playing the video again if the video wasn't paused 
        //// by the user or developer and autoPlay is true.       
        //if (shouldBePlaying)
        //{
            //videoPlayer.autoPlay = autoPlay;
            //
            //// only play the video if visibility caused it to pause 
            //// (instead of a user or developer calling video.pause()).
            //// Also, only play if autoPlay is true.  Otherwise when 
            //// the visibility changes, we won't automatically 
            //// play the video
            //if (causePlay && (playTheVideoOnVisible && autoPlay))
            //{
                //playTheVideoOnVisible = false;
                //
                //// set autoplay and call play() if the 
                //// source has loaded up and it's playable
                //if (inLoadingState1)
                    //cancelLoadAndPlay();
                //else if (videoPlayer.canPlay)
                    //videoPlayer.play();
            //}
        //}
        //else
        //{
            //// there are really three states the video player can 
            //// be in with respect to play vs. paused:
            //// 1) playing
            //// 2) paused
            //// 3) loading
            //// Here we are checking if we are playing or loading
            //// and going to play soon (autoPlay = true)
            //if (causePause && (playing || (videoPlayer.state == MediaPlayerState.LOADING && autoPlay)))
                //playTheVideoOnVisible = true;
//
            //// always set autoPlay to false here and 
            //// if pausable, pause the video
            //videoPlayer.autoPlay = false;
            //if (causePause)
            //{
                //// if we're loading up, then we will pause automatically, so let's 
                //// not interrupt this process
                //// if inLoadingState1 && pausable, then let loading state handle it
                //// if inLoadingState1 && !pausable, then let the loading state handle it
                //// if !inLoadingState1 && pausable, then just pause
                //// if !inLoadingState1 && !pausable, then load (if needed to show first frame)
                //if (!inLoadingState1 && videoPlayer.canPause)
                    //videoPlayer.pause();
                //else if (!videoPlayer.canPause && autoDisplayFirstFrame)
                    //load();
            //}
        //}
    //}
    
    /**
     *  @private
     *  Cancels the load, no matter what state it's in, and starts to play().
     */
    //private function cancelLoadAndPlay():void
    //{
        //if (inLoadingState1)
        //{
            //if (!inLoadingState2)
            //{
                //// first step
                //
                //// Don't need to do anything but set inLoadingState1 = false (done down below).
                //// This is handled in videoPlayer_mediaPlayerStateChangeHandlerForLoading which will still 
                //// be fired and will handle calling videoPlayer.play() without the rest of the loading 
                //// junk because inLoadingState1 = false now
            //}
            //else if (!inLoadingState3)
            //{
                //// second step
                //videoPlayer.muted = beforeLoadMuted;
                //
                //if (videoPlayer.displayObject)
                    //videoPlayer.displayObject.visible = true;
                //
                //videoPlayer.removeEventListener(TimeEvent.CURRENT_TIME_CHANGE, videoPlayer_currentTimeChangeHandler);
                //videoPlayer.removeEventListener(MediaPlayerCapabilityChangeEvent.CAN_SEEK_CHANGE, videoPlayer_canSeekChangeHandler);
            //}
            //else
            //{
                //// third step
                //videoPlayer.removeEventListener(SeekEvent.SEEKING_CHANGE, videoPlayer_seekChangeHandler);
                //videoPlayer.muted = beforeLoadMuted;
                //if (videoPlayer.displayObject)
                    //videoPlayer.displayObject.visible = true;
                //
                //// wasn't playing
                //if (videoPlayer.canPlay)
                    //videoPlayer.play();
            //}
            //
            //inLoadingState1 = false;
            //inLoadingState2 = false;
            //inLoadingState3 = false;
        //}
    //}
    
    /**
     *  @private
     *  Cancels the load, no matter what state it's in.  This is used when changing the source.
     */
    //private function cleanUpSource():void
    //{
        //// TODO (rfrishbe): very similar to cancelLoadAndPlay(). Should collapse it down.
        //
        //// always remove listener as we could be out of loadState1 but still "loading to play"
        //videoPlayer.removeEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, videoPlayer_mediaPlayerStateChangeHandlerForLoading);
        //
        //if (inLoadingState1)
        //{
            //if (!inLoadingState2)
            //{
                //// first step
                //
                //// Just need to remove event listeners as we did above
            //}
            //else if (!inLoadingState3)
            //{
                //// second step
                //videoPlayer.muted = beforeLoadMuted;
                //videoPlayer.displayObject.visible = true;
                //
                //// going to call pause() now to stop immediately
                //videoPlayer.pause();
            //}
            //else
            //{
                //// third step
                //videoPlayer.removeEventListener(SeekEvent.SEEKING_CHANGE, videoPlayer_seekChangeHandler);
                //videoPlayer.muted = beforeLoadMuted;
                //videoPlayer.displayObject.visible = true;
                //
                //// already called pause(), so don't do anything
            //}
            //
            //inLoadingState1 = false;
            //inLoadingState2 = false;
            //inLoadingState3 = false;
        //}
    //}
    
    /**
     *  @private
     */
    //private function addedToStageHandler(event:Event):void
    //{
        //_isOnDisplayList = true;
        //
        //// add listeners to current parents to see if their visibility has changed
        //if (pauseWhenHidden)
            //addVisibilityListeners();
        //
        //addEnabledListeners();
        //
        //computeEffectiveVisibilityAndEnabled();
//
        //// When added to the stage, restore some videoPlayer timers that we had
        //// disabled when we went offstage.
        //if (!isNaN(oldCurrentTimeUpdateInterval))
        //{
            //videoPlayer.currentTimeUpdateInterval = oldCurrentTimeUpdateInterval;
            //videoPlayer.bytesLoadedUpdateInterval = oldBytesLoadedUpdateInterval;
//
            //oldCurrentTimeUpdateInterval = NaN;
            //oldBytesLoadedUpdateInterval = NaN;
        //}
        //
        //// being added to the display list will not pause the video, but 
        //// it may play the video if pauseWhenHidden = true
        //changePlayback(false, pauseWhenHidden);
    //}
    
    /**
     *  @private
     */
    //private function removedFromStageHandler(event:Event):void
    //{
        //_isOnDisplayList = false;
        //
        //// remove listeners from old parents
        //if (pauseWhenHidden)
            //removeVisibilityListeners();
        //
        //removeEnabledListeners();
        //
        //// Stop the timers associated with these intervals when we go 
        //// offscreen so we are not pinned in memory. Save the old
        //// values of the timers so we can restore them when we come
        //// back on stage.
        //if (pauseWhenHidden)
        //{
            //oldCurrentTimeUpdateInterval = videoPlayer.currentTimeUpdateInterval;
            //oldBytesLoadedUpdateInterval = videoPlayer.bytesLoadedUpdateInterval;
            //videoPlayer.currentTimeUpdateInterval = -1;
            //videoPlayer.bytesLoadedUpdateInterval = -1;
        //}
        //
        //// being removed from the display list will pause the video if 
        //// pauseWhenHidden = true
        //changePlayback(pauseWhenHidden, false);
    //}
    
    /**
     *  @private
     *  Add event listeners for SHOW and HIDE on all the ancestors up the parent chain.
     *  Adding weak event listeners just to be safe.
     */
    //private function addVisibilityListeners():void
    //{
        //var current:IVisualElement = this;
        //while (current)
        //{
            //// add visibility listeners to the parent
            //current.addEventListener(FlexEvent.HIDE, visibilityChangedHandler, false, 0, true);
            //current.addEventListener(FlexEvent.SHOW, visibilityChangedHandler, false, 0, true);
            //
            //// add listeners to the design layer too
            //if (current.designLayer)
            //{
                //current.designLayer.addEventListener("layerPropertyChange", 
                    //designLayer_layerPropertyChangeHandler, false, 0, true);
            //}
            //
            //current = current.parent as IVisualElement;
        //}
    //}
    
    /**
     *  @private
     *  Add event listeners for "enabledChanged" event on all ancestors up the parent chain.
     *  Adding weak event listeners just to be safe.
     */
    //private function addEnabledListeners():void
    //{
        //var current:IVisualElement = this;
        //while (current)
        //{
            //current.addEventListener("enabledChanged", enabledChangedHandler, false, 0, true);
            //current.addEventListener("enabledChanged", enabledChangedHandler, false, 0, true);
            //
            //current = current.parent as IVisualElement;
        //}
    //}
    
    /**
     *  @private
     *  Remove event listeners for SHOW and HIDE on all the ancestors up the parent chain.
     */
    //private function removeVisibilityListeners():void
    //{
        //var current:IVisualElement = this;
        //while (current)
        //{
            //current.removeEventListener(FlexEvent.HIDE, visibilityChangedHandler, false);
            //current.removeEventListener(FlexEvent.SHOW, visibilityChangedHandler, false);
            //
            //if (current.designLayer)
            //{
                //current.designLayer.removeEventListener("layerPropertyChange", 
                    //designLayer_layerPropertyChangeHandler, false);
            //}
            //
            //current = current.parent as IVisualElement;
        //}
    //}
    
    /**
     *  @private
     *  Remove event listeners for "enabledChanged" event on all ancestors up the parent chain.
     */
    //private function removeEnabledListeners():void
    //{
        //var current:IVisualElement = this;
        //while (current)
        //{
            //current.removeEventListener("enabledChanged", enabledChangedHandler, false);
            //current.removeEventListener("enabledChanged", enabledChangedHandler, false);
            //
            //current = current.parent as IVisualElement;
        //}
    //}
    
    /**
     *  @private
     *  Event call back whenever the visibility of us or one of our ancestors 
     *  changes
     */
    //private function visibilityChangedHandler(event:FlexEvent):void
    //{
        //effectiveVisibilityChanged = true;
        //invalidateProperties();
    //}
    
    /**
     *  @private
     *  Event call back whenever the visibility of our designLayer or one of our parent's
     *  designLayers change.
     */
    //private function designLayer_layerPropertyChangeHandler(event:PropertyChangeEvent):void
    //{
        //if (event.property == "effectiveVisibility")
        //{
            //effectiveVisibilityChanged = true;
            //invalidateProperties();
        //}
    //}
    
    /**
     *  @private
     *  Event call back whenever the enablement of us or one of our ancestors 
     *  changes
     */
    //private function enabledChangedHandler(event:Event):void
    //{
        //effectiveEnabledChanged = true;
        //invalidateProperties();
    //}
    
    /**
     *  @private
     */
    //private function computeEffectiveVisibilityAndEnabled():void
    //{
        //// start out with true visibility and enablement
        //// then loop up parent-chain to see if any of them are false
        //effectiveVisibility = true;
        //effectiveEnabled = true;
        //var current:IVisualElement = this;
        //
        //while (current)
        //{
            //if (!current.visible || 
                //(current.designLayer && !current.designLayer.effectiveVisibility))
            //{
                //effectiveVisibility = false;
                //if (!effectiveEnabled)
                    //break;
            //}
            //
            //if (current is IUIComponent && !IUIComponent(current).enabled)
            //{
                //effectiveEnabled = false;
                //if (!effectiveVisibility)
                    //break;
            //}
            //
            //current = current.parent as IVisualElement;
        //}
    //}
    
    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    
    /**
     *  @private
     */
    //private function videoPlayer_volumeChangeHandler(event:AudioEvent):void
    //{
        //dispatchEvent(new Event("volumeChanged"));
    //}
    
    /**
     *  @private
     */
    //private function videoPlayer_mutedChangeHandler(event:AudioEvent):void
    //{
        //dispatchEvent(new Event("volumeChanged"));
    //}
    
    /**
     *  @private
     *  Event handler for mediaPlayerStateChange event.
     */
    //private function videoPlayer_mediaPlayerStateChangeHandler(event:MediaPlayerStateChangeEvent):void
    //{
        //// if the event change caused us to go in to a state where 
        //// nothing is loaded up and we've no chance of getting a 
        //// dimensionChangeEvent, then let's invalidate our size here
        //if (event.state == MediaPlayerState.PLAYBACK_ERROR)
            //invalidateSize();
        //
        //// this is a public event, so let's re-dispatch it
        //dispatchEvent(event);
    //}
    
    /**
     *  @private
     *  Event handler for mediaPlayerStateChange event--used only  
     *  when trying to load up the video without playing it.
     */
    //private function videoPlayer_mediaPlayerStateChangeHandlerForLoading(event:MediaPlayerStateChangeEvent):void
    //{
        //// only come in here when we want to load the video without playing it.
        ////trace("videoPlayer_mediaPlayerStateChangeHandlerForLoading: mediaPlayerState = " + event.state);
        //
        //// wait until we are ready so that we can set mute, play, pause, and seek
        //if (event.state == MediaPlayerState.READY)
        //{
            //// now that we are loading up, let's remove the event listener:
            //videoPlayer.removeEventListener(MediaPlayerStateChangeEvent.MEDIA_PLAYER_STATE_CHANGE, videoPlayer_mediaPlayerStateChangeHandlerForLoading);
            //
            //// if we are already playing() for some reason because someone called play(), then
            //// we don't need to do anything.
            //if (videoPlayer.playing)
                //return;
            //
            //// if this load wasn't cancelled, then we'll do the load stuff.
            //// otherwise, we'll just cause play().
            //if (inLoadingState1)
            //{
                ////trace("videoPlayer_mediaPlayerStateChangeHandlerForLoading: inLoadingState1");
//
                //beforeLoadMuted = videoPlayer.muted;
                //videoPlayer.muted = true;
                //
                //if (videoPlayer.displayObject)
                    //videoPlayer.displayObject.visible = false;
                //
                //inLoadingState2 = true;
            //}
            //
            //// call play(), here, then wait to call pause() and seek(0) in the 
            //// mediaSizeChangeHandler
            ////trace("videoPlayer_mediaPlayerStateChangeHandlerForLoading: call videoPlayer.play()");
            //videoPlayer.play();
        //}
    //}
    
    /**
     *  @private
     */
    //private function videoPlayer_mediaSizeChangeHandler(event:DisplayObjectEvent):void
    //{
        ////trace("videoPlayer_mediaSizeChangeHandler");
        //invalidateSize();
        //
        //// if we're loading up the video, then let's finish the load in here
        //if (inLoadingState2)
        //{
            ////trace("videoPlayer_mediaSizeChangeHandler: inLoadingState2");
//
            //if (videoPlayer.canSeek && videoPlayer.canSeekTo(0))
            //{
                ////trace("videoPlayer_mediaSizeChangeHandler: canSeek to first frame");
                //inLoadingState3 = true;
                //
                //// Don't call pause and seek inside this handler because OSMF is 
                //// not expecting us to change its HTTPStreamingState value in 
                //// HTTPNetStream.onMainTimer as a result of dispatching this 
                //// event (see SDK-27028).
                //callLater(pauseAndSeekCallBack);
            //}
            //else if (duration < 0)
            //{
                //// Work around for negative durations - FM-1009
                //// We want to seek to the first frame but we can't because the
                //// duration of the video is reported as negative. As a work around,
                //// listen for the first time change event and then pause the video.
                ////trace("videoPlayer_mediaSizeChangeHandler: negative duration - wait for first current time change event");
                //videoPlayer.addEventListener(TimeEvent.CURRENT_TIME_CHANGE, videoPlayer_currentTimeChangeHandler);
            //}
            //else
            //{
                ////trace("videoPlayer_mediaSizeChangeHandler: waiting for media to become seekable");
                //
                //// wait for the media to become seekable.
                //videoPlayer.addEventListener(MediaPlayerCapabilityChangeEvent.CAN_SEEK_CHANGE, videoPlayer_canSeekChangeHandler);
            //}
        //}
    //}

    //private function pauseAndSeekCallBack():void
    //{
        //// the seek(0) is asynchronous so let's add an event listener to see when it's finsished:
        //videoPlayer.addEventListener(SeekEvent.SEEKING_CHANGE, videoPlayer_seekChangeHandler);
        //
        //// called play(), now call pause() and seek(0);
        //videoPlayer.pause();
        //videoPlayer.seek(0);
                //
    //}
    
    /**
     *  @private
     *  Wait until the media is seekable before we call pause() and seek().
     */  
    //private function videoPlayer_canSeekChangeHandler(event:Event):void
    //{
        ////trace("videoPlayer_canSeekChangeHandler: seeking = " + videoPlayer.canSeek);
        //
        //videoPlayer.removeEventListener(MediaPlayerCapabilityChangeEvent.CAN_SEEK_CHANGE, videoPlayer_canSeekChangeHandler);
//
        //if (inLoadingState2)
        //{
            //if (videoPlayer.canSeek && videoPlayer.canSeekTo(0))
            //{
                //inLoadingState3 = true;
                //
                //// Don't call pause and seek inside this handler because OSMF is 
                //// not expecting us to change its HTTPStreamingState value in 
                //// HTTPNetStream.onMainTimer as a result of dispatching this 
                //// event (see SDK-27028).
                //callLater(pauseAndSeekCallBack);
            //}
        //}
    //}
    
    /**
     *  @private
     *  Event handler for seekEnd events.  We only use this 
     *  when trying to load up the video without playing it.
     *  This will be called after the video has loaded up and 
     *  we have finished seeking back to the first frame.
     */
    //private function videoPlayer_seekChangeHandler(event:SeekEvent):void
    //{
        //if (!event.seeking)
        //{
            //inLoadingState1 = false;
            //inLoadingState2 = false;
            //inLoadingState3 = false;
            //
            //videoPlayer.removeEventListener(SeekEvent.SEEKING_CHANGE, videoPlayer_seekChangeHandler);
            //videoPlayer.muted = beforeLoadMuted;
            //if (videoPlayer.displayObject)
                //videoPlayer.displayObject.visible = true;
//
            //// Disable the TimeEvents again that we had
            //// enabled for loading a video while offstage.
            //if (!isNaN(oldCurrentTimeUpdateInterval))
            //{
                //videoPlayer.currentTimeUpdateInterval = -1;
                //videoPlayer.bytesLoadedUpdateInterval = -1;
            //}
        //}
    //}
    
    
    /**
     *  @private
     *
     *  Work around for negative durations - see FM-1009.
     *  See want to seek to the first frame but can't because
     *  the video has a negative duration. So we listen to the
     *  current time. When we get a time change so we must be at
     *  least the first frame so pause the video now and clean 
     *  up the load state variables.
     */ 
    //private function videoPlayer_currentTimeChangeHandler(event:TimeEvent):void
    //{
        ////trace("videoPlayer_currentTimeChangeHandler: time = " + event.time);
        //
        //videoPlayer.removeEventListener(TimeEvent.CURRENT_TIME_CHANGE, videoPlayer_currentTimeChangeHandler);
        //videoPlayer.removeEventListener(MediaPlayerCapabilityChangeEvent.CAN_SEEK_CHANGE, videoPlayer_canSeekChangeHandler);
//
        //videoPlayer.pause();
        //videoPlayer.muted = beforeLoadMuted;
        //
        //if (videoPlayer.displayObject)
            //videoPlayer.displayObject.visible = true;
//
        //inLoadingState1 = false;
        //inLoadingState2 = false;
        //inLoadingState3 = false;
//
        //// Disable the TimeEvents again that we had
        //// enabled for loading a video while offstage.
        //if (!isNaN(oldCurrentTimeUpdateInterval))
        //{
            //videoPlayer.currentTimeUpdateInterval = -1;
            //videoPlayer.bytesLoadedUpdateInterval = -1;
        //}
    //}

    /**
     *  @private
     * 
     *  Work around for negative durations - see FM-1009.
     * 
     *  If we get a duration event that is negative while in 
     *  inLoadingState2 is true, then listen for the first time
     *  change event so we can pause the video.
     */ 
    //private function videoPlayer_durationChangeHandler(event:TimeEvent):void
    //{
        ////trace("videoPlayer_durationChangeHandler: time = " + event.time);
        //dispatchEvent(event);
        //
        //if (inLoadingState2)
        //{
            //if (event.time < 0)
            //{
                //// Work around for negative durations - FM-1009
                //// We want to seek to the first frame but we can't because the
                //// duration of the video is reported as negative. As a work around,
                //// listen for the first time change event and then pause the video.
                ////trace("videoPlayer_durationChangeHandler: negative duration - wait for first current time change event");
                //videoPlayer.addEventListener(TimeEvent.CURRENT_TIME_CHANGE, videoPlayer_currentTimeChangeHandler);
            //}
        //}
    //}
}
}
