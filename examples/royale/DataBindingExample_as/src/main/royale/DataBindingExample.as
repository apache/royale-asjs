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

import org.apache.royale.core.Application;
import org.apache.royale.core.ItemRendererClassFactory;
import org.apache.royale.core.SimpleCSSValuesImpl;
import org.apache.royale.events.Event;
import org.apache.royale.html.beads.ContainerView;
import org.apache.royale.html.beads.GroupView;
import org.apache.royale.html.beads.DataItemRendererFactoryForArrayData;
import org.apache.royale.html.beads.ListView;
import org.apache.royale.html.beads.TextItemRendererFactoryForArrayData;
import org.apache.royale.html.beads.controllers.ItemRendererMouseController;
import org.apache.royale.html.beads.controllers.ListSingleSelectionMouseController;
import org.apache.royale.html.beads.layouts.BasicLayout;
import org.apache.royale.html.beads.layouts.VerticalLayout;
import org.apache.royale.html.beads.models.ArraySelectionModel;
import org.apache.royale.html.beads.models.TextModel;
import org.apache.royale.html.beads.models.ToggleButtonModel;
import org.apache.royale.html.beads.models.ViewportModel;
import org.apache.royale.html.supportClasses.ContainerContentArea;
import org.apache.royale.html.supportClasses.DropDownListList;
import org.apache.royale.html.supportClasses.DataGroup;
import org.apache.royale.html.supportClasses.ScrollingViewport;
import org.apache.royale.html.supportClasses.Viewport;
import org.apache.royale.html.supportClasses.StringItemRenderer;
import org.apache.royale.net.HTTPService;
import org.apache.royale.collections.parsers.JSONInputParser;
import org.apache.royale.collections.LazyCollection;
import org.apache.royale.utils.ViewSourceContextMenuOption;

COMPILE::SWF
{
import org.apache.royale.html.beads.CSSButtonView;
import org.apache.royale.html.beads.CSSTextButtonView;
import org.apache.royale.html.beads.CSSTextToggleButtonView;
import org.apache.royale.html.beads.CheckBoxView;
import org.apache.royale.html.beads.DropDownListView;
import org.apache.royale.html.beads.RadioButtonView;
import org.apache.royale.html.beads.TextInputWithBorderView;
import org.apache.royale.html.beads.models.SingleLineBorderModel;
import org.apache.royale.html.beads.models.ValueToggleButtonModel;
import org.apache.royale.html.beads.controllers.DropDownListController;
import org.apache.royale.html.beads.controllers.EditableTextKeyboardController;
import org.apache.royale.html.beads.SingleLineBorderBead;
import org.apache.royale.html.beads.SolidBackgroundBead;
import org.apache.royale.html.beads.TextAreaView;
import org.apache.royale.html.beads.TextButtonMeasurementBead;
import org.apache.royale.html.beads.TextFieldLabelMeasurementBead;
import org.apache.royale.html.beads.TextFieldView;

}

import models.MyModel;
import controllers.MyController;

public class DataBindingExample extends Application
{

    public function DataBindingExample()
    {
        addEventListener("initialize", initializeHandler);
        var vi:SimpleCSSValuesImpl = new SimpleCSSValuesImpl();
        setupStyles(vi);
        valuesImpl = vi;
        initialView = new MyInitialView();
        model = new MyModel();
        controller = new MyController(this);
        service = new HTTPService();
        collection = new LazyCollection();
        collection.inputParser = new JSONInputParser();
        collection.itemConverter = new StockDataJSONItemConverter();
        service.addBead(collection);
        addBead(service);
        addBead(new ViewSourceContextMenuOption());
    }

    /**
     *  @royalesuppresspublicvarwarning
     */
    public var service:HTTPService;
    
    /**
     *  @royalesuppresspublicvarwarning
     */
    public var collection:LazyCollection;

    private function initializeHandler(event:Event):void
    {
        MyModel(model).stockSymbol="ADBE";
    }

