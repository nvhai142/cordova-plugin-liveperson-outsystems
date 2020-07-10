package com.liveperson.plugin;


import android.app.Activity;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;

import com.liveperson.api.LivePersonCallbackImpl;
import com.liveperson.api.sdk.LPConversationData;
import com.liveperson.infra.InitLivePersonProperties;
import com.liveperson.infra.callbacks.InitLivePersonCallBack;
import com.liveperson.messaging.TaskType;
import com.liveperson.messaging.model.AgentData;
import com.liveperson.messaging.sdk.api.LivePerson;
import com.liveperson.messaging.sdk.api.callbacks.LogoutLivePersonCallback;
import com.liveperson.messaging.sdk.api.model.ConsumerProfile;

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
        getMenuInflater().inflate(getApplication().getResources().getIdentifier("menu_chat", "menu", package_name), menu);
        mMenu = menu;
        return true;
    }
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();
        return super.onOptionsItemSelected(item);
    }


    @Override
    public boolean onPrepareOptionsMenu(Menu menu) {
        return true;
    }
}
