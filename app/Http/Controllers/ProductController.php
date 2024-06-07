<?php

namespace App\Http\Controllers;

use App\Models\Product;
use App\Models\ProductCategory;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Auth;

class ProductController extends Controller
{
    // function to get all products
    public function index(): JsonResponse
    {
        $products = Product::all();
        $products->load('images');
        return response()->json($products);
    }

    // function to get a product by id
    public function show($id): JsonResponse
    {
        $product = Product::find($id);
        $product->load('images');
        $product->load('reviews');
        $user = User::find(Auth::id());
        if ($user) {
            $isFavorite = $user->favorites->contains($product->id);
            $product->isFavorite = $isFavorite;
        }
        return response()->json($product);
    }

    //function to get all product categories
    public function categories(): JsonResponse
    {
        $product_categories = ProductCategory::all();
        return response()->json($product_categories);
    }

    // function show category
    public function categories_show($id): JsonResponse
    {
        $product_category = ProductCategory::find($id);
        return response()->json($product_category);
    }

    // function get all products by category
    public function category($category): JsonResponse
    {
        $products = Product::where('category_id', $category)->get();
        $products->load('images');
        $products->load('reviews');
        return response()->json($products);
    }
}
