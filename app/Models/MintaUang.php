<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class MintaUang extends Model
{
    protected $table = 'mintauang';
    protected $primaryKey = 'noref';

    protected $fillable = [
        'noref',
        'dari_iduser',
        'ke_iduser',
        'jumlahuang',
        'stt'
    ];
    public $incrementing = false;
    public $timestamps = false;
}