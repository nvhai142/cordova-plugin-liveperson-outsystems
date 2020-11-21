package com.liveperson.plugin;

import android.content.Context;
import android.content.res.ColorStateList;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.LayoutRes;
import android.support.design.widget.AppBarLayout;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.content.ContextCompat;
import android.support.v4.graphics.drawable.DrawableCompat;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.app.AppCompatDelegate;
import android.support.v7.widget.AppCompatTextView;
import android.support.v7.widget.Toolbar;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;

import com.liveperson.infra.BadArgumentException;
import com.liveperson.infra.CampaignInfo;
import com.liveperson.infra.ConversationViewParams;
import com.liveperson.infra.ICallback;
import com.liveperson.infra.InitLivePersonProperties;
import com.liveperson.infra.auth.LPAuthenticationParams;
import com.liveperson.infra.auth.LPAuthenticationType;
import com.liveperson.infra.callbacks.InitLivePersonCallBack;
import com.liveperson.infra.messaging_ui.fragment.ConversationFragment;
import com.liveperson.messaging.sdk.api.LivePerson;
import com.liveperson.messaging.sdk.api.model.ConsumerProfile;
import com.liveperson.messaging.sdk.api.callbacks.LogoutLivePersonCallback;

import com.liveperson.monitoring.model.EngagementDetails;
import com.liveperson.monitoring.model.LPMonitoringIdentity;
import com.liveperson.monitoring.sdk.MonitoringParams;
import com.liveperson.infra.MonitoringInitParams;
import com.liveperson.monitoring.sdk.api.LivepersonMonitoring;
import com.liveperson.monitoring.sdk.callbacks.EngagementCallback;
import com.liveperson.monitoring.sdk.callbacks.MonitoringErrorType;
import com.liveperson.monitoring.sdk.responses.LPEngagementResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Arrays;
import java.util.List;

/**
 * Created by han.nguyen on 20-03-2018.
 * Used as a LivePerson Fragment container.
 */

public class ChatActivity extends AppCompatActivity implements SwipeBackLayout.SwipeBackListener, LivepersonIntentHandler.ChatActivityCallback {
    private static final String TAG = ChatActivity.class.getSimpleName();
    private static final String LIVEPERSON_FRAGMENT = "liveperson_fragment";
    private ConversationFragment mConversationFragment;
    private static String BrandID = "47817293";
    private static String AppID = "com.outsystemsenterprise.aspirelifestylesdev.CosmoMobileApp";

    private Menu mMenu;
    String package_name ;
    private DialogHelper mDialogHelper;

    private final SwipeBackLayout.DragEdge DEFAULT_DRAG_EDGE = SwipeBackLayout.DragEdge.LEFT;

    protected AppBarLayout appBar;
    protected Toolbar toolbar;
    protected AppCompatTextView title;
    //Using this field to create swipe right to close child activity
    private SwipeBackLayout swipeBackLayout;
    protected boolean isSwipeBack = true;
    // Intent Handler
    private LivepersonIntentHandler mIntentsHandler;

    CampaignInfo campaign ;
    String partyID;

    public static String getBrandID(){
        return BrandID;
    }
    public static String getAppID(){
        return AppID;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        mDialogHelper = new DialogHelper(this);
        package_name = getApplicationContext().getPackageName();
        appBar = findViewById (getApplication().getResources().getIdentifier("appBar", "id", package_name));
        toolbar = findViewById (getApplication().getResources().getIdentifier("toolbar", "id", package_name));
        title = findViewById (getApplication().getResources().getIdentifier("title", "id", package_name));
        int layoutResID = getApplication().getResources().getIdentifier("activity_custom", "layout", package_name);
        setContentView(layoutResID);

        mIntentsHandler = new LivepersonIntentHandler(ChatActivity.this);
        setTitle("Visa Concierge");

        initLivePerson();
    }

    public void showProgressDialog() {
        mDialogHelper.showProgress();
    }

    public void dismissProgressDialog() { //CreateNewConciergeCase.View::
        mDialogHelper.dismissProgress();
    }


    @Override
    protected void onStart(){
        super.onStart();

       // setUserProfile();
    }


    private void setUserProfile() {
        Bundle extras = getIntent().getExtras();

        if(extras != null) {
            String jsonArray= extras.getString("EXTRA_PROFILE");
            try {
                JSONArray args = new JSONArray(jsonArray);
                final String firstName  = !args.isNull(1) ? args.getString(1) : "";
                final String lastName   = !args.isNull(2) ? args.getString(2) : "";
                final String nickname   = !args.isNull(3) ? args.getString(3) : "";
                final String profileImageUrl   = !args.isNull(4) ? args.getString(4) : "";
                final String phone      = !args.isNull(5) ? args.getString(5) : "";
                final String uid   = !args.isNull(6) ? args.getString(6) : "";
                final String employeeId   = !args.isNull(7) ? args.getString(7) : "";

                ConsumerProfile consumerProfile = new ConsumerProfile.Builder()
                .setFirstName(firstName)
                .setLastName(lastName)
                .setPhoneNumber(phone)
                .setNickname(nickname)
                .build();

                LivePerson.setUserProfile(consumerProfile);
            } catch (JSONException e) {
                e.printStackTrace();
            }
            
        }
        
    }



