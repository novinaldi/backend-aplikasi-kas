<?php

namespace App\Http\Controllers;

use Kreait\Laravel\Firebase\Facades\Firebase;
use Kreait\Firebase\Messaging\CloudMessage;

class NotificationController extends Controller
{
    public function sendNotification()
    {
        try {
            $messaging = Firebase::messaging();

            $deviceToken = "dEcTWAv0QH-YV0xJeJaK2X:APA91bHZrG0vnGmdnKeBUbkSCobSWkhCDC6WZ7JeThOOShfhqTSTeLWkiEShJmrm7gWAfYMLo4mGLn_ERbC1ABR8S1Fc9UT7uHzSrtoh2-19LtWH2JUsgd8";
            $message = CloudMessage::withTarget('token', $deviceToken)
                ->withNotification(['title' => 'Tes Kirim Notifikasi', 'body' => 'Halo ini tes notifikasi'])
                ->withData(['key' => 'value']);

            $messaging->send($message);

            return "Notification sent";
        } catch (\Exception $e) {
            echo $e->getMessage();
        }
    }
}
