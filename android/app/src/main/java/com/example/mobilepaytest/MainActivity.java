package com.example.mobilepaytest;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import dk.danskebank.mobilepay.sdk.CaptureType;
import dk.danskebank.mobilepay.sdk.Country;
import dk.danskebank.mobilepay.sdk.MobilePay;
import dk.danskebank.mobilepay.sdk.ResultCallback;
import dk.danskebank.mobilepay.sdk.model.FailureResult;
import dk.danskebank.mobilepay.sdk.model.Payment;
import dk.danskebank.mobilepay.sdk.model.SuccessResult;
import io.flutter.plugins.GeneratedPluginRegistrant;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.UUID;


public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "samples.flutter.io/mobilepay";
    private static final int MOBILEPAY_PAYMENT_REQUEST_CODE = 1337;
    private static Result sResult;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        // Initialize the AppSwitch SDK with your own Merchant ID. A country can also be provided to target specific MobilePay apps (default is DK). It is important that init() is called before everything else since it resets all settings.
        MobilePay.getInstance().init("APPDK0000000000", Country.DENMARK);

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                new MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, Result fResult) {
                        sResult = fResult;
                        goToPayment(new BigDecimal((int)call.argument("price")));
                    }
                });
    }

    private void goToPayment(BigDecimal price) {
        int MOBILEPAY_PAYMENT_REQUEST_CODE = 1337;

        tweakPaymentSettings();

// Check if the MobilePay app is installed on the device.
        boolean isMobilePayInstalled = MobilePay.getInstance().isMobilePayInstalled(getApplicationContext());

        if (isMobilePayInstalled) {
            // Create a new MobilePay Payment object.
            Payment payment = new Payment();

            // Set the product price.
            payment.setProductPrice(price);

            // Set BulkRef for this payment. Payments will be grouped under this tag.
            payment.setBulkRef("Afgift");

            // Set the order ID. This is your reference and should match your business case. Has to be unique.
            payment.setOrderId(UUID.randomUUID().toString());

            // Have the SDK create an Intent with the Payment object specified.
            Intent paymentIntent = MobilePay.getInstance().createPaymentIntent(payment);

            // We now jump to MobilePay to complete the transaction. Start MobilePay and wait for the result using an unique result code of your choice.
            startActivityForResult(paymentIntent, MOBILEPAY_PAYMENT_REQUEST_CODE);
        } else {
            // MobilePay is not installed. Use the SDK to create an Intent to take the user to Google Play and download MobilePay.
            Intent intent = MobilePay.getInstance().createDownloadMobilePayIntent(getApplicationContext());
            startActivity(intent);
        }
    }

    private void tweakPaymentSettings() {
        // Determines which type of payment you would like to start. CAPTURE, RESERVE and PARTIAL CAPTURE are the possibilities. CAPTURE is default. See the GitHub wiki for more information on each type.
        MobilePay.getInstance().setCaptureType(CaptureType.CAPTURE);
        // Set the number of seconds from the MobilePay receipt are shown to the user returns to the merchant app. Default is 1.
        MobilePay.getInstance().setReturnSeconds(1);
        // Set the number of seconds the user has to complete the payment. Default is 0, which is no timeout.
        MobilePay.getInstance().setTimeoutSeconds(0);
    }

//    private void startPayment(BigDecimal price) {
//        // Create a new MobilePay Payment object.
//        Payment payment = new Payment();
//
//        // Set the product price.
//        payment.setProductPrice(price);
//
//        // Set BulkRef for this payment. Payments will be grouped under this tag.
//        payment.setBulkRef("Afgift");
//
//        // Set the order ID. This is your reference and should match your business case. Has to be unique.
//        payment.setOrderId(UUID.randomUUID().toString());
//
//        // Have the SDK create an Intent with the Payment object specified.
//        Intent paymentIntent = MobilePay.getInstance().createPaymentIntent(payment);
//
//        // Query the SDK to see if MobilePay is present on the system.
//        boolean isMobilePayInstalled = MobilePay.getInstance().isMobilePayInstalled(getApplicationContext());
//
//        // If we determine that MobilePay is installed we start an AppSwitch payment, else we could lead the user to Google Play to download the app.
//        if (isMobilePayInstalled) {
//            // Call startActivityForResult with the Intent and a specific request code of your choice. Wait for the selected request code in OnActivityResult.
//            startActivityForResult(paymentIntent, MOBILEPAY_PAYMENT_REQUEST_CODE);
//        } else {
//            // Inform the user that MobilePay is not installed and lead them to Google Play.
//            downloadMobilePayApp();
//        }
//    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == MOBILEPAY_PAYMENT_REQUEST_CODE) {
            // We received a payment response matching our request code.

            // We call the AppSwitch SDK with resultCode and data. The SDK will handle any validation if needed and determine if the payment succeeded.
            MobilePay.getInstance().handleResult(resultCode, data, new ResultCallback() {
                @Override
                public void onSuccess(SuccessResult result) {
                    sResult.success(result.getTransactionId());
                }

                @Override
                public void onFailure(FailureResult result) {
                    sResult.error(String.valueOf(result.getErrorCode()), result.getErrorMessage(), null);
                }

                @Override
                public void onCancel() {
                    sResult.notImplemented();
                    // The payment was cancelled, which means the user jumped back from MobilePay before processing the payment.
                    ;
                }
            });
        }
    }

//    private void downloadMobilePayApp() {
//        // Simple dialog informing the user about the missing MobilePay app and offering them to install it from Google Play.
//        AlertDialog.Builder builder = new AlertDialog.Builder(this);
//        builder.setTitle("MobilePay not installed")
//                .setMessage("Do you want to download MobilePay?")
//                .setPositiveButton("Download", new DialogInterface.OnClickListener() {
//                    @Override
//                    public void onClick(DialogInterface dialog, int which) {
//                        // Create a MobilePay download Intent.
//                        Intent intent = MobilePay.getInstance().createDownloadMobilePayIntent(getApplicationContext());
//                        startActivity(intent);
//                    }
//                })
//                .setNegativeButton("Cancel", null);
//        AlertDialog dialog = builder.create();
//        dialog.show();
//    }
}
