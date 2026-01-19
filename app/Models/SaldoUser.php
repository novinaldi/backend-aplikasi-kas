<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SaldoUser extends Model
{
    protected $table = 'saldouser';
    protected $primaryKey = 'id';
    public $timestamps = false;

    protected $fillable = [
        'iduser',
        'jumlahsaldo'
    ];
}
