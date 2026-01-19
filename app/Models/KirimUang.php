<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class KirimUang extends Model
{
    protected $table = 'kirimuang';
    protected $primaryKey = 'noref';

    protected $fillable = [
        'noref',
        'dari_iduser',
        'ke_iduser',
        'jumlahuang',
    ];
    public $incrementing = false;
    public $timestamps = false;
}
