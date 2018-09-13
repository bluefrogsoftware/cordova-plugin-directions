//
//  Directions.java
//  Copyright (c) 2014 Lee Crossley - http://ilee.co.uk
//

package uk.co.ilee.directions;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URL;
import java.net.URLEncoder;

import android.annotation.SuppressLint;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONException;
import android.content.Intent;
import android.net.Uri;
import android.os.Environment;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;

@SuppressLint("DefaultLocale")
public class Directions extends CordovaPlugin {

	@Override
	public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
		JSONObject json = args.getJSONObject(0);
    Boolean showSource = Boolean.valueOf(getJSONProperty(json, "showSource"));
    String directionsMode = "";

		if(json.has("directionsMode")) {
      directionsMode = getJSONProperty(json, "directionsMode");
    }

		if(json.has("address")) {
    			String address = getJSONProperty(json, "address");
    			try {
			doSendIntent(address, showSource, directionsMode);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}else
		{
			String latitude = getJSONProperty(json, "latitude");
			String longitude = getJSONProperty(json, "longitude");
			try {
				doSendIntent(latitude, longitude, showSource, directionsMode);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
			return true;

	}

	private String getJSONProperty(JSONObject json, String property) throws JSONException {
		if (json.has(property)) {
			return json.getString(property);
		}
		return null;
	}

	private void doSendIntent(String latitude, String longitude, Boolean showSource, String directionsMode) throws IOException {
    String uri;

	//See: https://developers.google.com/maps/documentation/urls/android-intents

	if (directionsMode.equals("driving")) { directionsMode = "d"; }
	if (directionsMode.equals("walking")) { directionsMode = "w"; }
	if (directionsMode.equals("transit")) { directionsMode = "r"; }
	if (directionsMode.equals("bicycling")) { directionsMode = "b"; }

    if (showSource) {
      uri = "http://maps.google.com/maps?f=d&daddr=" + latitude + "," + longitude + "&dirflg=" + directionsMode;
    }
    else {
      uri = "http://maps.google.com/maps?q=" + latitude + "," + longitude;
    }

		final Intent intent = new Intent(android.content.Intent.ACTION_VIEW,
			Uri.parse(uri));
		intent.setClassName("com.google.android.apps.maps", "com.google.android.maps.MapsActivity");
		cordova.startActivityForResult(this, intent, 0);
	}

	private void doSendIntent(String address, Boolean showSource, String directionsMode) throws IOException {
    String uri;

	//See: https://developers.google.com/maps/documentation/urls/android-intents

	if (directionsMode.equals("driving")) { directionsMode = "d"; }
	if (directionsMode.equals("walking")) { directionsMode = "w"; }
	if (directionsMode.equals("transit")) { directionsMode = "r"; }
	if (directionsMode.equals("bicycling")) { directionsMode = "b"; }

    if (showSource) {
      uri = "http://maps.google.com/maps?f=d&daddr=" + URLEncoder.encode(address, "UTF-8") + "&dirflg=" + directionsMode;
    }
    else {
      uri = "http://maps.google.com/maps?q=" + URLEncoder.encode(address, "UTF-8");
    }

		final Intent intent = new Intent(android.content.Intent.ACTION_VIEW,
			Uri.parse(uri));
		intent.setClassName("com.google.android.apps.maps", "com.google.android.maps.MapsActivity");
		cordova.startActivityForResult(this, intent, 0);
	}
}
