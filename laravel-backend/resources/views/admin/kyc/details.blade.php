@extends('layouts.admin')

@section('title', 'User Verification Details - ' . $user->name)
@section('page-title', 'User Verification Details')
@section('page-description', 'View detailed verification information for ' . $user->name)

@section('content')
<div class="row g-4">
    <!-- User Information Card -->
    <div class="col-12">
        <div class="data-table">
            <div class="table-header">
                <h5 class="table-title">User Information</h5>
                <div class="d-flex align-items-center gap-2">
                    <span class="badge bg-primary">{{ $user->name }}</span>
                    <button onclick="window.close()" class="btn btn-outline-secondary btn-sm">
                        <i class="bi bi-arrow-left"></i> Back
                    </button>
                </div>
            </div>
            <div class="p-3">
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Name</label>
                        <p class="mb-0">{{ $user->name }}</p>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Email</label>
                        <p class="mb-0">{{ $user->email }}</p>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Phone</label>
                        <p class="mb-0">{{ $user->phone ?? 'N/A' }}</p>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">School</label>
                        <p class="mb-0">{{ $user->school->name ?? 'N/A' }}</p>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Faculty</label>
                        <p class="mb-0">{{ $user->faculty->name ?? 'N/A' }}</p>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Department</label>
                        <p class="mb-0">{{ $user->department->name ?? 'N/A' }}</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    @if($verificationDetails)
    <!-- BVN Verification Card -->
    <div class="col-12">
        <div class="data-table">
            <div class="table-header">
                <h5 class="table-title">BVN Verification</h5>
                <span class="badge {{ $verificationDetails['bvn']['status'] === 'verified' ? 'bg-success' : ($verificationDetails['bvn']['status'] === 'rejected' ? 'bg-danger' : 'bg-warning') }}">
                    {{ ucfirst($verificationDetails['bvn']['status']) }}
                </span>
            </div>
            <div class="p-3">
                @if($verificationDetails['bvn']['status'] !== 'not_started')
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">BVN Number</label>
                        <p class="mb-0">{{ $verificationDetails['bvn']['number'] ?? 'N/A' }}</p>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">First Name</label>
                        <p class="mb-0">{{ $verificationDetails['bvn']['first_name'] ?? 'N/A' }}</p>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Middle Name</label>
                        <p class="mb-0">{{ $verificationDetails['bvn']['middle_name'] ?? 'N/A' }}</p>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Surname</label>
                        <p class="mb-0">{{ $verificationDetails['bvn']['surname'] ?? 'N/A' }}</p>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Date of Birth</label>
                        <p class="mb-0">{{ $verificationDetails['bvn']['date_of_birth'] ?? 'N/A' }}</p>
                    </div>
                    @if($verificationDetails['bvn']['verified_at'])
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Verified At</label>
                        <p class="mb-0">{{ \Carbon\Carbon::parse($verificationDetails['bvn']['verified_at'])->format('M d, Y H:i') }}</p>
                    </div>
                    @endif
                </div>
                
                @if($verificationDetails['bvn']['rejection_reason'])
                <div class="mt-3">
                    <label class="form-label fw-semibold text-danger">Rejection Reason</label>
                    <div class="alert alert-danger mb-0">{{ $verificationDetails['bvn']['rejection_reason'] }}</div>
                </div>
                @endif
                @else
                <div class="text-center py-4">
                    <i class="bi bi-info-circle text-muted" style="font-size: 2rem;"></i>
                    <p class="text-muted mt-2">No BVN verification submitted yet.</p>
                </div>
                @endif
            </div>
        </div>
    </div>

    <!-- ID Card Verification Card -->
    <div class="col-12">
        <div class="data-table">
            <div class="table-header">
                <h5 class="table-title">ID Card Verification</h5>
                <span class="badge {{ $verificationDetails['id_card']['status'] === 'verified' ? 'bg-success' : ($verificationDetails['id_card']['status'] === 'rejected' ? 'bg-danger' : 'bg-warning') }}">
                    {{ ucfirst($verificationDetails['id_card']['status']) }}
                </span>
            </div>
            <div class="p-3">
                @if($verificationDetails['id_card']['status'] !== 'not_started')
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">ID Card Type</label>
                        <p class="mb-0">{{ ucfirst(str_replace('_', ' ', $verificationDetails['id_card']['type'])) ?? 'N/A' }}</p>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">ID Card Number</label>
                        <p class="mb-0">{{ $verificationDetails['id_card']['number'] ?? 'N/A' }}</p>
                    </div>
                    @if($verificationDetails['id_card']['verified_at'])
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Verified At</label>
                        <p class="mb-0">{{ \Carbon\Carbon::parse($verificationDetails['id_card']['verified_at'])->format('M d, Y H:i') }}</p>
                    </div>
                    @endif
                </div>
                
                @if($verificationDetails['id_card']['front_image'] || $verificationDetails['id_card']['back_image'])
                <div class="mt-4">
                    <label class="form-label fw-semibold">ID Card Images</label>
                    @if(config('app.debug'))
                    <div class="alert alert-info small">
                        <strong>Debug Info:</strong><br>
                        Front Image Path: {{ $verificationDetails['id_card']['front_image'] ?? 'N/A' }}<br>
                        Back Image Path: {{ $verificationDetails['id_card']['back_image'] ?? 'N/A' }}<br>
                        Front Image URL: {{ isset($verificationDetails['id_card']['front_image']) ? Storage::url($verificationDetails['id_card']['front_image']) : 'N/A' }}<br>
                        Back Image URL: {{ isset($verificationDetails['id_card']['back_image']) ? Storage::url($verificationDetails['id_card']['back_image']) : 'N/A' }}
                    </div>
                    @endif
                    <div class="row g-3">
                        @if($verificationDetails['id_card']['front_image'])
                        <div class="col-md-6">
                            <label class="form-label">Front Image</label>
                            <div class="border rounded p-2">
                                <img src="{{ Storage::url($verificationDetails['id_card']['front_image']) }}" 
                                     alt="ID Card Front" 
                                     class="img-fluid rounded"
                                     onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjIwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSIjZGRkIi8+PHRleHQgeD0iNTAlIiB5PSI1MCUiIGZvbnQtZmFtaWx5PSJBcmlhbCIgZm9udC1zaXplPSIxNCIgZmlsbD0iIzk5OSIgdGV4dC1hbmNob3I9Im1pZGRsZSIgZHk9Ii4zZW0iPkltYWdlIE5vdCBGb3VuZDwvdGV4dD48L3N2Zz4='; this.onerror=null;">
                            </div>
                        </div>
                        @endif
                        @if($verificationDetails['id_card']['back_image'])
                        <div class="col-md-6">
                            <label class="form-label">Back Image</label>
                            <div class="border rounded p-2">
                                <img src="{{ Storage::url($verificationDetails['id_card']['back_image']) }}" 
                                     alt="ID Card Back" 
                                     class="img-fluid rounded"
                                     onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjIwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSIjZGRkIi8+PHRleHQgeD0iNTAlIiB5PSI1MCUiIGZvbnQtZmFtaWx5PSJBcmlhbCIgZm9udC1zaXplPSIxNCIgZmlsbD0iIzk5OSIgdGV4dC1hbmNob3I9Im1pZGRsZSIgZHk9Ii4zZW0iPkltYWdlIE5vdCBGb3VuZDwvdGV4dD48L3N2Zz4='; this.onerror=null;">
                            </div>
                        </div>
                        @endif
                    </div>
                </div>
                @endif
                
                @if($verificationDetails['id_card']['rejection_reason'])
                <div class="mt-3">
                    <label class="form-label fw-semibold text-danger">Rejection Reason</label>
                    <div class="alert alert-danger mb-0">{{ $verificationDetails['id_card']['rejection_reason'] }}</div>
                </div>
                @endif
                @else
                <div class="text-center py-4">
                    <i class="bi bi-info-circle text-muted" style="font-size: 2rem;"></i>
                    <p class="text-muted mt-2">No ID card verification submitted yet.</p>
                </div>
                @endif
            </div>
        </div>
    </div>

    <!-- Selfie Verification Card -->
    <div class="col-12">
        <div class="data-table">
            <div class="table-header">
                <h5 class="table-title">Selfie Verification</h5>
                <span class="badge {{ $verificationDetails['selfie']['status'] === 'verified' ? 'bg-success' : ($verificationDetails['selfie']['status'] === 'rejected' ? 'bg-danger' : 'bg-warning') }}">
                    {{ ucfirst($verificationDetails['selfie']['status']) }}
                </span>
            </div>
            <div class="p-3">
                @if($verificationDetails['selfie']['status'] !== 'not_started')
                @if($verificationDetails['selfie']['verified_at'])
                <div class="row g-3 mb-3">
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Verified At</label>
                        <p class="mb-0">{{ \Carbon\Carbon::parse($verificationDetails['selfie']['verified_at'])->format('M d, Y H:i') }}</p>
                    </div>
                </div>
                @endif
                
                @if($verificationDetails['selfie']['image'])
                <div class="mt-3">
                    <label class="form-label fw-semibold">Selfie Image</label>
                    @if(config('app.debug'))
                    <div class="alert alert-info small">
                        <strong>Debug Info:</strong><br>
                        Selfie Image Path: {{ $verificationDetails['selfie']['image'] }}<br>
                        Selfie Image URL: {{ Storage::url($verificationDetails['selfie']['image']) }}
                    </div>
                    @endif
                    <div class="border rounded p-2 d-inline-block">
                        <img src="{{ Storage::url($verificationDetails['selfie']['image']) }}" 
                             alt="Selfie" 
                             class="img-fluid rounded" 
                             style="max-width: 200px;"
                             onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjIwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSIjZGRkIi8+PHRleHQgeD0iNTAlIiB5PSI1MCUiIGZvbnQtZmFtaWx5PSJBcmlhbCIgZm9udC1zaXplPSIxNCIgZmlsbD0iIzk5OSIgdGV4dC1hbmNob3I9Im1pZGRsZSIgZHk9Ii4zZW0iPkltYWdlIE5vdCBGb3VuZDwvdGV4dD48L3N2Zz4='; this.onerror=null;">
                    </div>
                </div>
                @endif
                
                @if($verificationDetails['selfie']['rejection_reason'])
                <div class="mt-3">
                    <label class="form-label fw-semibold text-danger">Rejection Reason</label>
                    <div class="alert alert-danger mb-0">{{ $verificationDetails['selfie']['rejection_reason'] }}</div>
                </div>
                @endif
                @else
                <div class="text-center py-4">
                    <i class="bi bi-info-circle text-muted" style="font-size: 2rem;"></i>
                    <p class="text-muted mt-2">No selfie verification submitted yet.</p>
                </div>
                @endif
            </div>
        </div>
    </div>
    @else
    <!-- No Verification Data -->
    <div class="col-12">
        <div class="data-table">
            <div class="table-header">
                <h5 class="table-title">Verification Status</h5>
            </div>
            <div class="p-3 text-center py-5">
                <i class="bi bi-info-circle text-muted" style="font-size: 3rem;"></i>
                <p class="text-muted mt-3">No verification data available for this user.</p>
            </div>
        </div>
    </div>
    @endif
</div>
@endsection