    @Override
    protected void onDestroy() {
        super.onDestroy();
    }


    private void initFragment(CampaignInfo campaignInfo) {
        dismissProgressDialog();
      //  setUserProfile();
        mConversationFragment = (ConversationFragment)getSupportFragmentManager().findFragmentByTag(LIVEPERSON_FRAGMENT);
        Log.d(TAG, "initFragment. mConversationFragment = " + mConversationFragment);
        if (mConversationFragment == null) {

            String authCode = "";
            String publicKey = "";

            Bundle extras = getIntent().getExtras();
            if(extras != null) {
                authCode= extras.getString("EXTRA_AUTHENTICATE");
            }
            Log.d(TAG, "initFragment. authCode = " + authCode);
            Log.d(TAG, "initFragment. publicKey = " + publicKey);
            LPAuthenticationParams authParams = new LPAuthenticationParams(LPAuthenticationType.AUTH);
            // add new
            ConversationViewParams conversationViewParams = new ConversationViewParams(false);

            Log.d(TAG, "initFragment. publicKey = " + campaignInfo);
            if(campaignInfo!=null){
                conversationViewParams.setCampaignInfo(campaignInfo);
            }
            //authCode = "eyJhbGciOiJSUzI1NiIsImtpZCI6Imh0dHBzOi8vYXNwaXJlLWNvbW1vbi1kZXYudmF1bHQuYXp1cmUubmV0L2tleXMvVGVzdFByaXZhdGVLZXkvNGFiY2Y3YjlmODRkNDFhNGE1MzJkOGI1ZTlkMjZjZDEiLCJ0eXAiOiJKV1QifQ.eyJzdWIiOiJTR1BfYWJjNjM3ODItMjAwMi00MjNiLWJmNDUtMzBkZmNmZDE1ZjViIiwiaXNzIjoiaHR0cDovL3d3dy5kYXJ3aW4tbGFicy5jb20iLCJpYXQiOjE2MDU4NjI4MjYsImV4cCI6MTYwNTg2NDYyNiwicHJlZmVycmVkX3VzZXJuYW1lIjoiSEFuIE5ndXllbiIsImdlbmRlciI6IkZlbWFsZSIsImVtYWlsIjoiaGl0QGdtYWlsLmNvbSIsImF1ZCI6ImRhcndpbi1sYWJzIiwianRpIjoiZGFmMjk4ODUwNWUzNDljN2JmMzIwYjllOGY1MDA2MTIifQ.pIr2PukLMn1mKa_0uJwYtY5UWPfDMhPpwerxcfxZ796AAK-W69cWQjWDioZX-nbZbPLWxHsKEaot9YyNFWO75rFw4vVzGRQxVzy7iwYPipBguPNsAd01EZ88ngKYKNGNo7fzpqrg7JTqbJUmIzKG6hVnk2otgj3-gnUYqZmqQXIAACHl4KILSAGx2KKyx690we5Z13VxRjcwCPNmkA4mwjl-fOyYcUpyAD6NZaF6C6HHuzBEI3lo35v9FAD0CLmscD1X6dvlt9a-SwfE1IaC3ByOnD6o_qV6YCHLnVDHfrwobOY45y0GO7lRnWc_nhH_PCmAIj-ac8jq1ACQf9Ar_g";
            authParams.setHostAppJWT(authCode);
            //authParams.addCertificatePinningKey(publicKey);
            //LivePerson.showConversation(this, authParams,conversationViewParams);
            mConversationFragment = (ConversationFragment) LivePerson.getConversationFragment(authParams, conversationViewParams);

            if (isValidState()) {

               FragmentTransaction ft = getSupportFragmentManager().beginTransaction();

                if (mConversationFragment != null) {
                    ft.add(getResources().getIdentifier("custom_fragment_container", "id", getPackageName()), mConversationFragment,
                            LIVEPERSON_FRAGMENT).commitAllowingStateLoss();
                } else {
                    mDialogHelper.alert("FAIL", "initFragment fail");
                }

            }else{
                mDialogHelper.alert("FAIL", "initFragment fail 2");
            }
        } else {
            attachFragment();
        }
    }

