<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\KasController;
use App\Http\Controllers\KirimUangController;
use App\Http\Controllers\MintaUangController;
use App\Http\Controllers\NotificationController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;


// Route untuk Register
Route::post('register', [AuthController::class, 'register']);

// Route untuk Login
Route::post('login', [AuthController::class, 'login']);

// Route yang membutuhkan autentikasi (menggunakan middleware auth:sanctum)
Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

// Route untuk Logout
Route::post('logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');

Route::get('data-pengguna', [AuthController::class, 'dataPengguna'])->middleware('auth:sanctum');

Route::put('update-user', [AuthController::class, 'updateUser'])
    ->middleware('auth:sanctum');

Route::middleware('auth:sanctum')->post('/update-photo', [AuthController::class, 'updateUserPhoto']);

Route::middleware('auth:sanctum')->get('/get-saldo', [AuthController::class, 'getSaldoUser']);


Route::middleware('auth:sanctum')->get('/kas-masuk/data', [KasController::class, 'getDataKasMasuk']);

Route::middleware('auth:sanctum')->post('/kas-masuk/save', [KasController::class, 'insertDataKasMasuk']);

Route::middleware('auth:sanctum')
    ->get('/kas-masuk/detail/{notrans}', [KasController::class, 'getDetailKasMasuk']);

Route::middleware('auth:sanctum')
    ->delete('/kas-masuk/delete/{notrans}', [KasController::class, 'deleteDataKasMasuk']);
Route::middleware('auth:sanctum')
    ->put('/kas-masuk/update/{notrans}', [KasController::class, 'updateDataKasMasuk']);

Route::middleware('auth:sanctum')->post('/kirim-uang/save', [KirimUangController::class, 'insertDataKirimUang']);

Route::middleware('auth:sanctum')->post('/minta-uang/save', [MintaUangController::class, 'insertDataMintaUang']);

Route::get('/send-notification', [NotificationController::class, 'sendNotification']);

Route::get('/minta-uang/detail/{noref}', [MintaUangController::class, 'getDataDetail'])
    ->middleware('auth:sanctum');

Route::put('/minta-uang/proses-permintaan/{noref}', [MintaUangController::class, 'prosesPermintaan'])
    ->middleware('auth:sanctum');
