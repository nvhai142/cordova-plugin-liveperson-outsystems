package com.liveperson.plugin;


import android.app.Activity;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.view.Menu;

public class MainActivity extends Activity {
    private Menu mMenu;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        String package_name = getApplication().getPackageName();
        setContentView(getApplication().getResources().getIdentifier("activity_main", "layout", package_name));
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        String package_name = getApplication().getPackageName();
        getMenuInflater().inflate(getApplication().getResources().getIdentifier("menu_chat", "layout", package_name), menu);
        mMenu = menu;
        return true;
    }
}
