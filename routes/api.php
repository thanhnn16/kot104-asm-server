<?php

use App\Http\Controllers\Auth\AuthenticatedSessionController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\UserController;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    $message = ['message' => 'Hello, World!'];

    return response()->json($message);
});

// Auth
Route::post('/auth/login', [UserController::class, 'login'])->name('login');
Route::post('/auth/register', [UserController::class, 'register'])->name('register');

// Products
Route::get('/products', [ProductController::class, 'index'])->name('products.index');
Route::get('/categories', [ProductController::class, 'categories'])->name('products.categories');
Route::get('/categories/{id}', [ProductController::class, 'categories_show'])->name('products.categories_show');
Route::get('/products/category/{category}', [ProductController::class, 'category'])->name('products.category');
Route::get('/products/search/{name}', [ProductController::class, 'search'])->name('products.search');

Route::middleware(['auth:sanctum'])->group(function () {
    // Auth
    Route::get('/auth/logout', [AuthenticatedSessionController::class, 'destroy'])->name('logout');

    // Products
    Route::get('/products/{id}', [ProductController::class, 'show'])->name('products.show');

    // Users
    Route::get('/users/{id}', [UserController::class, 'show'])->name('users.show');
    Route::get('/user/favorites', [UserController::class, 'getFavorites'])->name('users.favorites');
    Route::post('/user/favorites/{id}', [UserController::class, 'addFavorite'])->name('users.favorites_store');
    Route::delete('/user/favorites/{id}', [UserController::class, 'removeFavorite'])->name('users.favorites_destroy');
});
