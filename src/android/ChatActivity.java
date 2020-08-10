package com.liveperson.plugin;

import android.app.Notification;
import android.app.PendingIntent;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;


import com.liveperson.infra.ConversationViewParams;
import com.liveperson.infra.InitLivePersonProperties;
import com.liveperson.infra.auth.LPAuthenticationParams;
import com.liveperson.infra.callbacks.InitLivePersonCallBack;
import com.liveperson.messaging.sdk.api.LivePerson;
import com.liveperson.messaging.sdk.api.model.ConsumerProfile;
import com.liveperson.infra.messaging_ui.fragment.ConversationFragment;

/**
 * Created by han.nguyen on 20-03-2018.
 * Used as a LivePerson Fragment container.
 */

public class ChatActivity extends AppCompatActivity {
    private static final String TAG = ChatActivity.class.getSimpleName();
    private static final String LIVEPERSON_FRAGMENT = "liveperson_fragment";
    private ConversationFragment mConversationFragment;
    String BrandID = "2022139";
    String AppID = "com.exchange.demoliveperson";

    private Menu mMenu;
    String package_name ;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        package_name = getApplicationContext().getPackageName();
        setContentView(getApplication().getResources().getIdentifier("activity_custom", "layout", package_name));
        setTitle("Chat");

    }

    @Override
    protected void onStart(){
        super.onStart();
        initLivePerson();
       // initFragment();
        //setUserProfile();
    }


    private void setUserProfile() {
            ConsumerProfile consumerProfile = new ConsumerProfile.Builder()
                    .setFirstName("han")
                    .setLastName("nguyen")
                    .setPhoneNumber("123456789" + "|" + "hanit0693@gmail.com")
                    .build();
            LivePerson.setUserProfile(consumerProfile);
    }



    @Override
    protected void onDestroy() {
        super.onDestroy();
    }


    private void initFragment() {
        mConversationFragment = (ConversationFragment) getSupportFragmentManager().findFragmentByTag(LIVEPERSON_FRAGMENT);
        Log.d(TAG, "initFragment. mConversationFragment = " + mConversationFragment);
        if (mConversationFragment == null) {
            String authCode = "";
            String publicKey = "";

            Log.d(TAG, "initFragment. authCode = " + authCode);
            Log.d(TAG, "initFragment. publicKey = " + publicKey);
            LPAuthenticationParams authParams = new LPAuthenticationParams();
            authParams.setAuthKey(authCode);
            authParams.addCertificatePinningKey(publicKey);
            mConversationFragment = (ConversationFragment) LivePerson.getConversationFragment(authParams, new ConversationViewParams(false));

            if (isValidState()) {
               FragmentTransaction ft = getSupportFragmentManager().beginTransaction();

                if (mConversationFragment != null) {
                    ft.add(getResources().getIdentifier("custom_fragment_container", "id", getPackageName()), mConversationFragment,
                            LIVEPERSON_FRAGMENT).commitAllowingStateLoss();
                } else {

                }

            }
        } else {
            attachFragment();
        }
    }


    private boolean isValidState() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
            return !isFinishing() && !isDestroyed();
        } else {
            return !isFinishing();
        }
    }

    private void attachFragment() {
        if (mConversationFragment.isDetached()) {
            Log.d(TAG, "initFragment. attaching fragment");
            if (isValidState()) {
                FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
                ft.attach(mConversationFragment).commitAllowingStateLoss();
            }
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (mConversationFragment != null) {
            attachFragment();
        }
    }


    @Override
    public void onBackPressed() {
        if (mConversationFragment == null || !mConversationFragment.onBackPressed()) {
            super.onBackPressed();
        }
    }

    @Override
    public boolean onSupportNavigateUp() {
        onBackPressed();
        return true;
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
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
    public void initLivePerson() {
        Log.d("HAN_NGUYEN", "initLivePerson: ");
        LivePerson.initialize(getApplicationContext(), new InitLivePersonProperties(BrandID, AppID, new InitLivePersonCallBack() {

            @Override
            public void onInitSucceed() {
                Log.i("HAN_NGUYEN", "Liverperson SDK Initialized" + LivePerson.getSDKVersion());
                initFragment();
            }

            @Override
            public void onInitFailed(Exception e) {
                Log.e("HAN_NGUYEN", "Liverperson SDK Initialization Failed : " + e.getMessage());
            }
        }));
    }
}
