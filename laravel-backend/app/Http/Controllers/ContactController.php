<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;

class ContactController extends Controller
{
    /**
     * Check which contacts are registered users
     */
    public function checkContacts(Request $request)
    {
        $validated = $request->validate([
            'contacts' => 'required|array',
            'contacts.*.name' => 'required|string',
            'contacts.*.phone' => 'required|string',
        ]);

        $contacts = $validated['contacts'];
        $results = [];

        foreach ($contacts as $contact) {
            $normalizedPhone = $this->normalizePhoneNumber($contact['phone']);
            
            // Search for user by normalized phone number
            $user = User::where('phone', $normalizedPhone)->first();
            
            if ($user) {
                $results[] = [
                    'name' => $contact['name'],
                    'phone' => $contact['phone'],
                    'normalized_phone' => $normalizedPhone,
                    'available' => true,
                    'user' => [
                        'id' => $user->id,
                        'name' => $user->name,
                        'avatar_url' => $user->avatar_url,
                        'phone' => $user->phone,
                    ],
                ];
            } else {
                $results[] = [
                    'name' => $contact['name'],
                    'phone' => $contact['phone'],
                    'normalized_phone' => $normalizedPhone,
                    'available' => false,
                    'user' => null,
                ];
            }
        }

        // Sort by availability (available first)
        usort($results, function ($a, $b) {
            return $b['available'] <=> $a['available'];
        });

        return $this->success([
            'contacts' => $results,
            'total' => count($results),
            'available' => count(array_filter($results, fn($c) => $c['available'])),
            'not_available' => count(array_filter($results, fn($c) => !$c['available'])),
        ], 'Contacts checked successfully');
    }

    /**
     * Normalize phone number to start with 0
     * +2348012345678 -> 08012345678
     * 2348012345678 -> 08012345678
     * 08012345678 -> 08012345678
     */
    private function normalizePhoneNumber($phone)
    {
        // Remove all non-numeric characters
        $phone = preg_replace('/[^0-9]/', '', $phone);
        
        // Replace +234 or 234 with 0
        if (str_starts_with($phone, '234')) {
            $phone = '0' . substr($phone, 3);
        }
        
        return $phone;
    }
}



