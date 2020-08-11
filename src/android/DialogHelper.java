package com.liveperson.plugin;

import android.app.Activity;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;


public class DialogHelper {

    private Activity activity;
    private ProgressDialog progressDialog;

    public DialogHelper(Activity activity) {
        this.activity = activity;
    }

    public void alert(String title, String message) {
        alert(title, message, null);
    }

    public void alert(String title, String message, DialogInterface.OnDismissListener dismissListener) {
        Dialog dialog = new MyDialogBuilder(activity, title, message)
                .positiveText("OK")
                .onDismiss(dismissListener)
                .single(true)
                .build();
        dialog.show();
    }

    public void action(String title, String message, String positiveText, String negativeText,
                       DialogInterface.OnClickListener takeAction) {
        Dialog dialog = new MyDialogBuilder(activity, title, message)
                .positiveText(positiveText)
                .negativeText(negativeText)
                .onPositive(takeAction)
                .build();
        dialog.show();
    }

    public void action(String title, String message, String positiveText, String negativeText,
                       DialogInterface.OnClickListener takeAction, DialogInterface.OnClickListener cancelAction) {
        Dialog dialog = new MyDialogBuilder(activity, title, message)
                .positiveText(positiveText)
                .negativeText(negativeText)
                .onPositive(takeAction)
                .onNegative(cancelAction)
                .build();
        dialog.show();
    }

}
