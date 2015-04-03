package controller
{
	import models.Alert;
	import models.ProductsModel;
	import models.Stock;
	
	import org.apache.flex.core.IBeadController;
	import org.apache.flex.core.IBeadModel;
	import org.apache.flex.core.IStrand;
	import org.apache.flex.events.Event;
	import org.apache.flex.events.EventDispatcher;
	import org.apache.flex.utils.Timer;
	
	import views.AlertsView;
	
	public class AlertsViewController extends EventDispatcher implements IBeadController
	{
		public function AlertsViewController()
		{
			super();
			
			timer = new Timer(updateInterval, 0);
			timer.addEventListener("timer", timerHandler);
		}
		
		public var updateInterval:Number = 5000;
		
		protected var timer:Timer;
			
		private var _strand:IStrand;
		
		public function set strand(value:IStrand):void
		{
			_strand = value;
			
			var view:AlertsView = value as AlertsView;
			view.addEventListener("alertSet", handleAlertSet);
		}
		
		private var _model:IBeadModel;
		public function set model(value:IBeadModel):void
		{
			_model = value;
		}
		public function get model():IBeadModel
		{
			return _model;
		}
		
		private function handleAlertSet(event:Event):void
		{
			var view:AlertsView = _strand as AlertsView;
			
			var sym:String = view.symbolField.text.toUpperCase();
			var value:Number = Number(view.valueField.text);
			
			var alert:Alert = new Alert();
			alert.symbol = sym;
			alert.value = value;
			alert.greaterThan = view.higherCheck.selected;
			
			// add this stock to the watch list in case it isn't there already
			alert.stock = (model as ProductsModel).addStock(sym);
			
			// set up the alert for the stock
			(model as ProductsModel).addAlert(alert);
			
			view.symbolField.text = "";
			view.valueField.text = "";
			
			subscribe();
		}
		
		public function subscribe():void
		{
			if (!timer.running) 
			{
				timer.start();
			}
		}
		
		public function unsubscribe():void
		{
			if (timer.running) 
			{
				timer.stop();
			}
		}
		
		/**
		 * When the timer goes off, verify all of the alerts against each stocks' last
		 * price.
		 */
		protected function timerHandler(event:*):void
		{
			var alerts:Array = (model as ProductsModel).alerts;
			
			if (alerts.length == 0) return;
			
			for (var i:int=0; i < alerts.length; i++)
			{
				var alert:Alert = alerts[i] as Alert;
				alert.message = "";
				
				if (alert.greaterThan) {
					if (alert.stock.last >= alert.value) {
						alert.message = "Now @"+alert.stock.last;
					}
				}
				else {
					if (alert.stock.last <= alert.value) {
						alert.message = "Now @"+alert.stock.last;
					}
				}
			}
			
			var newEvent:Event = new Event("alertsUpdate");
			model.dispatchEvent(newEvent);
		}
	}
}