    private function setupStyles(vi:SimpleCSSValuesImpl):void
    {
        var viv:Object = vi.values = {};
        vi.addRule("global",
        {
            fontFamily: "Arial",
            fontSize: 12
        });

		var s:String = makeDefinitionName("org.apache.royale.html::Container");
        vi.addRule(s,
        {

            iBeadView: ContainerView,
    		iBeadLayout: BasicLayout
        });

	   var o:Object;
       COMPILE::SWF {
		    o = vi.values[s];
        	o.iContentView = ContainerContentArea;
         	o.iViewport = Viewport;
         	o.iViewportModel = ViewportModel;
         };

        s = makeDefinitionName("org.apache.royale.core::View");
		vi.addRule(s,
        {

            iBeadView: GroupView,
    		iBeadLayout: BasicLayout
        });

        COMPILE::SWF {
		    o = vi.values[s];
            o.iBackgroundBead = SolidBackgroundBead;
            o.iBorderBead = SingleLineBorderBead;
        }

        s = makeDefinitionName("org.apache.royale.html::List");
		vi.addRule(s,
        {
            iBeadModel: ArraySelectionModel,
            iBeadView:  ListView,
            iBeadController: ListSingleSelectionMouseController,
            iBeadLayout: VerticalLayout,
            iContentView: DataGroup,
            iDataProviderItemRendererMapper: DataItemRendererFactoryForArrayData,
			iViewport: ScrollingViewport,
			iViewportModel: ViewportModel,
            iItemRendererClassFactory: ItemRendererClassFactory,
            iItemRenderer: StringItemRenderer
        });

        s = makeDefinitionName("org.apache.royale.html::Button");
		vi.addRule(s,
        {
            backgroundColor: 0xd8d8d8,
			borderWidth: 1,
			borderStyle: "solid",
			borderColor: 0x000000,
            padding: 4
        });
        COMPILE::SWF {
		    o = vi.values[s];
            o.iBeadView = CSSButtonView;
        }

        s = makeDefinitionName("org.apache.royale.html::Button:hover");
		vi.addRule(s,
        {
            backgroundColor: 0x9fa0a1,
			borderWidth: 1,
			borderStyle: "solid",
			borderColor: 0x000000,
            padding: 4
        });

        s = makeDefinitionName("org.apache.royale.html::Button:active");
		vi.addRule(s,
        {
            backgroundColor: 0x929496,
			borderWidth: 1,
			borderStyle: "solid",
			borderColor: 0x000000,
            padding: 4
        });

        COMPILE::SWF {
            viv["org.apache.royale.html::CheckBox"] =
            {
                iBeadModel: ToggleButtonModel,
                iBeadView:  CheckBoxView
            };

            viv["org.apache.royale.html::DropDownList"] =
            {
                iBeadModel: ArraySelectionModel,
                iBeadView: DropDownListView,
                iBeadController: DropDownListController,
                iPopUp: DropDownListList
            };

            viv["org.apache.royale.html.supportClasses::DropDownListList"] =
            {
                iBeadModel: ArraySelectionModel,
                iDataProviderItemRendererMapper: TextItemRendererFactoryForArrayData,
                iItemRendererClassFactory: ItemRendererClassFactory,
                iItemRenderer: StringItemRenderer,
			    iBackgroundBead: SolidBackgroundBead,
				borderStyle: "solid",
    			borderRadius: 4,
			    borderColor: 0,
			    borderWidth: 1,
			    backgroundColor: 0xFFFFFF
            };

            viv["org.apache.royale.html.supportClasses::Border"] =
            {
				borderStyle: "inherit",
    			borderRadius: "inherit",
			    borderColor: "inherit",
			    borderWidth: "inherit",
			    border: "inherit"
            };

            viv["org.apache.royale.html::Label"] =
            {
                iBeadModel: TextModel,
                iBeadView: TextFieldView,
                iMeasurementBead: TextFieldLabelMeasurementBead
            };

            viv["org.apache.royale.html::List"] =
            {
                iBorderBead: SingleLineBorderBead,
                iBorderModel: SingleLineBorderModel
            };

            viv["org.apache.royale.html::RadioButton"] =
            {
                iBeadModel: ValueToggleButtonModel,
                iBeadView:  RadioButtonView
            };

            viv["org.apache.royale.html::TextArea"] =
            {
                iBeadModel: TextModel,
                iBeadView: TextAreaView,
                iBeadController: EditableTextKeyboardController,
                iBorderBead: SingleLineBorderBead,
                iBorderModel: SingleLineBorderModel,
			    borderStyle: "solid",
    			borderColor: 0,
    			borderWidth: 1,
    			backgroundColor: 0xFFFFFF
            };

            viv["org.apache.royale.html::TextButton"] =
            {
                iBeadModel: TextModel,
                iBeadView: CSSTextButtonView,
                iMeasurementBead: TextButtonMeasurementBead
            };

            viv["org.apache.royale.html::TextInput"] =
            {
                iBeadModel: TextModel,
                iBeadView: TextInputWithBorderView,
                iBeadController: EditableTextKeyboardController,
                iBorderBead: SingleLineBorderBead,
			    iBackgroundBead: SolidBackgroundBead,
			    borderStyle: "solid",
    			borderColor: 0,
    			borderWidth: 1,
    			backgroundColor: 0xFFFFFF
            };

            viv["org.apache.royale.html::ToggleTextButton"] =
            {
                iBeadModel: ToggleButtonModel,
                iBeadView:  CSSTextToggleButtonView
            };

            viv["org.apache.royale.html::SimpleList"] =
            {
                iBeadModel: ArraySelectionModel,
                iBeadView:  ListView,
                iBeadController: ListSingleSelectionMouseController,
                iBeadLayout: VerticalLayout,
                iContentView: DataGroup,
                iDataProviderItemRendererMapper: TextItemRendererFactoryForArrayData,
	    		iViewport: ScrollingViewport,
	    		iViewportModel: ViewportModel,
                iItemRendererClassFactory: ItemRendererClassFactory,
                iItemRenderer: StringItemRenderer
            }

            viv["org.apache.royale.html.supportClasses::StringItemRenderer"] =
            {
                iBeadController: ItemRendererMouseController,
                height: 16
            }
        }
    }

    private function makeDefinitionName(s:String):String
    {
        COMPILE::JS {
            s = s.replace("::", ".");
        }
        return s;
    }
}

}
