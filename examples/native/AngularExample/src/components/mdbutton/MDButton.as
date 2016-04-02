package components.mdbutton {
	import components.WebComponent;
	/**
	 * @author omuppirala
	 */
	public class MDButton extends WebComponent
	{
		
		protected var label:Text;
		protected var iconSpan:HTMLSpanElement;
		override public function setupComponent():void {
			createLabel();
			createIcon();
		}
		
		protected function createLabel():void
		{
			label = ownerDocument.createTextNode("");
    		sr.appendChild(Node(label));
		}
		
		public function setLabel(labelStr:String):void {
			this.textContent = labelStr;
		}
		
		protected function createIcon():void
		{
			iconSpan = ownerDocument.createElement("span") as HTMLSpanElement;
			iconSpan.setAttribute("class","material-icons");
    		this.appendChild(iconSpan);
		}
		
		public function setIcon(iconName:String):void {
			iconSpan.textContent = iconName;
		}
		
		public function clickHandler(functionName:String):void
		{
			this.setAttribute("ng-click", functionName+"()");
		}
		
	}
}
