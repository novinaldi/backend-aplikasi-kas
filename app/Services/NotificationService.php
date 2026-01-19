<?php

namespace App\Services;

use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\CloudMessage;

class NotificationService
{
    protected $messaging;

    public function __construct()
    {
        $this->messaging = (new Factory)->createMessaging();
    }

    public function sendPushNotification($deviceToken, $title, $message)
    {
        $notification = CloudMessage::withTarget('token', $deviceToken)
            ->withNotification([
                'title' => $title,
                'body' => $message,
            ]);

        try {
            $this->messaging->send($notification);
        } catch (MessagingException $e) {
            // Handle error
            dd($e->getMessage());
        }
    }
}
