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

/**
 *  Modality of components launched by the PopUp Manager is simulated by
 *  creating a large translucent overlay underneath the component.
 *  Because of the way translucent objects are rendered, you may notice a slight
 *  dimming of the objects under the overlay.
 *  The effective transparency can be set by changing the
 *  <code>modalTransparency</code> value from 0.0 (fully transparent)
 *  to 1.0 (fully opaque).
 *  You can also set the color of the overlay by changing the 
 *  <code>modalTransparencyColor</code> style.
 *
 *  @default 0.5
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="modalTransparency", type="Number", inherit="yes")]

/**
 *  The blur applied to the application while a modal window is open.
 *  A Blur effect softens the details of an image. 
 *  
 *  @see flash.filters.BlurFilter
 *
 *  @default 3
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="modalTransparencyBlur", type="Number", inherit="yes")]

/**
 *  Color of the modal overlay layer. This style is used in conjunction
 *  with the <code>modalTransparency</code> style to determine the colorization 
 *  applied to the application when a modal window is open.
 *
 *  @default #DDDDDD
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="modalTransparencyColor", type="uint", format="Color", inherit="yes")]

/**
 *  Duration, in milliseconds, of the modal transparency effect that
 *  plays when a modal window opens or closes.
 *
 *  @default 100
 *  
 *  @langversion 3.0
 *  @playerversion Flash 9
 *  @playerversion AIR 1.1
 *  @productversion Flex 3
 */
[Style(name="modalTransparencyDuration", type="Number", format="Time", inherit="yes")]
