<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;

class MailController extends Controller
{
    public function test(Request $request): JsonResponse
    {
        $to = $request->input('to', 'user@example.test');
        $subject = $request->input('subject', 'Laravel + Mailexam');
        $body = $request->input('body', $request->input('text', 'Mailexam test from Laravel'));

        Mail::raw($body, function ($message) use ($to, $subject): void {
            $message->to($to)->subject($subject);
        });

        return response()->json(['status' => 'ok']);
    }
}
