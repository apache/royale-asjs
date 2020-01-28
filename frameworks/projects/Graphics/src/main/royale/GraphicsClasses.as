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

/**
 *  @private
 *  This class is used to link additional classes into rpc.swc
 *  beyond those that are found by dependecy analysis starting
 *  from the classes specified in manifest.xml.
 */
internal class GraphicsClasses
{	

	import org.apache.royale.graphics.SolidColor; SolidColor;
	import org.apache.royale.graphics.SolidColorStroke; SolidColorStroke;
	import org.apache.royale.svg.TransformBead; TransformBead;
	import org.apache.royale.svg.LinearGradient; LinearGradient;
	import org.apache.royale.graphics.CubicCurve; CubicCurve;
	import org.apache.royale.graphics.LineStyle; LineStyle;
	import org.apache.royale.graphics.LineTo; LineTo;
	import org.apache.royale.graphics.MoveTo; MoveTo;
	import org.apache.royale.graphics.PathBuilder; PathBuilder;
	COMPILE::SWF
	{
		import org.apache.royale.graphics.utils.PathHelper; PathHelper;
	}
	COMPILE::JS 
	{
		import org.apache.royale.graphics.utils.addSvgElementToElement; addSvgElementToElement;
	}
	import org.apache.royale.graphics.QuadraticCurve; QuadraticCurve;
	import org.apache.royale.graphics.ICircle; ICircle;
	import org.apache.royale.graphics.IDrawable; IDrawable;
	import org.apache.royale.graphics.ICompoundGraphic; ICompoundGraphic;
	import org.apache.royale.graphics.IEllipse; IEllipse;
	import org.apache.royale.graphics.IPath; IPath;
	import org.apache.royale.graphics.IRect; IRect;
	import org.apache.royale.graphics.IText; IText;

	//swf level graphics api support:
	import org.apache.royale.display.Graphics; Graphics;
	import org.apache.royale.display.IGraphicsTarget; IGraphicsTarget;
	COMPILE::JS{
		import org.apache.royale.display.CapsStyle; CapsStyle;
		import org.apache.royale.display.GraphicsEndFill; GraphicsEndFill;
		import org.apache.royale.display.GraphicsGradientFill; GraphicsGradientFill;
		import org.apache.royale.display.GraphicsSolidFill; GraphicsSolidFill;
		import org.apache.royale.display.GraphicsStroke; GraphicsStroke;
		import org.apache.royale.display.IGraphicsData; IGraphicsData;
		import org.apache.royale.display.IGraphicsFill; IGraphicsFill;
		import org.apache.royale.display.IGraphicsStroke; IGraphicsStroke;
		import org.apache.royale.display.InterpolationMethod; InterpolationMethod;
		import org.apache.royale.display.JointStyle; JointStyle;
		import org.apache.royale.display.LineScaleMode; LineScaleMode;

		import org.apache.royale.display.BitmapData; BitmapData;
	}

}

}

