package com.liveperson.plugin;

import android.content.Context;
import android.content.res.ColorStateList;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.LayoutRes;
import android.support.design.widget.AppBarLayout;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.content.ContextCompat;
import android.support.v4.graphics.drawable.DrawableCompat;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.app.AppCompatDelegate;
import android.support.v7.widget.AppCompatTextView;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;

import com.liveperson.infra.ConversationViewParams;
import com.liveperson.infra.InitLivePersonProperties;
import com.liveperson.infra.auth.LPAuthenticationParams;
import com.liveperson.infra.callbacks.InitLivePersonCallBack;
import com.liveperson.infra.messaging_ui.fragment.ConversationFragment;
import com.liveperson.messaging.sdk.api.LivePerson;
import com.liveperson.messaging.sdk.api.model.ConsumerProfile;


/**
 * Created by han.nguyen on 20-03-2018.
 * Used as a LivePerson Fragment container.
 */

public class ChatActivity extends AppCompatActivity implements SwipeBackLayout.SwipeBackListener {
    private static final String TAG = ChatActivity.class.getSimpleName();
    private static final String LIVEPERSON_FRAGMENT = "liveperson_fragment";
    private ConversationFragment mConversationFragment;
    String BrandID = "2022139";
    String AppID = "com.exchange.demoliveperson";

    private Menu mMenu;
    String package_name ;

    private final SwipeBackLayout.DragEdge DEFAULT_DRAG_EDGE = SwipeBackLayout.DragEdge.LEFT;

    protected AppBarLayout appBar;
    protected Toolbar toolbar;
    protected AppCompatTextView title;
    //Using this field to create swipe right to close child activity
    private SwipeBackLayout swipeBackLayout;
    protected boolean isSwipeBack = true;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        package_name = getApplicationContext().getPackageName();
        appBar = findViewById (getApplication().getResources().getIdentifier("appBar", "id", package_name));
        toolbar = findViewById (getApplication().getResources().getIdentifier("toolbar", "id", package_name));
        title = findViewById (getApplication().getResources().getIdentifier("title", "id", package_name));
        int layoutResID = getApplication().getResources().getIdentifier("activity_custom", "layout", package_name);
        setContentView(layoutResID);
        setTitle("Chat");
    }


    @Override
    protected void onStart(){
        super.onStart();
        initLivePerson();
        setUserProfile();
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
        mConversationFragment = (ConversationFragment)getSupportFragmentManager().findFragmentByTag(LIVEPERSON_FRAGMENT);
        Log.d(TAG, "initFragment. mConversationFragment = " + mConversationFragment);
        if (mConversationFragment == null) {
//            String authCode = SampleAppStorage.getInstance(ChatActivity.this).getAuthCode();
//            String publicKey = SampleAppStorage.getInstance(ChatActivity.this).getPublicKey();
            String authCode = "";
            String publicKey = "";

            Log.d(TAG, "initFragment. authCode = " + authCode);
            Log.d(TAG, "initFragment. publicKey = " + publicKey);
            LPAuthenticationParams authParams = new LPAuthenticationParams();
            authParams.setAuthKey(authCode);
            authParams.addCertificatePinningKey(publicKey);
            mConversationFragment = (ConversationFragment) LivePerson.getConversationFragment(authParams, new ConversationViewParams(false));

            if (isValidState()) {

//                // Pending intent for image foreground service
//                Intent notificationIntent = new Intent(this, ChatActivity.class);
//                notificationIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//                PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, 0);
//                LivePerson.setImageServicePendingIntent(pendingIntent);
//
//                // Notification builder for image upload foreground service
//                Notification.Builder uploadBuilder = new Notification.Builder(this.getApplicationContext());
//                Notification.Builder downloadBuilder = new Notification.Builder(this.getApplicationContext());
//                uploadBuilder.setContentTitle("Uploading image")
//                        .setSmallIcon(getApplication().getResources().getIdentifier("arrow_up_float", "drawable", package_name))
//                        .setContentIntent(pendingIntent)
//                        .setProgress(0, 0, true);
//
//                downloadBuilder.setContentTitle("Downloading image")
//
//                        .setSmallIcon(getApplication().getResources().getIdentifier("arrow_down_float", "drawable", package_name))
//                        .setContentIntent(pendingIntent)
//                        .setProgress(0, 0, true);
//
//                LivePerson.setImageServiceUploadNotificationBuilder(uploadBuilder);
//                LivePerson.setImageServiceDownloadNotificationBuilder(downloadBuilder);


               FragmentTransaction ft = getSupportFragmentManager().beginTransaction();

                //ft.add(R.id.custom_fragment_container, mConversationFragment, LIVEPERSON_FRAGMENT).commitAllowingStateLoss();
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

    @Override
    public void onViewPositionChanged(float fractionAnchor, float fractionScreen) {

    }

    static {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
            AppCompatDelegate.setCompatVectorFromResourcesEnabled(true);
        }
    }

    @Override
    public void setContentView(@LayoutRes int layoutResID) {
        //getWindow().setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE);
        if (isSwipeBack) {
            super.setContentView(getContainer());
            View view = LayoutInflater.from(this).inflate(layoutResID, null);
            swipeBackLayout.addView(view);
        } else {
            super.setContentView(layoutResID);
        }
        setup();
    }

    private View getContainer() {
        RelativeLayout container = new RelativeLayout(this);
        swipeBackLayout = new SwipeBackLayout(this);
        swipeBackLayout.setDragEdge(DEFAULT_DRAG_EDGE);
        swipeBackLayout.setOnSwipeBackListener(this);

        RelativeLayout.LayoutParams params =
                new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT
                        , RelativeLayout.LayoutParams.MATCH_PARENT);
        container.addView(swipeBackLayout);
        return container;
    }


    @Override
    public void setContentView(View view) {
        super.setContentView(view);
        setup();
    }

    @Override
    public void setContentView(View view, ViewGroup.LayoutParams params) {
        super.setContentView(view, params);
        setup();
    }

    void setup() {
        if (toolbar == null) {
            toolbar = findViewById (getApplication().getResources().getIdentifier("toolbar", "id", package_name));
        }
        toolbar.setContentInsetsAbsolute(0, 0);
        toolbar.setContentInsetStartWithNavigation(0);
        toolbar.setContentInsetEndWithActions(0);
        if (appBar == null) {
            appBar = findViewById (getApplication().getResources().getIdentifier("appBar", "id", package_name));
        }
        if (title == null) {
            title = findViewById (getApplication().getResources().getIdentifier("title", "id", package_name));
        }
        setSupportActionBar(toolbar);
        Drawable icBack = ContextCompat.getDrawable(this, getApplication().getResources().getIdentifier("ic_arrow_left", "drawable", package_name));
        menuTintColors(this, icBack);
        getSupportActionBar().setHomeAsUpIndicator(icBack);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setDisplayShowTitleEnabled(false);
    }

    public void menuTintColors(Context context, Drawable... drawables) {
        ColorStateList colorStateList = ContextCompat.getColorStateList(context,
                getApplication().getResources().getIdentifier("ic_menu_tint_color", "color", package_name));
        for (Drawable icMenu : drawables) {
            DrawableCompat.setTintList(icMenu, colorStateList);
        }
    }

    @Override
    public void setTitle(CharSequence title) {
        this.title.setText(title);
    }

    @Override
    public void setTitle(int titleId) {
        title.setText(getString(titleId));
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        return super.onOptionsItemSelected(item);
    }

}
