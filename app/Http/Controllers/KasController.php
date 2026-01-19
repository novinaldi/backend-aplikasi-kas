<?php

namespace App\Http\Controllers;

use App\Models\Kas;
use App\Models\SaldoUser;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

// use Illuminate\Support\Facades\DB;

class KasController extends Controller
{
    public function getDataKasMasuk(Request $request)
    {
        $user = $request->user();

        // ORM 
        $dataKasMasuk = Kas::where('jenis', 'masuk')->where('iduser', $user->id)->get();

        // Query Builder
        // $dataKasMasuk = DB::table('kas')->where('jenis', 'masuk')->where('iduser', $user->id)->get();


        return response()->json([
            'tampildata' => $dataKasMasuk
        ]);
    }

    private function createNoTransaksiKasMasuk($tanggal)
    {
        $randomNumber = rand(0000, 9999);
        $formatTanggal = date('dmY', strtotime($tanggal));
        $noTransaksi = 'M' . $formatTanggal . $randomNumber;
        return $noTransaksi;
    }

    public function insertDataKasMasuk(Request $request)
    {
        $request->validate([
            'tgl' => 'required|date',
            'jmluang' => 'required|numeric',
            'ket' => 'required|string|max:255',
        ], [
            'tgl.required' => 'Tanggal wajib diisi.',
            'tgl.date' => 'Tanggal harus berupa format yang valid.',
            'jmluang.required' => 'Jumlah uang masuk wajib diisi.',
            'jmluang.numeric' => 'Jumlah uang masuk harus berupa angka.',
            'ket.required' => 'Keterangan wajib diisi.',
        ]);

        DB::beginTransaction();

        try {
            $noTransaksi = $this->createNoTransaksiKasMasuk($request->tgl);
            $user = $request->user();

            $kas = Kas::create([
                'notrans' => $noTransaksi,
                'tanggal' => $request->tgl,
                'jumlahuang' => $request->jmluang,
                'keterangan' => $request->ket,
                'iduser' => $user->id,
                'jenis' => 'masuk',
            ]);

            // $dataKas = new Kas();
            // $dataKas->notrans = $noTransaksi;
            // $dataKas->tanggal = $request->tgl;
            // $dataKas->jumlahuang = $request->jmluang;
            // $dataKas->save();

            // update saldo
            $dataSaldoUser = SaldoUser::where('iduser', $user->id)->first();
            // $dataSaldoUser = new SaldoUser();
            $dataSaldoUser->jumlahsaldo = $dataSaldoUser->jumlahsaldo + $request->jmluang;
            $dataSaldoUser->save();

            DB::commit();

            return response()->json([
                'message' => 'Data kas masuk berhasil ditambahkan!',
                'data' => $kas
            ], 201);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'status' => 'error',
                'msg' => 'Error : ' . $e->getMessage()
            ]);
        }
    }

    public function updateDataKasMasuk(Request $request, $notrans)
    {
        $request->validate([
            'tgl' => 'required|date',
            'jmluang' => 'required|numeric',
            'ket' => 'required|string|max:255',
        ], [
            'tgl.required' => 'Tanggal wajib diisi.',
            'tgl.date' => 'Tanggal harus berupa format yang valid.',
            'jmluang.required' => 'Jumlah uang masuk wajib diisi.',
            'jmluang.numeric' => 'Jumlah uang masuk harus berupa angka.',
            'ket.required' => 'Keterangan wajib diisi.',
        ]);

        DB::beginTransaction();

        try {
            $kas = Kas::where('notrans', $notrans)->first();

            if (!$kas) {
                return response()->json([
                    'status' => false,
                    'msg' => 'Data kas tidak ditemukan!'
                ], 404);
            }

            $dataSaldoUser = SaldoUser::where('iduser', $kas->iduser)->first();
            $dataSaldoUser->jumlahsaldo = $dataSaldoUser->jumlahsaldo - $kas->getOriginal('jumlahuang') + $request->jmluang;
            $dataSaldoUser->save();

            $kas->tanggal = $request->tgl;
            $kas->jumlahuang = $request->jmluang;
            $kas->keterangan = $request->ket;

            $kas->save();

            DB::commit();

            return response()->json([
                'status' => true,
                'message' => 'Data kas masuk berhasil diperbarui!',
                'data' => $kas,
            ], 200);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'status' => false,
                'msg' => 'Error: ' . $e->getMessage()
            ]);
        }
    }

    public function getDetailKasMasuk(Request $request, $notrans)
    {
        $user = $request->user();
        $dataKasMasuk = Kas::where('notrans', $notrans)->where('iduser', $user->id)->first();

        if (!$dataKasMasuk) {
            return response()->json([
                'status' => false,
                'msg' => 'Data kas masuk tidak ditemukan!'
            ], 404);
        }

        return response()->json([
            'status' => true,
            'data' => $dataKasMasuk
        ]);
    }

    public function deleteDataKasMasuk(Request $request, $notrans)
    {
        DB::beginTransaction();

        try {
            $kas = Kas::where('notrans', $notrans)->first();

            if (!$kas) {
                return response()->json([
                    'status' => false,
                    'msg' => 'Data kas tidak ditemukan!'
                ], 404);
            }

            // Update saldo sebelum menghapus data kas
            $dataSaldoUser = SaldoUser::where('iduser', $kas->iduser)->first();
            $dataSaldoUser->jumlahsaldo = $dataSaldoUser->jumlahsaldo - $kas->jumlahuang;
            $dataSaldoUser->save();

            $kas->delete();

            DB::commit();

            return response()->json([
                'status' => true,
                'message' => 'Data kas masuk berhasil dihapus!'
            ], 200);
        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json([
                'status' => false,
                'msg' => 'Error: ' . $e->getMessage()
            ]);
        }
    }
}
