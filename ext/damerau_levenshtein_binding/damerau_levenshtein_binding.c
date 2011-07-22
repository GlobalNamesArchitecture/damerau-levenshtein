#include "ruby.h"

VALUE DamerauLevenshteinBinding = Qnil;

void Init_damerau_levenshtein_binding();

VALUE method_distance_utf(VALUE self, VALUE _s, VALUE _t, VALUE _block_size, VALUE _max_distance);

void Init_damerau_levenshtein_binding() {
	DamerauLevenshteinBinding = rb_define_module("DamerauLevenshteinBinding");
	rb_define_method(DamerauLevenshteinBinding, "distance_utf", method_distance_utf, 4);
}

VALUE method_distance_utf(VALUE self, VALUE _s, VALUE _t, VALUE _block_size, VALUE _max_distance){
  int i, i1, j, j1, k, half_tl, cost, *d, distance, del, ins, subs, transp, block;
  int sl, tl, half_sl;
  int stop_execution = 0;
  int min = 0;
  int current_distance = 0;

  int block_size = NUM2INT(_block_size);
  int max_distance = NUM2INT(_max_distance);

  VALUE *sv = RARRAY_PTR(_s);
  VALUE *tv = RARRAY_PTR(_t);

  sl = (int) RARRAY_LEN(_s);
  tl = (int) RARRAY_LEN(_t);

  if (sl == 0) return INT2NUM(tl);
  if (tl == 0) return INT2NUM(sl);
  //case of lengths 1 must present or it will break further in the code
  if (sl == 1 && tl == 1 && sv[0] != tv[0]) return INT2NUM(1);

  int s[sl];
  int t[tl];

  for (i=0; i < sl; i++) s[i] = NUM2INT(sv[i]);
  for (i=0; i < tl; i++) t[i] = NUM2INT(tv[i]);

  sl++;
  tl++;

  //one-dimentional representation of 2 dimentional array len(s)+1 * len(t)+1
  d = malloc((sizeof(int))*(sl)*(tl));
  //populate 'vertical' row starting from the 2nd position (first one is filled already)
  for(i = 0; i < tl; i++){
    d[i*sl] = i;
  }

  //fill up array with scores
  for(i = 1; i<sl; i++){
    d[i] = i;
    if (stop_execution == 1) break;
    current_distance = 10000;
    for(j = 1; j<tl; j++){

      cost = 1;
      if(s[i-1] == t[j-1]) cost = 0;

      half_sl = (sl - 1)/2;
      half_tl = (tl - 1)/2;

      block = block_size < half_sl ? block_size : half_sl;
      block = block < half_tl ? block : half_tl;

      while (block >= 1){
        int swap1 = 1;
        int swap2 = 1;
        i1 = i - (block * 2);
        j1 = j - (block * 2);
        for (k = i1; k < i1 + block; k++) {
          if (s[k] != t[k + block]){
            swap1 = 0;
            break;
          }
        }
        for (k = j1; k < j1 + block; k++) {
          if (t[k] != s[k + block]){
            swap2 = 0;
            break;
          }
        }

        del = d[j*sl + i - 1] + 1;
        ins = d[(j-1)*sl + i] + 1;
        min = del;
        if (ins < min) min = ins;
        //if (i == 2 && j==2) return INT2NUM(swap2+5);
        if (i >= block && j >= block && swap1 == 1 && swap2 == 1){
          transp = d[(j - block * 2) * sl + i - block * 2] + cost + block -1;
          if (transp < min) min = transp;
          block = 0;
        } else if (block == 1) {
          subs = d[(j-1)*sl + i - 1] + cost;
          if (subs < min) min = subs;
        }
        block--;
      }
      d[j*sl+i]=min;
      if (current_distance > d[j*sl+i]) current_distance = d[j*sl+i];
    }
    if (current_distance > max_distance) {
      stop_execution = 1;
    }
  }
  distance=d[sl * tl - 1];
  if (stop_execution == 1) distance = current_distance;

  free(d);
  return INT2NUM(distance);
}
