<?php

namespace App\Http\Controllers;

use App\Models\KirimUang;
use App\Models\SaldoUser;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

use Kreait\Laravel\Firebase\Facades\Firebase;
use Kreait\Firebase\Messaging\CloudMessage;

class KirimUangController extends Controller
{
    private function createNoTransaksiKasMasuk()
    {
        $randomNumber = rand(0000, 99999);
        $formatTanggal = date('dmYHis', strtotime(Carbon::now()));
        $noTransaksi = 'KU' . $formatTanggal . $randomNumber;
        return $noTransaksi;
    }

    public function insertDataKirimUang(Request $request)
    {
        $request->validate([
            'email_penerima' => 'required|email',
            'jmluang' => 'required|numeric',
        ], [
            'email_penerima.required' => 'Email wajib diisi.',
            'email_penerima.email' => 'Alamat Email harus yang valid',
            'jmluang.required' => 'Jumlah uang masuk wajib diisi.',
            'jmluang.numeric' => 'Jumlah uang masuk harus berupa angka.',
        ]);

        // cek email penerima user 
        $ambiilDataUser = User::where('email', $request->email_penerima)->first();
        if ($ambiilDataUser) {
            $idUserPenerima = $ambiilDataUser->id;
            $tokenFcmPenerima = $ambiilDataUser->fcmtoken; //pemanggilan token fcm

            $idUserPengirim = $request->user()->id;

            // cek saldo user pengirim jika tidak cukup
            $dataSaldoUser = SaldoUser::where('iduser', $idUserPengirim)->first();
            $saldoUserPengirim = $dataSaldoUser->jumlahsaldo;

            if (intval($request->jmluang) > intval($saldoUserPengirim)) {
                return response()->json([
                    'status' => false,
                    'pesan' => 'Saldo anda tidak mencukupi',
                ]);
            } else {
                DB::beginTransaction();
                try {

                    // Lakukan Pengurangan jumlah saldo user dan update data
                    $dataSaldoUser->jumlahsaldo = $dataSaldoUser->jumlahsaldo - $request->jmluang;
                    $dataSaldoUser->save();

                    // simpan ke table kirim uang
                    $kirimUang = new KirimUang();
                    $kirimUang->noref = $this->createNoTransaksiKasMasuk();
                    $kirimUang->dari_iduser = $idUserPengirim;
                    $kirimUang->ke_iduser = $idUserPenerima;
                    $kirimUang->jumlahuang = $request->jmluang;
                    $kirimUang->save();

                    // lakukan update saldo user penerima
                    $saldoUserPenerima = SaldoUser::where('iduser', $idUserPenerima)->first();
                    $saldoUserPenerima->jumlahsaldo = $saldoUserPenerima->jumlahsaldo + $request->jmluang;
                    $saldoUserPenerima->save();

                    // Kirim Notifikasi Ke penerima
                    if ($tokenFcmPenerima != null || $tokenFcmPenerima != '') {
                        $messaging = Firebase::messaging();
                        $pesanKePenerima = 'Halo ' . $ambiilDataUser->name . ' ada kiriman uang nih dari ' . $request->user()->name . ' Sejumlah : ' . $request->jmluang;
                        $message = CloudMessage::withTarget('token', $tokenFcmPenerima)
                            ->withNotification(['title' => 'Ada Kiriman Uang', 'body' => $pesanKePenerima])
                            ->withData(['key' => 'value']);

                        $messaging->send($message);
                    }

                    DB::commit();

                    return response()->json([
                        'status' => true,
                        'pesan' => 'Kirim uang berhasil di lakukan'
                    ], 201);
                } catch (\Exception $e) {
                    DB::rollBack();

                    return response()->json(['pesan' => 'Gagal Eksekusi Data ' . $e->getMessage(), 'status' => false], 500);
                }
            }
        } else {
            return response()->json([
                'status' => false,
                'pesan' => 'Email yang anda input tidak ditemukan...'
            ]);
        }
    }
}
