{
   if (place_meeting(x+64,y+0,obj_ply) || place_meeting(x-64,y+0,obj_ply) || place_meeting(x,y+64,obj_ply)  ||  place_meeting(x,y-64,obj_ply))
        {
        global.p_atack_check = 1;
        }
        
}

//周囲１マスにて敵がいたら攻撃フラグを立てる
