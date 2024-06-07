<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class UserController extends Controller
{
    public function register(Request $request): JsonResponse
    {
        $request->validate([
            'fullName' => 'required',
            'email' => 'required|email',
            'password' => 'required',
        ]);

        try {
            $user = User::create([
                'full_name' => $request->fullName,
                'email' => $request->email,
                'password' => Hash::make($request->password),
            ]);

            return response()->json([
                'message' => 'User created successfully',
                'user' => $user,
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'User registration failed',
                'error' => $e->getMessage(),
            ], 400);
        }
    }

    public function login(Request $request): JsonResponse
    {
        try {
            Auth::attempt($request->only('email', 'password'));

            $user = Auth::user();

            $token = $user->createToken('auth_token')->plainTextToken;

            return response()->json([
                'message' => 'User logged in successfully',
                'user' => $user,
                'token' => $token,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'User login failed',
                'error' => $e->getMessage(),
            ], 400);
        }
    }

    public function show($id): JsonResponse
    {
        $user = User::find($id);
        return response()->json($user);
    }

    public function getFavorites(): JsonResponse
    {
        $user = Auth::user();
        $favorites = $user->favorites()->with('images')->get();
        return response()->json($favorites);
    }

    public function addFavorite($id): JsonResponse
    {
        try {
            $user = User::find(Auth::id());
            $user->favorites()->attach($id);
            return response()->json(['message' => 'Product added to favorites']);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Product already in favorites: ' . $e->getMessage()]);

            // Q: error: Call to undefined method Illuminate\\Database\\Eloquent\\Relations\\HasMany::attach()"
            // A: The error is caused by the fact that the favorites() method in the User model is defined as a HasMany relationship.
            // To fix this, change the favorites() method in the User model to a BelongsToMany relationship.

        }
    }

    public function removeFavorite($id): JsonResponse
    {
        $user = User::find(Auth::id());
        $user->favorites()->detach($id);
        return response()->json(['message' => 'Product removed from favorites']);
    }

    public function logout(): JsonResponse
    {
        Auth::user()->tokens()->delete();
        return response()->json(['message' => 'User logged out successfully']);
    }
}