    public void initLivePerson() {
        Log.d("HAN_NGUYEN", "initLivePerson: ");
        showProgressDialog();
        Bundle extras = getIntent().getExtras();
        String newAPP;
        String newID;
        if(extras != null) {
            newAPP= extras.getString("EXTRA_APPID");
            BrandID = newAPP;
            newID = extras.getString("EXTRA_APPIDENTIFIER");
            if(newID != null){
                // AppID = newID;
            }

            MonitoringInitParams monitoringParams = new MonitoringInitParams("443bc965-320f-402b-92ce-3a79cf831267");
            LivePerson.initialize(getApplicationContext(), new InitLivePersonProperties(BrandID, AppID, monitoringParams, new InitLivePersonCallBack() {

                @Override
                public void onInitSucceed() {
                    Log.i("HAN_NGUYEN", "Liverperson SDK Initialized" + LivePerson.getSDKVersion());
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            initEngagementAttributes();
                        }
                    });
                }

                @Override
                public void onInitFailed(Exception e) {
                    Log.e("HAN_NGUYEN", "Liverperson SDK Initialization Failed : " + e.getMessage());
                }
            }));
        }
    }
    public void initEngagementAttributes(){
        

        Bundle extras = getIntent().getExtras();
        String engagementAtt = "";
        String entrypoint = "";
        if(extras != null) {
            engagementAtt= extras.getString("EXTRA_ENGAGEMENT");
            entrypoint= extras.getString("EXTRA_ENTRYPOINT");
        }   
         
        JSONArray entryPoints = null;
        try {
            entryPoints = new JSONArray(entrypoint);
        } catch (JSONException e) {
            Log.e(TAG, "Error Creating Entry Points :: " + e);
        }

        JSONArray engagementAttributes = null;
        try {
            engagementAttributes = new JSONArray(engagementAtt);
        } catch (JSONException e) {
            Log.e(TAG, "Error Creating Engagement Attr :: " + e);
        }
        MonitoringParams params = new MonitoringParams("PageId", entryPoints, engagementAttributes);
        LPMonitoringIdentity identity = new  LPMonitoringIdentity(null,"");

        // Get Engagement
        LivepersonMonitoring.getEngagement(getApplicationContext(), Arrays.asList(identity), params, new EngagementCallback() {
            @Override
            public void onSuccess(LPEngagementResponse lpEngagementResponse) {
                List<EngagementDetails> engagementList = lpEngagementResponse.getEngagementDetailsList();
                // Check if User qualifies for an Engagement
                if (engagementList != null && !engagementList.isEmpty()) {
                    // Set Campaign ID
                    String currentCampaignId = engagementList.get(0).getCampaignId();
                    // Set Engagement ID
                    String currentEngagementId = engagementList.get(0).getEngagementId();
                    // Set Engagement Context Id
                    String currentEngagementContextId = engagementList.get(0).getContextId();
                    // Set Session ID
                    String currentSessionId = lpEngagementResponse.getSessionId();
                    // Set Visitor ID
                    String currentVisitorId = lpEngagementResponse.getVisitorId();
                    // Try-Catch Block
                    try {
                        // Create Campaign Object
                        CampaignInfo campaign = new CampaignInfo(Long.valueOf(currentCampaignId), Long.valueOf(currentEngagementId),
                                currentEngagementContextId, currentSessionId, currentVisitorId);
                        initFragment(campaign);
                    } catch (Exception  e){
                        initFragment(null);
                    }
                } else {
                    // Log Error
                    initFragment(null);
                }
            }

            @Override
            public void onError(MonitoringErrorType monitoringErrorType, Exception e) {
                initFragment(null);
            }
        });
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
        if (mIntentsHandler.getIsConversationActive()) {
            menu.setGroupEnabled(getResources().getIdentifier("grp_urgent", "id", getPackageName()), true);
        } else {
            menu.setGroupEnabled(getResources().getIdentifier("grp_urgent", "id", getPackageName()), false);
        }


        if (mIntentsHandler.getIsCsatLaunched()) {
            menu.setGroupEnabled(getResources().getIdentifier("grp_clear", "id", getPackageName()), false);
        }
        return true;
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
        Drawable icBack = ContextCompat.getDrawable(this, getApplication().getResources().getIdentifier("ic_baseline_close", "drawable", package_name));
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
        int id = item.getItemId();
        if(id == getApplication().getResources().getIdentifier("clear_history", "id", package_name)) {
            // check if the history is resolved,if not skip the clear command and notify the user.
            mDialogHelper.action("Clear Conversation",
                    "All of your existing conversation history will be lost. Are you sure?",
                    "Clear", "Cancel",
                    (dialog, which) -> {
                        LivePerson.checkActiveConversation(new ICallback<Boolean, Exception>() {
                            @Override
                            public void onSuccess(Boolean aBoolean) {
                                if (!aBoolean) {
                                    //clear history only from device
                                    LivePerson.clearHistory();
                                } else {
                                    mDialogHelper.alert("Clear Conversation", "Please resolve the conversation first");
                                }

                            }

                            @Override
                            public void onError(Exception e) {
//                                    Log.e(TAG, e.getMessage());
                            }
                        });

                    });
        } else if(id == getApplication().getResources().getIdentifier("mark_as_resolved", "id", package_name)){
            mDialogHelper.action("Resolve the conversation",
                    "Are you sure this topic is resolved?",
                    "Yes", "Cancel",
                    (dialog, which) -> {
                        LivePerson.resolveConversation();
                    });
        } else {

        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    public void finishChatScreen() {
        finish();
    }

    @Override
    public void reconectChat() {
    }

    @Override
    public void setAgentName(String agentName) {
        setTitle(agentName);
    }

    @Override
    public void closeOptionMenu() {
        if (mMenu != null)
            mMenu.close();
    }
}
