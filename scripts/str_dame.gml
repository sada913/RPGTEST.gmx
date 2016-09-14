{

{
if(global.str_d)
{
    DRAW_STR_H = 640;
    DRAW_STR_W = 512;
    DRAW_STR_UP = 28;
    DRAW_STR_MAX = 768;
    draw_set_font(font_default);
    draw_set_halign(fa_center);
    
    str = global.str_d
    draw_text_ext(DRAW_STR_W,DRAW_STR_H,"ドラゴンに"+string(str)+"ダメージﾞ",DRAW_STR_UP,DRAW_STR_MAX)

}
    
}
}
