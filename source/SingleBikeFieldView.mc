using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;

class SingleBikeFieldView extends Ui.DataField {
    hidden var currentSpeed;
    hidden var averageSpeed;
    hidden var maxSpeed;
    hidden var dist;
    hidden var timer;
    hidden var time;
    hidden var battery;
    hidden var deviceWidth;

    function initialize() {
        DataField.initialize();
        
        deviceWidth = Sys.getDeviceSettings().screenWidth;
        
	    currentSpeed = 0;
	    averageSpeed = 0;
	    maxSpeed = 0;
	    dist = 0;
	    timer = 0;
	    time = 0;
	    battery = 0;
    }

    // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
    function onLayout(dc) {
        var obscurityFlags = DataField.getObscurityFlags();
        //Sys.println(obscurityFlags);

        // Top left quadrant so we'll use the top left layout
        if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.TopLeftLayout(dc));

        // Top right quadrant so we'll use the top right layout
        } else if (obscurityFlags == (OBSCURE_TOP | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.TopRightLayout(dc));

        // Bottom left quadrant so we'll use the bottom left layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.BottomLeftLayout(dc));

        // Bottom right quadrant so we'll use the bottom right layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.BottomRightLayout(dc));

        // Use the generic, centered layout
        } else {
        	var font_large_height = dc.getFontHeight(Graphics.FONT_LARGE);
        	var font_tiny_height = dc.getFontHeight(Graphics.FONT_TINY);
        	var screen_widht_30_pro = getWidth(Sys.getDeviceSettings().screenHeight/100*30);

            View.setLayout(Rez.Layouts.MainLayout(dc));
            var label_currentSpeed = View.findDrawableById("label_currentSpeed");
            label_currentSpeed.locY -= font_tiny_height-8;
            var value_currentSpeed = View.findDrawableById("value_currentSpeed");
            value_currentSpeed.locY += 3;

            var label_averageSpeed = View.findDrawableById("label_averageSpeed");
            label_averageSpeed.locX += (deviceWidth - screen_widht_30_pro) / 2;
            var value_averageSpeed = View.findDrawableById("value_averageSpeed");
            value_averageSpeed.locX += ((deviceWidth - screen_widht_30_pro) / 2) + dc.getTextWidthInPixels(Ui.loadResource(Rez.Strings.label_averageSpeed), Gfx.FONT_XTINY)+3;
/*            var label_maxSpeed = View.findDrawableById("label_maxSpeed");
            label_maxSpeed.locX -= 0;
            var value_maxSpeed = View.findDrawableById("value_maxSpeed");
            value_maxSpeed.locX -= 0;*/

            var label_dist = View.findDrawableById("label_dist");
            label_dist.locY -= font_large_height;
            var value_dist = View.findDrawableById("value_dist");
            value_dist.locY -= 10;

            var label_timer = View.findDrawableById("label_timer");
            label_timer.locY -= font_large_height-3;
            var value_timer = View.findDrawableById("value_timer");
            value_timer.locY -= 10;
        }

        View.findDrawableById("label_currentSpeed").setText(Rez.Strings.label_currentSpeed);
        View.findDrawableById("label_averageSpeed").setText(Rez.Strings.label_averageSpeed);
        //View.findDrawableById("label_maxSpeed").setText(Rez.Strings.label_maxSpeed);
        View.findDrawableById("label_dist").setText(Rez.Strings.label_dist);
        View.findDrawableById("label_timer").setText(Rez.Strings.label_timer);
        return true;
    }

    // The given info object contains all the current workout information.
    // Calculate a value and save it locally in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info) {
	    currentSpeed = info.currentSpeed == null ? 0 : info.currentSpeed*3.6;
	    averageSpeed = info.averageSpeed == null ? 0 : info.averageSpeed*3.6;
//	    maxSpeed = info.maxSpeed == null ? 0 : info.maxSpeed*3.6;
	    dist = info.elapsedDistance == null ? 0 : Math.floor(info.elapsedDistance/100)/10;
	    var t = info.elapsedTime == null ? 0 : info.elapsedTime/1000;
	    var sec = t%60;
	    t -= t%60;
	    var min = (t/60)%60;
	    t -= (t/60)%60;
	    var h = (t/60/60)%60;
	    timer = Lang.format("$1$:$2$:$3$", [h.format("%02d"), min.format("%02d"), sec.format("%02d")]);
	    t = Sys.getClockTime();
	    time = Lang.format("$1$:$2$", [t.hour.format("%02d"), t.min.format("%02d")]);
	    battery = Math.round(Sys.getSystemStats().battery);
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc) {
        // Set the background color
        View.findDrawableById("Background").setColor(DataField.getBackgroundColor());


        // Set the foreground color and value
        var value_time = View.findDrawableById("value_time");
        value_time.setColor(Gfx.COLOR_BLACK);
        value_time.setText(time);

        var value_currentSpeed = View.findDrawableById("value_currentSpeed");
        value_currentSpeed.setText(currentSpeed.format("%.2f")+" km/h");
		var value_averageSpeed = View.findDrawableById("value_averageSpeed");
        value_averageSpeed.setText(averageSpeed.format("%.2f")+" km/h");
//		var value_maxSpeed = View.findDrawableById("value_maxSpeed");
//        value_maxSpeed.setText(maxSpeed.format("%.2f")+" km/h");

        var value_dist = View.findDrawableById("value_dist");
        value_dist.setText(dist.format("%.2f")+" km");

        var value_timer = View.findDrawableById("value_timer");
        value_timer.setText(timer);

		var value_battery = View.findDrawableById("value_battery");
        value_battery.setText(battery.format("%.0f")+"%");

        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);
    }

    (:roundVersion) function getWidth(y) {
        var radius = deviceWidth / 2;
        return (2 * radius * Math.sin(Math.toRadians(2 * Math.toDegrees(Math.acos(1 - (y.toFloat() / radius)))) / 2)).toNumber();
    }
/*    (:regularVersion) function getWidth(y) {
        return deviceWidth;
    }*/

}
