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
package 
{
import flash.display.*;
import flash.text.*;
import flash.events.Event;

[SWF(backgroundColor="0x0000FF", width="176", height="81")]
public class basicLoader extends MovieClip
{
	private var circle:Sprite;
	private var text:TextField;
	
	public function basicLoader()
	{
		super();
		
		text = new TextField();
		text.width = 176;
		text.height = 81;
		
		var tf:TextFormat;
		tf = new TextFormat;
		tf.bold = true;
		tf.font = "Arial";
		tf.size = "52";
		
		text.defaultTextFormat = tf;
		text.text = "Flex";
		
		addChild(text);
		
		circle = new Sprite();
		circle.graphics.beginFill(0xFF9933);
		circle.graphics.lineStyle(1);
		circle.graphics.drawCircle(0, 0, 28);
		circle.graphics.endFill();
		
		addChild(circle);
		
		addEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}
	
	private function enterFrameHandler(event:Event):void
	{
		circle.x = (circle.x + 33) % 236 - 28;
		circle.y = (circle.y + 33) % 134 - 28;		
	}
}


}

