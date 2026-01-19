<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Kas extends Model
{
    protected $table = 'kas';
    protected $primaryKey = 'notrans';

    protected $fillable = [
        'notrans',
        'tanggal',
        'keterangan',
        'jumlahuang',
        'jenis',
        'iduser'
    ];
    public $incrementing = false;
    public $timestamps = false;
}
