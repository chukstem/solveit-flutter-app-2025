<?php

namespace App\Http\Controllers;

use App\Models\Service;
use App\Models\ServiceCategory;
use App\Models\ServiceBooking;
use App\Models\ServiceRating;
use App\Models\ServicePayment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ServiceController extends Controller
{
    /**
     * Get all services with pagination and filters.
     */
    public function getServices(Request $request)
    {
        $query = Service::with(['user', 'category', 'bookings', 'ratings']);

        // Filter by category
        if ($request->has('category_id')) {
            $query->where('category_id', $request->category_id);
        }

        // Filter by location
        if ($request->has('location')) {
            $query->where('location', 'like', "%{$request->location}%");
        }

        // Filter by price range
        if ($request->has('min_price')) {
            $query->where('price', '>=', $request->min_price);
        }
        if ($request->has('max_price')) {
            $query->where('price', '<=', $request->max_price);
        }

        // Filter by availability
        if ($request->has('is_available')) {
            $query->where('is_available', $request->boolean('is_available'));
        }

        // Filter by rating
        if ($request->has('min_rating')) {
            $query->where('rating', '>=', $request->min_rating);
        }

        // Search
        if ($request->has('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', "%{$search}%")
                  ->orWhere('description', 'like', "%{$search}%");
            });
        }

        // Sort
        $sortBy = $request->get('sort_by', 'created_at');
        $sortOrder = $request->get('sort_order', 'desc');
        $query->orderBy($sortBy, $sortOrder);

        $services = $query->paginate(20);

        return $this->success($services);
    }

    /**
     * Get a single service by ID.
     */
    public function getService($id)
    {
        $service = Service::with(['user', 'category', 'bookings', 'ratings.user'])
            ->find($id);

        if (!$service) {
            return $this->notFound('Service not found');
        }

        // Increment views count
        $service->increment('views_count');

        return $this->success($service);
    }

    /**
     * Create a new service.
     */
    public function createService(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'category_id' => 'required|exists:service_categories,id',
            'name' => 'required|string|max:255',
            'description' => 'required|string',
            'price' => 'required|numeric|min:0',
            'duration' => 'nullable|string',
            'location' => 'required|string',
            'images' => 'nullable|array',
            'images.*' => 'file|mimes:jpeg,png,jpg,gif|max:5120',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $user = auth()->user();

        $service = Service::create([
            'user_id' => $user->id,
            'category_id' => $request->category_id,
            'name' => $request->name,
            'description' => $request->description,
            'price' => $request->price,
            'duration' => $request->duration,
            'location' => $request->location,
        ]);

        // Handle image uploads
        if ($request->hasFile('images')) {
            foreach ($request->file('images') as $file) {
                $service->addMediaFromRequest($file)->toMediaCollection('images');
            }
        }

        return $this->success($service->load(['user', 'category']), 'Service created successfully');
    }

    /**
     * Update a service.
     */
    public function updateService(Request $request, $id)
    {
        $service = Service::find($id);

        if (!$service) {
            return $this->notFound('Service not found');
        }

        // Check if user can update this service
        if ($service->user_id !== auth()->id()) {
            return $this->forbidden('You can only update your own services');
        }

        $validator = Validator::make($request->all(), [
            'category_id' => 'sometimes|exists:service_categories,id',
            'name' => 'sometimes|string|max:255',
            'description' => 'sometimes|string',
            'price' => 'sometimes|numeric|min:0',
            'duration' => 'nullable|string',
            'location' => 'sometimes|string',
            'is_available' => 'boolean',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $service->update($request->only([
            'category_id', 'name', 'description', 'price', 'duration', 'location', 'is_available'
        ]));

        return $this->success($service->load(['user', 'category']), 'Service updated successfully');
    }

    /**
     * Delete a service.
     */
    public function deleteService($id)
    {
        $service = Service::find($id);

        if (!$service) {
            return $this->notFound('Service not found');
        }

        // Check if user can delete this service
        if ($service->user_id !== auth()->id()) {
            return $this->forbidden('You can only delete your own services');
        }

        $service->delete();

        return $this->success(null, 'Service deleted successfully');
    }

    /**
     * Get service categories.
     */
    public function getCategories()
    {
        $categories = ServiceCategory::where('is_active', true)->get();
        return $this->success($categories);
    }

    /**
     * Create a service category.
     */
    public function createCategory(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'icon' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $category = ServiceCategory::create($request->all());

        return $this->success($category, 'Category created successfully');
    }

    /**
     * Book a service.
     */
    public function bookService(Request $request, $serviceId)
    {
        $validator = Validator::make($request->all(), [
            'booking_date' => 'required|date|after:today',
            'booking_time' => 'required|date_format:H:i',
            'duration' => 'nullable|string',
            'notes' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $service = Service::find($serviceId);

        if (!$service) {
            return $this->notFound('Service not found');
        }

        if (!$service->is_available) {
            return $this->error('Service is not available', 400);
        }

        $booking = ServiceBooking::create([
            'user_id' => auth()->id(),
            'service_id' => $serviceId,
            'booking_date' => $request->booking_date,
            'booking_time' => $request->booking_time,
            'duration' => $request->duration,
            'notes' => $request->notes,
            'total_amount' => $service->price,
        ]);

        return $this->success($booking->load(['user', 'service']), 'Service booked successfully');
    }

    /**
     * Get service bookings.
     */
    public function getBookings(Request $request)
    {
        $query = ServiceBooking::with(['user', 'service']);

        // Filter by user
        if ($request->has('user_id')) {
            $query->where('user_id', $request->user_id);
        }

        // Filter by service
        if ($request->has('service_id')) {
            $query->where('service_id', $request->service_id);
        }

        // Filter by status
        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        $bookings = $query->orderBy('created_at', 'desc')->paginate(20);

        return $this->success($bookings);
    }

    /**
     * Update booking status.
     */
    public function updateBookingStatus(Request $request, $bookingId)
    {
        $validator = Validator::make($request->all(), [
            'status' => 'required|string|in:pending,confirmed,cancelled,completed',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $booking = ServiceBooking::find($bookingId);

        if (!$booking) {
            return $this->notFound('Booking not found');
        }

        // Check if user can update this booking
        if ($booking->user_id !== auth()->id() && $booking->service->user_id !== auth()->id()) {
            return $this->forbidden('You can only update your own bookings');
        }

        $booking->update(['status' => $request->status]);

        return $this->success($booking->load(['user', 'service']), 'Booking status updated successfully');
    }

    /**
     * Rate a service.
     */
    public function rateService(Request $request, $serviceId)
    {
        $validator = Validator::make($request->all(), [
            'rating' => 'required|integer|min:1|max:5',
            'comment' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $service = Service::find($serviceId);

        if (!$service) {
            return $this->notFound('Service not found');
        }

        // Check if user has already rated this service
        $existingRating = ServiceRating::where('user_id', auth()->id())
            ->where('service_id', $serviceId)
            ->first();

        if ($existingRating) {
            return $this->error('You have already rated this service', 400);
        }

        $rating = ServiceRating::create([
            'user_id' => auth()->id(),
            'service_id' => $serviceId,
            'rating' => $request->rating,
            'comment' => $request->comment,
        ]);

        // Update service rating
        $service->update([
            'rating' => ServiceRating::where('service_id', $serviceId)->avg('rating'),
            'reviews_count' => ServiceRating::where('service_id', $serviceId)->count(),
        ]);

        return $this->success($rating->load('user'), 'Service rated successfully');
    }

    /**
     * Get service ratings.
     */
    public function getRatings($serviceId)
    {
        $ratings = ServiceRating::with('user')
            ->where('service_id', $serviceId)
            ->where('is_approved', true)
            ->orderBy('created_at', 'desc')
            ->paginate(20);

        return $this->success($ratings);
    }

    /**
     * Create a service payment.
     */
    public function createPayment(Request $request, $serviceId)
    {
        $validator = Validator::make($request->all(), [
            'booking_id' => 'nullable|exists:service_bookings,id',
            'amount' => 'required|numeric|min:0',
            'payment_method' => 'required|string',
            'notes' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $service = Service::find($serviceId);

        if (!$service) {
            return $this->notFound('Service not found');
        }

        $payment = ServicePayment::create([
            'user_id' => auth()->id(),
            'service_id' => $serviceId,
            'booking_id' => $request->booking_id,
            'amount' => $request->amount,
            'payment_method' => $request->payment_method,
            'notes' => $request->notes,
        ]);

        return $this->success($payment->load(['user', 'service', 'booking']), 'Payment created successfully');
    }

    /**
     * Get service payments.
     */
    public function getPayments(Request $request)
    {
        $query = ServicePayment::with(['user', 'service', 'booking']);

        // Filter by user
        if ($request->has('user_id')) {
            $query->where('user_id', $request->user_id);
        }

        // Filter by service
        if ($request->has('service_id')) {
            $query->where('service_id', $request->service_id);
        }

        // Filter by status
        if ($request->has('payment_status')) {
            $query->where('payment_status', $request->payment_status);
        }

        $payments = $query->orderBy('created_at', 'desc')->paginate(20);

        return $this->success($payments);
    }

    /**
     * Update payment status.
     */
    public function updatePaymentStatus(Request $request, $paymentId)
    {
        $validator = Validator::make($request->all(), [
            'payment_status' => 'required|string|in:pending,completed,failed,refunded',
            'transaction_id' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        $payment = ServicePayment::find($paymentId);

        if (!$payment) {
            return $this->notFound('Payment not found');
        }

        $payment->update([
            'payment_status' => $request->payment_status,
            'transaction_id' => $request->transaction_id,
            'payment_date' => $request->payment_status === 'completed' ? now() : null,
        ]);

        return $this->success($payment->load(['user', 'service', 'booking']), 'Payment status updated successfully');
    }
}
