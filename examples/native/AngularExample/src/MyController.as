package {
	import angular.material.MDAlertDialog;
	import angular.material.MDDialogService;
	import angular.IScope;
	/**
	 * @author omuppirala
	 */
	 
	public class MyController {
		
		private var $scope:IScope;
		private var $mdDialog:MDDialogService;
		
		public function MyController(scope:IScope,mdDialog:MDDialogService) {
			this.$scope = scope;
			this.$mdDialog = mdDialog;
			this.$scope["handleBtnClick"] = this.handleBtnClick;
			this.$scope["close"] = this.close;
			this.$scope["myDate"] = new Date();
			this.$scope["btnLabelStr"] = "Click me";

			//setupWatchForDate();
		}

		private function setupWatchForDate() : void {
			$scope.$watch('myDate', this.handleDateChange,true);
		}

		private function handleDateChange() : void {
			alert('Date selected: ' + $scope["myDate"].toString());
		}
		
		public function handleBtnClick(event:Event):void
		{
			$mdDialog.show(
			{
				scope: $scope,
				preserveScope: true,
      			//template: '<div style="margin:25px;"><img src="http://flex.apache.org/images/logo_01_fullcolor-sm.png" alt=""/><h1 md-heading">Angular Material</h1><img src="https://material.angularjs.org/latest/img/icons/angular-logo.svg" alt=""/><div layout="row"><span flex/><md-button ng-click=close()>CLOSE</md-button></div></div>',
      			template: '<div layout="column" layout-align="left center" style="width:500px; height:500px; margin:25px;"><h3>Select a date: </h3><md-datepicker ng-model="myDate" md-placeholder="Enter date"></md-datepicker><br>Selected date: {{myDate}}<span flex/><div layout="row"><span flex/><md-button ng-click=close()>CLOSE</md-button></div></div>',
			    clickOutsideToClose: true,
				openFrom: angular.element(document.querySelector('#myBtn')),
				closeTo: angular.element(document.querySelector('#myBtn'))
		    });
		}
		
		private function close():void
		{
			$mdDialog.cancel();
		}
	}
}