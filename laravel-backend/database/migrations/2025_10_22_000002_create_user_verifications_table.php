<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('user_verifications', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            
            // BVN Verification fields
            $table->string('bvn_number')->nullable();
            $table->string('bvn_first_name')->nullable();
            $table->string('bvn_middle_name')->nullable();
            $table->string('bvn_surname')->nullable();
            $table->date('bvn_date_of_birth')->nullable();
            $table->enum('bvn_verification_status', ['not_started', 'pending', 'verified', 'rejected'])->default('not_started');
            $table->text('bvn_rejection_reason')->nullable();
            $table->timestamp('bvn_verified_at')->nullable();
            
            // ID Card Verification fields
            $table->string('id_card_type')->nullable(); // national_id, driver_license, passport, etc.
            $table->string('id_card_number')->nullable();
            $table->string('id_card_front_image')->nullable();
            $table->string('id_card_back_image')->nullable();
            $table->enum('id_card_verification_status', ['not_started', 'pending', 'verified', 'rejected'])->default('not_started');
            $table->text('id_card_rejection_reason')->nullable();
            $table->timestamp('id_card_verified_at')->nullable();
            
            // Selfie Verification fields
            $table->string('selfie_image')->nullable();
            $table->enum('selfie_verification_status', ['not_started', 'pending', 'verified', 'rejected'])->default('not_started');
            $table->text('selfie_rejection_reason')->nullable();
            $table->timestamp('selfie_verified_at')->nullable();
            
            $table->timestamps();
            
            // Indexes for better performance
            $table->index(['user_id', 'bvn_verification_status']);
            $table->index(['user_id', 'id_card_verification_status']);
            $table->index(['user_id', 'selfie_verification_status']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('user_verifications');
    }
};
