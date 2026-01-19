<?php

namespace App\Http\Controllers;

use App\Models\SaldoUser;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;
use Intervention\Image\Laravel\Facades\Image;
use Illuminate\Support\Facades\File;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8|confirmed',
        ], [
            'name.required' => 'Nama tidak boleh kosong',
            'name.string' => 'Nama Harus string'
        ]);

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
        ]);

        // Simpan ke table saldo user
        SaldoUser::create([
            'iduser' => $user->id,
            'jumlahsaldo' => 0
        ]);

        return response()->json(
            ['message' => 'User registered successfully!', 'data' => $user],
            201
        );
    }

    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|string|email',
            'password' => 'required|string|min:8',
        ], [
            'email.required' => 'Email wajib diisi.',
            'email.email' => 'Format email tidak valid.',
            'password.required' => 'Password wajib diisi.',
            'password.min' => 'Password minimal 8 karakter.',
        ]);

        if (Auth::attempt(['email' => $request->email, 'password' => $request->password])) {
            $user = Auth::user();

            // DB::table('users')
            //     ->where('id', $user->id)
            //     ->update(['ip_address' => $request->ip()]);

            $user->ip_address = $request->ip();
            $user->user_agent = $request->header('User-Agent');
            $user->fcmtoken = $request->token_fcm;
            $user->save();

            // Buat token
            $token = $user->createToken('auth_token_novinaldi')->plainTextToken;

            return response()->json([
                'token_den' => $token
            ]);
        }

        return response()->json(['message' => 'Unauthorized'], 401);
    }

    public function logout(Request $request)
    {
        $request->user()->tokens->each(function ($token) {
            $token->delete();
        });

        return response()->json(['message' => 'Logged out successfully!']);
    }


    public function dataPengguna(Request $request)
    {
        $user = $request->user();

        return response()->json([
            'user' => $user
        ]);
    }

    public function updateUser(Request $request)
    {
        $request->validate([
            'name' => 'sometimes|string|max:255',
            'email' => 'sometimes|string|email|max:255|unique:users,email,' . $request->user()->id,
            'password' => 'nullable|string|min:8|confirmed',
        ]);

        $user = $request->user();

        if ($request->has('name')) {
            $user->name = $request->name;
        }

        if ($request->has('email')) {
            $user->email = $request->email;
        }

        if ($request->has('password')) {
            if ($request->password !== $request->password_confirmation) {
                return response()->json(['message' => 'Password and confirm password do not match'], 400);
            }
            $user->password = Hash::make($request->password);
        }

        $user->save();

        return response()->json([
            'message' => 'User updated successfully!',
            'data' => $user
        ], 200);
    }

    public function updateUserPhoto(Request $request)
    {
        $request->validate([
            'photo' => 'required|file|mimes:jpeg,jpg,png|max:5120',
        ], [
            'photo.required' => 'Foto wajib diisi',
            'photo.file' => 'File yang diunggah harus berupa gambar.',
            'photo.mimes' => 'File gambar harus berformat jpeg, jpg, atau png.',
            'photo.max' => 'Ukuran file gambar tidak boleh lebih dari 5MB.',
        ]);

        $user = $request->user(); // select * from users where users.id = '';

        if ($request->hasFile('photo')) {
            $file = $request->file('photo');

            $fileName = time() . '.' . $file->getClientOriginalExtension();
            $fileNameThumb = 'thumb_' . time() . '.' . $file->getClientOriginalExtension();

            if ($user->photo) {
                $oldPhotoPath = public_path('storage/photos/' . basename($user->photo));
                if (File::exists($oldPhotoPath)) {
                    File::delete($oldPhotoPath);
                }
            }

            if ($user->photo_thumb) {
                $oldThumbPath = public_path('storage/photos/thumbnail/' . basename($user->photo_thumb));
                if (File::exists($oldThumbPath)) {
                    File::delete($oldThumbPath);
                }
            }

            $filePath = $file->storeAs('foto_saya', $fileName, 'public');

            $destinationPathThumbnail = public_path('storage/foto_saya/thumbnail/');
            if (!File::exists($destinationPathThumbnail)) {
                File::makeDirectory($destinationPathThumbnail, 0755, true);
            }

            // kompress
            $image = Image::read($file);
            $image->scaleDown(width: 200);
            $image->save($destinationPathThumbnail . $fileNameThumb);

            $user->photo = Storage::url($filePath);
            $user->photo_thumb = '/storage/foto_saya/thumbnail/' . $fileNameThumb;
            $user->save();

            return response()->json([
                'message' => 'Foto berhasil diperbarui!',
                'foto' => $user->photo,
                'foto_thumb' => $user->photo_thumb,
            ], 200);
        }

        return response()->json(['message' => 'Tidak ada foto yang diunggah.'], 400);
    }

    public function getSaldoUser(Request $request)
    {
        $user = $request->user();
        $dataSaldo = SaldoUser::where('iduser', $user->id)->first();

        return response()->json([
            'data' => $dataSaldo
        ]);
    }
}
