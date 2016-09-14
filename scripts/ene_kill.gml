{

    if(global.p_atack)
    {
     damage = global.atack 
    e_hp -= damage;
    global.str_d = damage;
    instance_create(0,0,obj_str);
    obj_str.alarm[1] = 90;

    

    global.p_atack = 0;
    }
    
    //攻撃処理

    if(e_hp <= 0){
    instance_destroy();

    global.expr += e_exp;
    //引数の経験値を得る
    

    }

}
