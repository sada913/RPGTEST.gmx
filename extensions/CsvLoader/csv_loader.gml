#define csv_load
// csv_load(path);
//
// @brief     Load CSV file.
// @authoer   2dgames.jp (syun)
// @date      2013/10/8
// @argument0 path CSV file path.
// @return    ds_map map
// @note      map is readonly and not destroy.
// @usage:
//   csv data. "test.csv"
//    id,name,hp,mp,str,vit
//    int,str,int,int,int,int
//    1,hoge,100,3,20,15
//    2,piyo,150,2,15,8
//    3,momo,120,5,30,5
//
//   // Load CSV.
//   var map = csv_load("test.csv");
//
//   // Get row data. (ex. get frist row data)
//   var data = ds_map_find_value(map, 1);
//   // Get parameters.
//   var name = ds_map_find_value(data, "name");
//   var hp   = ds_map_find_value(data, "hp");
//   var mp   = ds_map_find_value(data, "mp");
//   var str  = ds_map_find_value(data, "str");
//   var vit  = ds_map_find_value(data, "vit");
//   
//   show_debug_message("name:" + name);
//   show_debug_message("hp:"   + string(hp));
//   show_debug_message("mp:"   + string(mp));
//   show_debug_message("str:"  + string(str));
//   show_debug_message("vit:"  + string(vit));

// Get argument.
var path = argument0;

// Load CSV file.
var hFile = file_text_open_read(path);
if(hFile == -1)
{
  // file not found.
  show_message("Error: File not found.(" + path + ")");
  return noone;
}

// Parse CSV.
var ROW_HEAD = 0; // head row. (attribute name) NOTE:Rquire "id" column.
var ROW_TYPE = 1; // type row. ("int" or "str")
var ROW_DATA = 2; // data row start. (NOTE: "id" column need unique key)
var map = ds_map_create();
var head, types;
var row = 0;
while(file_text_eof(hFile) == false)
{
  // read line.
  var line = file_text_read_string(hFile);
  var tmp = line;
  var col = 0;
  
  var data = noone;
  if(row >= ROW_DATA)
  {
    data = ds_map_create();
  }
  while(true)
  {
    // separate ','
    var idx = string_pos(',', tmp);
    if(idx == 0)
    {
      // end.
      switch(row)
      {
      case ROW_HEAD:
        head[col] = tmp;
        break;
      case ROW_TYPE:
        types[col] = tmp;
        break;
      default:
        if(types[col] == "int") { ds_map_add(data, head[col], real(tmp)); }
        else                    { ds_map_add(data, head[col], tmp); }
        break;
      }
      
      // end loop.
      break;
    }
    
    // find.
    var token = string_copy(tmp, 0, idx-1);
    switch(row)
    {
    case ROW_HEAD:
      head[col] = token;
      break;
    case ROW_TYPE:
      types[col] = token;
      break;
    default:
      if(types[col] == "int") { ds_map_add(data, head[col], real(token)); }
      else                    { ds_map_add(data, head[col], token); }
      break;
    }
    
    // next column.
    tmp = string_copy(tmp, idx+1, 65535);
    col++; 
  }
  
  if(data != noone)
  {
    ds_map_add(map, ds_map_find_value(data, "id"), data);
  }
  // next row.
  file_text_readln(hFile);
  row++;
}
ds_map_add(map, "head", head);
ds_map_add(map, "types", types);
ds_map_add(map, "size", row-2); // data row length. (subtract 'head' and 'types')

// close file.
file_text_close(hFile);

/*
// debug.
var strHead = "";
for(var i = 0; i < array_length_1d(head); i++)
{
  strHead += head[i] + "|";
}
show_debug_message(strHead);
show_debug_message("--------------------------");
var key = ds_map_find_first(map);
for(var i = 0; i < ds_map_size(map); i++)
{
  if(string(key) == "head" or string(key) == "types")
  {
    // header.
    key = ds_map_find_next(head, key);
    continue;
  }
  var str = ""
  var data = ds_map_find_value(map, key);
  for(var j = 0; j < array_length_1d(head); j++)
  {
    var key2 = head[j];
    str += string(ds_map_find_value(data, key2));
    str += "|";
    key2 = ds_map_find_next(data, key2);
  }
  show_debug_message(str);
  key = ds_map_find_next(head, key);
}
// debug end.
*/

return map;


#define csv_unload
// csv_unload(map);
//
// @brief     Unload CSV file.
// @author    2dgames.jp (syun)
// @date      2013/10/30
// @argument0 ds_map return value by csv_unload
var map = argument0;

// get first.
var key = ds_map_find_first(map);
var size = ds_map_size(map);
for(var i = 0; i < size; i++)
{
  // Key of data is real.
  if(is_real(key))
  {
    // get data.
    var data = ds_map_find_value(map, key);
    // destroy.
    ds_map_destroy(data);
  }
  // to next.
  key = ds_map_find_next(map, key);
}
ds_map_destroy(map);


#define csv_dump
// csv_dump(map);
//
// @brief     Dump CSV ds_map.
// @author    2dgames.jp (syun)
// @date      2013/11/4
// @argument0 ds_map map (created by 'csv_load()')
var map = argument0;

var head = ds_map_find_value(map, "head");
// debug.
var strHead = "";
for(var i = 0; i < array_length_1d(head); i++)
{
  strHead += head[i] + "|";
}
show_debug_message(strHead);
show_debug_message("--------------------------");
var key = ds_map_find_first(map);
for(var i = 0; i < ds_map_size(map); i++)
{
  if(string(key) == "head" or string(key) == "types" or string(key) == "size")
  {
    // header.
    key = ds_map_find_next(head, key);
    continue;
  }
  var str = ""
  var data = ds_map_find_value(map, key);
  for(var j = 0; j < array_length_1d(head); j++)
  {
    var key2 = head[j];
    str += string(ds_map_find_value(data, key2));
    str += "|";
    key2 = ds_map_find_next(data, key2);
  }
  show_debug_message(str);
  key = ds_map_find_next(head, key);
}
// debug end.


