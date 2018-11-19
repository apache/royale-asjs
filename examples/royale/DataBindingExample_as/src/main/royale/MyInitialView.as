/**

Licensed to the Apache Software Foundation (ASF) under one or more
contributor license agreements.  See the NOTICE file distributed with
this work for additional information regarding copyright ownership.
The ASF licenses this file to You under the Apache License, Version 2.0
(the "License"); you may not use this file except in compliance with
the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

*/
package
{

//import mx.states.State;

import models.MyModel;

import org.apache.royale.binding.ConstantBinding;
import org.apache.royale.binding.SimpleBinding;
import org.apache.royale.core.SimpleCSSValuesImpl;
import org.apache.royale.core.ValuesManager;
import org.apache.royale.core.View;
import org.apache.royale.events.CustomEvent;
import org.apache.royale.events.Event;
import org.apache.royale.events.MouseEvent;
import org.apache.royale.html.CheckBox;
import org.apache.royale.html.Container;
import org.apache.royale.html.DropDownList;
import org.apache.royale.html.Label;
import org.apache.royale.html.RadioButton;
import org.apache.royale.html.TextArea;
import org.apache.royale.html.TextButton;
import org.apache.royale.html.TextInput;
import org.apache.royale.html.beads.layouts.HorizontalLayout;
import org.apache.royale.html.beads.layouts.VerticalLayout;

public class MyInitialView extends View
{

    public function MyInitialView()
    {
        addEventListener("initComplete", initCompleteHandler);
        /*
        var statesArray = [];
        var state:State = new mx.states.State();
        state.name = "hideAll";
        statesArray.push(state);
        state = new mx.states.State();
        state.name = "showAll";
        statesArray.push(state);
        states = statesArray;
        */
        var vi:SimpleCSSValuesImpl = ValuesManager.valuesImpl as SimpleCSSValuesImpl;
        vi.addRule(".output", {
            "font-size": 20
        });

        vi.addRule(".topContainer", {
            "padding": 10
        });

        vi.addRule(".leftSide", {
            "vertical-align": "top",
            "margin-right": 10
        });

        vi.addRule(".rightSide", {
            "vertical-align": "top",
            "margin-left": 10,
            "padding-left": 10
        });

        vi.addRule(".quoteButton", {
            "margin-top": 10,
            "margin-bottom": 10
        });

    }

    private function initCompleteHandler(event:Event):void
    {
        initControls();
    }

	private var _symbol:String;

    public function get symbol():String
    {
        return _symbol;
    }

	public function get requestedField():String
	{
		return radio1.selectedValue as String;
	}

    [Bindable]
    public var fieldText:String;

	private function radioChanged(e:org.apache.royale.events.Event):void
	{
		dispatchEvent(new CustomEvent("radioClicked"));
		fieldText = RadioButton(e.target).text;
	}

	private function initControls():void
	{
		list.selectedItem = MyModel(applicationModel).stockSymbol;
		radio1.selectedValue = MyModel(applicationModel).requestedField;
		if (radio1.selected)
			fieldText = radio1.text;
		else if (radio2.selected)
			fieldText = radio2.text;
		else if (radio3.selected)
			fieldText = radio3.text;
		else if (radio4.selected)
			fieldText = radio4.text;

	}

    private function setState():void
    {
        currentState = showAllData.selected ? "showAll" : "hideAll";
    }

    override public function get MXMLDescriptor():Array
    {
        var c:Container = new Container();
        c.x = 0;
        c.y = 0;
        c.className = "topContainer";
        c.addBead(new VerticalLayout());
        addElement(c);
        var l:Label = new Label();
        l.width = 300;
        l.text = "Enter Stock Symbol or choose from list:";
        c.addElement(l);
        var c2:Container = new Container();
        c2.addBead(new HorizontalLayout());
        c.addElement(c2);
        var c3:Container = new Container();
        c3.className = "leftSide";
        c3.addBead(new VerticalLayout());
        c2.addElement(c3);
        symbolTI = new TextInput();
        var sb:SimpleBinding = new SimpleBinding();
        sb.sourceID = "applicationModel";
        sb.sourcePropertyName = "stockSymbol";
        sb.eventName = "stockSymbolChanged";
        sb.destination = symbolTI;
        sb.destinationPropertyName = "text";
        sb.setDocument(this);
        addBead(sb);
        c3.addElement(symbolTI);
        var tb:TextButton = new TextButton();
        tb.text = "Get Quote";
        tb.className = "quoteButton";
        tb.addEventListener("click", tb_clickHandler);
        c3.addElement(tb);
        field = new Label();
        sb = new SimpleBinding();
        sb.sourcePropertyName = "fieldText";
        sb.eventName = "valueChange";
        sb.destination = field;
        sb.destinationPropertyName = "text";
        sb.setDocument(this);
        addBead(sb);
        c3.addElement(field);
        output = new Label();
        output.className = "output";
        output.height=24;
        sb = new SimpleBinding();
        sb.sourceID = "applicationModel";
        sb.sourcePropertyName = "responseText";
        sb.eventName = "responseTextChanged";
        sb.destination = output;
        sb.destinationPropertyName = "text";
        sb.setDocument(this);
        addBead(sb);
        c3.addElement(output);
        c3.childrenAdded();

        c3 = new Container();
        c3.className="rightSide";
        c3.addBead(new VerticalLayout());
        c2.addElement(c3);
        list = new DropDownList();
        list.width=100;
        list.height=17;
        var cb:ConstantBinding = new ConstantBinding();
        cb.sourceID = "applicationModel";
        cb.sourcePropertyName = "strings";
        cb.destination = list;
        cb.destinationPropertyName = "dataProvider";
        cb.setDocument(this);
        addBead(cb);
        list.addEventListener("change", list_changeHandler);
        c3.addElement(list);
        radio1 = new RadioButton();
        radio1.text = "Price";
        radio1.value = "Ask";
        radio1.groupName = "group1";
        radio1.addEventListener("change", radioChanged);
        c3.addElement(radio1);
        radio2 = new RadioButton();
        radio2.text = "Change";
        radio2.value = "Change";
        radio2.groupName = "group1";
        radio2.addEventListener("change", radioChanged);
        c3.addElement(radio2);
        radio3 = new RadioButton();
        radio3.text = "Day's High";
        radio3.value = "DaysHight";
        radio3.groupName = "group1";
        radio3.addEventListener("change", radioChanged);
        c3.addElement(radio3);
        radio4 = new RadioButton();
        radio4.text = "Day's Low";
        radio4.value = "DaysLow";
        radio4.groupName = "group1";
        radio4.addEventListener("change", radioChanged);
        c3.addElement(radio4);
        showAllData = new CheckBox();
        showAllData.text = "Show All Data";
        showAllData.addEventListener("change", showAllData_changeHandler);
        c3.addElement(showAllData);
        c3.childrenAdded();
        ta = new TextArea();
        ta.width = 300;
        ta.height = 100;
        sb = new SimpleBinding();
        sb.sourceID = "applicationModel";
        sb.sourcePropertyName = "allData";
        sb.eventName = "responseDataChanged";
        sb.destination = ta;
        sb.destinationPropertyName = "text";
        sb.setDocument(this);
        addBead(sb);
        c.addElement(ta);
        c2.childrenAdded();
        c.childrenAdded();

        return super.MXMLDescriptor;

    }

    /**
     *  @royalesuppresspublicvarwarning
     */
    public var symbolTI:TextInput;
    /**
     *  @royalesuppresspublicvarwarning
     */
    public var output:Label;
    /**
     *  @royalesuppresspublicvarwarning
     */
    public var field:Label;
    /**
     *  @royalesuppresspublicvarwarning
     */
    public var list:DropDownList;
    /**
     *  @royalesuppresspublicvarwarning
     */
    public var radio1:RadioButton;
    /**
     *  @royalesuppresspublicvarwarning
     */
    public var radio2:RadioButton;
    /**
     *  @royalesuppresspublicvarwarning
     */
    public var radio3:RadioButton;
    /**
     *  @royalesuppresspublicvarwarning
     */
    public var radio4:RadioButton;
    /**
     *  @royalesuppresspublicvarwarning
     */
    public var showAllData:CheckBox;
    /**
     *  @royalesuppresspublicvarwarning
     */
    public var ta:TextArea;

    private function tb_clickHandler(event:MouseEvent):void
    {
        _symbol = symbolTI.text;
        dispatchEvent(new CustomEvent('buttonClicked'));
    }

    private function list_changeHandler(event:Event):void
    {
        _symbol = list.selectedItem as String;
        dispatchEvent(new CustomEvent('listChanged'));
    }

    private function showAllData_changeHandler(event:Event):void
    {
        setState();
    }
}
}
