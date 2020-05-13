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
package org.apache.royale.svg.elements
{
  import org.apache.royale.html.Group;
  COMPILE::JS
  public class SVGBase extends Group
  {
    public function SVGBase()
    {
      super();
    }

    override public function get x():Number{
      return Number(element.getAttribute("x"));
    }

    override public function set x(value:Number):void{
      element.setAttribute("x",value);
    }

    override public function get y():Number{
      return Number(element.getAttribute("y"));
    }
    override public function set y(value:Number):void{
      element.setAttribute("y",value);
    }

    override public function get width():Number{
      return Number(element.getAttribute("width"));
    }

    override public function set width(value:Number):void{
      element.setAttribute("width",value);
    }

    override public function get height():Number{
      return Number(element.getAttribute("height"));
    }
    override public function set height(value:Number):void{
      element.setAttribute("height",value);
    }

    protected function get svgElement():SVGElement{
      return element as SVGElement;
    }
    public function get clipPath():String{
    	return element.getAttribute("clip-path");
    }

    public function set clipPath(value:String):void{
    	element.setAttribute("clip-path",value);
    }
    public function get clipRule():String{
    	return element.getAttribute("clip-rule");
    }

    public function set clipRule(value:String):void{
    	element.setAttribute("clip-rule",value);
    }
    public function get color():String{
    	return element.getAttribute("color");
    }
    public function set color(value:String):void{
    	element.setAttribute("color",value);
    }

    public function get colorInterpolation():String{
    	return element.getAttribute("color-interpolation");
    }
    public function set colorInterpolation(value:String):void{
    	element.setAttribute("color-interpolation",value);
    }
    public function get colorRendering():String{
    	return element.getAttribute("color-rendering");
    }
    public function set colorRendering(value:String):void{
    	element.setAttribute("color-rendering",value);
    }
    public function get cursor():String{
    	return element.getAttribute("cursor");
    }
    public function set cursor(value:String):void{
    	element.setAttribute("cursor",value);
    }

    public function get display():String{
      return element.getAttribute("display");
    }
    public function set display(value:String):void{
      element.setAttribute("display",value);
    }
    public function get fill():String{
      return element.getAttribute("fill");
    }
    public function set fill(value:String):void{
      element.setAttribute("fill",value);
    }
    public function get fillOpacity():String{
      return element.getAttribute("fill-opacity");
    }
    public function set fillOpacity(value:String):void{
      element.setAttribute("fill-opacity",value);
    }
    public function get fillRule():String{
      return element.getAttribute("fill-rule");
    }
    public function set fillRule(value:String):void{
      element.setAttribute("fill-rule",value);
    }
    public function get filter():String{
      return element.getAttribute("filter");
    }
    public function set filter(value:String):void{
      element.setAttribute("filter",value);
    }
    public function get mask():String{
      return element.getAttribute("mask");
    }
    public function set mask(value:String):void{
      element.setAttribute("mask",value);
    }
    public function get opacity():String{
      return element.getAttribute("opacity");
    }
    public function set opacity(value:String):void{
      element.setAttribute("opacity",value);
    }
    public function get pointerEvents():String{
      return element.getAttribute("pointer-events");
    }
    public function set pointerEvents(value:String):void{
      element.setAttribute("pointer-events",value);
    }
    public function get shapeRendering():String{
      return element.getAttribute("shape-rendering");
    }
    public function set shapeRendering(value:String):void{
      element.setAttribute("shape-rendering",value);
    }
    public function get stroke():String{
      return element.getAttribute("stroke");
    }
    public function set stroke(value:String):void{
      element.setAttribute("stroke",value);
    }
    public function get strokeDasharray():String{
      return element.getAttribute("stroke-dasharray");
    }
    public function set strokeDasharray(value:String):void{
      element.setAttribute("stroke-dasharray",value);
    }
    public function get strokeDashoffset():String{
      return element.getAttribute("stroke-dashoffset");
    }
    public function set strokeDashoffset(value:String):void{
      element.setAttribute("stroke-dashoffset",value);
    }
    public function get strokeLinecap():String{
      return element.getAttribute("stroke-linecap");
    }
    public function set strokeLinecap(value:String):void{
      element.setAttribute("stroke-linecap",value);
    }
    public function get strokeLinejoin():String{
      return element.getAttribute("stroke-linejoin");
    }
    public function set strokeLinejoin(value:String):void{
      element.setAttribute("stroke-linejoin",value);
    }
    public function get strokeMiterlimit():String{
      return element.getAttribute("stroke-miterlimit");
    }
    public function set strokeMiterlimit(value:String):void{
      element.setAttribute("stroke-miterlimit",value);
    }
    public function get strokeOpacity():String{
      return element.getAttribute("stroke-opacity");
    }
    public function set strokeOpacity(value:String):void{
      element.setAttribute("stroke-opacity",value);
    }
    public function get strokeWidth():String{
      return element.getAttribute("stroke-width");
    }
    public function set strokeWidth(value:String):void{
      element.setAttribute("stroke-width",value);
    }
    public function get transform():String{
      return element.getAttribute("transform");
    }
    public function set transform(value:String):void{
      element.setAttribute("transform",value);
    }
    public function get vectorEffect():String{
      return element.getAttribute("vector-effect");
    }
    public function set vectorEffect(value:String):void{
      element.setAttribute("vector-effect",value);
    }
    public function get visibility():String{
      return element.getAttribute("visibility");
    }
    public function set visibility(value:String):void{
      element.setAttribute("visibility",value);
    }
    public function get tabIndex():Number{
    	return Number(element.getAttribute("tabIndex"));
    }
    public function set tabIndex(value:Number):void{
    	element.setAttribute("tabIndex",value);
    }
    public function get lang():String{
    	return element.getAttribute("xml:lang");
    }
    public function set lang(value:String):void{
      value = value || "und";
      element.setAttribute("xml:lang",value);
    }
  }
}