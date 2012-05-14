// Define the overlay, derived from google.maps.OverlayView
function Label(opt_options) {
	// Initialization
	this.setValues(opt_options);
	
	// Label specific
	var span = this.span_ = document.createElement('span');
	span.className = "topUserPagePinLabel";
	
	var div = this.div_ = document.createElement('div');
	div.appendChild(span);
	div.style.cssText = 'position: absolute; display: none';
	
};
Label.prototype = new google.maps.OverlayView;

// Implement onAdd
Label.prototype.onAdd = function() {
	var pane = this.getPanes().overlayLayer;
	pane.appendChild(this.div_);

	// Ensures the label is redrawn if the text or position is changed.
	var me = this;
	this.listeners_ = [
	google.maps.event.addListener(this, 'position_changed',
		function() { me.draw(); }),
	google.maps.event.addListener(this, 'text_changed',
		function() { me.draw(); })
 ];
};

// Implement onRemove
Label.prototype.onRemove = function() {
	this.div_.parentNode.removeChild(this.div_);

	// Label is removed from the map, stop updating its position/text.
	for (var i = 0, I = this.listeners_.length; i < I; ++i) {
		google.maps.event.removeListener(this.listeners_[i]);
	}
};

// Implement draw
Label.prototype.draw = function() {
	
	var projection = this.getProjection();
	var position = projection.fromLatLngToDivPixel(this.get('position'));

	var div = this.div_;
	div.style.left = position.x + 'px';
	div.style.top = position.y + 'px';
	div.style.display = 'block';
	
	var bound = this.bound;
	var leftTop = projection.fromLatLngToDivPixel(bound.getSouthWest());
	var rightBottom = projection.fromLatLngToDivPixel(bound.getNorthEast());
	
	this.span_.style.width = parseInt(Math.abs(leftTop.x - rightBottom.x)-8) + "px";
	this.span_.style.height = parseInt(Math.abs(leftTop.y - rightBottom.y)-8) + "px";
	
	this.span_.style.marginLeft = "4px";
	this.span_.style.marginRight = "4px";
	this.span_.style.marginTop = "4px";
	this.span_.style.marginBottom = "4px";
	
	if (this.zoom == 12)
		this.span_.style.fontSize = "10px";
	else
		this.span_.style.fontSize = "14px";

	this.span_.innerHTML = this.get('text').toString();
	
};

Label.prototype.hide = function() {
  if (this.div_) {
    this.div_.style.visibility = "hidden";
  }
}

Label.prototype.show = function() {
  if (this.div_) {
    this.div_.style.visibility = "visible";
  }
}
