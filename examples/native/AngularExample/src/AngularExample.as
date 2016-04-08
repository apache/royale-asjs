package {
	import angular.IModule;

	import components.mdbutton.MDButton;
	import components.mdbutton.MDButtonFactory;
	/**
	 * @author omuppirala
	 */
	public class AngularExample {
		
		private var app:IModule;
		
		public function AngularExample() {
			//set up angular app
			app = angular.module("app",["ngMaterial"]);
			app.controller("MyController", ["$scope", "$mdDialog", MyController]);
			document.body.setAttribute("ng-app", "app");
			
			//App container
			var container:HTMLDivElement = document.createElement('div') as HTMLDivElement;
			container.style.width = '100%';
			container.style.height = '100%';
			container.setAttribute("layout", "row");
			container.setAttribute("layout-align", "center center");
			document.body.appendChild(container);
			
			//App
			var div:HTMLDivElement = document.createElement('div') as HTMLDivElement;
			div.id = 'div';
			div.style.width = '50%';
			div.style.height = '50%';
			div.setAttribute("layout", "column");
			div.setAttribute("layout-align", "center center");
			
			div.setAttribute("ng-controller", "MyController");
			div.setAttribute("md-whiteframe", "18");
			div.setAttribute("class", "md-whiteframe-14dp");
			container.appendChild(div);
			
			//App children
			div.innerHTML = '<h1>FlexJS + Angular + Angular Material Demo</h1>';
			div.innerHTML += '<span flex />';
			div.innerHTML += '<md-button id="myBtn" class="md-primary md-raised" ng-click="handleBtnClick()">{{btnLabelStr}}</md-button>';
//			div.innerHTML += '<md-datepicker ng-model="myDate" md-placeholder="Enter date"></md-datepicker>';
//			div.innerHTML += '<md-progress-circular md-mode="indeterminate"></md-progress-circular>';
			div.innerHTML += '<md-input-container class="md-block" flex-gt-sm><label>Change button label...</label><input ng-model="btnLabelStr"></md-input-container>';
			div.innerHTML += '<span flex />';

//			var labelButtonClass:Object = MDButtonFactory.getInstance().getButtonClass();
//			var labelButton:MDButton = new labelButtonClass();
//			labelButton.setAttribute("class", "md-primary md-raised");
//			div.appendChild(labelButton);
//			labelButton.setLabel("Label Button");
			
//			var cakeButtonClass:Object = MDButtonFactory.getInstance().getButtonClass();
//			var cakeButton:MDButton = new cakeButtonClass();
//			cakeButton.setAttribute("class", "md-fab");
//			//cakeButton.setAttribute("md-no-ink", "");
//			div.appendChild(cakeButton);
//			cakeButton.setIcon("cake");
//			cakeButton.clickHandler("handleBtnClick");
			
		}

	}
}